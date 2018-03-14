% Motor Test

competition_properties_2017_E_FSAE_AUS;

nTests = 6; 
FDR = 3:0.2:5;
n = length(FDR);
total = zeros(6,n);

% Single 208
vehicle_properties_2018_Electric;
for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(1,i) = Score.total;
    fprintf('Iteration %d/%d\n',i,6*length(FDR));
end

% Dual 208 Single Drive
car.mass.Iterate = car.mass.Iterate+9.4;
car.torque = car.torque*2; 
car.power = car.power*2;
car.peak_power = 2*car.peak_power;
for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(2,i) = Score.total;
    fprintf('Iteration %d/%d\n',i+length(FDR),6*length(FDR));
end


% Dual 208 Separate Drive
car.mass.Iterate = car.mass.Iterate+20.6-9.4;
for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(3,i) = Score.total;
    fprintf('Iteration %d/%d\n',i+2*length(FDR),6*length(FDR));
end


% Single 228
clear car
vehicle_properties_2018_Electric_228;
for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(4,i) = Score.total;
    fprintf('Iteration %d/%d\n',i+3*length(FDR),6*length(FDR));
end


% Dual 228 Single Drive
car.mass.Iterate = car.mass.Iterate+12.3;
car.torque = car.torque*2; 
car.power = car.power*2;
car.peak_power = 2*car.peak_power;
for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(5,i) = Score.total;
    fprintf('Iteration %d/%d\n',i+4*length(FDR),6*length(FDR));
end

% Dual 228 Separate Drive
car.mass.Iterate = car.mass.Iterate+26.4;

for i = 1:length(FDR)
    car.gear.final = FDR(i);
    [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    [Score, timesE1, Energy] = competitionScores(car,competition);
    total(6,i) = Score.total;
    fprintf('Iteration %d/%d\n',i+5*length(FDR),6*length(FDR));
end


plot(FDR,total(1,:),FDR,total(2,:),FDR,total(3,:),FDR,total(4,:),FDR,total(5,:),FDR,total(6,:));
legend('Single 208', 'Dual 208, Single Drive', 'Dual 208, Separate Drive (No TV)', 'Single 228', 'Dual 228, Single Drive', 'Dual 228, Separate Drive (No TV)');
grid minor
xlabel('FDR')
ylabel('Dynamic Points')
title('FDR VS Competition Points for various motor configurations')
figure
plot(FDR,EnduroEnergy)
xlabel('FDR')
ylabel('Energy Used in Endurance')
title('Endurance energy consumed for FDR sweep')