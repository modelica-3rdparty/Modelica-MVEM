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
partial model TwoPort "Model for all Flow Components with InPut and OutPut "
  // Define medium properties
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium annotation(choicesAllMatching=true);
  // Define i/o Connections
  Interfaces.GasPort InPut(redeclare replaceable package Medium = Medium)
     annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
  Interfaces.GasPort OutPut(redeclare replaceable package Medium = Medium)
     annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=
            0)));

end TwoPort;
