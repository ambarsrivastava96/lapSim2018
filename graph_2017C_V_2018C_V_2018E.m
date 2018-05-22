% 2018 C vs 2018 E vs 2017 C
competition_properties_2017_C_FSAE_AUS;
vehicle_properties_2017_Combustion;

[Scores17,Time17,Energy17,K17] = competitionScores(car,competition);
clear car
vehicle_properties_2018_Combustion;
[Scores18C,Time18C,Energy18C,K18C] = competitionScores(car,competition);
clear car competition
competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;
[Scores18E,Time18E,Energy18E,K18E] = competitionScores(car,competition);

plot(K17.x,K17.v,K18C.x,K18C.v,K18E.x,K18E.v);
legend('MUR2017C','MUR2018C','MUR2018E');
title('Comparison of 2017 car to 2018 cars')
xlabel('Distance (m)')
ylabel('Velocity (m/s)')
grid on

