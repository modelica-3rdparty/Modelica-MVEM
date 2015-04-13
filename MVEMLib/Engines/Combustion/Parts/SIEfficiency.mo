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

within MVEMLib.Engines.Combustion.Parts;
model SIEfficiency "Model of SI Otto efficiency with torque"
  extends MVEMLib.Basic.Restrictions.Partial.ThreePortWithExternalSource;

  parameter SI.Volume Vd =          2.3e-3 "Displaced engine volume";
  parameter Real nCyl =             4 "Number of cylinders";
  parameter SI.Length B =           0.09 "Cylinder Bore";
  parameter SI.Efficiency etaOtto = 0.41 "Gross efficiency";
  parameter Real PIbl =             1.5 "Boost layout";
  parameter Real xiAux =            1.3 "Factor for auxilliary devices";
  parameter Real cTq1 =             0.2e6 "BMEP parameter C_tq1";
  parameter Real cTq2 =             1.2e6 "BMEP parameter C_tq2";

  //Basic.Interfaces.GasPort InPut(redeclare replaceable package Medium =
  //      fuelAirMedium.burnedMedium)
  //  annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  //Basic.Interfaces.GasPort OutPut(redeclare replaceable package Medium =
  //      fuelAirMedium.burnedMedium)   annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput dh
   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealInput wEng
                                          annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,110})));
  Modelica.Blocks.Interfaces.RealOutput Tq  annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,-110})));

protected
  Real GrossTorque;
  Real NetTorque;
  Real PumpTorque;
  Real FrictionTorque;

equation
  // Flow equations
  InPut.p = OutPut.p;
  InPut.T = OutPut.T;
  InPut.Xi = OutPut.Xi;

  InPut.dm  = - OutPut.dm;
  InPut.dmXi = - OutPut.dmXi;
  InPut.dH + OutPut.dH = -dh*InPut.dm*(1-etaOtto);

  // Set flows to intake manifold to zero
  ExternalSource.dH = 0;
  ExternalSource.dm = 0;
  ExternalSource.dmXi = ExternalSource.Xi*0;

  // Torque calculation
  GrossTorque = -dh*InPut.dm*etaOtto/(wEng*(0.25/Modelica.Constants.pi))*(0.25/Modelica.Constants.pi);
  FrictionTorque = ((0.464+0.00172*(wEng*4*Vd/nCyl/(B^2)/(Modelica.Constants.pi^2))^1.8)*PIbl+0.0215*(cTq2*InPut.dm/Vd/(wEng/(4*Modelica.Constants.pi))-cTq1))*sqrt(75/(B*1000))*xiAux*Vd*(0.25/Modelica.Constants.pi);
  PumpTorque = (OutPut.p-ExternalSource.p)*Vd*(0.25/Modelica.Constants.pi);
  NetTorque = GrossTorque-FrictionTorque-PumpTorque;
  Tq = NetTorque;

  annotation (Diagram(graphics), Icon(graphics={
                                Line(
          points={{72,-60},{72,-60},{38,-58},{12,-54},{-12,-48},{-28,-40},{-38,-32},
              {-44,-26},{-48,-16},{-48,86},{-24,20},{-12,-2},{2,-14},{16,-24},{32,
              -32},{46,-38},{62,-42},{72,-44}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-64,-80},{90,-80},{82,-86},{82,-74},{90,-80}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{85,0},{-85,0},{-77,6},{-77,-6},{-85,0}},
          color={0,0,255},
          smooth=Smooth.None,
          origin={-57,-2},
          rotation=-90,
          thickness=0.5),
        Line(
          points={{72,-44},{72,-60},{-48,-60},{-48,-54},{72,-54}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-120,20},{-60,60}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="In"),
        Text(
          extent={{60,20},{120,60}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="Out"),
        Text(
          extent={{-60,90},{80,48}},
          lineColor={0,0,255},
          textString="%name")}));
end SIEfficiency;
