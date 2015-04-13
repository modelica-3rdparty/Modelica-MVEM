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
model HeatExchangePipe
  "Model of heating/cooling due to temperature difference and flow"
  extends MVEMLib.Basic.Restrictions.Partial.ThreePortWithExternalSource;

  parameter SI.Length D=0.007 "Pipe diameter";
  parameter SI.Length L=0.4 "Pipe length";
  parameter Integer n_pipes=4 "Number of pipes";
  parameter SI.CoefficientOfHeatTransfer h_external=100
    "External heat transfer";
  parameter SI.RatioOfSpecificHeatCapacities gamma=1.29
    "Ratio of speficic heats";
  parameter SI.DynamicViscosity mu=4e-5 "Dynamic Viscosity";
  parameter SI.ThermalConductivity lambda=0.06 "Thermal conductivity";
  parameter Integer HC_num=1 "Choice of heat correlation";
  parameter Boolean dmInReynolds = true
    "Use mass flow in calculation of reynolds number";

  // Gas properties
  Medium.BaseProperties gas_hot(T(start=300), p(start=1e5));
  Medium.BaseProperties gas_out(T(start=300), p(start=1e5));

protected
  SI.SpecificHeatCapacityAtConstantPressure c_p;
  SI.Area Wall_surf_area;
  SI.CoefficientOfHeatTransfer h_tot;
  SI.CoefficientOfHeatTransfer h_int;
  Real Re_num;
  SI.Temperature T_out;
  SI.Temperature T_cool;
  SI.Temperature T_hot;
  constant Real c_tf[18, 4]={{0.26,0.6,0,0},{0.18,0.7,0,0},{0.027,0.8,0.3333,
      0.14},{0.081,0.8,0.3333,0.14},{0.0432,0.8,0.3333,0.14},{0.0483,0.783,0,0},
      {0.258,0.8,0,0},{0.26,0.6,0,0},{0.83,0.46,0,0},{0.027,0.82,0,0},{0.02948,
      0.8,0,0},{0.02,0.8,0,0},{0.01994,0.8,0,0},{0.023,0.8,0.3,0},{0.48,0.5,0,0},
      {1.86,0.333,0.333,0.14},{0.0175,1,0,0},{0.023, 0.9, 0.3, 0}};
  // 01 Meisner Sorenson
  // 02 Shayler 1997a
  // 03 Sieder Tate
  // 04 Wendland Takedown
  // 05 Wendland Tailpipe
  // 06 Malcov et al
  // 07 Caton Heywood
  // 08 DOHC Downpipe
  // 09 Valencia downpipe
  // 10 PROMEX
  // 11 Woods
  // 12 Blair
  // 13 Standard
  // 14 Standard turbulent
  // 15 Eriksson
  // 16 Standard laminar 2
  // 17 Reynolds
  // 18 INTERCOOLER
  constant Real prandtl_num=0.7;
equation
  // Flow equations
  InPut.p = OutPut.p;
  InPut.T = OutPut.T;
  InPut.Xi = OutPut.Xi;

  InPut.dm = -OutPut.dm;
  InPut.dmXi = -OutPut.dmXi;
  InPut.dH = -OutPut.dH + InPut.dm*(gas_hot.h - gas_out.h);

  // Set flows from Ambiant to zero
  ExternalSource.dm = 0;
  ExternalSource.dmXi = ExternalSource.Xi*0;
  ExternalSource.dH = 0;

  // Gas properties, same upstream and downstream
  gas_hot.Xi*InPut.dm = InPut.dmXi;
  gas_hot.p = InPut.p;
  gas_hot.h*InPut.dm = InPut.dH;

  gas_out.Xi = gas_hot.Xi;
  gas_out.p = gas_hot.p;
  gas_out.T = T_out;

  c_p =Medium.specificHeatCapacityCp(gas_hot.state);

  // Temperature calculations
  Re_num = 4/Modelica.Constants.pi/D/mu* (if dmInReynolds then InPut.dm/n_pipes else 1/n_pipes);

  h_int = (prandtl_num^c_tf[HC_num, 3])*(Re_num^c_tf[HC_num, 2])*c_tf[HC_num, 1]
    /(D/lambda);
  h_tot = 1/(1/h_external + 1/h_int);
  Wall_surf_area = Modelica.Constants.pi*D*L;
  T_cool = ExternalSource.T;
  T_hot = gas_hot.T;
  // Temperature of flowing gas is modeled as a temperature drop/raise.
  T_out = T_cool + (T_hot - T_cool)*exp(-(if dmInReynolds then n_pipes/(abs(InPut.dm) + 1e-16) else n_pipes)*h_tot*
    Wall_surf_area/c_p);

  annotation (Diagram, Icon(graphics={
        Text(
          extent={{-100,-60},{100,-100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,20},{-20,-20}},
          lineColor={0,0,255},
          textString="InPut"),
        Text(
          extent={{18,-20},{98,20}},
          lineColor={0,0,255},
          textString="OutPut"),
        Line(points={{-76,50},{76,50}}, color={0,0,255}),
        Line(points={{-76,-50},{76,-50}}, color={0,0,255}),
        Rectangle(
          extent={{-68,58},{64,50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.CrossDiag,
          fillColor={255,255,255}),
        Line(
          points={{-20,64},{-2,82},{2,74},{18,94},{12,94},{18,88},{18,94}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{20,100},{60,62}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag,
          textString="Q")}));
end HeatExchangePipe;
