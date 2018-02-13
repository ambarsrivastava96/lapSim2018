% Shift Time Sweep

shiftTimes = 0.001:0.01:0.5;
n = length(shiftTimes);

competition_properties_2017_C_FSAE_AUS;
vehicle_properties_2017_Combustion;

total = zeros(1,n);
Accel = zeros(1,n);
Skidpan = zeros(1,n);
AutoX = zeros(1,n);
Enduro = zeros(1,n);
Efficiency = zeros(1,n);

for i = 1:n
    fprintf('Iteration %d out of %d\n',i,n);
    car.shiftTime = shiftTimes(i);
    
    [Score,Time,Energy,~] = competitionScores(car,competition);
    Accel(i) = Score.Accel;
    Skidpan(i) = Score.Skidpan;
    AutoX(i) = Score.AutoX;
    Enduro(i) = Score.Enduro;
    Efficiency(i) = Score.Efficiency;
    total(i) = Score.total;
end

plot(shiftTimes,total,shiftTimes,Accel,shiftTimes,Skidpan,shiftTimes,AutoX,shiftTimes,Enduro,shiftTimes,Efficiency);
legend('Total', 'Acceleration', 'Skidpan', 'Autocross', 'Endurance', 'Efficiency');
grid minor
xlabel('Shift Time (s)')
ylabel('Dynamic Points')
title('Shift Time VS Competition Points')

