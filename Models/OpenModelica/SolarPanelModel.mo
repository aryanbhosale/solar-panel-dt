model SolarPanelModel
  // Inputs
  input Real irradiance; // in W/m^2

  // Outputs
  output Real power; // in Watts

  // Parameters
  parameter Real panelArea = 1.0 "Area of the solar panel (m^2)";
  parameter Real efficiency = 0.2 "Efficiency of the solar panel (20%)";

equation
  // Calculate power output
  power = irradiance * panelArea * efficiency;
end SolarPanelModel;
