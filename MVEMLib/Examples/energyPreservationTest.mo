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
model energyPreservationTest
  "Test of energy preservation properties of simpleControlVolume."
  replaceable package Medium =
    MVEMLib.Basic.Media.FuelAirMixture
    annotation (choicesAllMatching=true);
  Basic.Volumes.FixedVolume volume1(
            redeclare replaceable package Medium = Medium.airMedium,
     pStart = 202600)
    annotation (Placement(transformation(extent={{-72,4},{-52,24}}, rotation=0)));
  Basic.Volumes.FixedVolume volume2(
            redeclare replaceable package Medium =  Medium.airMedium,
     pStart = 101300)
    annotation (Placement(transformation(extent={{-6,4},{14,24}}, rotation=0)));
  MVEMLib.Basic.Restrictions.Compressible throttle(redeclare replaceable
      package Medium = Medium.airMedium) annotation (Placement(transformation(
          extent={{-36,4},{-16,24}}, rotation=0)));
  Modelica.Blocks.Sources.Step throttheArea(
    height=5e-6,
    offset=5e-6,
    startTime=0.2) "Models a step in throttle area"
    annotation (Placement(transformation(extent={{-76,38},{-56,58}}, rotation=0)));
  Real m1;
  Real m2;
  Real totalEnergy;
  Real totalMass;
equation
  m1 = volume1.gas.p*volume1.VStart/volume1.gas.R/volume1.gas.T;
  m2 = volume2.gas.p*volume2.VStart/volume2.gas.R/volume2.gas.T;
  totalMass   = m1 + m2;
  totalEnergy = volume1.gas.u*m1+volume2.gas.u*m2;
  connect(volume1.OutPut,throttle. InPut)
    annotation (Line(points={{-52,14},{-36,14}}, color={0,0,0}));
  connect(throttheArea.y,throttle. Aeff) annotation (Line(points={{-55,48},{-40,
          48},{-40,18},{-35.8,18}}, color={0,0,127}));
  connect(throttle.OutPut, volume2.InPut)
    annotation (Line(points={{-16,14},{-6,14}}, color={0,0,0}));
  annotation (Diagram(graphics));
end energyPreservationTest;
