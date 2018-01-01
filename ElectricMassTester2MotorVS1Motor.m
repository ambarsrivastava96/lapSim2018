clear all
% Electric DualDrive VS Single Mass tester 

competition_properties_2016_FSAE_AUS;
vehicle_properties_Electric2017_dualDrive;

[Scores1, times1] = competitionScores(car,competition);

vehicle_properties_Electric2017;
[Scores2, times2] = competitionScores(car,competition);

delta = 0;
while Scores2.total<Scores1.total
    delta = delta+5;
    car.mass.Iterate = car.mass.Iterate - 5;
    [Scores2, times2] = competitionScores(car,competition);
    fprintf('Delta required = %d\n',delta);
end