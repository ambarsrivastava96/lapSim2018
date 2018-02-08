clear all
%Sensitivity test

vehicle_properties_2017_Combustion;
competition_properties_2017_C_FSAE_AUS;

[Score,Time] = competitionScores(car,competition);
baseScore = Score.total;
% 
% %CL
car.CL_IterateValue = car.CL_IterateValue+0.1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Cl increase (+0.1): %.3f\n', diff);
vehicle_properties_2017_Combustion;

% %CD
car.CD_IterateValue = car.CD_IterateValue-0.1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('CD decrease (-0.1): %.3f\n', diff);
vehicle_properties_2017_Combustion

% %Mass
car.mass.Iterate = car.mass.Iterate-1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Mass decrease (-1kg): %.3f\n', diff);
vehicle_properties_2017_Combustion;

% %Power
car.power = car.power + 1;
car.torque = car.power./(car.RPM*2.*3.141592./(60*1000));
[car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Power Increase (+1kW): %.3f\n', diff);
vehicle_properties_2017_Combustion;

% %COG Height
car.COG_height = car.COG_height-0.01;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('COG Decrease (-0.01m): %.3f\n', diff);
vehicle_properties_2017_Combustion;

%Shift Time
car.shiftTime = car.shiftTime-0.05;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Shift Time decrease (-0.05s): %.3f\n', diff);
vehicle_properties_2017_Combustion;
