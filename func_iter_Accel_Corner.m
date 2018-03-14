function [time, v_final, energyUsed, K] = func_iter_Accel_Corner(car, grade, v_initial, a_x_initial,v_max, corner_rad, distance, dt)

%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3

%Activate DRS Mode

% if car.DRS == 1
%     CD = car.CD_DRS;
% else 
%     CD = car.CD_IterateValue;
% end

R = car.gear.R;

%Car parameters
Fz = car.mass.Iterate*g;

%--------------------------------------------------------------------------
% Pre Allocating arrays
arraySize = 10000000;
v_x = zeros(1,arraySize);
a_x = zeros(1,arraySize);
a_y = zeros(1,arraySize);
x = zeros(1,arraySize);
t = zeros(1,arraySize);
p = zeros(1,arraySize);
gear = zeros(1,arraySize);

%--------------------------------------------------------------------------
%Start simulation
t(1) = 0;
a_x(1) = a_x_initial;
a_y(1) = v_initial^2/corner_rad;
v_x(1) = v_initial;
x(1) = 0;
p(1) = 0;
E = 0;

[~,  gear_no] = func_iter_RPM_locater(car, v_initial);

gearShift = 0;

for s = 2:arraySize
    if x(s-1) < distance && v_x(s-1) < v_max
        Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_x(s-1)^2;
        DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_x(s-1)^2;
        
        % Calculate load transfer
        Load_transfer_x = (car.mass.Iterate)*a_x(s-1)*car.COG_height/car.wheelbase; % Front to rear load transfer
        if Load_transfer_x > Fz/2+DF/2
            Load_transfer_x = Fz/2 + DF/2;
        end
        Load_transfer_y_f = (car.mass.Iterate)*a_y(s-1)*car.COG_height/car.track.front; % Front Inside to Outside load transfer 
        Load_transfer_y_r = (car.mass.Iterate)*a_y(s-1)*car.COG_height/car.track.rear; % Rear Inside to Outside load transfer
        if Load_transfer_y_f+Load_transfer_y_r > Fz/2+DF/2
            Load_transfer_y_f = (Fz/2+DF/2)*(car.track.front/(car.track.front+car.track.rear));
            Load_transfer_y_r = (Fz/2+DF/2)*(car.track.rear/(car.track.front+car.track.rear));
        end
        % Calculate Wheel Loads
        Fz_f_i= 0.25*(Fz)*cosd(grade) - Load_transfer_x/2 - Load_transfer_y_f/2+ DF/4 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
        Fz_r_i = 0.25*(Fz)*cosd(grade) + Load_transfer_x/2 - Load_transfer_y_r/2+ DF/4 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
        
        Fz_f_o = 0.25*(Fz)*cosd(grade) - Load_transfer_x/2 + Load_transfer_y_f/2 + DF/4 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
        Fz_r_o = 0.25*(Fz)*cosd(grade) + Load_transfer_x/2 + Load_transfer_y_r/2+ DF/4 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
        
%         mu = func_Coeff_Friction_long_rolling(Fz_r/2);
%         mu = car.tyre.longMuRolling(Fz_r/2)*car.tyre.longMuScale;
%         Fx_r = mu*Fz_r;
        
        % Proportion of load on each tyre
        Fz_total = Fz_f_i + Fz_r_i + Fz_f_o + Fz_r_o;
        
        P_Fz_f_i = Fz_f_i/(Fz_total);
        P_Fz_r_i = Fz_r_i/(Fz_total);
        P_Fz_f_o = Fz_f_o/(Fz_total);
        P_Fz_r_o = Fz_r_o/(Fz_total);
        
        % Calculate Amount of Vertical Load Used for cornering on rear
        Fy_total = car.mass.Iterate*a_y(s-1);
        
        Fz_f_i_corner = (Fy_total*P_Fz_f_i)/(car.tyre.latMu(Fz_f_i)*car.tyre.latMuScale);
        Fz_r_i_corner = (Fy_total*P_Fz_r_i)/(car.tyre.latMu(Fz_r_i)*car.tyre.latMuScale);
        Fz_f_o_corner = (Fy_total*P_Fz_f_o)/(car.tyre.latMu(Fz_f_o)*car.tyre.latMuScale);
        Fz_r_o_corner = (Fy_total*P_Fz_r_o)/(car.tyre.latMu(Fz_r_o)*car.tyre.latMuScale);
        
        % Calculate Remaining Available Tractive Force (Long)
        Fz_r_i_long = Fz_r_i - Fz_r_i_corner;
        Fz_r_o_long = Fz_r_o - Fz_r_o_corner;
        
        Fx_r_i = Fz_r_i_long*car.tyre.longMuRolling(Fz_r_i_long)*car.tyre.longMuScale;
        Fx_r_o = Fz_r_o_long*car.tyre.longMuRolling(Fz_r_i_long)*car.tyre.longMuScale;
     
        Fx_r_open = 2*min([Fx_r_i Fx_r_o]); % Acceleration limited by least loaded tyre (Open diff)
        Fx_r_locked = Fx_r_o; % Acceleration all through outer wheel, i.e. lifting inner (Locked diff)

        Fx_traction = (Fx_r_open+Fx_r_locked)/2;% Assume average of Open and Locked (LSD)
        
