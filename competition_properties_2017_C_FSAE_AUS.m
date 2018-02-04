%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
competition.trackData = loadTrackData('2017_FSAEA_TRACK_DATA');
competition.trackDistance = sum(competition.trackData(:,1));
competition.laps = 20;
competition.totalDistance = competition.trackDistance*competition.laps;

%% Scores
competition.autocrossMin = 74.6;
competition.enduranceMin = 1515.2; 
competition.accelMin = 4.312;
competition.skidMin = 5.216;

%% Efficiency
% competition.efficiency.LapTotalCO2min = ;
% competition.efficiency.CO2min = ;