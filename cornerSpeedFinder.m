clear all
% Finding Average Corner Speed

competition_properties_2017_C_FSAE_AUS;
vehicle_properties_2017_Combustion;

% competition_properties_2017_E_FSAE_AUS;
% vehicle_properties_2018_Electric;

[Score,Time,Energy,K] = competitionScores(car,competition);
area = 0;
area2 = 0;
t_sum = 0;

for i = 1:length(K.t)
    if(K.ay(i) ~= 0)
        dt = K.t(i)-K.t(i-1);
        radius = K.v(i)^2/K.ay(i);
        area = area + dt*K.v(i);
        area2 = area2 + dt*radius;
        t_sum = t_sum + K.t(i)-K.t(i-1);
    end
end

ave_corner_speed = area/t_sum;
ave_radius = area2/t_sum;

