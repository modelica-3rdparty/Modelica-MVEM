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

within MVEMLib.Basic.Interfaces;
connector GasPort
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium;
  // The connectors need to know the properties of the gas that is flowing, i.e.
  // pressure temperature and composisiton. This information can then be passed on
  // to the restrictions so that they can calculate the mass-flow correctly.
  SI.Pressure p "Pressure in the connector point";
  SI.Temperature T "Temperature in the connector point";
  SI.MassFraction Xi[Medium.nXi]
    "Mass fractions of respective independent gas component in the connector point";
  flow SI.EnthalpyFlowRate dH "Specific enthalpy flow through the connector";
  flow SI.MassFlowRate dm "Total Mass flow through the connector";
  flow SI.MassFlowRate dmXi[Medium.nXi]
    "Mass flow of respective independent component through the connector";
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,115,0},
          fillPattern=FillPattern.Solid)}));
end GasPort;
