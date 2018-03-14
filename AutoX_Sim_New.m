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
gear = [1];

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
%     disp(i);
    Brake = 0;
    Corner = 1;
    % Straight
    v_test = v_launch;
    [Accel_time, v_final, energyUsed, K_a] = func_iter_Accel_time(car, trackData(i,3),v(end),trackData(i,1), dt);


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
                v_brakes = v_corner_max+0.001;
                while braking_dist > trackData(i,1)+trackData(i+1,1)
                    [braking_dist, ~, ~,K_b] = func_iter_Braking_dist(car, trackData(i,3), v_final, v_brakes, dt);
                    v_brakes = v_brakes+0.01;
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
          if K_a.a(end) < 0
              ia = length(K_a.a);
              while K_a.a(ia)<0
                ia = ia-1;
                endAccel = K_a.a(ia);
              end
          else 
              endAccel = K_a.a(end);
          end
          [time, v_final, energyUsed, K_a2] = func_iter_Accel_Corner(car, trackData(i+1,3), v_final, endAccel ,v_corner_max, abs(trackData(i+1,2)), abs(trackData(i+1,1)), dt);
          t_add = K_a.t(end)+K_a2.t;
          x_add = K_a.x(end)+K_a2.x;
          K_a.t = [K_a.t t_add];
          K_a.x = [K_a.x x_add];
          K_a.v = [K_a.v K_a2.v];
          K_a.a = [K_a.a K_a2.a];
          K_a.ay = [K_a.ay K_a2.ay];
          K_a.p = [K_a.p K_a2.p];
          K_a.gear = [K_a.gear K_a2.gear];
          
          if v_final>v_corner_max
              trackData(i+1,1) = trackData(i+1,1)-K_a2.x(end);
          else
              Corner = 0;
          end
          
%         [~, v_final_check, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1)+trackData(i+1,1), dt);
%             
%         if v_final_check<v_corner_max% Not enough accel distance on corner + straight % A
%             Corner = 0;
%         else
%             cornerLength = trackData(i+1,1);
%             first = 1;
%             while abs(v_final-v_corner_max) > 0.005
%                 if v_final < v_corner_max
%                     sign = 1;
%                 else
%                     sign = -1;
%                 end
%                 cornerLength = 0.5*cornerLength;
%                 trackData(i,1) = trackData(i,1) + sign*cornerLength;
%                 trackData(i+1,1) = trackData(i+1,1) - sign*cornerLength;
%                 first = 0;
%                 [~, v_final, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1), dt);
%             end
%             
%             %In case already within threshold
%             if first == 1 
%                 [~, ~, ~, K_a] = func_iter_Accel_time(car, trackData(i,3), v(end),trackData(i,1), dt);
%             end
%                 
%         end
    end

    Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    Fx_resist = car.tyre.rollingResistance*(car.mass.Iterate*g+DF);
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
        ay = [ay K_a.ay];
        p = [p K_a.p];
        gear = [gear K_a.gear];
    end

    % Add Braking to Data Arrays
    if Brake == 1
        t_add = K_b.t+t(end);
        x_add = K_b.x+x(end);
        t = [t t_add];
        x = [x x_add];
        v = [v K_b.v];
        a = [a K_b.a];
        ay = [ay K_b.ay];
        p = [p K_b.p];
        gear = [gear K_b.gear];
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
        ay = [ay (v_corner_max^2/abs(trackData(i+1,2)))*ones(1,length(t_add))];
        p = [p p_corner*ones(1,length(t_add))];
        gear = [gear zeros(1,length(t_add))];
    end
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

