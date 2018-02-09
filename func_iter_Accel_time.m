function [Accel_time, v_final, energyUsed, K] = func_iter_Accel_time(car, grade, v_initial, distance, dt)

%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3

%Activate DRS Mode

if car.DRS == 1
    CD = car.CD_DRS;
else 
    CD = car.CD_IterateValue;
end
%Engine parameters
%http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/...
%specifications/24036/05/transmission.html

%R = [car.gear.R1 car.gear.R2 car.gear.R3 car.gear.R4 car.gear.R5 car.gear.R6];
R = car.gear.R;

%Car parameters
Fz = car.mass.Iterate*g;

%--------------------------------------------------------------------------
% Pre Allocating arrays
arraySize = 10000000;
v_x = zeros(1,arraySize);
a_x = zeros(1,arraySize);
x = zeros(1,arraySize);
t = zeros(1,arraySize);
p = zeros(1,arraySize);

%--------------------------------------------------------------------------
%Set up RPM locaters
%Define RPM and velocity characteristics
rpm_size = 10000;

% rpm = zeros(rpm_size,length(R));
% v = zeros(rpm_size,length(R));
% 
% for i = 2:rpm_size
%     for j = 1:length(R)
%         rpm(i,j) = rpm(i - 1,j) + 2;
%         v(i,j) = (((rpm(i,j)*2*pi)/60)/(R(j)*car.gear.final*car.gear.primary))*car.rim_RM;
%     end
% end

%--------------------------------------------------------------------------
%Start simulation
t(1) = 0;
a_x(1) = 0;
v_x(1) = v_initial;
x(1) = 0;
p(1) = 0;
E = 0;

[~,  gear_no] = func_iter_RPM_locater(car, v_initial);

R_gear = R(gear_no);
gearShift = 0;
D(1) = 0;


if v_initial == 0.001 && car.electric == 0
    launch = 1;
else
    launch = 0;
end

F_max = max(max(car.F_matrix));

for s = 2:arraySize
    if x(s-1) < distance
        Drag = 0.5*CD*rho*car.farea_Iterate*v_x(s-1)^2;
        DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_x(s-1)^2;

        Load_transfer = (car.mass.Iterate)*a_x(s-1)*car.COG_height/car.wheelbase;

        Fz_f = 0.5*(Fz)*cosd(grade) - Load_transfer + DF/2 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
        Fz_r = 0.5*(Fz)*cosd(grade) + Load_transfer + DF/2 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);

        mu = func_Coeff_Friction_long_rolling(Fz_r/2);
        Fx_r = mu*Fz_r;

        Fx_traction = Fx_r;

        %http://www.engineeringtoolbox.com/rolling-friction-resistance-d_1303.html
        Fx_resist = 0.03*(Fz_f + Fz_r);


        %%%%%%
        i_upper = length(car.V_matrix(:,gear_no));
        i_lower = 1;
        if car.V_matrix(i_upper,gear_no) < v_x(s-1) %If V above RPM range
            Lower_vel = car.V_matrix(i_upper,gear_no);
            F_drive = car.F_matrix(i_upper,gear_no);
        elseif car.V_matrix(i_lower,gear_no) > v_x(s-1) %If V below RPM range
            Lower_vel = 0;
            Lower_Force = 0;
            Upper_vel = car.V_matrix(i_lower,gear_no);
            Upper_Force = car.F_matrix(i_lower,gear_no);
            F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(s-1)-Lower_vel)/(Upper_vel-Lower_vel);
        else %Search for current RPM
            i = floor((i_lower+i_upper)/2); % Middle index
            i_last = i_upper;
            while car.V_matrix(i,gear_no)>v_x(s-1) || car.V_matrix(i+1,gear_no)< v_x(s-1)
                if car.V_matrix(i,gear_no)< v_x(s-1)
                    i_lower = i;
                else
                    i_upper = i;
                end
                i = floor((i_lower+i_upper)/2);
            end
            Lower_vel = car.V_matrix(i,gear_no);
            Lower_Force = car.F_matrix(i,gear_no);
            Upper_vel = car.V_matrix(i+1,gear_no);
            Upper_Force = car.F_matrix(i+1,gear_no);
            F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(s-1)-Lower_vel)/(Upper_vel-Lower_vel);
            [~,maxF_index] = max(car.F_matrix(:,gear_no));
            if i > maxF_index
                launch = 0;
            end
        end
        
