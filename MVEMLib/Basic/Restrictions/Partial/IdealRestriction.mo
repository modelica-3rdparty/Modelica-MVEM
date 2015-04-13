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

within MVEMLib.Basic.Restrictions.Partial;
partial class IdealRestriction "Partial model for all restrictions."
   extends MVEMLib.Basic.Restrictions.Partial.TwoPort;
   // Gas properties
  Medium.BaseProperties gas(T(start=300),p(start=1e5));
  // Properties of the restriction
equation
  // Replace with something valid for the subclassed restriction
  //  InPut.dmX = ... * flow_dir * X;
  // Calculate the flow variables
  InPut.dm   = -OutPut.dm;
  InPut.dmXi  = -OutPut.dmXi;

  InPut.dmXi = InPut.dm * gas.Xi;

  InPut.dH   = - OutPut.dH;
  // FIXME: Would be nice with a semilinear here
  InPut.dH = InPut.dm * gas.h;
  annotation (Icon(graphics={
        Line(points={{-80,50},{-20,50},{-20,20},{20,20}}, color={0,0,255}),
        Line(points={{-80,-50},{-20,-50},{-20,-20},{20,-20}}, color={0,0,255}),
        Line(points={{20,-20},{20,-34},{20,-50},{80,-50}}, color={0,0,255}),
        Line(points={{20,20},{20,34},{20,50},{80,50}}, color={0,0,255}),
        Text(
          extent={{-100,100},{100,80}},
          lineColor={0,0,255},
          fillColor={0,115,0},
          fillPattern=FillPattern.Solid,
          textString=
               "%name")}),
                    Diagram(graphics));
end IdealRestriction;
