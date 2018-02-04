function [Score,Time,Energy] = competitionScores(car,competition)
    dt = 0.001;
    [Score.AutoX, Time.AutoX, Energy.AutoX_Used, Energy.AutoX_recovered] = AutoX_Sim_New(car,competition);

    [Time.Accel, ~] = func_iter_Accel_time(car, 0, 0.001, 75, dt);
    
    Tmin = competition.accelMin;
    Tmax = Tmin*1.5;
    Score.Accel = (95.5*((Tmax/Time.Accel) -1)/ ((Tmax/Tmin) - 1)) + 4.5;
    
    if Score.Accel<4.5
        Score.Accel = 4.5;
    end

    if (Score.Accel > 75)
        Score.Accel = 75;
    end
    
    [Score.Enduro, Time.Enduro, Energy.Enduro_Used, Energy.Enduro_recovered] = Enduro_Sim_iterate(car,Time.AutoX,competition, Energy.AutoX_Used, Energy.AutoX_recovered);
%     Score.Efficiency = Efficiency_Sim_iterate(car.CO2conversionFactor, competition, Energy.AutoX_used, Time.Enduro);
    [Score.Skidpan, Time.Skidpan] = SkidPad_Sim_iterate(car, competition);
    Score.total = Score.AutoX + Score.Accel + Score.Enduro + Score.Skidpan; 
end

