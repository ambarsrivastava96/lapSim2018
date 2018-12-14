function [Enduro_Score, Enduro_time, Energy_used, Energy_recovered] = Enduro_Sim_iterate(car,AutoX_time,competition, AutoX_Used, AutoX_recovered);

%Calculate adjusted time for AutoX to Enduro to account for
%changes in enduro times 
if car.electric == 1
    Number1_enduro = 1654.5/20; 
    Number2_enduro = 1723.5/20; 
    Number3_enduro = 1783.4/20;
else
    Number1_enduro = 1515.2/20; 
    Number2_enduro = 1641/20; 
    Number3_enduro = 1667.2/20;
end

if car.electric == 1
    Number1_AX = 75;
    Number2_AX = 78.8;
    Number3_AX = 87.7;
else
    Number1_AX = 74.6;
    Number2_AX = 86.0;
    Number3_AX = 78.7;
end

Adjusted_1 = Number1_enduro - Number1_AX;
Adjusted_2 = Number2_enduro - Number2_AX;
Adjusted_3 = Number3_enduro - Number3_AX;

Average_adjusted = (Adjusted_1 + Adjusted_2 + Adjusted_3)/3;

AutoX_time_adjusted = AutoX_time + Average_adjusted;

Enduro_time = AutoX_time_adjusted*competition.laps;
Energy_used = AutoX_Used*competition.laps;
Energy_recovered = AutoX_recovered*competition.laps;

%Score Calculation
Tmin = competition.enduranceMin;
Tmax = Tmin*1.45;
Tyour = Enduro_time;

% if car.electric == 1
%     oldPowerLimit = car.powerLimit;
%     deltaPowerLimit = oldPowerLimit/2;
%     
%     while abs(AutoX_time*competition.laps-Tyour)>0.1
%         if AutoX_time*competition.laps > Tyour
%             car.powerLimit = car.powerLimit + deltaPowerLimit;
%         else 
%             car.powerLimit = car.powerLimit - deltaPowerLimit;
%         end
%         deltaPowerLimit = abs(car.powerLimit - oldPowerLimit)/2;
%         oldPowerLimit = car.powerLimit; 
%         [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition);
%         Energy_used = AutoX_energy_used*competition.laps;
%     end
%         
% end

Enduro_Score = 250*(((Tmax/Tyour) - 1)/((Tmax/Tmin) - 1)) + 25;

% if (Enduro_Score > 275)
%     Enduro_Score = 275;
% end

if Enduro_Score < 25
    Enduro_Score = 25;
end

% if Energy_used > car.energyCapacity
%     Enduro_Score = 0;
% end

end