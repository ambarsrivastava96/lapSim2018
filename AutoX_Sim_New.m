function [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_New(car, competition)

% Constants
g = 9.81;
rho = 1.225;
dt = 0.001;
v_launch = 0.001;

% Set Up Data Arrays
t = []; % Time
x = []; % Position/Distance
v = []; % Velocity
a = []; % Acceleratiom
p = []; % Power

% Launch


