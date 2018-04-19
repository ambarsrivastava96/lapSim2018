%Power Limit vs Energy Used
clear all

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

powerLimit = 10E3:10E3:80E3; 
energy = zeros(1,length(powerLimit));

for i = 1:length(powerLimit)
    car.powerLimit = powerLimit(i);
    [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition);
    energy(i) = competition.laps*AutoX_energy_used;
end

plot(powerLimit, energy, '*-')
xlabel('Power Limit (W)')
ylabel('Energy Used (kWh)')