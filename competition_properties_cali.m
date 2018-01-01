%% Setup file with all Competition properties of FSAE-A 2016

%% Track Data
load('autocross_FS_Cali');
competition.trackData = TRACKdef;

%% Scores
competition.autocrossMin = 61.463;
competition.enduranceMin = 1345.438; 
competition.accelMin = 3.816;
competition.skidMin = 4.974;