% Track Width Tester
startTrack = 0.6;
endTrack = 1.5;
increment = 0.05;
courseWidth = 3.46; % From 2017 Comp Map

track = startTrack:increment:endTrack;

% Pre Allocate Scoring Arrays
n = length(track);
total = zeros(1,n);
Accel = zeros(1,n);
Skidpan = zeros(1,n);
AutoX = zeros(1,n);
Enduro = zeros(1,n);
Efficiency = zeros(1,n);

% Load Initial Vehicle and Comp Properties
competition_properties_2017_C_FSAE_AUS;
vehicle_properties_2017_Combustion;
originalTrackData = competition.trackData;

% Aero Properties
CLA_2016 = 2.38;
CDA_2016 = 1.18;
trackAve_2016 = 1.06;

CLA_2017 = 3.62;
CDA_2017 = 1.34;
trackAve_2017 = 1.13;

CLA_grad = (CLA_2017-CLA_2016)/(trackAve_2017-trackAve_2016);
CLA_int = CLA_2017-CLA_grad*trackAve_2017;

CDA_grad = (CDA_2017-CDA_2016)/(trackAve_2017-trackAve_2016);
CDA_int = CDA_2017-CDA_grad*trackAve_2017;

CLA = @(tr) tr*CLA_grad+CLA_int;
CDA = @(tr) tr*CDA_grad+CDA_int;

% Mass Change
mass_grad = 50; % 5 kg per 100mm extra trackwidth
mass_int = car.mass.Iterate - mass_grad*car.track.average;
mass_estimate = @(tr) tr*mass_grad+mass_int;

% Start Iteration
for i = 1:n
    fprintf('Iteration %d out of %d\n',i,n);
    tr = track(i);
    
    %Change vehicle properties
    car.track.average = tr;
    car.mass.Iterate = mass_estimate(tr);
    car.CL_IterateValue = CLA(tr);
    car.CD_IterateValue = CDA(tr);
    
    %Change course properties
    competition.trackData = track_change(originalTrackData,courseWidth,tr,startTrack);
    
    [Score,Time,Energy,~] = competitionScores(car,competition);
    Accel(i) = Score.Accel;
    Skidpan(i) = Score.Skidpan;
    AutoX(i) = Score.AutoX;
    Enduro(i) = Score.Enduro;
    Efficiency(i) = Score.Efficiency;
    total(i) = Score.total;
end

plot(track,total,track,Accel,track,Skidpan,track,AutoX,track,Enduro,track,Efficiency);
legend('Total', 'Acceleration', 'Skidpan', 'Autocross', 'Endurance', 'Efficiency');
grid minor
xlabel('Track Width (m)')
ylabel('Dynamic Points')
title('Track width VS Competition Points')
