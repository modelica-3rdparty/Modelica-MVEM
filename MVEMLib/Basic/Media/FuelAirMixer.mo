// --------------------------------------------------------------------
//                       MVEMLib for Modelica 
// A Mean Value Engine Library for simulation of SI and CI engines
// --------------------------------------------------------------------
// Copyright (C) 2012  Per Öberg
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this software.  If not, see <http://www.gnu.org/licenses/>.
//
// Primary author: Per Öberg <per.oberg@liu.se>

within MVEMLib.Basic.Media;
model FuelAirMixer
  "Transforms the separate fuel and air streams into the unburned medium"
  replaceable package fuelAirMedium = FuelAirMixture annotation(choicesAllMatching=true);

  // Define i/o Connections
  Interfaces.GasPort FuelInPut(redeclare replaceable package Medium =
        fuelAirMedium.fuelMedium)
    annotation (Placement(transformation(extent={{-112,50},{-92,70}}, rotation=
            0)));
  Interfaces.GasPort AirInPut( redeclare replaceable package Medium =
        fuelAirMedium.airMedium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}},
          rotation=0)));
  Interfaces.GasPort MixOutPut(redeclare replaceable package Medium =
        fuelAirMedium.unburnedMedium)
    annotation (Placement(transformation(extent={{92,-10},{112,10}}, rotation=0)));
  // Variables used to simplify the equations for MixOutput.Xi as a function of
  // AirInput.Xi and FueInput.Xi
protected
  Real mix_X[fuelAirMedium.unburnedMedium.nX];
  Real mix_dmX[fuelAirMedium.unburnedMedium.nX];
  Real air_X[fuelAirMedium.airMedium.nX];
  Real air_dmX[fuelAirMedium.airMedium.nX];
  Real fuel_X[fuelAirMedium.fuelMedium.nX];
  Real fuel_dmX[fuelAirMedium.fuelMedium.nX];
equation
  // No matter what the flow direction is we are connected to
  // restrictions upstreams and a controlvolume downstreams. The
  // restrictions ports have the same pressures and temperatures as
  // that of the control volume.
  // Implication: p,T,X     are those of the control volume
  //              dm,dmX,dH are those of the restriction

  // Regard the fuel and air inputs as extensions of the port of the control volume.
  // They have the properties of the control volume.

  // 1) Pressure and Temperature
  FuelInPut.p = MixOutPut.p;
  AirInPut.p  = MixOutPut.p;
  FuelInPut.T = MixOutPut.T;
  AirInPut.T  = MixOutPut.T;

  // 2) Composition, X
  //    If size of X is reduced for single component media a number of
  //    cases can occur Therefore these intermediate variables are
  //    used to simplify the calculations
  mix_X[1:fuelAirMedium.unburnedMedium.nXi] = MixOutPut.Xi;
  if fuelAirMedium.unburnedMedium.nX > fuelAirMedium.unburnedMedium.nXi then
    mix_X[fuelAirMedium.unburnedMedium.nX] = 1 - sum(MixOutPut.Xi);
  end if;
  air_X  = mix_X[1:fuelAirMedium.airMedium.nX];
  fuel_X = mix_X[(fuelAirMedium.airMedium.nX+1):(fuelAirMedium.airMedium.nX+fuelAirMedium.fuelMedium.nX)];
  AirInPut.Xi  = if sum(air_X) >0 then
    air_X[1:fuelAirMedium.airMedium.nXi] else
    fuelAirMedium.airMedium.reference_X[1:fuelAirMedium.airMedium.nXi];
  FuelInPut.Xi = if sum(fuel_X)>0 then
    fuel_X[1:fuelAirMedium.fuelMedium.nXi]/sum(fuel_X) else
    fuelAirMedium.fuelMedium.reference_X[1:fuelAirMedium.fuelMedium.nXi];

  // 3) The independent components mass flows dmXi
  air_dmX[1:fuelAirMedium.airMedium.nXi] = AirInPut.dmXi;
  if fuelAirMedium.airMedium.nX > fuelAirMedium.airMedium.nXi then
    air_dmX[fuelAirMedium.airMedium.nX] = AirInPut.dm-sum(AirInPut.dmXi);
  end if;
  fuel_dmX[1:fuelAirMedium.fuelMedium.nXi] = FuelInPut.dmXi;
  if fuelAirMedium.fuelMedium.nX > fuelAirMedium.fuelMedium.nXi then
    fuel_dmX[fuelAirMedium.fuelMedium.nX] = FuelInPut.dm-sum(FuelInPut.dmXi);
  end if;
   - mix_dmX = cat(1,air_dmX,  fuel_dmX);
   MixOutPut.dmXi = mix_dmX[1:fuelAirMedium.unburnedMedium.nXi];

  // 4) The other flow variables, dm,dH
  FuelInPut.dm + AirInPut.dm = -MixOutPut.dm;
  FuelInPut.dH + AirInPut.dH = -MixOutPut.dH;
  annotation (Diagram(graphics),
                       Icon(graphics={
        Text(
          extent={{-100,100},{100,80}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Text(
          extent={{-100,80},{0,60}},
          lineColor={0,0,255},
          textString=
               "Fuel"),
        Text(
          extent={{-100,-60},{0,-80}},
          lineColor={0,0,255},
          textString=
               "Air"),
        Text(
          extent={{20,30},{100,10}},
          lineColor={0,0,255},
          textString=
               "Unburned"),
        Line(points={{-80,54},{-38,54},{-38,10},{0,10}}, color={0,127,0}),
        Line(points={{-80,-52},{-38,-52},{-38,-10},{0,-10}}, color={0,0,255}),
        Line(points={{-80,50},{-42,50},{-42,6},{0,6}}, color={0,127,0}),
        Line(points={{-80,-48},{-42,-48},{-42,-6},{0,-6}}, color={0,0,255}),
        Line(points={{0,2},{80,2}}, color={255,128,0}),
        Line(points={{0,-2},{80,-2}}, color={255,128,0}),
        Line(points={{92,-20},{80,-32}}, color={0,0,255}),
        Line(points={{-24,-20},{92,-20},{78,-10}}, color={0,0,255})}));
end FuelAirMixer;
