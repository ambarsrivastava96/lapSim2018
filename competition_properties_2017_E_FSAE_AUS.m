%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
competition.trackData = loadTrackData('2016TrackDataVer2');
competition.trackDistance = sum(competition.trackData(:,1));
competition.laps = 20;
competition.totalDistance = competition.trackDistance*competition.laps;

%% Scores
competition.autocrossMin = 75;
competition.enduranceMin = 1654.5; 
competition.accelMin = 4.231;
competition.skidMin = 5.306;

%% Efficiency
competition.efficiency.LapTotalCO2min = 1723.5;
competition.efficiency.CO2min = 4*0.65; % UTS Electric