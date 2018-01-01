% Only use this function at the start of Accel to find start Force/Gear
function [Current_Force,Gear_no] = func_iter_RPM_locater(car, vel)
Lower_vel = 0;
Upper_vel = inf;
Lower_Force = 0;
Upper_Force = Inf;
for i = 1:length(car.FVG_Matrix(1,:))
    if car.FVG_Matrix(1,i)< vel
        Lower_Force = car.FVG_Matrix(2,i);
        Lower_vel = car.FVG_Matrix(1,i);
        Gear_no_lower = car.FVG_Matrix(3,i);
    elseif car.FVG_Matrix(1,i)<Upper_vel
        Upper_Force = car.FVG_Matrix(2,i);
        Upper_vel = car.FVG_Matrix(1,i);
        Gear_no_upper = car.FVG_Matrix(3,i);
    else
        break;
    end
end

Gear_no = Gear_no_upper;
Current_Force = Lower_Force + (Upper_Force-Lower_Force)*(vel-Lower_vel)/(Upper_vel-Lower_vel);
    
end
