function [Accel_time, v_final, energyUsed, K] = func_iter_Accel_time(car, grade, v_initial, distance, dt)

%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3

%Activate DRS Mode
%Cl = 0.5*Cl;
%Cd = 0.85;

%Engine parameters
%http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/...
%specifications/24036/05/transmission.html

%R = [car.gear.R1 car.gear.R2 car.gear.R3 car.gear.R4 car.gear.R5 car.gear.R6];
R = car.gear.R;

%Car parameters
Fz = car.mass.Iterate*g;


%--------------------------------------------------------------------------
%Set up RPM locaters
%Define RPM and velocity characteristics
rpm_size = 10000;

rpm = zeros(rpm_size,length(R));
v = zeros(rpm_size,length(R));

for i = 2:rpm_size
    
    for j = 1:length(R)
        rpm(i,j) = rpm(i - 1,j) + 2;
        v(i,j) = (((rpm(i,j)*2*pi)/60)/(R(j)*car.gear.final*car.gear.primary))*car.rim_RM;
    end
    
end

%--------------------------------------------------------------------------
%Start simulation (no aerodynamics)
t = 0;
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

while(x(length(x)) < distance)
    
    Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_x(length(v_x))^2;
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_x(length(v_x))^2;
    
    D = [D Drag];
    
    Load_transfer = (car.mass.Iterate)*a_x(length(a_x))*car.COG_height/car.wheelbase;
    
    Fz_f = 0.5*(Fz )*cosd(grade) - Load_transfer + DF/2 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    Fz_r = 0.5*(Fz)*cosd(grade) + Load_transfer + DF/2 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    
    mu = func_Coeff_Friction_long_rolling(Fz_r/2);
    Fx_r = mu*Fz_r;
    
    Fx_traction = Fx_r;
    
    %http://www.engineeringtoolbox.com/rolling-friction-resistance-d_1303.html
    Fx_resist = 0.03*(Fz_f + Fz_r);
    
    i=1;
    Lower_vel = 0;
    Lower_Force = 0;
    Upper_vel = car.V_matrix(i,gear_no);
    Upper_Force = car.F_matrix(i,gear_no);
    F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(end)-Lower_vel)/(Upper_vel-Lower_vel);
    while car.V_matrix(i,gear_no)< v_x(end)
        Lower_vel = car.V_matrix(i,gear_no);
        Lower_Force = car.F_matrix(i,gear_no);
        if i<length(car.V_matrix(:,gear_no))
            Upper_vel = car.V_matrix(i+1,gear_no);
            Upper_Force = car.F_matrix(i+1,gear_no);
            if Upper_Force==max(max(car.F_matrix))
                launch = 0;
            end
            F_drive = Lower_Force + (Upper_Force-Lower_Force)*(v_x(end)-Lower_vel)/(Upper_vel-Lower_vel);
            i = i+1;
        else
            F_drive = Lower_Force;
            Upper_vel = Lower_vel;
            break
        end
    end

    % Check if shift needed
    if v_x(end)>car.shiftV(gear_no) && gear_no < length(car.gear.R)
        gear_no = gear_no + 1;
        gearShift = 1;
        tShift = t(end);
    end
    

    %Check if still mid-shift
    if gearShift == 1
        if t(end)-tShift>=car.shiftTime
            gearShift = 0;
        else
        F_drive = 0;
        end
    end
    
    powerMotor = F_drive*v_x(end)/car.drivetrain_efficiency;
    if powerMotor > car.powerLimit
        powerMotor = car.powerLimit;
        F_drive = car.powerLimit/v_x(end)*car.drivetrain_efficiency;
    end
    
    F_eng1 = F_drive - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade);% Power Limited
    F_eng2 = Fx_traction - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade); % Traction Limited
    F_eng3 = F_max - Fx_resist - Drag - (car.mass.Iterate)*g*sind(grade); % Launch Force if power limited
    
    if(F_drive > Fx_traction) % Clutch Fully released (launch complete)
        launch = 0;
        a_x = [a_x F_eng2/(car.mass.Iterate)];
        powerMotor = Fx_traction*v_x(end)/car.drivetrain_efficiency;
    elseif (launch == 1) && F_max < Fx_traction % Launching but power limited
        a_x = [a_x F_eng3/(car.mass.Iterate)];
        powerMotor = Fx_traction*v_x(end)/car.drivetrain_efficiency;
    elseif (launch == 1) % Launching traction limited
        a_x = [a_x F_eng2/(car.mass.Iterate)];
        powerMotor = Fx_traction*v_x(end)/car.drivetrain_efficiency;
    else
        a_x = [a_x F_eng1/(car.mass.Iterate)];
    end
    
    %Longitundinal acceleration limited by load transfer
    if (abs(a_x(length(a_x))) > (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF*0.5)/(car.COG_height*(car.mass.Iterate))))
        a_x(length(a_x)) = (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF*0.5)/(car.COG_height*(car.mass.Iterate))); 
    end

    %Discrete integration to find velocity and position
    v_new = v_x(length(v_x)) + a_x(length(a_x))*dt;
    if v_new >car.top_speed
        v_new = car.top_speed;
    end
    v_x = [v_x, v_new];
    x = [x, x(length(x)) + v_x(length(v_x))*dt + 0.5*a_x(length(a_x))*dt^2]; 
    t = [t, t(length(t)) + dt];
    p = [p, powerMotor];
    E = E+dt*powerMotor;
    
end

% plot(t, a_x)
% xlabel('time');
% ylabel('accel');

Accel_time = t(length(t));
v_final = v_x(length(v_x));
energyUsed = E;

K.t = t;
K.x = x;
K.v = v_x;
K.a = a_x;
K.p = p;

end