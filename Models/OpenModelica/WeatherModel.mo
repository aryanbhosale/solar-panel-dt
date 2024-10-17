model WeatherModel
  // Outputs
  output Real irradiance; // in W/m^2

  // Parameters
  parameter Real maxIrradiance = 1000 "Maximum irradiance (W/m^2)";
  parameter Real dayLength = 12 "Length of the day (hours)";
  parameter Real timeOffset = 6 "Time at which irradiance peaks (hours)";
  parameter Real cloudFactor = 0.8 "Factor representing cloud cover (0 to 1)";

  // Variables
  Real timeInHours;
  Real irradianceRaw;

equation
  // Convert simulation time from seconds to hours
  timeInHours = time / 3600;

  // Calculate raw irradiance value
  irradianceRaw = if timeInHours >= 0 and timeInHours <= 24 then
                    maxIrradiance * sin(Modelica.Constants.pi * (timeInHours - timeOffset) / dayLength) * cloudFactor
                  else
                    0;

  // Ensure irradiance is non-negative
  irradiance = max(irradianceRaw, 0);
end WeatherModel;
