clear all 
close all

%-------------------------------------------------------------------------
%% Start Simulation 

%Previouse Vehicle Property file with alot more data points, not
%specifically used in the lap sim file name:  
% vehichle_properties; 

%% TO DO

% Add Variable for Driver skill 

% Make RPM locater function flexible to iteration direction (10000-0 or
% 0-10000)

%Add Sensitivity output for Variables 

%Add Shifting times

%%  Select Vehicle 

%MUR2016
%vehicle_properties_2016;
vehicle_properties_2016_525Stock;
%vehicle_properties_2016_690Duke;
%vehicle_properties_Electric2017;


%% Select Track/ Competition 

%FSAE-A - 2016
%load('autocross_FS_Cali');
%TRACKdef = loadTrackData('Data-from-2016-Track2');

competition_properties_2016_FSAE_AUS;
%competition_properties_cali;


%% Select Variable to Iterate Through 
% Var = 0 for no iteration
% Var = 1 for CL
% Var = 2 for Cd
% Var = 3 for Mass
% Var = 4 for Power
% Var = 5 for Track Width       
% Var = 6 for COG Height
% Var = 7 for Torque
% Var = 8 for Shifting RPM 
% Var = 9 for shifting wheelbase

Var = 9;

%% Iteration Properties for Selected Variable 
%% CL
if Var == 1
    
    Number_of_Iterations = 6;
    Amount_Deviated_Below_Data = 0.8;
    Amount_Deviated_Above_Data = 0.5;
    
end

%% CD
if Var == 2
    
    Number_of_Iterations = 6;
    Amount_Deviated_Below_Data = 0.5;
    Amount_Deviated_Above_Data = 0.5;

end

%% Mass
if Var == 3
    
    Number_of_Iterations = 5;
    Amount_Deviated_Below_Data = 20;
    Amount_Deviated_Above_Data = 20;
    
end

%% Power
if Var == 4
    
    Number_of_Iterations = 5;
    Amount_Deviated_Below_Data = 0;
    Amount_Deviated_Above_Data = 15;
    
end 

%% Track Width
if Var == 5
    
    Number_of_Iterations = 3;
    Amount_Deviated_Below_Data = 0;
    Amount_Deviated_Above_Data = 0.2;
    
    % Racing Line Reengineering
    course_width = 3.5;
    original_track = 1.06;
    scale_aero = 1.0;
    track_offset=0;
   
    % Add scaling factor for Mass increase, Cl Increase and CD increase 
end 

%% COG Height
if Var == 6
    
    Number_of_Iterations = 20;
    Amount_Deviated_Below_Data = 0.1;
    Amount_Deviated_Above_Data = 0.05;
    
end 

%% Torque
if Var == 7
    
    Number_of_Iterations = 15;
    Amount_Deviated_Below_Data = 0;
    Amount_Deviated_Above_Data = 10;
    
end 

%% Shifting RPM 
if Var == 8
    
    Number_of_Iterations = 3;
    Amount_Deviated_Below_Data = 120;
    Amount_Deviated_Above_Data = 0;
    
end
%% Shifting Wheelbase 
if Var == 9
    
    Number_of_Iterations = 3;
    Amount_Deviated_Below_Data = 0.5;
    Amount_Deviated_Above_Data = 0.5;
    
end
%% No iteration
if Var == 0
    fprintf('Selected car: %s\n', car.name);
    [Score,Time] = competitionScores(car,competition);
    fprintf('Dynamic score = %2.10f\n',Score.total);
    fprintf('AutoX Time = %2.10f\n',Time.AutoX);
    fprintf('Accel Time = %2.10f\n',Time.Accel);
end

%% Iterate CL

if Var == 1
Lower_Iteration_Bound = car.CL_IterateValue-Amount_Deviated_Below_Data;
Upper_Iteration_Bound = car.CL_IterateValue+Amount_Deviated_Above_Data;

IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
    car.CL_IterateValue = IterateValue(k);
    
    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    IterateValue(k) = car.CL_IterateValue;
    
end

plot(IterateValue, scores)
xlabel('Cl');
ylabel('Dynamic Score Total (w/o EFF)');
end 

%% Iterate CD

if Var == 2
Lower_Iteration_Bound = car.CD_IterateValue-Amount_Deviated_Below_Data;
Upper_Iteration_Bound = car.CD_IterateValue+Amount_Deviated_Above_Data;

IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);

Timer = 0;


for k = 1:Number_of_Iterations
   
   car.CD_IterateValue = IterateValue(k);
    
    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    IterateValue(k) = car.CD_IterateValue;
end

plot(IterateValue, scores)
xlabel('Cd');
ylabel('Dynamic Score Total (w/o EFF)');

end 

%% Iterate Mass

if Var == 3
Lower_Iteration_Bound = car.mass.Iterate-Amount_Deviated_Below_Data;
Upper_Iteration_Bound = car.mass.Iterate+Amount_Deviated_Above_Data;

IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
   
   car.mass.Iterate = IterateValue(k);
    
    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    IterateValue(k) = car.mass.Iterate;
end

plot(IterateValue, scores)
xlabel('Mass (Kg)');
ylabel('Dynamic Score Total (w/o EFF)');
end 

%% Iterate POWER (kW)

if Var == 4

