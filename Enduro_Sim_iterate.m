function [Enduro_Score, Enduro_time, Energy_used, Energy_recovered] = Enduro_Sim_iterate(car,AutoX_time,competition, AutoX_Used, AutoX_recovered);

%Calculate adjusted time for AutoX to Enduro to account for
%changes in course difficulty
% Number1_enduro = 1345.438/18.6168; 
% Number2_enduro = 1352.107/18.6168; 
% Number3_enduro = 1369.156/18.6168;
% 
% Number1_AX = 63.979;
% Number2_AX = 63.192;
% Number3_AX = 65.309;
% 
% Adjusted_1 = Number1_enduro - Number1_AX;
% Adjusted_2 = Number2_enduro - Number2_AX;
% Adjusted_3 = Number3_enduro - Number3_AX;
% 
% Average_adjusted = (Adjusted_1 + Adjusted_2 + Adjusted_3)/3;
% 
% AutoX_time_adjusted = AutoX_time + Average_adjusted;
% 
% AutoX_length = sum(competition.trackData(:,1));
% laps = 2*round(22*10^3/(AutoX_length*2));
joulesToKWh = 3600000;
Enduro_time = AutoX_time*competition.laps;
Energy_used = AutoX_Used*competition.laps/joulesToKWh;
Energy_recovered = AutoX_recovered*competition.laps/joulesToKWh;

%Score Calculation
Tmin = competition.enduranceMin;
Tmax = Tmin*1.45;
Tyour = Enduro_time;

Enduro_Score = 250*(((Tmax/Tyour) - 1)/((Tmax/Tmin) - 1)) + 25;

if (Enduro_Score > 300)
    Enduro_Score = 300;
end

if Enduro_Score < 25
    Enduro_Score = 25;
end

% if Energy_used > car.energyCapacity
%     Enduro_Score = 0;
% end

end