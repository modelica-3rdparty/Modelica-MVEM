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
model ConstantGasReference "Models infinite gas source"
  // Define medium properties
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  Medium.BaseProperties gas;
  parameter SI.AbsolutePressure p = 101300 "Pressure of source";
  parameter SI.Temperature T = 298 "Temperature of the source";
  parameter SI.MassFraction X[Medium.nX] = Medium.reference_X
    "Mass fractions of respective gas component of the source";
  // Define i/o Connections
  Interfaces.GasPort OutPut(redeclare replaceable package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  // Properties of the medium of the source is the same the properties in the connector
  OutPut.p = gas.p;
  OutPut.T = gas.T;
  OutPut.Xi = gas.Xi;
  gas.p = p;
  gas.T = T;
  // Instead of the independent variables Xi I want to use the actual X here since
  // that's what is specified as a starting point. This only works if there is an actual X and for
  // single component gases it may be reduced away

 // WARNING, this may break when something is reduced away!!!!
  if Medium.nXi > 0 then
    gas.X = X;
  end if;
  annotation (Diagram(graphics),
                       Icon(graphics={
        Rectangle(extent={{-80,60},{80,-60}}, lineColor={0,0,255}),
        Text(
          extent={{-100,-80},{100,-100}},
          lineColor={0,0,255},
          textString=
               "Constant"),
        Text(
          extent={{-100,100},{100,80}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Ellipse(extent={{-38,32},{-36,30}}, lineColor={0,0,255}),
        Ellipse(extent={{8,-8},{10,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-22,8},{-24,10}}, lineColor={0,0,255}),
        Ellipse(extent={{-4,28},{-2,26}}, lineColor={0,0,255}),
        Ellipse(extent={{-22,0},{-20,-2}}, lineColor={0,0,255}),
        Ellipse(extent={{-40,8},{-38,6}}, lineColor={0,0,255}),
        Ellipse(extent={{24,-10},{26,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,44},{-32,42}}, lineColor={0,0,255}),
        Ellipse(extent={{-44,16},{-42,18}}, lineColor={0,0,255}),
        Ellipse(extent={{-16,22},{-14,20}}, lineColor={0,0,255}),
        Ellipse(extent={{-6,40},{-4,38}}, lineColor={0,0,255}),
        Ellipse(extent={{-16,6},{-14,4}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,18},{-28,16}}, lineColor={0,0,255}),
        Ellipse(extent={{14,30},{16,28}}, lineColor={0,0,255}),
        Ellipse(extent={{0,18},{2,16}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,44},{-32,42}}, lineColor={0,0,255}),
        Ellipse(extent={{8,10},{10,8}}, lineColor={0,0,255}),
        Ellipse(extent={{-36,-30},{-34,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{14,-24},{16,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{-14,14},{-12,12}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,18},{-28,16}}, lineColor={0,0,255}),
        Ellipse(extent={{14,30},{16,28}}, lineColor={0,0,255}),
        Ellipse(extent={{0,18},{2,16}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,60},{-28,58}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,42},{-22,40}}, lineColor={0,0,255}),
        Ellipse(extent={{-10,-24},{-8,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{8,48},{10,46}}, lineColor={0,0,255}),
        Ellipse(extent={{34,-6},{36,-8}}, lineColor={0,0,255}),
        Ellipse(extent={{-20,28},{-18,26}}, lineColor={0,0,255}),
        Ellipse(extent={{10,38},{12,36}}, lineColor={0,0,255}),
        Ellipse(extent={{-22,-14},{-20,-16}}, lineColor={0,0,255}),
        Ellipse(extent={{8,10},{10,8}}, lineColor={0,0,255}),
        Ellipse(extent={{54,-30},{56,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{34,-22},{32,-20}}, lineColor={0,0,255}),
        Ellipse(extent={{52,-2},{54,-4}}, lineColor={0,0,255}),
        Ellipse(extent={{34,-30},{36,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{16,-22},{18,-24}}, lineColor={0,0,255}),
        Ellipse(extent={{70,-32},{72,-34}}, lineColor={0,0,255}),
        Ellipse(extent={{12,22},{14,20}}, lineColor={0,0,255}),
        Ellipse(extent={{12,-14},{14,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{40,-8},{42,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{40,18},{42,16}}, lineColor={0,0,255}),
        Ellipse(extent={{40,-24},{42,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{26,-12},{28,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{60,8},{62,6}}, lineColor={0,0,255}),
        Ellipse(extent={{56,-12},{58,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{12,22},{14,20}}, lineColor={0,0,255}),
        Ellipse(extent={{64,-20},{66,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{16,-40},{18,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{56,-40},{58,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{42,-16},{44,-18}}, lineColor={0,0,255}),
        Ellipse(extent={{26,-12},{28,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{60,8},{62,6}}, lineColor={0,0,255}),
        Ellipse(extent={{56,-12},{58,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{22,20},{24,18}}, lineColor={0,0,255}),
        Ellipse(extent={{44,-36},{46,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{54,26},{56,24}}, lineColor={0,0,255}),
        Ellipse(extent={{70,-20},{72,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{36,-2},{38,-4}}, lineColor={0,0,255}),
        Ellipse(extent={{56,16},{58,14}}, lineColor={0,0,255}),
        Ellipse(extent={{34,-44},{36,-46}}, lineColor={0,0,255}),
        Ellipse(extent={{-72,6},{-70,4}}, lineColor={0,0,255}),
        Ellipse(extent={{-36,-26},{-34,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{-56,-18},{-58,-16}}, lineColor={0,0,255}),
        Ellipse(extent={{-38,2},{-36,0}}, lineColor={0,0,255}),
        Ellipse(extent={{-56,-26},{-54,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{-74,-18},{-72,-20}}, lineColor={0,0,255}),
        Ellipse(extent={{-20,-28},{-18,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,18},{-66,16}}, lineColor={0,0,255}),
        Ellipse(extent={{-78,-10},{-76,-8}}, lineColor={0,0,255}),
        Ellipse(extent={{-50,-4},{-48,-6}}, lineColor={0,0,255}),
        Ellipse(extent={{-40,14},{-38,12}}, lineColor={0,0,255}),
        Ellipse(extent={{-50,-20},{-48,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{-64,-8},{-62,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-20,4},{-18,2}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,-8},{-32,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,18},{-66,16}}, lineColor={0,0,255}),
        Ellipse(extent={{-26,-16},{-24,-18}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,-36},{-66,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,-42},{-28,-44}}, lineColor={0,0,255}),
        Ellipse(extent={{-48,-12},{-46,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{-64,-8},{-62,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-20,4},{-18,2}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,-8},{-32,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-58,16},{-56,14}}, lineColor={0,0,255}),
        Ellipse(extent={{-44,-34},{-42,-36}}, lineColor={0,0,255}),
        Ellipse(extent={{-26,22},{-24,20}}, lineColor={0,0,255}),
        Ellipse(extent={{-10,-24},{-8,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,2},{-52,0}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,12},{-22,10}}, lineColor={0,0,255}),
        Ellipse(extent={{-56,-40},{-54,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{8,42},{10,40}}, lineColor={0,0,255}),
        Ellipse(extent={{44,10},{46,8}}, lineColor={0,0,255}),
        Ellipse(extent={{24,18},{22,20}}, lineColor={0,0,255}),
        Ellipse(extent={{42,38},{44,36}}, lineColor={0,0,255}),
        Ellipse(extent={{24,10},{26,8}}, lineColor={0,0,255}),
        Ellipse(extent={{6,18},{8,16}}, lineColor={0,0,255}),
        Ellipse(extent={{60,8},{62,6}}, lineColor={0,0,255}),
        Ellipse(extent={{12,54},{14,52}}, lineColor={0,0,255}),
        Ellipse(extent={{2,26},{4,28}}, lineColor={0,0,255}),
        Ellipse(extent={{30,32},{32,30}}, lineColor={0,0,255}),
        Ellipse(extent={{40,50},{42,48}}, lineColor={0,0,255}),
        Ellipse(extent={{30,16},{32,14}}, lineColor={0,0,255}),
        Ellipse(extent={{16,28},{18,26}}, lineColor={0,0,255}),
        Ellipse(extent={{60,40},{62,38}}, lineColor={0,0,255}),
        Ellipse(extent={{46,28},{48,26}}, lineColor={0,0,255}),
        Ellipse(extent={{12,54},{14,52}}, lineColor={0,0,255}),
        Ellipse(extent={{54,20},{56,18}}, lineColor={0,0,255}),
        Ellipse(extent={{20,-28},{22,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{60,-14},{62,-16}}, lineColor={0,0,255}),
        Ellipse(extent={{32,24},{34,22}}, lineColor={0,0,255}),
        Ellipse(extent={{16,28},{18,26}}, lineColor={0,0,255}),
        Ellipse(extent={{60,40},{62,38}}, lineColor={0,0,255}),
        Ellipse(extent={{46,28},{48,26}}, lineColor={0,0,255}),
        Ellipse(extent={{22,52},{24,50}}, lineColor={0,0,255}),
        Ellipse(extent={{54,58},{56,56}}, lineColor={0,0,255}),
        Ellipse(extent={{70,12},{72,10}}, lineColor={0,0,255}),
        Ellipse(extent={{26,38},{28,36}}, lineColor={0,0,255}),
        Ellipse(extent={{56,48},{58,46}}, lineColor={0,0,255}),
        Ellipse(extent={{34,-12},{36,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{-70,42},{-68,40}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,10},{-32,8}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,18},{-56,20}}, lineColor={0,0,255}),
        Ellipse(extent={{-36,38},{-34,36}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,10},{-52,8}}, lineColor={0,0,255}),
        Ellipse(extent={{-72,18},{-70,16}}, lineColor={0,0,255}),
        Ellipse(extent={{-18,8},{-16,6}}, lineColor={0,0,255}),
        Ellipse(extent={{-66,54},{-64,52}}, lineColor={0,0,255}),
        Ellipse(extent={{-76,26},{-74,28}}, lineColor={0,0,255}),
        Ellipse(extent={{-48,32},{-46,30}}, lineColor={0,0,255}),
        Ellipse(extent={{-38,50},{-36,48}}, lineColor={0,0,255}),
        Ellipse(extent={{-48,16},{-46,14}}, lineColor={0,0,255}),
        Ellipse(extent={{-62,28},{-60,26}}, lineColor={0,0,255}),
        Ellipse(extent={{-18,40},{-16,38}}, lineColor={0,0,255}),
        Ellipse(extent={{-32,28},{-30,26}}, lineColor={0,0,255}),
        Ellipse(extent={{-66,54},{-64,52}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,20},{-22,18}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,-20},{-66,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{-28,-6},{-26,-8}}, lineColor={0,0,255}),
        Ellipse(extent={{-46,24},{-44,22}}, lineColor={0,0,255}),
        Ellipse(extent={{-62,28},{-60,26}}, lineColor={0,0,255}),
        Ellipse(extent={{-18,40},{-16,38}}, lineColor={0,0,255}),
        Ellipse(extent={{-32,28},{-30,26}}, lineColor={0,0,255}),
        Ellipse(extent={{-56,52},{-54,50}}, lineColor={0,0,255}),
        Ellipse(extent={{-42,-14},{-40,-16}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,58},{-22,56}}, lineColor={0,0,255}),
        Ellipse(extent={{-8,12},{-6,10}}, lineColor={0,0,255}),
        Ellipse(extent={{-52,38},{-50,36}}, lineColor={0,0,255}),
        Ellipse(extent={{-22,48},{-20,46}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,-4},{-52,-6}}, lineColor={0,0,255}),
        Ellipse(extent={{4,-20},{6,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{-26,-12},{-24,-14}}, lineColor={0,0,255}),
        Ellipse(extent={{20,-22},{22,-24}}, lineColor={0,0,255}),
        Ellipse(extent={{-40,-42},{-38,-44}}, lineColor={0,0,255}),
        Ellipse(extent={{10,-36},{12,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{-14,-36},{-12,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-18},{32,-20}}, lineColor={0,0,255}),
        Ellipse(extent={{-26,-26},{-24,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{50,-42},{52,-44}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-34},{28,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-42},{32,-44}}, lineColor={0,0,255}),
        Ellipse(extent={{12,-34},{14,-36}}, lineColor={0,0,255}),
        Ellipse(extent={{66,-44},{68,-46}}, lineColor={0,0,255}),
        Ellipse(extent={{8,-26},{10,-24}}, lineColor={0,0,255}),
        Ellipse(extent={{36,-20},{38,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{36,-36},{38,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{22,-24},{24,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{52,-24},{54,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{60,-32},{62,-34}}, lineColor={0,0,255}),
        Ellipse(extent={{12,-52},{14,-54}}, lineColor={0,0,255}),
        Ellipse(extent={{52,-52},{54,-54}}, lineColor={0,0,255}),
        Ellipse(extent={{38,-28},{40,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{22,-24},{24,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{52,-24},{54,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{40,-48},{42,-50}}, lineColor={0,0,255}),
        Ellipse(extent={{76,-40},{78,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-56},{32,-58}}, lineColor={0,0,255}),
        Ellipse(extent={{-40,-38},{-38,-40}}, lineColor={0,0,255}),
        Ellipse(extent={{-60,-30},{-62,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{-42,-10},{-40,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{-60,-38},{-58,-40}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,-40},{-22,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,-16},{-52,-18}}, lineColor={0,0,255}),
        Ellipse(extent={{-54,-32},{-52,-34}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,-20},{-66,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,-8},{-22,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-30,-28},{-28,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{-72,-48},{-70,-50}}, lineColor={0,0,255}),
        Ellipse(extent={{-34,-54},{-32,-56}}, lineColor={0,0,255}),
        Ellipse(extent={{-52,-24},{-50,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{-68,-20},{-66,-22}}, lineColor={0,0,255}),
        Ellipse(extent={{-24,-8},{-22,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{-48,-46},{-46,-48}}, lineColor={0,0,255}),
        Ellipse(extent={{-14,-36},{-12,-38}}, lineColor={0,0,255}),
        Ellipse(extent={{-58,-10},{-56,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{-60,-52},{-58,-54}}, lineColor={0,0,255}),
        Ellipse(extent={{16,-40},{18,-42}}, lineColor={0,0,255}),
        Ellipse(extent={{56,-26},{58,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{30,-24},{32,-26}}, lineColor={0,0,255}),
        Ellipse(extent={{-72,-32},{-70,-34}}, lineColor={0,0,255}),
        Ellipse(extent={{-32,-18},{-30,-20}}, lineColor={0,0,255}),
        Ellipse(extent={{-46,-26},{-44,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{-58,-16},{-56,-18}}, lineColor={0,0,255}),
        Ellipse(extent={{6,6},{4,8}}, lineColor={0,0,255}),
        Ellipse(extent={{12,20},{14,18}}, lineColor={0,0,255}),
        Ellipse(extent={{12,4},{14,2}}, lineColor={0,0,255}),
        Ellipse(extent={{-2,16},{0,14}}, lineColor={0,0,255}),
        Ellipse(extent={{-8,-32},{-6,-34}}, lineColor={0,0,255}),
        Ellipse(extent={{14,12},{16,10}}, lineColor={0,0,255}),
        Ellipse(extent={{-2,16},{0,14}}, lineColor={0,0,255}),
        Ellipse(extent={{18,-26},{20,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{6,-16},{8,-18}}, lineColor={0,0,255}),
        Ellipse(extent={{-8,-28},{-6,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{-10,0},{-8,-2}}, lineColor={0,0,255}),
        Ellipse(extent={{8,-30},{10,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{8,2},{10,0}}, lineColor={0,0,255}),
        Ellipse(extent={{-6,-10},{-4,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{2,-18},{4,-20}}, lineColor={0,0,255}),
        Ellipse(extent={{8,2},{10,0}}, lineColor={0,0,255}),
        Ellipse(extent={{-6,-10},{-4,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{2,20},{4,18}}, lineColor={0,0,255}),
        Ellipse(extent={{18,-26},{20,-28}}, lineColor={0,0,255}),
        Ellipse(extent={{4,10},{6,8}}, lineColor={0,0,255}),
        Ellipse(extent={{-6,8},{-4,6}}, lineColor={0,0,255}),
        Ellipse(extent={{10,6},{12,4}}, lineColor={0,0,255}),
        Ellipse(extent={{4,18},{6,16}}, lineColor={0,0,255}),
        Ellipse(extent={{0,-8},{2,-10}}, lineColor={0,0,255}),
        Ellipse(extent={{20,10},{22,8}}, lineColor={0,0,255}),
        Ellipse(extent={{2,-14},{4,-16}}, lineColor={0,0,255}),
        Ellipse(extent={{2,-28},{4,-30}}, lineColor={0,0,255}),
        Ellipse(extent={{4,-10},{6,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{-2,-30},{0,-32}}, lineColor={0,0,255}),
        Ellipse(extent={{4,-10},{6,-12}}, lineColor={0,0,255}),
        Ellipse(extent={{-4,-20},{-2,-22}}, lineColor={0,0,255})}));
end ConstantGasReference;
