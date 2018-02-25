function [mu] = func_Coeff_Friction_lat(Fz)

mu = (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.3);
% mu = mu*1.1;

end
