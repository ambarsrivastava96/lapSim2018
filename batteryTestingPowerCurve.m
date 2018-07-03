% Power Curve for Battery Testing
clear car competition

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

time = [0];
power = [0];

% for i = 1:competition.laps/2
  [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K, B] = AutoX_Sim_New(car, competition);
  car.battery.startVoltage = B.startVoltage; 
  car.battery.totalDischarge = B.totalDischarge;
  time_add = K.t+time(end);
  time = [time time_add];
  power = [power K.p];
% end

% time_3min = 0:0.001:60*3;
% time_3min_add = time_3min+time(end);
% time = [time time_3min_add];
% power = [power ones(1,length(time_3min_add))];
% 
% for i = 1:competition.laps/2
%   [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K, B] = AutoX_Sim_New(car, competition);
%   car.battery.startVoltage = B.startVoltage; 
%   car.battery.totalDischarge = B.totalDischarge;
%   time_add = K.t+time(end);
%   time = [time time_add];
%   power = [power K.p];
% end

power_adjusted = (power(1:100:end)')./960; % 96 cells, 10 to account for amplifier
time_adjusted = time(1:100:end)';