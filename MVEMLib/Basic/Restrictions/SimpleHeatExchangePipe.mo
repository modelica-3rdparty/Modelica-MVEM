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
model SimpleHeatExchangePipe
  "Model of heating/cooling due to temperature difference and efficiecy"
  extends MVEMLib.Basic.Restrictions.Partial.ThreePortWithExternalSource;

  parameter Real epsilon=0.81 "Intercooler efficiency";

  // Gas properties
  Medium.BaseProperties gas_hot(T(start=300), p(start=1e5));
  Medium.BaseProperties gas_out(T(start=300), p(start=1e5));

protected
  SI.Temperature T_out;
  SI.Temperature T_cool;
  SI.Temperature T_hot;
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

  // Temperature calculations
  T_cool = ExternalSource.T;
  T_hot = gas_hot.T;
  // Temperature of flowing gas is modeled as a temperature drop/raise.
  T_out = T_cool + (T_hot - T_cool)*epsilon;

  annotation (Diagram(graphics),
                       Icon(graphics={
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
end SimpleHeatExchangePipe;
