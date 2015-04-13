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

within MVEMLib.Basic.Restrictions.Partial;
partial model ThreePortWithExternalSource
  "Model for simple heat exchanging devices with InPut and OutPut + knowledge of temperature and/or pressure "
  replaceable package externalMedium =  Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);
  replaceable package flowMedium =  Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);

  Interfaces.GasPort InPut(redeclare replaceable package Medium = flowMedium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0)));
  Interfaces.GasPort OutPut(redeclare replaceable package Medium = flowMedium) annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  Interfaces.GasPort ExternalSource(redeclare replaceable package Medium = externalMedium) annotation ( Placement(transformation(extent={{-70,90},{-50,110}})));

end ThreePortWithExternalSource;
