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
v = [v_launch]; % Velocity
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
for i = 1:2:n-1
    Accel = 1;
    disp(i);
    Brake = 0;
    Corner = 1;
    % Straight
    v_test = v_launch;
    [~, v_final, ~, K_a] = func_iter_Accel_time(car, trackData(i,3),v(end),trackData(i,1), dt);

    % Corner
    v_corner_max = func_iter_Max_Cornering_Vel(car, abs(trackData(i+1,2)));

    if v_final > v_corner_max % Need to Brake
        Brake = 1;
        [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final, v_corner_max, dt);
        if braking_dist > trackData(i,1)% Needs more braking distance than is available on straight
            Accel = 0;
            if braking_dist > trackData(i,1)+trackData(i+1,1)% Not enough braking distance on corner + straight
                % B Brake for straight + corner distance
                Corner = 0;
                v_brakes = v_corner_max+0.1;
                while braking_dist > trackData(i,1)+trackData(i+1,1)
                    [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final, v_brakes, dt);
                    v_brakes = v_brakes+0.1;
                end              
            else % B - C Brake through straight and part of corner
                trackData(i+1,1) = trackData(i,1)+trackData(i+1,1)-braking_dist;
            end
        else
            % A-B-C (Accel - Brake - Corner)

            trackData(i,1) = trackData(i,1) - braking_dist; % Reduce Straight Length
            [~, v_final_adjusted, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1), dt); % New Straight Sim
            while abs(v_final-v_final_adjusted>0.001) % Iterate until velocities match
                [braking_dist_new, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final_adjusted, v_corner_max, dt);
                v_final = v_final_adjusted;
                trackData(i,1) = trackData(i,1) + braking_dist - braking_dist_new;
                braking_dist = braking_dist_new;
                [~, v_final_adjusted, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1), dt); % New Straight Sim
            end
        end
    else
        while v_final < v_corner_max
            trackData(i,1) = trackData(i,1) + 0.1;
            trackData(i+1,1) = trackData(i+1,1) - 0.1;
            if trackData(i+1,1)<0% Not enough accel distance on corner + straight % A
                Corner = 0;
                break
            end
            [~, v_final, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1), dt);
        end
    end

    Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    Fx_resist = 0.03*(car.mass.Iterate*g+DF);
    Force = Fx_resist + Drag + (car.mass.Iterate)*g*sind(trackData(i,3));
    p_corner = Force*v_corner_max/car.drivetrain_efficiency;

    % Add Straight to Data Arrays
    if Accel == 1
        t_add = K_a.t+t(end);
        x_add = K_a.x+x(end);
        t = [t t_add];
        x = [x x_add];
        v = [v K_a.v];
        a = [a K_a.a];
        p = [p K_a.p];
    end

    % Add Braking to Data Arrays
    if Brake == 1
        t_add = K_b.t+t(end);
        x_add = K_b.x+x(end);
        t = [t t_add];
        x = [x x_add];
        v = [v K_b.v];
        a = [a K_b.a];
        p = [p K_b.p]; 
    end

    % Add Corner to Data Arrays
    if Corner == 1
        t_corner = abs(trackData(i+1,1))/v_corner_max;

        t_add = t(end):dt:t(end)+t_corner;
        x_add = x(end) + (t_add-t(end))*v_corner_max;
        t = [t t_add];
        x = [x x_add];
        v = [v v_corner_max*ones(1,length(t_add))];
        a = [a zeros(1,length(t_add))];
        p = [p p_corner*ones(1,length(t_add))];
    end
end

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