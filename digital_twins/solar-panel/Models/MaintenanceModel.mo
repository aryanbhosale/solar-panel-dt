model MaintenanceModel
  // Inputs
  input Real irradiance;  // in W/m^2, from WeatherModel
  input Real dirtFactor = 0.05 "Fractional loss due to soiling (0 to 1)";

  // Outputs
  output Real effectiveIrradiance; // in W/m^2

equation
  // Calculate effective irradiance 
  effectiveIrradiance = irradiance * (1 - dirtFactor);
end MaintenanceModel;
