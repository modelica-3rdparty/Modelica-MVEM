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
model throttleSanityCheck
  "Simple model that checks to see if the compressible and incompressible restrictions are behaving as expected"
  replaceable package Medium =
    Modelica.Media.IdealGases.MixtureGases.CombustionAir
    annotation (choicesAllMatching=true);
  Basic.Volumes.FixedVolume upVolume(redeclare replaceable package Medium = Medium,
         pStart=101300*1.7,
         VStart=0.002)
    annotation (Placement(transformation(extent={{-38,-30},{-18,-10}}, rotation=
           0)));
  Basic.Restrictions.Compressible upperThrottle(
                  redeclare replaceable package Medium = Medium)
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}}, rotation=
           0)));
  Modelica.Blocks.Sources.Constant const(        k=1e-5)
    annotation (Placement(transformation(extent={{-96,2},{-76,22}}, rotation=0)));
  Basic.Sources.ConstantGasReference constantGasReference(
                         redeclare replaceable package Medium = Medium,
    p=202600)
    annotation (Placement(transformation(extent={{-96,-30},{-76,-10}}, rotation=
           0)));
  Basic.Sources.ConstantGasReference constantGasReference1(
                          redeclare replaceable package Medium = Medium,
     p=101300)
    annotation (Placement(transformation(
        origin={88,-20},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Basic.Restrictions.Incompressible lowerPipe(
              redeclare replaceable package Medium = Medium,
       H=1e10)
    annotation (Placement(transformation(extent={{52,-30},{72,-10}}, rotation=0)));
  Basic.Restrictions.Compressible lowerThrottle(
                  redeclare replaceable package Medium = Medium)
    annotation (Placement(transformation(extent={{-8,-30},{12,-10}}, rotation=0)));
  Modelica.Blocks.Sources.Step throttheArea(
   startTime=0.2,
   offset=1e-5,
   height=-5e-6) "Models a step in throttle area"
    annotation (Placement(transformation(extent={{-48,20},{-28,40}}, rotation=0)));
  Basic.Volumes.FixedVolume downVolume(
               redeclare replaceable package Medium = Medium,
        pStart=101300*1.5,
        VStart=0.002)
    annotation (Placement(transformation(extent={{22,-30},{42,-10}}, rotation=0)));
equation
  connect(upperThrottle.OutPut, upVolume.InPut)
    annotation (Line(points={{-46,-20},{-38,-20}}, color={0,0,0}));
  connect(const.y, upperThrottle.Aeff)
    annotation (Line(points={{-75,12},{-72,12},{-72,-16},{-65.8,-16}}, color={0,
          0,127}));
  connect(constantGasReference.OutPut, upperThrottle.InPut)
    annotation (Line(points={{-76,-20},{-66,-20}}, color={0,0,0}));
  connect(lowerPipe.OutPut, constantGasReference1.OutPut)
    annotation (Line(points={{72,-20},{78,-20}}, color={0,0,0}));
  connect(throttheArea.y, lowerThrottle.Aeff) annotation (Line(points={{-27,30},
          {-16,30},{-16,-16},{-7.8,-16}}, color={0,0,127}));
  connect(downVolume.OutPut, lowerPipe.InPut)
    annotation (Line(points={{42,-20},{52,-20}}, color={0,0,0}));
  connect(lowerThrottle.OutPut, downVolume.InPut)
    annotation (Line(points={{12,-20},{22,-20}}, color={0,0,0}));
  connect(lowerThrottle.InPut, upVolume.OutPut)
    annotation (Line(points={{-8,-20},{-18,-20}}, color={0,0,0}));
  annotation (Diagram(graphics),
                       DymolaStoredErrors);
end throttleSanityCheck;
