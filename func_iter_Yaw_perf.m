function [Yaw_perf] = func_iter_Yaw_perf(car, radius)

%radius = [5:1:30];

%Yaw_angle = -58.28.*(radius + 0.884146).^-1 + 8.40457;
if (radius == 0)
    Yaw_angle = 0;  
else 
    Yaw_angle = (180/pi)*atan(car.wheelbase*0.5/radius);
    Yaw_angle = Yaw_angle;
end

if (Yaw_angle < 30)
    m = (1.23 - car.CL_IterateValue)/30;
    car.CL_IterateValue_graph = m*abs(Yaw_angle) + car.CL_IterateValue;
else
    car.CL_IterateValue_graph = 1.23;
end

Yaw_perf = car.CL_IterateValue_graph/(car.CL_IterateValue);

end