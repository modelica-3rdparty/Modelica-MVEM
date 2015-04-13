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

within MVEMLib.Basic.Media;
package FuelAirMixture
  "Models of a set of Fuel, Air, Unburned Mixture and Burned Mixture."
  // Air Medium
  package airMedium "Air medium based on CombustionAir"
      extends Modelica.Media.IdealGases.MixtureGases.CombustionAir(
        excludeEnthalpyOfFormation = false);
  end airMedium;

  // Fuel Medium
  package fuelMedium
    "Ideal gas \"C8H18 Isooctane\" from NASA Glenn coefficients"
    extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
      excludeEnthalpyOfFormation=false,
      mediumName="C8H18 Isooctane",
      data={Modelica.Media.IdealGases.Common.SingleGasesData.C8H18_isooctane},
      substanceNames={"Isooctane C8H18"},
      fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.C8H18_n_octane},
      reference_X={1});
  end fuelMedium;
  
  // Unburned Medium
  package unburnedMedium "Mixture of fuel and air"
    extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
      excludeEnthalpyOfFormation=false,
      mediumName="Mixture of Combustion air (O2 N2) and Isooctane",
      data={Modelica.Media.IdealGases.Common.SingleGasesData.N2,Modelica.Media.IdealGases.Common.SingleGasesData.O2,
          Modelica.Media.IdealGases.Common.SingleGasesData.C8H18_isooctane},
      substanceNames={"Nitrogen","Oxygen","Isooctane C8H18"},
      reference_X={0.76761,0.23239,0});   // On mass basis, on molar basis it's about [3.773 1]/4.773
    //                     fluidConstants = {},
  end unburnedMedium;

  // Some Fuel/Air constants
  constant Integer fuelCarbons=8;
  constant Integer fuelHydrogens=18;
  constant Real HCratio=fuelHydrogens/fuelCarbons;
  constant Real AFs=(fuelCarbons + fuelHydrogens/4.0)*(2*16.00 + 3.773*2*14.007)
      /(12.01*fuelCarbons + 1.008*fuelHydrogens)
    "Stoichiometric air fuel ratio for the Mixturemodel";
  constant Real epsilon=4/(HCratio + 4); // c.f. p. 52 Ph.D. Thesis by Per Öberg

  // Burned Medium
  package burnedMedium "Burned medium based on FlueGasSixComponents"
    extends Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents(
      excludeEnthalpyOfFormation = false);
  end burnedMedium;

  function calcBurnedFractions
    input SI.MassFraction unburned_dmX[unburnedMedium.nX]
      "Independent mass flow fractions of the flowing unburned components, these are ALWAYS positive";
    input SI.Temperature Tburned "Temperature at the end of combustion";
    output SI.MassFraction burned_dmX[burnedMedium.nX]
      "Independent mass flow fractions of the flowing burned components";
    output Real dummyOutput;
  protected
    Real c;
    Real phi;
    Real dmxuN2;
    Real dmxuO2;
    Real dmxuHC;
    Real dmxbH2;
    Real dmxbCO2;
    Real dmxbH2O;
    Real dmxbCO;
    Real dmxbO2;
    Real lnK;
    Real K;
    Real eq_a;
    Real eq_b;
    Real eq_c;
    Real dummySum;
    Real xuN2_tilde;                                                                                          //, xuO2_tilde, xuHC_tilde;
  algorithm
    dmxuN2 := unburned_dmX[1];
    dmxuO2 := unburned_dmX[2];
    dmxuHC := unburned_dmX[3];
    if dmxuO2 <= 0 then
      phi := 1;
    else
      phi := dmxuHC/(dmxuO2*(1 + 0.76761/0.23239))*AFs;
    end if;
    if phi >= 2 then
      phi := 2;
    end if;
    if phi > 1 then
      // Rich mixtures
      lnK := 2.743 - 1.761e3/Tburned - 1.611e6/Tburned/Tburned + 0.2083e9/
        Tburned/Tburned/Tburned;
      K := exp(lnK);
      eq_a := (1 - K);
      eq_b := (K*(2*(phi - 1) + epsilon*phi) + 2*(1 - epsilon*phi));
      eq_c := -2*K*epsilon*phi*(phi - 1);
      // Numerically sound solution of second degree equation even for eq_a = 0, --- this IS correct ---
      c := -eq_c/(eq_b/2 + sqrt(eq_b*eq_b/4 - eq_c*eq_a));
      dmxbCO2 := (epsilon*phi - c)*(12.01 + 2*16.00);
      dmxbH2O := (2*(1 - epsilon*phi) + c)*(2*1.008 + 16.00);
      dmxbCO := c*(12.01 + 16.00);
      dmxbH2 := (2*(phi - 1) - c)*(2*1.008);
      dmxbO2 := 0;
    else
      // Lean mixtures
      dmxbCO2 := epsilon*phi*(12.01 + 2*16.00);
      dmxbH2O := 2*(1 - epsilon)*phi*(2*1.008 + 16.00);
      dmxbCO := 0;
      dmxbH2 := 0;
      dmxbO2 := (1 - phi)*(2*16.00);
    end if;
    dummySum := (dmxbH2 + dmxbCO2 + dmxbH2O + dmxbCO + dmxbO2);
    // Now, divide by sum of fractions
    dmxbH2 := dmxbH2/dummySum*(dmxuO2 + dmxuHC);
    dmxbCO2 := dmxbCO2/dummySum*(dmxuO2 + dmxuHC);
    dmxbH2O := dmxbH2O/dummySum*(dmxuO2 + dmxuHC);
    dmxbCO := dmxbCO/dummySum*(dmxuO2 + dmxuHC);
    dmxbO2 := dmxbO2/dummySum*(dmxuO2 + dmxuHC);
    //N2,H2,CO2,O2,H20,CO2
    burned_dmX := {-dmxuN2,-dmxbH2,-dmxbCO,-dmxbO2,-dmxbH2O,-dmxbCO2};
    //dummyOutput := K;
    dummyOutput := phi;
    //dummyOutput := (dmxuN2+dmxbH2+dmxbCO+dmxbO2+dmxbH2O+dmxbCO2)/(dmxuN2+dmxuO2+dmxuHC);
  end calcBurnedFractions;

end FuelAirMixture;
