function [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition)

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
v = [v_launch]; % Velocity
a = [0]; % Acceleration (Long)
ay = [0]; % Acceleration (Lat)
p = [0]; % Power
gear = [1]; % Gear

emptyK.t = [];
emptyK.x = [];
emptyK.v = [];
emptyK.a = [];
emptyK.ay = [];
emptyK.p = [];
emptyK.gear = [];

%% Process Track Data
for i = 1:n
    if ((trackData(i,2) ~= 0)) %Check if not straight
        trackData(i,2) = trackData(i,2)*(pi()/180); % Convert to radians
        trackData(i,2) = trackData(i,1)/(trackData(i,2)); % Calculate radius
    end
end

%% Begin Simulation
for i = 1:2:n-1
%     disp(i);
    % Straight Calculation - A
    [Accel_time, v_final, energyUsed, K_a] = func_iter_Accel_time(car, trackData(i,3),v(end),trackData(i,1), dt);
    
    % Braking Structure Initialisation (Assume no braking) - B
    K_b = emptyK;
 
    % Corner Calculation - C
    v_corner_max = func_iter_Max_Cornering_Vel_New(car, abs(trackData(i+1,2)),0);
    K_c = func_iter_cornerData(car, v_corner_max, trackData(i+1,1), abs(trackData(i+1,2)), trackData(i+1,3), dt, g, rho);
    
    if v_final>v_corner_max % Need to Brake
        [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final, v_corner_max, dt); %Calc braking distance required
        if braking_dist > K_a.x(end) % Needs more braking distance than is available on the straight
            totalDist = K_a.x(end)+K_c.x(end);
            if braking_dist > totalDist % Needs more braking distance than is available straight and corner
                K_a = emptyK; % Delete Straight
                K_c = emptyK; % Delete Corner
                
                % Brake for distance of straight and corner
                v_brakes = v_corner_max;
                v_brakes_old = v_final;
                [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_brakes_old, v_brakes, dt);
                dist_diff = braking_dist - (totalDist);
                while abs(dist_diff)>0.01
                    v_brakes_delta = abs(v_brakes-v_brakes_old)/2;
                    v_brakes_old = v_brakes;
                    if dist_diff>0
                        v_brakes = v_brakes + v_brakes_delta;
                    else
                        v_brakes = v_brakes - v_brakes_delta;
                    end
                    [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final, v_brakes, dt);
                    dist_diff = braking_dist - (totalDist);
                end      
            else %Brake into corner
                K_a = emptyK; % Delete Straight
                
                cornerBrakeDistance = totalDist - braking_dist;
                if cornerBrakeDistance < 0
                    error('Corner Brake Distance Error');
                end
                % New Corner Data with reduced length
                K_c = func_iter_cornerData(car, v_corner_max, cornerBrakeDistance, abs(trackData(i+1,2)), trackData(i+1,3), dt, g, rho);
            end
        else 
            accelDist = trackData(i,1) - braking_dist;
            [~, v_final_adjusted, ~, K_a] = func_iter_Accel_time(car, trackData(i,3),v(end),accelDist, dt);
            v_diff = v_final-v_final_adjusted;
            v_diff_old = v_diff; 
            while abs(v_diff)>0.001 % Iterate until velocities match
                [braking_dist_new, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final_adjusted, v_corner_max, dt);
                v_final = v_final_adjusted;
                accelDist = accelDist + braking_dist - braking_dist_new;
                braking_dist = braking_dist_new;
                [~, v_final_adjusted, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),accelDist, dt); % New Straight Sim
                v_diff = v_final-v_final_adjusted;
                if isequal(abs(v_diff),abs(v_diff_old))
                   break;
                end
                v_diff_old = v_diff; 
            end
        end
    else % Need to accelerate through corner
        totalDist = K_a.x(end)+K_c.x(end);
        endAccel = K_a.a(end);
        [~, v_final, ~, K_b] = func_iter_Accel_Corner(car, trackData(i+1,3), v_final, endAccel ,v_corner_max, abs(trackData(i+1,2)), abs(trackData(i+1,1)), dt);
        cornerDist = totalDist - K_b.x(end) - K_a.x(end);
        if cornerDist > 0
            K_c = func_iter_cornerData(car, v_corner_max, cornerDist, abs(trackData(i+1,2)), trackData(i+1,3), dt, g, rho);
        elseif abs(cornerDist)<0.1 
            K_c = emptyK; % Should not need this line
        else
            error('Corner Accel Distance too long, something whacks happening');
        end
    end
    
    if ~isempty(K_a.t) 
        t_add_a = t(end)+K_a.t;
        x_add_a = x(end)+K_a.x;
        if ~isempty(K_b.t)
            t_add_b = t_add_a(end)+K_b.t;
            x_add_b = x_add_a(end)+K_b.x;
            if ~isempty(K_c.t)
                t_add_c = t_add_b(end)+K_c.t;
                x_add_c = x_add_b(end)+K_c.x;
            else
                t_add_c = [];
                x_add_c = [];
            end
        else
            error('Somethings whack, this condition should not be possible');
        end
    else
        t_add_a = []; % No Accel Distance
        x_add_a = [];
        if ~isempty(K_b.t)
            t_add_b = t(end)+K_b.t;
            x_add_b = x(end)+K_b.x;
            if ~isempty(K_c.t)
                t_add_c = t_add_b(end)+K_c.t;
                x_add_c = x_add_b(end)+K_c.x;
            else
                t_add_c = [];
                x_add_c = [];
            end
        else
            error('Somethings whack, this condition should not be possible');
        end
    end
        

    t_add = [t_add_a,t_add_b,t_add_c];
    x_add = [x_add_a,x_add_b,x_add_c];
    v_add = [K_a.v, K_b.v, K_c.v];
    a_add = [K_a.a, K_b.a, K_c.a];
    ay_add = [K_a.ay, K_b.ay, K_c.ay];
    p_add = [K_a.p, K_b.p, K_c.p];
    gear_add = [K_a.gear, K_b.gear, K_c.gear];
    
    t = [t,t_add];
    x = [x,x_add];
    v = [v,v_add];
    a = [a,a_add];
    ay = [ay,ay_add];
    p = [p,p_add];
    gear = [gear,gear_add];
