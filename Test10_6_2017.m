clear all
% 10/6 Test file
competition_properties_2016_FSAE_AUS

vehicle_properties_Electric2017;
[ScoresE, timesE] = competitionScores(car,competition);

competition_properties_2016_FSAE_AUS;

vehicle_properties_2016_525Stock;
[ScoresC, timesC] = competitionScores(car,competition);