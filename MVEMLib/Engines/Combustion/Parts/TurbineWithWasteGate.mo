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
model TurbineWithWasteGate "Turbine with Wastegate"
  extends Basic.Restrictions.Partial.TwoPort;
  parameter SI.Area WG_Amax = 3.5e-4 "Maximum Wastegate Area";
  parameter Real WG_Cd(final quantity="DischargeCoefficient", final unit="1") = 0.9
    "Discharge coefficient (Flow efficiency)";
  parameter Real k1 =                                               0.0170
    "Turbine mass flow fit parameter";
  parameter Real k2 =                                               1.4
    "Turbine mass flow fit parameter";
  parameter SI.Length D =                                           0.05
    "Trubine diameter";
  parameter SI.Efficiency eta_max =                                 0.75
    "Maximum efficiency";
  parameter Real eta_max_BSR =                                      0.7
    "Maximum efficiency blade speed ratio";
  parameter SI.Efficiency eta_min =                                 0.3
    "Minimum efficiency";

  FixedTurbine fixedTurbine(
    redeclare replaceable package Medium = Medium,
    k1=k1,
    k2=k2,
    D=D,
    eta_max=eta_max,
    eta_max_BSR=eta_max_BSR,
    eta_min=eta_min)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Basic.Restrictions.Compressible compressible(redeclare replaceable package
      Medium =                                                                        Medium)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Interfaces.RealInput uWG
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}),
        iconTransformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Math.Gain uWGtoArea(k=WG_Amax*WG_Cd)
    annotation (Placement(transformation(extent={{-62,70},{-42,90}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  connect(InPut, compressible.InPut) annotation (Line(
      points={{-100,5.55112e-16},{-60,5.55112e-16},{-60,30},{-10,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fixedTurbine.InPut, InPut) annotation (Line(
      points={{-10,-30},{-60,-30},{-60,5.55112e-16},{-100,5.55112e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fixedTurbine.OutPut, OutPut) annotation (Line(
      points={{10,-30},{60,-30},{60,5.55112e-16},{100,5.55112e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(compressible.OutPut, OutPut) annotation (Line(
      points={{10,30},{60,30},{60,5.55112e-16},{100,5.55112e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(uWG, uWGtoArea.u) annotation (Line(
      points={{-100,80},{-64,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uWGtoArea.y, compressible.Aeff) annotation (Line(
      points={{-41,80},{-28,80},{-28,34},{-9.8,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flange_a, fixedTurbine.flange_a) annotation (Line(
      points={{5.55112e-16,-100},{6.10623e-16,-100},{6.10623e-16,-40}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Line(points={{-80,50},{-20,50},{-20,20},{20,20}}, color={0,0,255}),
        Text(
          extent={{-100,100},{100,80}},
          lineColor={0,0,255},
          fillColor={0,115,0},
          fillPattern=FillPattern.Solid,
          textString=
               "%name"),
        Text(
          extent={{-100,20},{-20,-20}},
          lineColor={0,0,255},
          textString="InPut"),
        Text(
          extent={{18,-20},{98,20}},
          lineColor={0,0,255},
          textString="OutPut"),
        Line(points={{20,-20},{20,-34},{20,-50},{80,-50}}, color={0,0,255}),
        Line(points={{-80,-50},{-20,-50},{-20,-20},{20,-20}}, color={0,0,255}),
        Text(
          extent={{-20,-80},{78,-100}},
          lineColor={0,0,255},
          textString="Shaft"),
        Line(points={{80,50},{20,50},{20,20}},            color={0,0,255})}));
end TurbineWithWasteGate;
