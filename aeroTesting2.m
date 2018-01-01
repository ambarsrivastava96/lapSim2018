%Aero Testing
competition_properties_2016_FSAE_AUS; %load competition
vehicle_properties_2016_525Stock; %load Car

%No Changes
[Score,Time] = competitionScores(car,competition);
fprintf('No Changes Full Aero: Dynamic score = %2.10f\n',Score.total);

%No aero
car.CL_IterateValue = 0.00001;
car.CD_IterateValue = 0.5;
car.mass.Iterate = car.mass.Iterate - 25;
[Score,Time] = competitionScores(car,competition);
fprintf('No Aero: Dynamic score = %2.10f\n',Score.total);

% Just Undertray
% vehicle_properties_2016_525Stock;

car.CL_IterateValue = 1.5;
car.CD_IterateValue = 0.5;
car.mass.Iterate = car.mass.Iterate +10;
[Score,Time] = competitionScores(car,competition);
fprintf('Just Undertray: Dynamic score = %2.10f\n',Score.total)

% Just Undertray
% vehicle_properties_2016_525Stock;
%%  Full aero
car.CL_IterateValue = 2.9;
car.CD_IterateValue = 1.2;
car.mass.Iterate = car.mass.Iterate +15;
[Score,Time] = competitionScores(car,competition);
fprintf('Full Aero Standard: Dynamic score = %2.10f\n',Score.total)

%  Full aero + 0.5 CLA
car.CL_IterateValue = 2.9+0.5;
car.CD_IterateValue = 1.2;
car.mass.Iterate = car.mass.Iterate ;
[Score,Time] = competitionScores(car,competition);
fprintf('Full aero + 0.5 CLA: Dynamic score = %2.10f\n',Score.total)

% Full aero + 0.5 CDA
car.CL_IterateValue = 2.9;
car.CD_IterateValue = 1.2+0.5;
car.mass.Iterate = car.mass.Iterate ;
[Score,Time] = competitionScores(car,competition);
fprintf('Full aero + 0.5 CLA: Dynamic score = %2.10f\n',Score.total)
