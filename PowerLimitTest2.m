% Power Test
competition_properties_2016_FSAE_AUS;
i = 1:8;
scoresTotal = zeros(1,length(i));
scoresAccel = zeros(1,length(i));
scoresEnduro = zeros(1,length(i));
scoresAutoX = zeros(1,length(i));
scoresSkid = zeros(1,length(i));

for i = 1:8
    vehicle_properties_2017_ElectricConcept;
    car.powerLimit = 40000+i*5000;
    [Score,Time,Energy] = competitionScores(car,competition);
    scoresTotal(i) = Score.total;
    scoresAccel(i) = Score.Accel;
    scoresEnduro(i) = Score.Enduro;
    scoresAutoX(i) = Score.AutoX;
    scoresSkid(i) = Score.Skidpan;
end
r = 45:5:80;
plot(r,scoresTotal,r,scoresAccel,r,scoresEnduro,r,scoresAutoX,r,scoresSkid);
legend('Total', 'Accel', 'Enduro', 'AutoX', 'Skid');