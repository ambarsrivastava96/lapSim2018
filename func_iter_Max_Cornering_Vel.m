function [v_max] = func_iter_Max_Cornering_Vel(car, radius)

g = 9.81; %m/s
rho = 1.225; %kg/m^3

Fz = car.mass.Iterate*g;
%---------------------------------------------------------
%Alter car.CL_IterateValue depending on Yaw angle prescribed by radius

Yaw_perf = func_iter_Yaw_perf(car, radius);
CL = car.CL_IterateValue*Yaw_perf;

%---------------------------------------------------------

%Assume initial velocity of v_aero
v = 5;
a_lat = v^2/(radius);

Fz_l = Fz/2;
Fz_r = Fz/2;

mu_left = func_Coeff_Friction_lat(Fz_l/2);
mu_right = func_Coeff_Friction_lat(Fz_r/2);
Fy = (mu_left*Fz_l + mu_right*Fz_r);
Fy_old = 10e6;


while (abs(Fy - Fy_old) > 0.001)
    
    DF = 0.5*CL*rho*car.farea_Iterate*v^2;
    
    Load_transfer = (car.mass.Iterate)*a_lat*car.COG_height/car.track.average;
    Fz_l = (Fz)/2 + Load_transfer + 0.5*DF;
    Fz_r = (Fz)/2 - Load_transfer + 0.5*DF;
    
    mu_left = func_Coeff_Friction_lat(Fz_l/2);
    mu_right = func_Coeff_Friction_lat(Fz_r/2);
    Fy_l = mu_left*Fz_l;
    Fy_r = mu_right*Fz_r;
    
    Fy_old = Fy;
    Fy = Fy_l + Fy_r;
    
    a_lat = Fy/(car.mass.Iterate);
    
    %Lateal acceleration limited by load transfer
    if (abs(a_lat) > (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate))))
        
        a_lat = (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate)));
    end
    
    v = (radius*a_lat)^0.5;
    
    if (v > car.top_speed)
        
        v = car.top_speed - 0.01;
        check = 1;
    end
    
    if (v > car.top_speed && check == 1)
        
        v = car.top_speed - 0.01;
        break;
    end
end

v_max = v;
end