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

within MVEMLib.Engines.Combustion.Parts.Partial;
partial model PartialEngine
  "Partial engine model defining the interfaces of any engine in the library"
  parameter SI.MomentOfInertia J = 0.1 "Moment of inertia for the engine";
  Modelica.Mechanics.Rotational.Components.Inertia engineInertia(
                                                      J=J) annotation (Placement(
        transformation(extent={{0,-10},{20,10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Sources.Torque engineTorque(useSupport=false)
                                                     annotation (Placement(
        transformation(extent={{-24,-10},{-4,10}}, rotation=0)));
  // Define i/o
  Modelica.Blocks.Interfaces.RealInput TqRef
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}, rotation=
           0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b CrankShaft
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction(
                                                                peak=1, tau_pos=
       [0,0; 100,2],
    useSupport=false)
                     annotation (Placement(transformation(extent={{42,-10},{62,
            10}}, rotation=0)));
equation
  connect(engineTorque.flange,  engineInertia.flange_a) annotation (Line(points={{-4,
          6.10623e-16},{-3,6.10623e-16},{-3,1.22125e-15},{-2,1.22125e-15},{-2,
          6.10623e-16},{-5.55112e-16,6.10623e-16}},
                         color={0,0,0}));
  connect(bearingFriction.flange_b, CrankShaft)
    annotation (Line(points={{62,6.10623e-16},{71.5,6.10623e-16},{71.5,
          1.16573e-15},{81,1.16573e-15},{81,5.55112e-16},{100,5.55112e-16}},
                                              color={0,0,0}));
  connect(bearingFriction.flange_a, engineInertia.flange_b)
    annotation (Line(points={{42,6.10623e-16},{36.5,6.10623e-16},{36.5,
          1.22125e-15},{31,1.22125e-15},{31,6.10623e-16},{20,6.10623e-16}},
                                             color={0,0,0}));
  annotation (Icon(graphics={
        Rectangle(extent={{-60,28},{-20,-12}}, lineColor={0,0,255}),
        Line(points={{-40,2},{-20,-52},{-40,-72}}, color={0,0,255}),
        Ellipse(extent={{-44,-68},{-36,-76}}, lineColor={0,0,255}),
        Line(points={{-60,18},{-20,18}}, color={0,0,255}),
        Ellipse(extent={{-42,4},{-38,0}}, lineColor={0,0,255}),
        Line(points={{-60,20},{-20,20}}, color={0,0,255}),
        Rectangle(extent={{12,50},{52,10}}, lineColor={0,0,255}),
        Line(points={{32,24},{12,-30},{32,-50}}, color={0,0,255}),
        Ellipse(extent={{28,-46},{36,-54}}, lineColor={0,0,255}),
        Line(points={{12,40},{52,40}}, color={0,0,255}),
        Ellipse(extent={{30,26},{34,22}}, lineColor={0,0,255}),
        Line(points={{12,42},{52,42}}, color={0,0,255}),
        Line(points={{-40,54},{-40,34},{-46,40},{-34,40},{-40,34}}, color={0,0,
              255}),
        Line(points={{32,56},{32,74},{26,68},{38,68},{32,74}}, color={0,0,255}),
        Text(
          extent={{-100,100},{22,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString=
               "%name")}),Diagram(graphics));
end PartialEngine;
