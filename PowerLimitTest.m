% Power Limit Test

competition_properties_2016_FSAE_AUS;
vehicle_properties_Electric2017;

limit = 20:5:100;
limit = limit*1000;

scores = [];
for i = 1:length(limit)
    car.powerLimit = limit(i);
    [Scores1, times1] = competitionScores(car,competition);
    scores = [scores Scores1.total];
    fprintf('Iteration = %d/%d\n',i,2*length(limit));
end

vehicle_properties_Electric2017_dualDrive;

scores2 = [];
for i = 1:length(limit)
    car.powerLimit = limit(i);
    [Scores2, times2] = competitionScores(car,competition);
    scores2 = [scores2 Scores2.total];
    fprintf('Iteration = %d/%d\n',i,2*length(limit));
end

plot(limit,scores,limit,scores2)