import pandas as pd
import matplotlib.pyplot as plt

# Read simulation results from the correct path
df = pd.read_csv('/workspace/examples/data/solar-panel/output/outputs.csv')

# Fill NaN values with zeros
df.fillna(0, inplace=True)

# Convert time from seconds to hours
df['time_hours'] = df['time'] / 3600

# Create figure with enhanced styling
plt.figure(figsize=(12, 8))

# Plot irradiance
plt.subplot(2, 1, 1)
plt.plot(df['time_hours'], df['{weather}.WeatherModel.irradiance'], 
         label='Irradiance', color='#FDB813', linewidth=2)
plt.title('Solar Irradiance Over Time', pad=15, fontsize=12)
plt.xlabel('Time (hours)')
plt.ylabel('Irradiance (W/m²)')
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()

# Plot power output
plt.subplot(2, 1, 2)
plt.plot(df['time_hours'], df['{panel}.SolarPanelModel.power'], 
         label='Power Output', color='#FF6B6B', linewidth=2)
plt.title('Solar Panel Power Output Over Time', pad=15, fontsize=12)
plt.xlabel('Time (hours)')
plt.ylabel('Power (W)')
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()

# Adjust layout and display
plt.tight_layout()
plt.show()
