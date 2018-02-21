%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
competition.trackData = loadTrackData('2017_FSAEA_TRACK_DATA.csv');
competition.trackDistance = sum(competition.trackData(:,1));
competition.laps = 20;
competition.totalDistance = competition.trackDistance*competition.laps;

%% Scores
competition.autocrossMin = 74.6;
competition.enduranceMin = 1515.2;
competition.accelMin = 4.312;
competition.skidMin = 5.216;

%% Efficiency
competition.electric = 0;
competition.efficiency.T_CO2min = 1641.0; % Wollongong
competition.efficiency.CO2min = 2.31*2.8; % Wollongong