%         Fx_traction = Fx_r_open; 

        %http://www.engineeringtoolbox.com/rolling-friction-resistance-d_1303.html
        Fx_resist = car.tyre.rollingResistance*(Fz_f_i + Fz_f_o + Fz_r_i + Fz_r_o);


        % Find Drive Force Available at current speed (RPM and Gear)
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
        end
        
        % Check if mid-shift
        if gearShift == 1
            if t(s-1)-tShift>=car.shiftTime %Check if shift time has elapsed
                gearShift = 0; % Change to out of shift
            else
            F_drive = 0; % If mid shift, no drive force
            end
        else 
            % Check if shift needed
            if v_x(s-1)>car.shiftV(gear_no) && gear_no < length(car.gear.R) %If speed has passed shifting speed, and not top gear
                gear_no = gear_no + 1; % Increment to next gear
                gearShift = 1; % Change to mid shift condition
                tShift = t(s-1); % Shifting start point 
            end
        end

        powerMotor = F_drive*v_x(s-1)/car.drivetrain_efficiency; % Output Power
        if powerMotor > car.powerLimit % For electric car power limit
            powerMotor = car.powerLimit;
            F_drive = car.powerLimit/v_x(s-1)*car.drivetrain_efficiency;
        end

        F_eng1 = F_drive - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade);% Power Limited
        F_eng2 = Fx_traction - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade); % Traction Limited
            
        if(F_drive > Fx_traction) && (F_eng2>0)% Traction Limited
            a_x(s) = F_eng2/(car.mass.Iterate);
            powerMotor = Fx_traction*v_x(s-1)/car.drivetrain_efficiency;
        elseif F_drive < Fx_traction % Power Limited
            a_x(s) = F_eng1/(car.mass.Iterate);
        else 
            a_x(s) = 0; 
            v_x(s-1) = v_max;
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
        a_y(s) = v_x(s)^2/corner_rad;
        p(s) = powerMotor; 
        E = E+dt*powerMotor;
        gear(s) = gear_no;
    else
        t = t(1,1:s-1);
        x = x(1,1:s-1);
        v_x = v_x(1,1:s-1);
        a_x = a_x(1,1:s-1);
        a_y = a_y(1,1:s-1);
        p = p(1,1:s-1);
        gear = gear(1,1:s-1);
        break
    end
    
    if rem(s,arraySize) == 0
        disp('Trip');
        t = [t zeros(1,arraySize)];
        x = [x zeros(1,arraySize)];
        v_x = [v_x zeros(1,arraySize)];
        a_x = [a_x zeros(1,arraySize)];
        a_y = [a_y zeros(1,arraySize)];
        p = [p zeros(1,arraySize)];
        gear = [gear zeros(1,arraySize)];
    end
end

time = t(length(t));
v_final = v_x(length(v_x));
energyUsed = E;

K.t = t;
K.x = x;
K.v = v_x;
K.a = a_x;
K.ay = a_y;
K.p = p;
K.gear = gear;

end
