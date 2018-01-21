function [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_iterate(car, competition)

g = 9.81;
rho = 1.225;
dt = 0.01;

%Set up data arrays
v_corner_max = zeros(1,length(competition.trackData(:,2)));
v_all = zeros(1,length(competition.trackData(:,2)));
Total_time = zeros(1,length(competition.trackData(:,2)));
Total_energy_used = zeros(1,length(competition.trackData(:,2)));
Total_energy_recovered = zeros(1,length(competition.trackData(:,2)));
v_launch = 0.001;

for i = 1:length(v_all)
    if ((competition.trackData(i,2) ~= 0)) %Check if not straight
        competition.trackData(i,2) = competition.trackData(i,2)*(3.141592/180); % Convert to radians
        competition.trackData(i,2) = competition.trackData(i,1)/(competition.trackData(i,2)); % Calculate radius
    end
end

%-------------------------------------------------------------------------
%fprintf('Section 2 - Calculate maximum cornering velocities\n\n')
%Calculate maximum cornering velocity
for i = 1:length(v_corner_max)
    if (competition.trackData(i,2) ~= 0)
        v_corner_max(i) = func_iter_Max_Cornering_Vel(car, abs(competition.trackData(i,2)));
    end  
end

% disp(v_corner_max);
%-------------------------------------------------------------------------

%fprintf('Section 4 - Calculate longitudinal response\n\n')
%Iteratively calculate time for each longitudinal section

for i = 1:(length(v_corner_max) - 1)
    disp(i);
    if (competition.trackData(i,2) == 0) % Find Straights
        if (i == 1) % Check if launch/start straight
            [Accel_time, v_final] = func_iter_Accel_time(car, competition.trackData(i,3), v_launch, competition.trackData(i,1),dt);
        else
            [Accel_time, v_final] = func_iter_Accel_time(car, competition.trackData(i,3), v_corner_max(i - 1), competition.trackData(i,1),dt);
        end
        
        %Last stretch
        if (i == (length(v_corner_max) - 1))
        
            %            fprintf('   Segment %2.0f - Last Stretch\n', i);
            [Accel_time, v_accel, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_corner_max(i - 1), competition.trackData(i,1),dt);
            Total_time(i) = Accel_time;
            Total_energy_used(i) = energy;
            
            %Only need to brake
        elseif ((i ~= 1) && (v_corner_max(i - 1) > v_corner_max(i + 1)))
            
            %            fprintf('   Segment %2.0f - Braking required\n', i);
            [Braking_dist, Braking_time, energyRecovered] = func_iter_Braking_dist(car, competition.trackData(i,3), v_corner_max(i - 1), v_corner_max(i + 1),dt);
            Rem_dist = competition.trackData(i,1) - Braking_dist;
            
            index = 1;
            %If more braking distance required, reduce incoming velocity
            while (Rem_dist < 0)
                v_corner_max(i - 1) = (1 - index/1000)*v_corner_max(i - 1);
                [Braking_dist, Braking_time, energyRecovered] = func_iter_Braking_dist(car, competition.trackData(i,3), v_corner_max(i - 1), v_corner_max(i + 1),dt);
                Rem_dist = competition.trackData(i,1) - Braking_dist;
                index = index + 1;
            end
            
            if (abs(Rem_dist) < 0.001)
                Total_time(i) = Braking_time;
                Total_energy_recovered(i) = energyRecovered;
            else
                Total_time(i) = Braking_time + (Rem_dist/v_corner_max(i + 1));
                Total_energy_recovered(i) = energyRecovered;
            end
            
        elseif (v_final < v_corner_max(i + 1))
            %Does not require braking time but accelerating
            
            %            fprintf('   Segment %2.0f - Accelerating segment\n', i);
            
            v_check = 0;
            distReq = 0;
            while v_check<v_corner_max(i+1)
                distReq = distReq + 1;
                [Accel_time,v_check,energy] = func_iter_Accel_time(car,competition.trackData(i,3),v_final,distReq,dt);
                if distReq > competition.trackData(i+1,1)
                    break;
                end
            end
               
            if distReq > competition.trackData(i+1,1) % If corner is too long to get up to speed
                Accel_time2 = Accel_time;
                energy2 = energy;
                competition.trackData(i+1,1) = 0; %Effective corner length = 0
            else % Can get to max corner V before end of corner
                Accel_time2 = Accel_time;
                energy2 = energy;
                competition.trackData(i+1,1) = competition.trackData(i+1,1)-distReq; %Effective corner length reduced
            end

%             v_corner_max(i+1) = v_final; % Simulate car that can't accelerate through corner
%             Accel_time2 = 0;
            
            if (i == 1)
                [Accel_time, v_final, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_launch, competition.trackData(i,1),dt);
            else
                [Accel_time, v_final, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_corner_max(i - 1), competition.trackData(i,1),dt);
            end
            
            Total_time(i) = Accel_time + Accel_time2;
            Total_energy_used(i) = energy+energy2;
            
            %Requires accelerating and braking time
        else %((v_final > v_corner_max(i + 1)) && (v_corner_max(i + 1) > v_corner_max(i - 1)))
            
            %            fprintf('   Segment %2.0f - Acceleration and Braking required\n', i);
            Accel_dist = competition.trackData(i,1);
            Braking_dist = 0;
            
            if (i == 1)
                [Accel_time, v_accel, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_launch, competition.trackData(i,1),dt);
            else
                [Accel_time, v_accel, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_corner_max(i - 1), competition.trackData(i,1),dt);
            end
            
            [Braking_dist, Braking_time, energyRecovered] = func_iter_Braking_dist(car, competition.trackData(i,3), v_accel, v_corner_max(i + 1),dt);
            
            accel_dist_index = 1;
            
            while (abs((Braking_dist + Accel_dist - competition.trackData(i,1)))/competition.trackData(i,1) > 0.01)
                
                Accel_dist = (1 - accel_dist_index/100)*competition.trackData(i,1);
                
                if (i == 1)
                    [Accel_time, v_accel, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_launch, Accel_dist,dt);
                else
                    [Accel_time, v_accel, energy] = func_iter_Accel_time(car, competition.trackData(i,3), v_corner_max(i - 1), Accel_dist,dt);
                end
                
                [Braking_dist, Braking_time, energyRecovered] = func_iter_Braking_dist(car, competition.trackData(i,3), v_accel, v_corner_max(i + 1),dt);
                accel_dist_index = accel_dist_index + 1;
                
            end
            
            Total_time(i) = Braking_time + Accel_time;
            Total_energy_used(i) = energy;
            Total_energy_recovered(i) = energyRecovered;
            %Dist_check = Braking_dist + Accel_dist - competition.trackData(i,1);
            
        end
        
    end
    
end

%-------------------------------------------------------------------------
%fprintf('Section 5 - Calculate lateral response\n\n')
%Find total time for each rotational section

Time_below_5 = 0;
Time_below_10 = 0;
Time_below_15 = 0;
Time_below_20 = 0;
Time_below_25 = 0;
Time_below_30 = 0;
Time_below_35 = 0;

for i = 1:length(v_corner_max)
    
    if (v_corner_max(i) ~= 0)
        
        Total_time(i) = competition.trackData(i,1)/v_corner_max(i);
%         [Force,~] = func_iter_RPM_locater(car,v_corner_max(i));
        Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_corner_max(i)^2;
        DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_corner_max(i)^2;
        Fx_resist = 0.03*(car.mass.Iterate*g+DF);
        Force = Fx_resist + Drag + (car.mass.Iterate)*g*sind(competition.trackData(i,3));
        Total_energy_used(i) = Force*v_corner_max(i)*Total_time(i)/car.drivetrain_efficiency;
        
        if (competition.trackData(i,2) < 5)
            
            Time_below_5 = Time_below_5 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 10)
            
            Time_below_10 = Time_below_10 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 15)
            
            Time_below_15 = Time_below_15 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 20)
            
            Time_below_20 = Time_below_20 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 25)
            
            Time_below_25 = Time_below_25 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 30)
            
            Time_below_30 = Time_below_30 + Total_time(i);
            
        elseif (competition.trackData(i,2) < 35)
            
            Time_below_35 = Time_below_35 + Total_time(i);
            
        end
    end
