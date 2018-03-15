function [Skidpad_Score, Skidpad_time] = SkidPad_Sim_iterate(car,competition)

%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3
Fz = car.mass.Iterate*g;
grade = 0;

r = 15.25/2 + car.track.average;
tempTyre = car.tyre.latMu;
car.tyre.latMu = car.tyre.latMuSkid;
%---------------------------------------------------------------------
v = func_iter_Max_Cornering_Vel_New(car, r, grade);

%Score Calculation
Tmin = competition.skidMin;
Tmax = Tmin*1.25;
Tyours = 2*pi()*r/v;

Skidpad_Score = (71.5*((Tmax/Tyours)^2 -1) / ((Tmax/Tmin)^2 -1)) + 3.5;

% if (Skidpad_Score > 75)
%     Skidpad_Score = 75;
% end

Skidpad_time = Tyours;

car.tyre.latMu = tempTyre; 

end

