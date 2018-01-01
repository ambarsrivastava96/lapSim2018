function [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_New(car, competition)

%% Constants
g = 9.81;
rho = 1.225;
dt = 0.001;
v_launch = 0.001;

%% Set Up
trackData = competition.trackData;
n = length(trackData(:,2));


%% Set Up Data Arrays
t = [0]; % Time
x = [0]; % Position/Distance
v = [0]; % Velocity
a = [0]; % Acceleratiom
p = [0]; % Power

%% Process Track Data
for i = 1:n
    if ((trackData(i,2) ~= 0)) %Check if not straight
        trackData(i,2) = trackData(i,2)*(pi()/180); % Convert to radians
        trackData(i,2) = trackData(i,1)/(trackData(i,2)); % Calculate radius
    end
end

%% Begin Simulation
% Straight
[Accel_time, v_final, energyUsed, K] = func_iter_Accel_time(car, competition.trackData(1,3), v_launch,competition.trackData(1,1), dt);

% Corner
v_corner_max = func_iter_Max_Cornering_Vel(car, abs(trackData(2,2)));
Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
Fx_resist = 0.03*(car.mass.Iterate*g+DF);
Force = Fx_resist + Drag + (car.mass.Iterate)*g*sind(trackData(2,3));
p_corner = Force*v_corner_max/car.drivetrain_efficiency;

% Add Straight to Data Arrays
t_add = K.t+t(end);
t = [t t_add];
x = [x K.x];
v = [v K.v];
a = [a K.a];
p = [p K.p];

% Add Corner to Data Arrays
t_corner = abs(trackData(2,1))/v_corner_max;
t_add = t(end):dt:t(end)+t_corner;
t = [t t_add];

x_add = x(end) + t_add*v_corner_max;
x = [x x_add];

v = [v v_corner_max*ones(1,length(t_add))];
a = [a zeros(1,length(t_add))];
p = [p p_corner*ones(1,length(t_add))];

%% Plotting
subplot(2,2,1)
plot(t,x)
title('Distance');

subplot(2,2,2)
plot(t,v)
title('Velocity');

subplot(2,2,3)
plot(t,a)
title('Acceleration');

subplot(2,2,4)
plot(t,p)
title('Power');

%% Relics
AutoX_Score = 1;
AutoX_time = 1;
AutoX_energy_used = 1;
AutoX_energy_recovered = 1;