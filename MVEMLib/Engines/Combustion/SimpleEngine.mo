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

within MVEMLib.Engines.Combustion;
class SimpleEngine
  "An extremely simple engine which converts throttle position to applied torque."
  extends Parts.Partial.PartialEngine(engineInertia(w(fixed=true, start=1000/60
            *2*3.1415)));
  Modelica.Blocks.Math.Gain torqueMax(k=350) annotation (Placement(
        transformation(extent={{-82,-10},{-62,10}}, rotation=0)));
  Modelica.Blocks.Math.Max IdleControl annotation (Placement(transformation(
          extent={{-52,-10},{-32,10}}, rotation=0)));
  Modelica.Blocks.Sources.Constant minTorque(k=2)
    annotation (Placement(transformation(extent={{-88,-42},{-68,-22}}, rotation=
           0)));
equation
  connect(IdleControl.y, engineTorque.tau)
    annotation (Line(points={{-31,6.10623e-16},{-29.75,6.10623e-16},{-29.75,
          1.27676e-15},{-28.5,1.27676e-15},{-28.5,6.66134e-16},{-26,6.66134e-16}},
                                               color={0,0,127}));
  connect(minTorque.y, IdleControl.u2) annotation (Line(points={{-67,-32},{-62,
          -32},{-62,-6},{-54,-6}}, color={0,0,127}));
  connect(TqRef, torqueMax.u)
    annotation (Line(points={{-104,5.55112e-16},{-99,5.55112e-16},{-99,
          1.22125e-15},{-94,1.22125e-15},{-94,6.66134e-16},{-84,6.66134e-16}},
                                                color={0,0,127}));
  connect(torqueMax.y, IdleControl.u1) annotation (Line(points={{-61,
          6.10623e-16},{-60,6.10623e-16},{-60,6},{-54,6}},
                            color={0,0,127}));
  annotation (Diagram(graphics));
end SimpleEngine;