%         while car.V_matrix(i,gear_no)< v_x(s-1)
%             Lower_vel = car.V_matrix(i,gear_no);
%             Lower_Force = car.F_matrix(i,gear_no);
%             if i==length(car.V_matrix(:,gear_no))
%                 F_drive = Lower_Force;
%                 Upper_vel = Lower_vel;
%                 break
%             else
%                 Upper_vel = car.V_matrix(i+1,gear_no);
%                 Upper_Force = car.F_matrix(i+1,gear_no);
%                 if Upper_Force==max(max(car.F_matrix))
%                     launch = 0;
%                 end
%                 F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(s-1)-Lower_vel)/(Upper_vel-Lower_vel);
%                 i = i+1;
%             end
%                 
%                 
%             if i<length(car.V_matrix(:,gear_no))
%                 Upper_vel = car.V_matrix(i+1,gear_no);
%                 Upper_Force = car.F_matrix(i+1,gear_no);
%                 if Upper_Force==max(max(car.F_matrix))
%                     launch = 0;
%                 end
%                 F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(s-1)-Lower_vel)/(Upper_vel-Lower_vel);
%                 i = i+1;
%             else
%                 F_drive = Lower_Force;
%                 Upper_vel = Lower_vel;
%                 break
%             end
%         end
        %%%%%%%%%%%%%%

        % Check if shift needed
        if v_x(s-1)>car.shiftV(gear_no) && gear_no < length(car.gear.R)
            gear_no = gear_no + 1;
            gearShift = 1;
            tShift = t(s-1);
        end


        %Check if still mid-shift
        if gearShift == 1
            if t(s-1)-tShift>=car.shiftTime
                gearShift = 0;
            else
            F_drive = 0;
            end
        end

        powerMotor = F_drive*v_x(s-1)/car.drivetrain_efficiency;
        if powerMotor > car.powerLimit
            powerMotor = car.powerLimit;
            F_drive = car.powerLimit/v_x(s-1)*car.drivetrain_efficiency;
        end

        F_eng1 = F_drive - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade);% Power Limited
        F_eng2 = Fx_traction - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade); % Traction Limited
        F_eng3 = F_max - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade); % Launch Force if power limited

        if(F_drive > Fx_traction) % Clutch Fully released (launch complete)
            launch = 0;
            a_x(s) = F_eng2/(car.mass.Iterate);
            powerMotor = Fx_traction*v_x(s-1)/car.drivetrain_efficiency;
        elseif (launch == 1) && F_max < Fx_traction % Launching but power limited
            a_x(s) = F_eng3/(car.mass.Iterate);
            powerMotor = Fx_traction*v_x(s-1)/car.drivetrain_efficiency;
        elseif (launch == 1) % Launching traction limited
            a_x(s) = F_eng2/(car.mass.Iterate);
            powerMotor = Fx_traction*v_x(s-1)/car.drivetrain_efficiency;
        else
            a_x(s) = F_eng1/(car.mass.Iterate);
        end

        %Longitundinal acceleration limited by load transfer
        if (abs(a_x(s-1)) > (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF*0.5)/(car.COG_height*(car.mass.Iterate))))
            a_x(s) = (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF*0.5)/(car.COG_height*(car.mass.Iterate))); 
        end

        %Discrete integration to find velocity and position
        v_new = v_x(s-1) + a_x(s-1)*dt;
        if v_new >car.top_speed
            v_new = car.top_speed;
        end
%         v_x = [v_x, v_new];
%         x = [x, x(length(x)) + v_x(length(v_x))*dt + 0.5*a_x(length(a_x))*dt^2]; 
%         t = [t, t(length(t)) + dt];
%         p = [p, powerMotor];

        v_x(s) = v_new;
        x(s) = x(s-1) + v_x(s-1)*dt + 0.5*a_x(s-1)*dt^2;
        t(s) = t(s-1) + dt;
        p(s) = powerMotor; 
        E = E+dt*powerMotor;
    else
        t = t(1,1:s-1);
        x = x(1,1:s-1);
        v_x = v_x(1,1:s-1);
        a_x = a_x(1,1:s-1);
        p = p(1,1:s-1);
        break
    end
    
    if rem(s,arraySize) == 0
        disp('Trip');
        t = [t zeros(1,arraySize)];
        x = [x zeros(1,arraySize)];
        v_x = [v_x zeros(1,arraySize)];
        a_x = [a_x zeros(1,arraySize)];
        p = [p zeros(1,arraySize)];
    end
end

Accel_time = t(length(t));
v_final = v_x(length(v_x));
energyUsed = E;

K.t = t;
K.x = x;
K.v = v_x;
K.a = a_x;
K.p = p;

end