end

%--------------------------------------------------------------------------

%Complete final section

%[Accel_time, v_final] = func_iter_Accel_time(grade, v_accel, TRACKdef(length(v_corner_max),1));
%Total_time(end) = Accel_time;

%--------------------------------------------------------------------------
%fprintf('Section 6 - Calculate lap time and point tally\n\n')
%Find total lap time

Lap_time = 0;
Corner_time = 0;
Lap_dist = 0;
Corner_dist = 0;
Energy_Consumed = 0;
Energy_Recovered = 0;

for i = 1:length(Total_time)
    
    Lap_time = Lap_time + Total_time(i);
    Lap_dist = Lap_dist + competition.trackData(i,1);
    Energy_Consumed = Energy_Consumed + Total_energy_used(i);
    Energy_Recovered = Energy_Recovered + Total_energy_recovered(i);
    
    if (v_corner_max(i) ~= 0)
        
        Corner_time = Corner_time + Total_time(i);
        Corner_dist = Corner_dist + competition.trackData(i,1);
        
    end 
end

AutoX_time = Lap_time;

Time_below_10 = Time_below_10 + Time_below_5;
Time_below_15 = Time_below_15 + Time_below_10;
Time_below_20 = Time_below_20 + Time_below_15;
Time_below_25 = Time_below_25 + Time_below_20;
Time_below_30 = Time_below_30 + Time_below_25;
Time_below_35 = Time_below_35 + Time_below_30;

%Plot corner probability
Radius_plot = [5 10 15 20 25 30 35 40];
Time_plot = [Time_below_5 Time_below_10 Time_below_15 Time_below_20 Time_below_25 Time_below_30 Time_below_35 1]./Corner_time;
% plot(Radius_plot, Time_plot)
% axis([5 35 0 1])
% title('Proportion of time in corner')
% xlabel('Radius(m)')
% ylabel('Cumulative time spent in radius')

% Competition Results
T_min = competition.autocrossMin;
T_max = 1.45*T_min;
T_your = AutoX_time;

AutoX_Score = 118.5*(((T_max/T_your) - 1)/((T_max/T_min) - 1)) + 6.5;
AutoX_energy_used = Energy_Consumed;
AutoX_energy_recovered = Energy_Recovered;

% if (AutoX_Score > 150)
%     AutoX_Score = 150;
% end

%fprintf('Results\n')
%fprintf('Lap time = %4.4f sec => Score = %4.3f\n\n', AutoX_time, AutoX_Score);

%figure(2)


%---------------------------------------------------------------------

end