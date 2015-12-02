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

within MVEMLib.Basic.Volumes;
model FixedVolume "Fixed Volume, i.e. that cannot change size "
  extends Basic.Restrictions.Partial.TwoPort;
  parameter SI.AbsolutePressure pStart = 101300
    "Initial Pressure of open system";
  parameter SI.Volume VStart = 0.001 "Volume of the open system";
  parameter SI.Temperature TStart = 298 "Initial Temperature of open system";

  // Gas properties
  Medium.BaseProperties gas(T(start=TStart,fixed=true),p(start=pStart,fixed=true),
    X(start=Medium.reference_X,each fixed=true))
    "Pressure, temperature, composition, and other gas properties of the open system";
  // States or variables
protected
  SI.Mass m(start = pStart * VStart / 300 / TStart) "Mass of system";
  SI.Volume V(start = VStart) "Volume of system";
  // This state is not really needed but is used until der(gas.X) is rewritten
  // as a function of Input.X etc. For now mx=gas.X*m and der(mx) is used
  SI.Mass mXi[Medium.nXi] "Mass of respective independent gas component";
  SI.InternalEnergy U;
equation
  // The connectors need to know the properties of the gas that is flowing, i.e.
  // pressure temperature and composisiton. This information is then used to calculate
  // the mass flow through the conenction
  InPut.T  = gas.T;
  InPut.p  = gas.p;
  InPut.Xi = gas.Xi;
  OutPut.T = InPut.T;
  OutPut.p = InPut.p;
  OutPut.Xi = InPut.Xi;
  mXi = gas.Xi * m;
  // Saker som beror på inflöde
  //der(gas.X)*m = InPut.dmx-OutPut.dmX - der(m)*X;
   //der(m) = InPut.dm-OutPut.dm;
  der(m)  = InPut.dm  + OutPut.dm;
  der(mXi) = InPut.dmXi + OutPut.dmXi;
  // dU = dQ + dW = dQ -pdV
  // dU = m cv dT + (u(T,x_j)-h(T_j,x_j))dm_j
  der(U) = InPut.dH + OutPut.dH;
  U = m*gas.u;
  V = VStart;
  gas.p * V = m * gas.R * gas.T;
//initial equation
//  m = p * V / gas.R / T;
//  mX = m * gas.X;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,80},{100,100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString=
               "%name"),
        Text(
          extent={{-100,-80},{100,-100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString=
               "simpleCV")}),Diagram(graphics));
end FixedVolume;
