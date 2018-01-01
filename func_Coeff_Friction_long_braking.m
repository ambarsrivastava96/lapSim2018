function [mu] = func_Coeff_Friction_long_braking(Fz)

%Friction = [1.45, 1.43, 1.40, 1.35, 1.25, 1.1];
%Load = [0, 250, 500, 750, 1000, 1250]*4.44822;
%mu = -1.9525e-12.*Fz.^3 + 2.8559e-09.*Fz.^2 - 1.8532e-05.*Fz + 1.4498;

%Fy = [2.3 1.9 1.5 1.05 0.5 0]*1000;
%Fz = [1.1 0.875 0.655 0.44 0.205 0]*1000;
%mu = Fy./Fz;

%plot(Fz, mu)

%Fz = [1090, 870, 600, 210];
%Fx = [2650, 2300, 1900, 833.33];

%plot(Fz,Fx./Fz)

%mu = 7.8901e-07.*Fz.^2 - 0.00028024.*Fz + 4.5298;

%mu = -0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038;

Fz = Fz./1000;

Fx = -0.0229.*Fz.^3 + 0.8056.*Fz.^2 + 2.8459.*Fz - 0.0065;

mu = Fx./Fz;

end