end

%% Plotting
% subplot(2,2,1)
% plot(t,x)
% title('Distance');
% hold on
% 
% subplot(2,2,2)
% plot(t,v)
% title('Velocity');
% hold on 
% 
% subplot(2,2,3)
% plot(t,a)
% title('Acceleration');
% hold on 
% 
% subplot(2,2,4)
% plot(t,p/1000)
% title('Power');
% hold on 

%% Scoring
T_your = t(end);
T_min = competition.autocrossMin;
T_max = 1.45*T_min;
AutoX_Score = 118.5*((T_max/T_your)-1)/((T_max/T_min)-1)+6.5;
AutoX_time = T_your;

%% Energy Usage
AutoX_energy_used = 0;
AutoX_energy_recovered = 0;
for i = 1:length(p)
    if p(i) > 0
        AutoX_energy_used = AutoX_energy_used + p(i)*dt;
    elseif p(i) < 0
        AutoX_energy_recovered = AutoX_energy_recovered + p(i)*dt;
    end
end

AutoX_energy_used = AutoX_energy_used/3600000; % Convert to kWh
AutoX_energy_recovered = AutoX_energy_recovered/3600000;

%% Export Kinematic Data
K.t = t;
K.x = x;
K.v = v;
K.a = a;
K.ay = ay;
K.p = p;
K.gear = gear;

%% Continuity Check
% for i = 1:length(K.t)-1
%     if(abs(K.v(i+1)-K.v(i))>1) % Check for velocity jump greater than 1m/s between any successive points
%         error('Continuity Error at t = %.4f',K.t(i));
%     end
% end

