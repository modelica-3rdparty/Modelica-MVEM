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
model ThrottleServo
  "Simple model of throttle plate area from throttle open fraction"
  extends Partial.PartialThrottleServo;
  parameter SI.Area Amax = 1000e-6 "Maximal throttle area";
  parameter SI.Area Amin = 15e-6 "Maximal throttle area";
  Modelica.Blocks.Math.Gain throttleAreaGain(k=(Amax - Amin))
    annotation (Placement(transformation(extent={{-30,30},{-10,50}}, rotation=0)));
  Modelica.Blocks.Math.Add throttleAreaSum annotation (Placement(transformation(
          extent={{6,10},{26,30}}, rotation=0)));
  Modelica.Blocks.Sources.Constant minArea(k=Amin)
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}}, rotation=
            0)));
equation
  connect(throttleAreaGain.y, throttleAreaSum.u1) annotation (Line(points={{-9,40},
          {-4,40},{-4,26},{4,26}},     color={0,0,127}));
  connect(minArea.y, throttleAreaSum.u2) annotation (Line(points={{-11,
          6.10623e-16},{-4,6.10623e-16},{-4,14},{4,14}},
                           color={0,0,127}));
  connect(throttleAreaGain.u, throttlePosition) annotation (Line(points={{-32,40},
          {-62,40},{-62,1.11022e-15},{-100,1.11022e-15}},
                                          color={0,0,127}));
  connect(throttleArea, throttleAreaSum.y) annotation (Line(points={{100,0},{
          63.5,0},{63.5,20},{27,20}},
                color={0,0,127}));
end ThrottleServo;
