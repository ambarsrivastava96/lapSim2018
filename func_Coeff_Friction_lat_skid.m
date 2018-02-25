function [mu] = func_Coeff_Friction_lat_skid(Fz)

%Friction = [1.45, 1.43, 1.40, 1.35, 1.25, 1.1];
%Load = [0, 250, 500, 750, 1000, 1250]*4.44822;
%mu = -1.9525e-12.*Fz.^3 + 2.8559e-09.*Fz.^2 - 1.8532e-05.*Fz + 1.4498;

%Fy = [2.3 1.9 1.5 1.05 0.5 0]*1000;
%Fz = [1.1 0.875 0.655 0.44 0.205 0]*1000;
%mu = Fy./Fz;

%plot(Fz, mu-0.9)

mu = (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.9);
% mu = mu*1.1;

end



%USE R/IC to find VELOCITYx and VELOCITYy of FRONT WHEEL = FIND REAR WHEEL