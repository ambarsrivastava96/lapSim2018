% CoG Test

cog = 0.3:0.01:0.35;
n = length(cog);
competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

total = zeros(1,n);
Accel = zeros(1,n);
Skidpan = zeros(1,n);
AutoX = zeros(1,n);
Enduro = zeros(1,n);
Efficiency = zeros(1,n);
EnduroEnergy = zeros(1,n);


for i = 1:length(cog)
    car.COG_height = cog(i);
    [Score, timesE1,Energy] = competitionScores(car,competition);
    Accel(i) = Score.Accel;
    Skidpan(i) = Score.Skidpan;
    AutoX(i) = Score.AutoX;
    Enduro(i) = Score.Enduro;
    Efficiency(i) = Score.Efficiency;
    EnduroEnergy(i) = Energy.Enduro_Used;
    total(i) = Score.total;
    fprintf('Iteration %d/%d\n',i,length(cog));
end


plot(cog,total,cog,Accel,cog,Skidpan,cog,AutoX,cog,Enduro,cog,Efficiency);
legend('Total', 'Acceleration', 'Skidpan', 'Autocross', 'Endurance', 'Efficiency');
grid minor
xlabel('CoG Height')
ylabel('Dynamic Points')
title('CoG VS Competition Points')