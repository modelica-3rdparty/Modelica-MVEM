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

within MVEMLib.Basic.Sources;
class ForcedMassFlow
  extends MVEMLib.Basic.Restrictions.Partial.IdealRestriction;
  Modelica.Blocks.Interfaces.RealInput dm "Mass flow rate in kg/s"
    annotation (Placement(transformation(
        origin={0,-98},
        extent={{-10,-10},{10,10}},
        rotation=90)));
equation
  // The properties of the flow depends on the flow direction
  gas.T  = if dm > 0 then InPut.T else  OutPut.T;
  gas.p  = if dm > 0 then InPut.p else  OutPut.p;
  gas.Xi = if dm > 0 then InPut.Xi else OutPut.Xi;
  InPut.dm = dm;
  annotation (Icon(graphics={
        Line(points={{-80,8},{68,8}}, color={0,0,255}),
        Line(points={{-80,-8},{68,-8}}, color={0,0,255}),
        Line(points={{60,20},{80,0}}, color={0,0,255}),
        Line(points={{80,0},{60,-20}}, color={0,0,255}),
        Line(points={{-70,0},{-50,0}}, color={0,0,255}),
        Line(points={{-30,0},{-10,0}}, color={0,0,255}),
        Line(points={{12,0},{32,0}}, color={0,0,255}),
        Line(points={{48,0},{68,0}}, color={0,0,255})}));
end ForcedMassFlow;
