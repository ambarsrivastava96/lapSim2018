clear all
%Sensitivity test

vehicle_properties_Electric2017;
competition_properties_2016_FSAE_AUS;

[Score,Time] = competitionScores(car,competition);
baseScore = Score.total;
% 
% %CL
car.CL_IterateValue = car.CL_IterateValue+0.1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Cl increase (+0.1): %.3f\n', diff);
vehicle_properties_Electric2017;

% %CD
car.CD_IterateValue = car.CD_IterateValue-0.1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('CD decrease (-0.1): %.3f\n', diff);

car.CD_IterateValue = car.CD_IterateValue+0.1;

% %Mass
car.mass.Iterate = car.mass.Iterate-1;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Mass decrease (-1kg): %.3f\n', diff);

car.mass.Iterate = car.mass.Iterate+1;

% %Power
car.power = car.power + 1;
car.torque = car.power./(car.RPM*2.*3.141592./(60*1000));
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Power Increase (+1kW): %.3f\n', diff);

car.power = car.power - 1;
car.torque = car.power./(car.RPM*2.*3.141592./(60*1000));

% %COG Height
car.COG_height = car.COG_height-0.01;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('COG Decrease (-0.01m): %.3f\n', diff);

car.COG_height = car.COG_height+0.01;

vehicle_properties_2016_525Stock;
competition_properties_2016_FSAE_AUS;

%Shift Time
car.shiftTime = car.shiftTime-0.05;
[Score,Time] = competitionScores(car,competition);
NewScore = Score.total;
diff = NewScore - baseScore; 
fprintf('Shift Time decrease (-0.05s): %.3f\n', diff);

car.shiftTime = car.shiftTime+0.05;
