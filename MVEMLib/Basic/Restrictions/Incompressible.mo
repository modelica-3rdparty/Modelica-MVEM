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

within MVEMLib.Basic.Restrictions;
model Incompressible "Model of incompressible restrictions such as air filter"
  extends MVEMLib.Basic.Restrictions.Partial.NaturalFlowRestriction;
  parameter Real H =           1e7 "Flow resitance";
  parameter SI.Pressure pLin = 100 "Linearization limit";
  // Intermediate calculation variables
protected
  Real pDiff;
  Real flowDir;
equation
  pDiff = abs(InPut.p - OutPut.p);
  flowDir = sign(InPut.p - OutPut.p);
  InPut.dm = (if pLin > pDiff then  pDiff / sqrt(pLin) else sqrt(pDiff)) * sqrt(gas.p / H / gas.T) * flowDir;
  annotation (Icon(graphics={Text(
          extent={{-2,-80},{-2,-100}},
          lineColor={0,0,255},
          fillColor={0,115,0},
          fillPattern=FillPattern.Solid,
          textString=
               "Incompressible"), Text(
          extent={{-100,100},{100,80}},
          lineColor={0,0,255},
          fillColor={0,115,0},
          fillPattern=FillPattern.Solid,
          textString=
               "%name")}));
end Incompressible;
