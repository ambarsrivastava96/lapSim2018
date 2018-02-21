%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
competition.trackData = loadTrackData('2016TrackDataVer2.csv');
competition.trackDistance = sum(competition.trackData(:,1));
competition.laps = 18;
competition.totalDistance = competition.trackDistance*competition.laps;

%% Scores
competition.autocrossMin = 75;
competition.enduranceMin = 78*competition.laps; 
competition.accelMin = 3.816;
competition.skidMin = 4.974;

%% Efficiency
competition.electric = 0;
competition.efficiency.T_CO2min = 1641.0; % Wollongong
competition.efficiency.CO2min = 2.31*2.8; % Wollongong