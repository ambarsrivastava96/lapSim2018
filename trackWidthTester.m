% Track Width Tester

competition_properties_2017_C_FSAE_AUS;
vehicle_properties_2017_Combustion;

[AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_New(car, competition);

car.track.average = car.track.average + 0.5;

competition.trackData=track_change(competition.trackData,3,car.track.average-0.5,car.track.average);

[AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered] = AutoX_Sim_New(car, competition);

