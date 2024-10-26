model WeatherModel
  // Inputs
  input Real beta = -0.004 "Temperature coefficient per degree Celsius, typically negative";
  input Real Tcell = 25 "Actual cell temperature in Celsius";

  // Outputs
  output Real irradiance;     // in W/m^2
  output Real tempCoeff;      // no units
  output Real timeInHours;    // For debugging
  output Real irradianceRaw;  // For debugging

  // Parameters
  parameter Real maxIrradiance = 1000 "Maximum irradiance (W/m^2)";
  parameter Real dayLength = 12 "Length of the day (hours)";
  parameter Real timeOffset = 6 "Time at which irradiance starts (hours)";
  parameter Real cloudFactor = 0.8 "Factor representing cloud cover (0 to 1)";
  parameter Real Tsc = 25 "Cell temperature at STC in Celsius";

  // Constants
  constant Real pi = 3.141592653589793;

  // Variables
  Real sinArgument;  // For debugging
  Real dummyState(start = 0, fixed = true); // Dummy continuous state with fixed start value

equation
  // Dummy differential equation to introduce a continuous state
  der(dummyState) = 0;

  // Convert simulation time from seconds to hours
  timeInHours = time / 3600;

  // Calculate the argument for the sin function
  sinArgument = pi * (timeInHours - timeOffset) / dayLength;

  // Calculate raw irradiance value
  irradianceRaw = if timeInHours >= timeOffset and timeInHours <= (timeOffset + dayLength) then
                    maxIrradiance * sin(sinArgument) * cloudFactor
                  else
                    0;

  // Ensure irradiance is non-negative
  irradiance = max(irradianceRaw, 0);

  // Calculate temperature coefficient
  tempCoeff = 1 + beta * (Tcell - Tsc);
end WeatherModel;
