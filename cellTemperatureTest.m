clear all
% Cell Temp Test

joulesToWh = 3600;

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;
dt = 0.001;

T_amb = 30;

powerLimit = 50E3; %40E3:5E3:80E3;
deltaT = zeros(1,length(powerLimit));
lapTime = zeros(1,length(powerLimit));
nTubes = 7;
nBlocks = 96;
maxV = 4.2;
packVoltage = nBlocks*maxV;
mTube = 0.0466; % kg
nLaps = competition.laps;

% Air Properties
V_housing = 0.450*0.235*0.147; % Volume of housing
r_cell = 0.009; % Radius
l_cell = 0.0652; % Length
V_cell = pi*r_cell^2*l_cell; % Volume of one cell
V_cells = nBlocks*nTubes*V_cell/2; % Volume of cells in one container
V_Relay = 1.433E5/1E9; % Volume of one relay

V_air = V_housing - V_cells - 3*V_Relay;
m_air = V_air*1.225; 
airSpecificHeat = 1000; % J/kg/K Constant Pressure

% Housing Properties
A_internalHousing = 2*2.777E4+4.259E4*4+9.866E4*2+3.482E4*2+6.47E4*2;
A_internalHousing = A_internalHousing/(1000^2); % Convert to m^2
% h_housing_freeConvection = 100; %W/m/K
h_housing_freeConvection = 10:20:110;


% Single Cell Discharge Curve @ 10A
VTC6voltage = [4.2 3.85 3.8 3.2 2.8 2.5]; %V
VTC6capacity = [0 0.075 0.15 2.3 2.876 3]; %Ah

cellResist = 0.02; % ohm
cellSpecificHeat = 960; % J/kg/K http://jes.ecsdl.org/content/146/3/947

A_cell = 1.6540e+04/(1000000);
A_totalCells = A_cell*nTubes*nBlocks/2;

figure
xlabel('Time (s)')
ylabel('Cell Temperature')
title('Cell temperatures over endurance')
hold on 

for i = 1:length(powerLimit)
    car.powerLimit = powerLimit(i);
    
    voltage = nBlocks*max(VTC6voltage);
    
    totalCapacity = max(VTC6capacity)*nTubes*nBlocks;
    totalEnergy = trapz(VTC6capacity, VTC6voltage)*nTubes*nBlocks*joulesToWh;
    capacity = totalCapacity; 
    energy = totalEnergy;
    [AutoX_Score, AutoX_time, AutoX_energy_used, AutoX_energy_recovered, K] = AutoX_Sim_New(car, competition);
    timeArray = zeros(1,competition.laps*length(K.t));
    powerArray = zeros(1,competition.laps*length(K.t));
    for j = 1:nLaps
        for k = 1:length(K.t)
            timeArray((j-1)*length(K.t)+k) = dt*((j-1)*length(K.t)+k);
            powerArray((j-1)*length(K.t)+k) = K.p(k);
        end
        
    end
    currentArray = zeros(1,length(timeArray(1,:)));
    voltageArray = zeros(1,length(timeArray(1,:)));
    
    for s = 1:length(timeArray(1,:))
        dE = dt*powerArray(1,s)/joulesToWh;
        energy = energy - dE; % New energy remaining
        capacity = capacity - dE/voltage; % Work out drop in capacity (assume old voltage still true)
        tubeCapacity = capacity/(nTubes*nBlocks);
        tubeCapacityDrop = max(VTC6capacity)-tubeCapacity;
        voltage = nBlocks*interp1(VTC6capacity, VTC6voltage, tubeCapacityDrop); % Work out new voltage
        voltageArray(1,s) = voltage; 
        currentArray(1,s) = powerArray(1,s)./voltage; % Work out current drawn
    end
    
    cellCurrentArray = currentArray/nTubes;
    Q_gen = cellCurrentArray.^2*cellResist; 
%     heatEnergy = trapz(timeArray,Q_gen);
%     tempIncrease = heatEnergy/(mTube*cellSpecificHeat);

    
    for j = 1:length(h_housing_freeConvection)
        T_cells = T_amb*ones(1,length(Q_gen(1,:)));
        T_air = T_amb*ones(1,length(Q_gen(1,:)));
        T_housing = T_amb*ones(1,length(Q_gen(1,:)));

        for q = 2:length(Q_gen)
            Q_cellsToAir = h_housing_freeConvection(j)*A_totalCells*(T_cells(q-1)-T_air(q-1));
            Q_airToHousing = h_housing_freeConvection(j)*A_internalHousing*(T_air(q-1)-T_housing(q-1));
            Q_cells = (Q_gen(q)*nBlocks*nTubes/2)-Q_cellsToAir-Q_airToHousing;

            T_air(q) = T_air(q-1) + (Q_cellsToAir-Q_airToHousing)*dt/(m_air*airSpecificHeat);
            T_cells(q) = T_cells(q-1) + Q_cells*dt/(cellSpecificHeat*mTube*nTubes*nBlocks/2);
        end

        deltaT(i) = max(T_cells);
        lapTime(i) = AutoX_time;
        plot(timeArray, T_cells)
%         fprintf('Power limit = %d',powerLimit(i))
    end
end

% figure
% plot(powerLimit,deltaT,'-*');
% xlabel('Power Limit (kW)')
% ylabel('Temp Increase')
% title('Temperature increase of cells at different power limits')
% 
% figure
% plot(powerLimit,lapTime, '-*');
% xlabel('Power Limit (kW)')
% ylabel('Lap Time')
% title('Affect of power limit on lap time')