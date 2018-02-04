% Drag vs Energy Test

E = zeros(1,10);
D = zeros(1,10);
vehicle_properties_2017_ElectricConcept;

aeroEff = car.CL_IterateValue/car.CD_IterateValue;

competition_properties_2017_C_FSAE_AUS;
[Score,Time,Energy] = competitionScores(car,competition);
D(1) = car.CD_IterateValue;
E(1) = competition.laps*Energy.AutoX_Used;

for i = 2:10
    car.CD_IterateValue = car.CD_IterateValue - 0.1;
    car.CL_IterateValue = car.CD_IterateValue*aeroEff;
    [Score,Time,Energy] = competitionScores(car,competition);
    D(i) = car.CD_IterateValue;
    E(i) = competition.laps*Energy.AutoX_Used;
end

plot(D,E);

