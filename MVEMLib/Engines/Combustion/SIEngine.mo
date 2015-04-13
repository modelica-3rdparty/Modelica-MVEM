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
class SIEngine
  "A simple SI engine with intake and exhaust manifold as well as throttle."
  extends Parts.Partial.PartialEngine(engineInertia(phi(fixed=false), w(fixed=
            false, start=1000/60*2*3.1415)));
  replaceable package fuelAirMedium = Basic.Media.FuelAirMixture annotation (
      choicesAllMatching=true);
  Basic.Media.FuelAirMixer fuelAirMixer(redeclare replaceable package
      fuelAirMedium = fuelAirMedium) annotation (Placement(transformation(
        origin={80,-30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Basic.Volumes.FixedVolume intakeManifold(redeclare replaceable package Medium
      = fuelAirMedium.airMedium, VStart=0.0018) annotation (Placement(
        transformation(extent={{14,44},{34,64}}, rotation=0)));
  Basic.Volumes.FixedVolume exhaustManifold(VStart=0.0025, redeclare
      replaceable package Medium = fuelAirMedium.burnedMedium) annotation (
      Placement(transformation(
        origin={-40,-70},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Basic.Sources.ConstantGasReference ambiantAir(redeclare replaceable package
      Medium = fuelAirMedium.airMedium) annotation (Placement(transformation(
          extent={{-152,62},{-132,82}},
                                      rotation=0)));
  Basic.Sources.ConstantGasReference fuel(redeclare replaceable package Medium
      = fuelAirMedium.fuelMedium) annotation (Placement(transformation(
        origin={90,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Basic.Restrictions.Incompressible ExhaustSystem(
    H=300e7,
    redeclare replaceable package Medium = fuelAirMedium.burnedMedium,
    pLin=300) annotation (Placement(transformation(
        origin={-114,-70},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  MVEMLib.Engines.Combustion.Parts.SpeedDensityEngineFlow engineFlow(
                                                       redeclare replaceable
      package Medium = fuelAirMedium.airMedium) annotation (Placement(
        transformation(
        origin={70,30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Blocks.Sources.Constant const(k=fuelAirMedium.AFs) annotation (
      Placement(transformation(extent={{-60,80},{-38,100}}, rotation=0)));
  Basic.Sensors.MassFlowSensor massFlow(redeclare package Medium =
        fuelAirMedium.airMedium) annotation (Placement(transformation(extent={{-20,44},
            {0,64}},           rotation=0)));
  Modelica.Blocks.Math.Division fuelDemand annotation (Placement(transformation(
          extent={{0,80},{20,100}}, rotation=0)));
  Basic.Sources.ForcedMassFlow forcedMassFlow(redeclare replaceable package
      Medium = fuelAirMedium.fuelMedium) annotation (Placement(transformation(
        origin={90,62},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Basic.Sources.ConstantGasReference ambiantMix(redeclare replaceable package
      Medium = fuelAirMedium.burnedMedium) annotation (Placement(transformation(
          extent={{-150,-80},{-130,-60}},
                                        rotation=0)));
  //Real burnedGasComposition[fuelAirMedium.burnedMedium.nXi];
  //Real dummyOutput;
  Basic.Media.AdiabaticBurner adiabaticBurner annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,-70})));
  MVEMLib.Engines.Combustion.Parts.SIEfficiency ottoEfficiency(redeclare
      package externalMedium = fuelAirMedium.airMedium, redeclare package
      flowMedium = fuelAirMedium.burnedMedium)                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={22,-70})));
  MVEMLib.Basic.Restrictions.HeatExchangePipe exhaustTemperatureDrop(
      redeclare package externalMedium = fuelAirMedium.airMedium, redeclare
      package flowMedium = fuelAirMedium.burnedMedium)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,-70})));
  Modelica.Blocks.Math.Gain gain(k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-22,84})));
  MVEMLib.Basic.Restrictions.SimpleHeatExchangePipe interCooler(
                                                              redeclare package
      Medium = fuelAirMedium.airMedium,
    redeclare package externalMedium = fuelAirMedium.airMedium,
    redeclare package flowMedium = fuelAirMedium.airMedium)
    annotation (Placement(transformation(extent={{-72,44},{-52,64}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (Placement(
        transformation(extent={{10,20},{30,40}}, rotation=0)));
  Engines.Combustion.Parts.ButterflyThrottle throttle(
                                   redeclare replaceable package Medium =
        fuelAirMedium.airMedium, redeclare
      MVEMLib.Engines.Combustion.Parts.ThrottleServo throttleServo(Amin=15e-6,
        Amax=1000e-6))                                                                                      annotation (Placement(
        transformation(extent={{-46,44},{-26,64}}, rotation=0)));
  Basic.Volumes.FixedVolume compressorCV(redeclare replaceable package Medium
      = fuelAirMedium.airMedium, VStart=3e-3)   annotation (Placement(
        transformation(extent={{-98,66},{-76,86}},
                                                 rotation=0)));
  Basic.Volumes.FixedVolume turbineCV(redeclare replaceable package Medium =
        fuelAirMedium.burnedMedium, VStart=3e-3)               annotation (
      Placement(transformation(
        origin={-90,-70},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Engines.Combustion.Parts.TurboShaft turboShaft1(cFUpper=0.2e-6)
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-74,2})));
  Modelica.Blocks.Sources.Constant wg_control(k=0)            annotation (
      Placement(transformation(extent={{-6,-6},{6,6}},      rotation=180,
        origin={-34,-94})));
  Engines.Combustion.Parts.Compressor compressor(redeclare package Medium =
        fuelAirMedium.airMedium)
    annotation (Placement(transformation(extent={{-124,66},{-104,86}})));
  Engines.Combustion.Parts.TurbineWithWasteGate turbineWithWasteGate(redeclare
      package Medium = fuelAirMedium.burnedMedium) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-66,-70})));
equation
  // Debug  burned fractions calculation
  //(burnedGasComposition,dummyOutput)=fuelAirMedium.calcBurnedFractions(exhaustManifold.InPut.dmXi,2000);
  connect(intakeManifold.OutPut, engineFlow.InPut)
    annotation (Line(points={{34,54},{70,54},{70,40}}, color={0,0,0}));
  connect(massFlow.OutPut, intakeManifold.InPut)
    annotation (Line(points={{5.55112e-16,54},{5.55112e-16,54},{14,54}},
                                                color={0,0,0}));
  connect(const.y, fuelDemand.u2) annotation (Line(points={{-36.9,90},{-12,90},
          {-12,84},{-2,84}}, color={0,0,127}));
  connect(fuel.OutPut, forcedMassFlow.InPut)
    annotation (Line(points={{90,80},{90,72}}, color={0,0,0}));
  connect(forcedMassFlow.dm, fuelDemand.y) annotation (Line(points={{80.2,62},{
          76,62},{76,90},{21,90}}, color={0,0,127}));
  connect(ambiantMix.OutPut, ExhaustSystem.OutPut)
    annotation (Line(points={{-130,-70},{-124,-70}},
                                                   color={0,0,0}));
  connect(forcedMassFlow.OutPut, fuelAirMixer.FuelInPut) annotation (Line(
        points={{90,52},{90,8},{86,8},{86,-19.8}}, color={0,0,0}));
  connect(engineFlow.OutPut, fuelAirMixer.AirInPut)
    annotation (Line(points={{70,20},{70,8},{74,8},{74,-20}}, color={0,0,0}));
  connect(adiabaticBurner.UnburnedInPut, fuelAirMixer.MixOutPut) annotation (
      Line(
      points={{56,-70},{80,-70},{80,-40.2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ottoEfficiency.InPut, adiabaticBurner.BurnedOutPut) annotation (Line(
      points={{32,-70},{36,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ottoEfficiency.dh, adiabaticBurner.dh) annotation (Line(
      points={{22,-81},{22,-90},{46,-90},{46,-81}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(exhaustTemperatureDrop.InPut, ottoEfficiency.OutPut) annotation (Line(
      points={{5.55112e-16,-70},{12,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(exhaustManifold.InPut, exhaustTemperatureDrop.OutPut) annotation (
      Line(
      points={{-30,-70},{-20,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(massFlow.dm, gain.u) annotation (Line(
      points={{-10,64},{-10,68},{-22,68},{-22,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, fuelDemand.u1) annotation (Line(
      points={{-22,95},{-12,95},{-12,96},{-2,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speedSensor.w, engineFlow.wEng) annotation (Line(
      points={{31,30},{61,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(throttle.OutPut, massFlow.InPut) annotation (Line(
      points={{-26,54},{-20,54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(interCooler.OutPut, throttle.InPut) annotation (Line(
      points={{-52,54},{-46,54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ottoEfficiency.wEng, speedSensor.w) annotation (Line(
      points={{16,-81},{16,-94},{64,-94},{64,12},{31,12},{31,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ottoEfficiency.ExternalSource, intakeManifold.OutPut) annotation (
      Line(
      points={{28,-80},{28,-86},{60,-86},{60,2},{40,2},{40,54},{34,54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(turbineCV.OutPut, ExhaustSystem.InPut) annotation (Line(
      points={{-100,-70},{-104,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(interCooler.ExternalSource, ambiantAir.OutPut) annotation (Line(
      points={{-68,64},{-68,90},{-132,90},{-132,72}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ambiantAir.OutPut, exhaustTemperatureDrop.ExternalSource) annotation (
     Line(
      points={{-132,72},{-138,72},{-138,-40},{-158,-40},{-158,-112},{-4,-112},{
          -4,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(compressorCV.OutPut, interCooler.InPut) annotation (Line(
      points={{-76,76},{-74,76},{-74,54},{-72,54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ambiantAir.OutPut, compressor.InPut) annotation (Line(
      points={{-132,72},{-128,72},{-128,76},{-124,76}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(compressor.OutPut, compressorCV.InPut) annotation (Line(
      points={{-104,76},{-98,76}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(turbineCV.InPut, turbineWithWasteGate.OutPut) annotation (Line(
      points={{-80,-70},{-76,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(turbineWithWasteGate.InPut, exhaustManifold.OutPut) annotation (Line(
      points={{-56,-70},{-50,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(wg_control.y, turbineWithWasteGate.uWG) annotation (Line(
      points={{-40.6,-94},{-48,-94},{-48,-78},{-56,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turboShaft1.flange_b, turbineWithWasteGate.flange_a) annotation (Line(
      points={{-74,-8},{-74,-30},{-54,-30},{-54,-54},{-66,-54},{-66,-60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(compressor.flange_b, turboShaft1.flange_a) annotation (Line(
      points={{-114,66},{-112,66},{-112,60},{-80,60},{-80,12},{-74,12}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(throttle.ThrottleRef, TqRef) annotation (Line(
      points={{-46.2,61},{-50,61},{-50,16},{-104,16},{-104,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ottoEfficiency.Tq, engineTorque.tau) annotation (Line(
      points={{22,-59},{22,-30},{-34,-30},{-34,6.66134e-16},{-26,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(speedSensor.flange, engineInertia.flange_a) annotation (Line(
      points={{10,30},{0,30},{0,6.10623e-16},{-5.55112e-16,6.10623e-16}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (
    extent=[60, -70; 80, -50],
    rotation=180,
    Diagram(graphics),
    experiment(
      StopTime=6,
      Interval=0.001,
      Tolerance=1e-05),
    experimentSetupOutput,
    Placement(transformation(
        origin={70,-60},
        extent={{-10,-10},{10,10}},
        rotation=180)),
    Diagram);
end SIEngine;
