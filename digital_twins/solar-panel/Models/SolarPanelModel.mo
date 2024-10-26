model SolarPanelModel
  // Inputs
  input Real effectiveIrradiance;          // Solar irradiance at normal incidence (in W/m^2)
  input Real shadingFactor = 0.2;          // Fraction of panel area shaded (no unit)
  input Real beta = 0.3491 "Tilt angle (radians)";   // Tilt angle in radians
  input Real phi = 0.6109 "Latitude (radians)";      // Latitude in radians
  input Real tempCoeff;                    // Temperature coefficient from WeatherModel

  // Outputs
  output Real power;       // in Watts
  output Real cosTheta;    // Cosine of angle of incidence between sun's rays and panel's normal

  // Parameters
  parameter Real panelArea = 1.0 "Area of the solar panel (m^2)";
  parameter Real selectedEfficiency = 0.2 "Selected panel efficiency";

  // Constants
  constant Real pi = 3.141592653589793;
  constant Integer dayOfYear = 299 "Day of the year for October 25, 2024";

  // Variables
  Real delta;              // Solar declination angle (radians)
  Real h;                  // Hour angle (radians)
  Real timeInHours;        // Time in hours
  Real cosThetaRaw;

equation
  // Convert simulation time from seconds to hours
  timeInHours = time / 3600;

  // Calculate solar declination angle
  delta = 0.4093 * sin((2 * pi / 365) * (dayOfYear - 81));

  // Calculate hour angle (ranging from -pi to pi)
  h = (pi / 12) * (timeInHours - 12);

  // Calculate the raw cosine of the angle of incidence
  cosThetaRaw = sin(delta) * sin(phi - beta) + cos(delta) * cos(phi - beta) * cos(h);

  // Ensure cosTheta is non-negative
  cosTheta = max(cosThetaRaw, 0);

  // Calculate power output
  power = effectiveIrradiance * panelArea * selectedEfficiency * tempCoeff * cosTheta * (1 - shadingFactor);
end SolarPanelModel;
