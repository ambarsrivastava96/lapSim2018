%Aero Tester

vehicle_properties_2016_525Stock;
competition_properties_2016_FSAE_AUS

% %No Aero
% car.CL_IterateValue = car.CL_NoAero;
% car.CD_IterateValue = car.CD_NoAero;
% car.mass.Iterate = car.mass.total - car.mass.aero;
% 
% [scores, time] = competitionScores(car,competition);
% fprintf('Total score = %.4f\n', scores.total);
% 
% %Full aero
% car.CL_IterateValue = car.CL_FullAero; 
% car.CD_IterateValue = car.CD_FullAero;
% car.mass.Iterate = car.mass.total;
% 
% [scores, time] = competitionScores(car,competition);
% fprintf('Total score = %.4f\n', scores.total);
% 
% %Full aero
car.CL_IterateValue = car.CL_FullAero; 
car.CD_IterateValue = car.CD_FullAero;
car.mass.Iterate = car.mass.total;

[scores, time] = competitionScores(car,competition);
fprintf('No change: Total score = %.4f\n', scores.total);

car.CL_IterateValue = car.CL_IterateValue + 0.1;

[scores, time] = competitionScores(car,competition);
fprintf('CL increase: Total score = %.4f\n', scores.total);

car.CL_IterateValue = car.CL_IterateValue;
car.CD_IterateValue = car.CD_IterateValue - 0.1;

[scores, time] = competitionScores(car,competition);
fprintf('CD decrease: Total score = %.4f\n', scores.total);