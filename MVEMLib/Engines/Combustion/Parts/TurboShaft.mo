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
model TurboShaft "Model of Turbocompound Shaft with frictions"
 extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
 parameter SI.Inertia J = 0.87e-5 "Inertia";
 parameter SI.CoefficientOfFriction cF = 0.2e-6
    "Friction coefficient for w=1 rad/s";
 parameter SI.CoefficientOfFriction cFUpper = 100
    "Friction coefficient when above upper speed limit";
 parameter SI.AngularVelocity wStart =         530 "Initial rotational speed";
 parameter SI.AngularVelocity wUpper =         21000 "Upper speed limit";
 parameter SI.AngularVelocity wLower =         10 "Lower speed limit";

  Modelica.Mechanics.Rotational.Components.Inertia turboInertia(J=J, w(fixed=
          false, start=wStart))
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction(
      tau_pos=[0,0; wLower,0; 2*wLower,cF*2*wLower; wUpper,cF*wUpper; wLower +
        wUpper,cFUpper*(wLower + wUpper)])
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation

  connect(flange_a, turboInertia.flange_a) annotation (Line(
      points={{-100,5.55112e-16},{-75,5.55112e-16},{-75,6.10623e-16},{-50,
          6.10623e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(turboInertia.flange_b, bearingFriction.flange_a) annotation (Line(
      points={{-30,6.10623e-16},{-16,6.10623e-16},{-16,6.10623e-16},{
          -5.55112e-16,6.10623e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(bearingFriction.flange_b, flange_b) annotation (Line(
      points={{20,6.10623e-16},{62,6.10623e-16},{62,5.55112e-16},{100,
          5.55112e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-98,10},{-48,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{52,10},{102,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Line(points={{-78,-25},{-58,-25}}, color={0,0,0}),
        Line(points={{62,-25},{82,-25}}, color={0,0,0}),
        Line(points={{-68,-25},{-68,-70}}, color={0,0,0}),
        Line(points={{72,-25},{72,-70}}, color={0,0,0}),
        Line(points={{-80,25},{-60,25}}, color={0,0,0}),
        Line(points={{60,25},{80,25}}, color={0,0,0}),
        Line(points={{-70,45},{-70,25}}, color={0,0,0}),
        Line(points={{70,45},{70,25}}, color={0,0,0}),
        Line(points={{-68,-70},{72,-70}}, color={0,0,0}),
        Rectangle(
          extent={{-48,50},{52,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Text(
          extent={{-154,104},{146,64}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-146,-68},{154,-108}},
          lineColor={0,0,0},
          textString="J=%J")}));
end TurboShaft;
