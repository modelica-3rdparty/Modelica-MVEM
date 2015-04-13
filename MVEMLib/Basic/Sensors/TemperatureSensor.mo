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

within MVEMLib.Basic.Sensors;
model TemperatureSensor
  "Ideal sensor to measure the temperature at a gasFlowConnector"
  extends Modelica.Icons.RotationalSensor;
  extends Basic.Restrictions.Partial.OnePort;

  // Define medium properties
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  // Temperature  output
  Modelica.Blocks.Interfaces.RealOutput T "Temperature at measurement point"
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  // Define i/o Connections
  Interfaces.GasPort InPut(redeclare replaceable package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
equation
  InPut.dm = 0;
  for ii in 1:Medium.nXi loop
    InPut.dmXi[ii] = 0;
  end for;
  InPut.dH = 0;
  T = InPut.T;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{19,100},{69,60}},
          lineColor={0,0,0},
          textString="dm"),
        Line(points={{-70,0},{-90,0}}, color={0,0,0}),
        Line(points={{0,92},{0,70}}, color={0,0,127}),
        Text(extent={{119,-100},{-120,-63}}, textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Line(points={{-70,0},{-96,0}}, color={0,0,0}),
          Line(points={{70,0},{100,0}})}),
    Window(
      x=0.12,
      y=0.08,
      width=0.6,
      height=0.6));
end TemperatureSensor;
