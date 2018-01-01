function [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_New(car, competition)

% Constants
g = 9.81;
rho = 1.225;
dt = 0.001;
v_launch = 0.001;
n = length(competition.trackData(i,2));

% Set Up Data Arrays
t = []; % Time
x = []; % Position/Distance
v = []; % Velocity
a = []; % Acceleratiom
p = []; % Power

% Process Track Data
for i = 1:n
    if ((competition.trackData(i,2) ~= 0)) %Check if not straight
        competition.trackData(i,2) = competition.trackData(i,2)*(pi()/180); % Convert to radians
        competition.trackData(i,2) = competition.trackData(i,1)/(competition.trackData(i,2)); % Calculate radius
    end
end

% Launch
[Accel_time, v_final, energyUsed, K] = func_iter_Accel_time(car, competition.trackData(i,3), v_launch,competition.trackData(i,1), dt);

% First Corner
v_corner_max = func_iter_Max_Cornering_Vel(car, abs(competition.trackData(2,2)));

% Add to Data Arrays
t_add = K.t+t(end);
t = [t t_add];
x = [x K.x];
v = [v K.v];
a = [a K.a];
p = [p K.p];

