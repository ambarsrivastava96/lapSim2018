function [Skidpad_Score, Skidpad_time] = SkidPad_Sim_iterate(car,competition)

%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3
Fz = car.mass.Iterate*g;

%Define x and y coordinates of circar.CL_IterateValuees
r = (15.25 + 3)/2;

%---------------------------------------------------------------------

%Assume initial velocity of v_aero
v = 3;
a_lat = v^2/(r);

Fz_l = Fz/2;
Fz_r = Fz/2;

mu_left = func_Coeff_Friction_lat_skid(Fz_l/2);
mu_right = func_Coeff_Friction_lat_skid(Fz_r/2);
Fy = (mu_left*Fz_l + mu_right*Fz_r);
Fy_old = 10e6;

while (abs(Fy - Fy_old) > 0.001)

DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v^2;
    
Load_transfer = (car.mass.Iterate)*a_lat*car.COG_height/car.track.average;
Fz_l = (Fz)/2 + Load_transfer + 0.5*DF;
Fz_r = (Fz)/2 - Load_transfer + 0.5*DF;

mu_left = func_Coeff_Friction_lat_skid(Fz_l/2);
mu_right = func_Coeff_Friction_lat_skid(Fz_r/2);
Fy_l = mu_left*Fz_l;
Fy_r = mu_right*Fz_r;

Fy_old = Fy;
Fy = Fy_l + Fy_r;

a_lat = Fy/(car.mass.Iterate);

%Lateral acceleration limited by load transfer
if (abs(a_lat) > (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate))))
        
    a_lat = (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate)));
        
end

v = (r*a_lat)^0.5;

end

d = 2*pi*r;
t_aero = d/v;

%Score Calculation
Tmin = competition.skidMin;
Tmax = Tmin*1.25;
Tyour2 = t_aero;

Skidpad_Score = (71.5*((Tmax/Tyour2)^2 -1) / ((Tmax/Tmin)^2 -1)) + 3.5;

% if (Skidpad_Score > 75)
%     Skidpad_Score = 75;
% end

Skidpad_time = Tyour2;


end

