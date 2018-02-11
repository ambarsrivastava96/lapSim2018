function top_speed = findCarTopSpeed(car)

gearingTop = car.top_speed;
currentV = 1;
lastV = 0;
distance = 500;

while abs(currentV-lastV) > 0.01
    lastV = currentV;
    [~,currentV] = func_iter_Accel_time(car,0,0.001,distance, 0.001);
    distance = distance + 500;
end
dragTop = currentV;
if dragTop < gearingTop
    top_speed = dragTop;
else
    top_speed = gearingTop;
end

end