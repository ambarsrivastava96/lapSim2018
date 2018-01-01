function top_speed = findCarTopSpeed(car)

gearingTop = car.top_speed;
currentV = 1;
lastV = 0;
distance = 10;

while abs(currentV-lastV) > 0.001
    lastV = currentV;
    [~,currentV] = func_iter_Accel_time(car,0,0.001,distance);
    distance = distance + 400;
end
dragTop = currentV;
if dragTop < gearingTop
    top_speed = dragTop;
else
    top_speed = gearingTop;
end

end