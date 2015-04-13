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
model FixedTurbine "Model of Turbine Without Wastegate"
  extends MVEMLib.Basic.Restrictions.Partial.NonIdealRestriction;

  parameter Real k1 =                                               0.0170
    "Turbine mass flow fit paramter";
  parameter Real k2 =                                               1.4
    "Turbine mass flow fit paramter";
  parameter SI.Length D =                                           0.05
    "Trubine diameter";
  parameter SI.Efficiency eta_max =                                 0.75
    "Maximum efficency";
  parameter Real eta_max_BSR =                                      0.7
    "Maximum efficiency blade speed ratio";
  parameter SI.Efficiency eta_min =                                 0.3
    "Minimum efficency";

  // Medium to keep track of temperature increase/drop
  //Medium.BaseProperties gas_out(T(start=300),p(start=1e5));

  // Mechanical flange
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}),
                                                           iconTransformation(
          extent={{-10,-110},{10,-90}})));

   // Working variables
protected
  Real BSR;
  SI.SpecificHeatCapacityAtConstantPressure cp;
  SI.Temperature T_out;
  Real PI;
  Real N;
  Real eta;
  Real gamma;
  Real w_tc;

equation
  // The flowing medium is from InPut for typical compressors
  gas.T  = InPut.T;
  gas.p  = InPut.p;
  gas.Xi = InPut.Xi;

  // Keep track of enthalpy change due to temperature increase/drop
  //gas_out.Xi = gas.Xi;
  //gas_out.p = gas.p;
  //gas_out.T = T_out;

  // The only equation that is needed, and is not in the base class.
  InPut.dH = -OutPut.dH;  //+ InPut.dm*(gas.h - gas_out.h);

  // Calculate some necessary properties
  gamma = Medium.isentropicExponent(gas.state);
  cp = Medium.specificHeatCapacityCp(gas.state);

  // Turbine Speed
  w_tc = der(flange_a.phi);
  N = w_tc / 2 / Modelica.Constants.pi;

  // Pressure ratio
  PI = min(1,OutPut.p/InPut.p);

  // Temperature calculations
  T_out = gas.T * (1 - eta * (1 - PI ^ (1-1/gamma)));

  // Turbine Efficiency
  BSR = (D / 2) * w_tc / sqrt(max((1 - (1/PI) ^ ((1-gamma)/gamma)) * 2 * cp * T_out,0.001));
  eta = min(max(eta_max * (1 - ((BSR - eta_max_BSR) / eta_max_BSR) ^ 2),eta_min),eta_max);

  // Turbine mass flow
  InPut.dm = sqrt(max(1 - (PI ^ k2),  0)) * k1 / sqrt(T_out) * (OutPut.p / 1000);

  // Torque calculation
  flange_a.tau = -cp * max((gas.T-T_out),0) * InPut.dm / w_tc;

  // Turbine Torque
  // Wastegate.A_eff = WG_Amax*WG_Cd*u_wg;

  // Wastegate
  //MixAfterWastegate.T_1 = Temperature.T_out;

  // Mix after wastegate
  //MixAfterWastegate.mFlow_1 = W_turbine;
  //W_es = MixAfterWastegate.mFlow_tot;

  // FIX WASTEGATE

  annotation (Diagram, Icon(graphics={
        Text(
          extent={{-100,20},{-20,-20}},
          lineColor={0,0,255},
          textString="InPut"),
        Text(
          extent={{18,-20},{98,20}},
          lineColor={0,0,255},
          textString="OutPut"),
        Text(
          extent={{-20,-80},{78,-100}},
          lineColor={0,0,255},
          textString="Shaft")}));
end FixedTurbine;
