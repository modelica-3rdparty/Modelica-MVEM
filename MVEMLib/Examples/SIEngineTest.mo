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

within MVEMLib.Examples;
model SIEngineTest "Constantspeed test of SI Engine"
  Engines.Combustion.SIEngine sIEngine
    annotation (Placement(transformation(extent={{2,0},{22,20}})));
  Modelica.Mechanics.Rotational.Sources.Speed ForcedSpeed
    annotation (Placement(transformation(extent={{2,40},{22,60}})));
  Modelica.Blocks.Sources.Constant EngineSpeed(k=1500) "Speed in RPM"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.UnitConversions.From_rpm from_rpm
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Modelica.Blocks.Sources.Step step(
    startTime=5,
    height=0.3,
    offset=0.05)
    annotation (Placement(transformation(extent={{-38,0},{-18,20}})));
equation
  connect(ForcedSpeed.flange, sIEngine.CrankShaft) annotation (Line(
      points={{22,50},{32,50},{32,10},{22,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(from_rpm.u, EngineSpeed.y) annotation (Line(
      points={{-32,50},{-39,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ForcedSpeed.w_ref, from_rpm.y) annotation (Line(
      points={{-6.66134e-16,50},{-9,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, sIEngine.TqRef) annotation (Line(
      points={{-17,10},{1.6,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=15, Tolerance=1e-05),
    experimentSetupOutput);
end SIEngineTest;
