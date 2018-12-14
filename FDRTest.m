% FDR Test
competition_properties_2017_C_FSAE_AUS;
% vehicle_properties_2018_Electric;
vehicle_properties_2018_Combustion;

FDR = 2:0.1:5;
n = length(FDR);
total = zeros(1,n);
Accel = zeros(1,n);
Skidpan = zeros(1,n);
AutoX = zeros(1,n);
Enduro = zeros(1,n);
Efficiency = zeros(1,n);
EnduroEnergy = zeros(1,n);


for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1,Energy] = competitionScores(car,competition);
    Accel(i) = Score.Accel;
    Skidpan(i) = Score.Skidpan;
    AutoX(i) = Score.AutoX;
    Enduro(i) = Score.Enduro;
    Efficiency(i) = Score.Efficiency;
    EnduroEnergy(i) = Energy.Enduro_Used;
    total(i) = Score.total;
    fprintf('Iteration %d/%d\n',i,length(FDR));
end

% vehicle_properties_Electric2017_dualDrive;
% for i = 1:length(FDR)
%     car.gear.final = FDR(i);
%     [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
%     [ScoresE2, timesE2] = competitionScores(car,competition);
%     scores2 = [scores2 ScoresE2.total];
%     fprintf('Iteration %d/%d\n',length(FDR)+i,2*length(FDR));
% end



figure
plot(FDR,EnduroEnergy)
xlabel('FDR')
ylabel('Energy Used in Endurance')
title('Endurance energy consumed for FDR sweep')