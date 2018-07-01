% Power Curve for Battery Testing
clear car competition

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

time = [0];
power = [0];

for i = 1:competition.laps/2
  [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition);
  time_add = K.t+time(end);
  time = [time time_add];
  power = [power K.p];
end

