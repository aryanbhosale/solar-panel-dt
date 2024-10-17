# Solar Panel Digital Twin

## Overview

This digital twin simulates a simple solar panel system consisting of two components: a weather model and a solar panel model. The weather model provides solar irradiance data over time, accounting for factors like cloud cover and time of day. The solar panel model calculates the electrical power output based on the irradiance received and the panel's efficiency.

By coupling these two models, we can simulate and analyze the power generation of the solar panel system under varying environmental conditions.

![Solar Panel System](images/solar_panel_system.png)

## Example Structure

The simulation includes two FMU (Functional Mock-up Unit) models:

1. **WeatherModel.fmu**: Simulates solar irradiance over time.
2. **SolarPanelModel.fmu**: Calculates power output based on irradiance input.

These models are connected so that the irradiance output from the `WeatherModel` feeds into the irradiance input of the `SolarPanelModel`.

## Code Structure and Codebase

The project directory is organized as follows:

```
SolarPanelSystem/
├── FMUs/
│   └── OpenModelica/
│       ├── WeatherModel.fmu
│       └── SolarPanelModel.fmu
├── Models/
│   └── OpenModelica/
│       ├── WeatherModel.mo
│       └── SolarPanelModel.mo
├── Multi-models/
│   └── SolarPanelSystem/
│       ├── mm.json
│       └── coe.json
├── scripts/
│   └── plot.py
├── images/
│   └── solar_panel_system.png
├── readme.md
└── .project.json
```

### Models

#### 1. WeatherModel.mo

```modelica
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

equation
  // Convert simulation time from seconds to hours
  timeInHours = time / 3600;

  // Solar irradiance model (simple sine wave to simulate day/night cycle)
  irradiance = if timeInHours >= 0 and timeInHours <= 24 then
                 maxIrradiance * sin(pi * (timeInHours - timeOffset) / dayLength) * cloudFactor
               else
                 0;

  // Ensure irradiance is non-negative
  irradiance = max(irradiance, 0);
end WeatherModel;
```

#### 2. SolarPanelModel.mo

```modelica
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
```

### Multi-model Configuration

#### mm.json

```json
{
  "fmus": {
    "{weather}": "OpenModelica/WeatherModel.fmu",
    "{panel}": "OpenModelica/SolarPanelModel.fmu"
  },
  "connections": {
    "{weather}.WeatherModel.irradiance": ["{panel}.SolarPanelModel.irradiance"]
  },
  "parameters": {}
}
```

#### coe.json

```json
{
  "startTime": 0,
  "endTime": 86400,
  "multimodel_path": "Multi-models/SolarPanelSystem/mm.json",
  "livestream": {
    "{weather}.WeatherModel": ["irradiance"],
    "{panel}.SolarPanelModel": ["power"]
  },
  "livestreamInterval": 60,
  "visible": false,
  "loggingOn": false,
  "algorithm": {
    "type": "fixed-step",
    "size": 60
  },
  "postProcessingScript": "",
  "stabilizationEnabled": false,
  "global_absolute_tolerance": 1e-6,
  "global_relative_tolerance": 1e-4
}
```

### Plotting Script

#### plot.py

```python
import pandas as pd
import matplotlib.pyplot as plt

# Read simulation results
df = pd.read_csv('results.csv')

# Fill NaN values with zeros
df.fillna(0, inplace=True)

# Convert time from seconds to hours
df['time_hours'] = df['time'] / 3600

# Plot irradiance
plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plt.plot(df['time_hours'], df['{weather}.WeatherModel.irradiance'], label='Irradiance (W/m^2)')
plt.title('Solar Irradiance Over Time')
plt.xlabel('Time (hours)')
plt.ylabel('Irradiance (W/m^2)')
plt.legend()

# Plot power output
plt.subplot(2, 1, 2)
plt.plot(df['time_hours'], df['{panel}.SolarPanelModel.power'], label='Power Output (W)', color='orange')
plt.title('Solar Panel Power Output Over Time')
plt.xlabel('Time (hours)')
plt.ylabel('Power (W)')
plt.legend()

plt.tight_layout()
plt.show()
```

## Steps to Run the Simulation

### Prerequisites

- **OpenModelica**: To create FMUs from the Modelica models.
- **Java Development Kit (JDK)**: Required for the co-simulation tool.
- **Maestro Co-simulation Tool**: Used to run the co-simulation.
- **Python 3**: For running the plotting script.
- **Matplotlib and Pandas**: Python libraries for plotting.

### Step 1: Create the Models

1. **Install OpenModelica** if not already installed.
2. **Open OMEdit** (OpenModelica Connection Editor).
3. **Create a new Modelica class** for each model:

   - **WeatherModel**
     - Copy and paste the `WeatherModel.mo` code.
   - **SolarPanelModel**
     - Copy and paste the `SolarPanelModel.mo` code.

### Step 2: Export FMUs

For each model:

1. Right-click on the model in OMEdit.
2. Select **Export** > **FMU**.
3. Choose **FMI Version 2.0** and **Model Exchange**.
4. Click **OK** to export the FMU.
5. Save the FMUs in the `FMUs/OpenModelica/` directory.

### Step 3: Set Up the Co-simulation Configuration

Ensure that the `mm.json` and `coe.json` files are correctly configured as shown above. Place them in the `Multi-models/SolarPanelSystem/` directory.

### Step 4: Install Java Development Kit (JDK)

Install **OpenJDK 17** or a compatible version required by the Maestro tool.

### Step 5: Download the Maestro Co-simulation Tool

1. Download the `maestro-2.3.0-jar-with-dependencies.jar` file.
2. Place it in a `tools/` directory or specify its location in your simulation scripts.

### Step 6: Run the Co-simulation

Create a script or use the command line to execute the co-simulation:

```bash
java -jar maestro-2.3.0-jar-with-dependencies.jar coe.json
```

This command will start the co-simulation using the configuration specified in `coe.json`.

### Step 7: Examine the Results

After the simulation completes:

- The results will be saved in a CSV file, typically named `results.csv`.
- This file contains the time series data for irradiance and power output.

### Step 8: Plot the Results

Ensure that Python 3, Pandas, and Matplotlib are installed:

```bash
pip install pandas matplotlib
```

Run the plotting script:

```bash
python scripts/plot.py
```

This will generate plots showing the solar irradiance and power output over time.

## Where FMU Files Are Used

FMUs (Functional Mock-up Units) are used to encapsulate simulation models in a standardized format for co-simulation and model exchange. In this project:

- **FMUs are created from the Modelica models** using OpenModelica.
- **The co-simulation tool (Maestro)** uses these FMUs to run the simulation.
- **FMUs are specified in the `mm.json` configuration file**, where they are associated with identifiers (`{weather}` and `{panel}`) for use in the co-simulation.
- **Data exchange between FMUs** occurs during the co-simulation, where outputs from one FMU are inputs to another.

## Clean Up

After the simulation and analysis, you can clean up the generated files:

```bash
rm -rf results.csv
rm -rf logs/
```

## Additional Information

For more information on co-simulation techniques and FMUs, refer to:

- **Functional Mock-up Interface (FMI) Standard**: [https://fmi-standard.org/](https://fmi-standard.org/)
- **OpenModelica User Guide**: [https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/](https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/)
- **Maestro Co-simulation Tool Documentation**: [https://into-cps.org/tool/maestro/](https://into-cps.org/tool/maestro/)
