% Cell test 

competition_properties_2016_FSAE_AUS;
vehicle_properties_Electric2017;

FDR = 2:0.5:6;
cells = [96 120 128];
cellMass = (cells-96)*0.5;
cellEnergy = [7.2 7.5 8.1];

for c = 1:length(cells)
    car.mass.Iterate = car.mass.Iterate+cellMass(c);
    car.energyCapacity = cellEnergy(c)*3600000;
    for i = 1:length(FDR)
        car.gear.final = FDR(i);
        [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
        [ScoresE, timesE] = competitionScores(car,competition);
        if ScoresE.Enduro == 0
            plot(FDR(i),ScoresE.total,'r*')
            hold on
        else 
            plot(FDR(i),ScoresE.total,'b*')
            hold on
        end
    end
end

