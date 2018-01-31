%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
competition.trackData = loadTrackData('2016TrackDataVer2');
competition.laps = 18;

%% Scores
competition.autocrossMin = 75;
competition.enduranceMin = 78*competition.laps; 
competition.accelMin = 3.816;
competition.skidMin = 4.974;