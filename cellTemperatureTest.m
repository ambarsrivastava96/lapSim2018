% Cell Temp Test

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

powerLimit = 40E3:5E3:80E3;
deltaT = zeros(1,length(powerLimit));
lapTime = zeros(1,length(powerLimit));
packVoltage = 470;
nTubes = 7;
nBlocks = 110;
mTube = 46.6;
nLaps = 20; 

cellResist = 0.02; % ohm
cellSpecificHeat = 1.04; % J/g/K http://jes.ecsdl.org/content/146/3/947

for i = 1:length(powerLimit)
    car.powerLimit = powerLimit(i);
    [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition);
    current = (K.p./packVoltage)/(nTubes);
    Q_gen = current.^2*cellResist; 
    heatEnergy = trapz(K.t,Q_gen);
    tempIncrease = nLaps*heatEnergy/(mTube*cellSpecificHeat);
    deltaT(i) = tempIncrease;
    lapTime(i) = AutoX_time;
end

plot(powerLimit,deltaT,'-*');
xlabel('Power Limit (kW)')
ylabel('Temp Increase')
title('Temperature increase of cells at different power limits')

figure
plot(powerLimit,lapTime, '-*');
xlabel('Power Limit (kW)')
ylabel('Lap Time')
title('Affect of power limit on lap time')