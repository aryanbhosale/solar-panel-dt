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
