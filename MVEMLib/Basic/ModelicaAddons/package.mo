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

within MVEMLib.Basic;
package ModelicaAddons "Modelica addons, with same structure as Modelica Standard lib"
  package Blocks
    package Math
      block Poly "Output polynomial of the input"
      extends Modelica.Blocks.Interfaces.SISO;
      parameter Integer n=1 "Polynomial order";
      parameter Real Cpol[:]=fill(0.0, n)
        "Polynomial coefficients for c1 + c2*u + ... + cn * u^(n-1)";
    protected
      Real upow[size(Cpol, 1)];
      equation
      y = upow*Cpol;
      upow[1] = 1;
      for i in 1:(n - 1) loop
        upow[i + 1] = upow[i]*u;
      end for;
      annotation (Icon(graphics={
            Line(points={{-68,-70},{-12,-42},{24,0},{52,48},{64,86}}, color={0,
                  0,255}),
            Line(points={{-82,-74},{84,-74}}, color={0,0,255}),
            Line(points={{-74,-82},{-74,90}}, color={0,0,255}),
            Line(points={{-78,84},{-74,90},{-70,84}}, color={0,0,255}),
            Line(points={{78,-70},{84,-74},{78,-78}}, color={0,0,255})}));
      end Poly;
    end Math;

    package Continous
      block LimitPIDWithReset
      "Antiwindup limitable PID controller with reset input. Resets on raising and falling edge of reset input."
      extends Modelica.Blocks.Continuous.LimPID;
      Modelica.Blocks.Interfaces.RealInput PIReset
        "Reset signal, triggers reset on beginning of raising and falling edges. (der > 1e-6)"
        annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
              rotation=0)));
    protected
      Boolean isReset;
      equation
      isReset = abs(der(PIReset)) > 1e-6;
      algorithm
      when isReset then
        reinit(I.y, I.y_start);
      elsewhen not isReset then
        reinit(I.y, I.y_start);
      end when;
      annotation (Diagram(graphics),
                           Icon(graphics));
      end LimitPIDWithReset;
    end Continous;
  end Blocks;


  package Mechanics
    package Rotational
      model IdealGearBox
      "Ideal gearbox with multiple gears. Gearshift is implemented as a first order system in gear_ratio to not trigger steps."
      extends
        Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;
      parameter Real ratios[:]={1}
        "Transmission ratios (flange_a.phi/flange_b.phi)";
      Modelica.Blocks.Interfaces.IntegerInput Gear "Gear number"
        annotation (Placement(transformation(extent={{-114,68},{-92,92}}, rotation=0)));
      parameter Real Tg=0.1 "Time constant for change of gear ratio.";

      Modelica.SIunits.Angle phi_a
        "Angle between left shaft flange and support";
      Modelica.SIunits.Angle phi_b
        "Angle between right shaft flange and support";

      Real gearRatio(start=1, fixed=true);
      equation
      der(gearRatio) = ((if Gear == 0 then 1 else ratios[Gear]) - gearRatio)/Tg;
      der(phi_a) = gearRatio*der(phi_b);
      phi_a = flange_a.phi - phi_support;
      phi_b = flange_b.phi - phi_support;
      0 = gearRatio*flange_a.tau + flange_b.tau;
      annotation (Diagram(graphics),
                           Icon(graphics={
              Rectangle(
                extent={{-40,20},{-20,-20}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-40,140},{-20,20}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{20,100},{40,60}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{20,60},{40,-60}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-96,10},{-40,-10}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{40,10},{96,-10}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-20,90},{20,70}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Line(points={{-90,-80},{-20,-80}}, color={128,128,128}),
              Polygon(
                points={{0,-80},{-20,-75},{-20,-85},{0,-80}},
                lineColor={128,128,128},
                fillColor={128,128,128},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,20},{-60,20}}, color={0,0,0}),
              Line(points={{-80,-20},{-60,-20}}, color={0,0,0}),
              Line(points={{-70,-20},{-70,-70}}, color={0,0,0}),
              Line(points={{70,-70},{-70,-70}}, color={0,0,0}),
              Line(points={{0,60},{0,-90}}, color={0,0,0}),
              Line(points={{-10,60},{10,60}}, color={0,0,0}),
              Line(points={{-10,100},{10,100}}, color={0,0,0}),
              Line(points={{60,20},{80,20}}, color={0,0,0}),
              Line(points={{60,-20},{80,-20}}, color={0,0,0}),
              Line(points={{70,-20},{70,-70}}, color={0,0,0}),
              Text(
                extent={{-18,138},{100,102}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid,
                textString=
                   "%name")}));
      end IdealGearBox;
    end Rotational;

    package Translational
      model SpeedDependentForce
      "Applies a force polynomial depending on the speed of the flange. "
      parameter Integer n=3;
      parameter Real Cpol[:]=fill(0.0, n);
      Modelica.Mechanics.Translational.Sensors.SpeedSensor speedSensor
        annotation (Placement(transformation(
            origin={-10,20},
            extent={{-10,-10},{10,10}},
            rotation=180)));
      Basic.ModelicaAddons.Blocks.Math.Poly speedToForce(n=n, Cpol=Cpol)
        annotation (Placement(transformation(extent={{-54,30},{-34,50}},
              rotation=0)));
      // Define i/o
      Modelica.Mechanics.Translational.Interfaces.Flange_b Flange_b
        annotation (Placement(transformation(extent={{88,0},{108,20}}, rotation=
               0)));
      Modelica.Mechanics.Translational.Sources.Force Force
        annotation (Placement(transformation(extent={{-20,30},{0,50}}, rotation=
               0)));
      equation
      connect(Force.flange,   Flange_b) annotation (Line(points={{0,40},{18,40},
              {18,10},{98,10}}, color={0,127,0}));
      connect(speedSensor.flange,Force.flange)
        annotation (Line(points={{0,20},{0,40}}, color={0,127,0}));
      connect(speedToForce.y, Force.f) annotation (Line(points={{-33,40},{-22,
              40}}, color={0,0,127}));
      connect(speedToForce.u, speedSensor.v) annotation (Line(points={{-56,40},
              {-60,40},{-60,20},{-21,20}}, color={0,0,127}));
      annotation (Diagram(graphics),
                           Icon(graphics={
            Line(points={{-100,-98},{-88,-92},{-80,-88},{-60,-78},{-40,-64},{
                  -20,-46},{0,-24},{20,2},{40,32},{60,66},{76,100}}, color={0,0,
                  255}),
            Text(
              extent={{-146,102},{154,62}},
              lineColor={0,0,255},
              textString=
                  "%name"),
            Polygon(
              points={{-100,20},{4,20},{4,51},{74,10},{4,-31},{4,0},{-100,0},{
                  -100,20}},
              lineColor={0,127,0},
              fillColor={0,127,0},
              fillPattern=FillPattern.Solid),
            Line(points={{-90,-88},{-10,-88}}, color={0,0,0}),
            Rectangle(
              extent={{-81,-76},{-10,-44}},
              lineColor={0,0,0},
              fillPattern=FillPattern.Sphere,
              fillColor={255,255,255}),
            Polygon(
              points={{20,-88},{-10,-78},{-10,-98},{20,-88}},
              lineColor={128,128,128},
              fillColor={128,128,128},
              fillPattern=FillPattern.Solid)}));
      end SpeedDependentForce;
    end Translational;
  end Mechanics;
end ModelicaAddons;