Deviation = linspace(-Amount_Deviated_Below_Data, Amount_Deviated_Above_Data, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
    
    car.power = car.power + Deviation(k);
    car.torque = car.power./(car.RPM*2.*3.141592./(60*1000));

    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    
    IterateValue(k) = max(car.power);
end

plot(IterateValue, scores)
xlabel('Maximum Engine Power (kW)');
ylabel('Dynamic Score Total (w/o EFF)');
end 


%% Iterate Track Width 

if Var == 5

scale_mass = car.mass.aero/car.track.average;
scale_farea = car.farea_WithAero/car.track.average;    
fprintf('\nChosen Iteration Parameter: Track Width\n');
fprintf('-----------------------------------------------------------\n\n');
Lower_Iteration_Bound = car.track.average-Amount_Deviated_Below_Data;
Upper_Iteration_Bound = car.track.average+Amount_Deviated_Above_Data;

IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);

Timer = 0;
competition.trackDataOriginal = competition.trackData;

for k = 1:Number_of_Iterations
   
%    % Reset track data
%    load('autocross_FS_Cali');
   
   % Iterate trackF
   car.track.average = IterateValue(k);
   car.track.front = car.track.average+track_offset/2;
   car.track.rear = car.track.average-track_offset/2;
   
   % Correct track data for new car width
   car.width=car.track.average+car.tyre.width+track_offset/2;
   competition.trackData = track_change(competition.trackDataOriginal, course_width, car.width, original_track);
   
   % Update mass and frontal area
   car.mass.aero = scale_mass*car.track.rear;
   car.farea_WithAero = scale_farea * car.track.average;
   car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
   car.mass.Iterate = car.mass.total;
   
   % Compute New Lift and Drag Coefficients (comment out unused methods)
   
   % Equation 1: Track in mm
   % CLA = 0.009250000000000001*car.track.average - 7.155000000000001;
   
   % Equation 2: Track in m
   % CLA = (9.250000000000001*(car.track.average)) - 7.155000000000001;
   
   % Equation 3: Track in m, use of scale factor on gradient
   scale_correct = 1.37*scale_aero-0.37;
   CLA = (9.250000000000001*(car.track.average)*scale_aero) - 7.155000000000001*scale_correct;
   
   car.CL_FullAero = CLA/car.farea_WithAero;
   car.CL_Tray = car.CL_FullAero/2;
   car.CD_NoAero = 0.8 + (0.4/(2.3^2)).*car.CL_NoAero;
   car.CD_Tray = 0.8 + (0.4/(2.3^2)).*car.CL_Tray;
   car.CD_FullAero = 0.8 + (0.4/(2.3^2)).*car.CL_FullAero;
   
   car.CL_IterateValue = car.CL_FullAero;
   car.CD_IterateValue = car.CD_FullAero;
     
    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    IterateValue(k) = car.track.average;
    
end

% Find maximum dynamic score with corresponding track, offset and CLA
[max_score, max_index] = max(scores);
CLA_opt= (9.250000000000001*(IterateValue(max_index)) - 7.155000000000001)* scale_aero;
fprintf('\nMaximum Dynamic score of %2.0f points \n', max_score);
fprintf('Average track of %2.3f, offset by %2.0fmm, at a CLA of %2.2f\n\n', IterateValue(max_index), track_offset*1000, CLA_opt);

plot(IterateValue, scores)
xlabel('Track Width (m)');
ylabel('Dynamic Score Total (w/o EFF)');

end 

%% Iterate COG Height

if Var == 6
Lower_Iteration_Bound = car.COG_height-Amount_Deviated_Below_Data;
Upper_Iteration_Bound = car.COG_height+Amount_Deviated_Above_Data;

IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
   
   car.COG_height = IterateValue(k);
    
    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    IterateValue(k) = car.COG_height;
    
end

plot(IterateValue, scores)
xlabel('COG Height (m)');
ylabel('Dynamic Score Total (w/o EFF)');

end 


%% Iterate Torque (Nm)

if Var == 7

Deviation = linspace(-Amount_Deviated_Below_Data, Amount_Deviated_Above_Data, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
    
    car.torque = car.torque + Deviation(k);

    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    
    IterateValue(k) = max(car.torque);
end

plot(IterateValue, scores)
xlabel('Maximum Engine torque (Nm)');
ylabel('Dynamic Score Total (w/o EFF)');
end  
%% Iterate Shifting RPM

if Var == 8

Deviation = linspace(-Amount_Deviated_Below_Data, Amount_Deviated_Above_Data, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
    
    car.shift_RPM = car.shift_RPM + Deviation(k);

    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    
    IterateValue(k) = car.shift_RPM;
end

plot(IterateValue, scores)
xlabel('Shifting RPM');
ylabel('Dynamic Score Total (w/o EFF)');
end 

%% Iterate Shifting wheelbase

if Var == 9

Deviation = linspace(-Amount_Deviated_Below_Data, Amount_Deviated_Above_Data, Number_of_Iterations);

Timer = 0;

for k = 1:Number_of_Iterations
    
    car.wheelbase = car.wheelbase + Deviation(k);

    fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
    tic
    [Score,Time] = competitionScores(car,competition);
    scores(k) = Score.total;
    toc;
    Timer = Timer + toc;
    Average_time = Timer/k;
    minutes = floor(Average_time*(Number_of_Iterations - k)/60);
    seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
    fprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
   
    
    IterateValue(k) = car.wheelbase;
end

plot(IterateValue, scores)
xlabel('Shifting RPM');
ylabel('Dynamic Score Total (w/o EFF)');
end 




%% Sensitivities

% if Var == 1
%     
%     
%     
% end 
% 
% if Var == 2
%     
% end
% 
% if Var == 3
%     
% end
% 
% if Var == 4
%     
% end
% 
% if Var == 5
%     
% end
% 
% if Var == 6
%     
% end
