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
model Compressor "Model of compressor"
    extends MVEMLib.Basic.Restrictions.Partial.NonIdealRestriction;

  parameter SI.Length D =                                       0.1
    "Compressor Diameter";
  parameter Real Psi_max =                                      2.3
    "Maximum Psi";
  parameter Real Phi_max =                                      0.12
    "Maximum Psi";
  parameter SI.Efficiency eta_max =                             0.8
    "Maximum efficiency";
  parameter Real Phi_at_eta_max =                               0.06
    "Phi at maximum efficiency";
  parameter SI.Efficiency eta_min =                             0.3
    "Minimum efficiency";

  // Medium to keep track of temperature increase/drop
  // Medium.BaseProperties gas_out(T(start=300),p(start=1e5));

  // Mechanical flange
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation (
      Placement(transformation(extent={{-10,-110},{10,-90}}),
                                                           iconTransformation(
          extent={{-10,-110},{10,-90}})));

protected
  SI.SpecificHeatCapacityAtConstantPressure cp;
  SI.Temperature T_out;
  Real PI;
  Real Psi;
  Real N;
  Real Phi;
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
  InPut.dH = -OutPut.dH; // + InPut.dm*(gas.h - gas_out.h);

  // Calculate some necessary properties
  gamma = Medium.isentropicExponent(gas.state);
  cp = Medium.specificHeatCapacityCp(gas.state);

  // Speed of the turbine
  w_tc = der(flange_b.phi);
  N = w_tc / 2 / Modelica.Constants.pi;

  // Pressure ratio
  PI = max(OutPut.p/InPut.p,1);

  Psi = cp / (D ^ 2) * gas.T * (min(PI,10) ^ ((gamma-1) / gamma) - 1) / (N ^ 2);
  Phi = Phi_max * sqrt(1 - max(min((Psi/Psi_max)^2,1),0));

  // Compressor Efficiency
  eta = min(max(Phi * ((Phi_at_eta_max * 2 - Phi) / (Phi_at_eta_max ^ 2)) * eta_max,  max( eta_min,  1e-3)), 1);

  // Temperature calculations
  T_out = gas.T*(1+(PI^(1-1/gamma)-1)/eta);

  // Compressor Mass Flow
  InPut.dm  = Phi * InPut.p / gas.T / gas.R * N * D^3;

  // Torque calculation
  flange_b.tau = cp * max((T_out-gas.T),0) * InPut.dm / w_tc;

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
end Compressor;
