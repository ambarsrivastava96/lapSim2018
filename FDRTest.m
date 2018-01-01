% FDR Test
competition_properties_2016_FSAE_AUS;
%vehicle_properties_2017_ElectricConcept;
vehicle_properties_2017_Combustion;

FDR = 2.5:0.1:4.5;
scores1 = [];
accelTimes = [];
autoXTimes = [];
% scores2 = [];

for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [ScoresE1, timesE1] = competitionScores(car,competition);
    accelTimes = [accelTimes timesE1.Accel];
    autoXTimes = [autoXTimes timesE1.AutoX];
    scores1 = [scores1 ScoresE1.total];
    fprintf('Iteration %d/%d\n',i,2*length(FDR));
end

% vehicle_properties_Electric2017_dualDrive;
% for i = 1:length(FDR)
%     car.gear.final = FDR(i);
%     [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
%     [ScoresE2, timesE2] = competitionScores(car,competition);
%     scores2 = [scores2 ScoresE2.total];
%     fprintf('Iteration %d/%d\n',length(FDR)+i,2*length(FDR));
% end

plot(FDR,scores1);
% plot(FDR,scores1, FDR, scores2);
xlabel('FDR');
ylabel('Competition Points (Exluding Efficiency)');