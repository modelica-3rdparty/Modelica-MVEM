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
partial class NaturalFlowRestriction
  "Partial model for restrictions for which the flow always is from high pressure to low pressure"
  extends MVEMLib.Basic.Restrictions.Partial.IdealRestriction;
equation
  // For a natural restriction flow is always from high pressure to low pressure
  gas.T  = if InPut.p > OutPut.p then InPut.T else  OutPut.T;
  gas.p  = if InPut.p > OutPut.p then InPut.p else  OutPut.p;
  gas.Xi = if InPut.p > OutPut.p then InPut.Xi else OutPut.Xi;
  annotation (Icon(graphics={
        Line(points={{-80,66},{80,66},{66,76}}, color={0,0,255}),
        Line(points={{80,66},{68,54}}, color={0,0,255}),
        Line(points={{-68,78},{-80,66}}, color={0,0,255}),
        Line(points={{-80,66},{-68,54}}, color={0,0,255})}));
end NaturalFlowRestriction;
