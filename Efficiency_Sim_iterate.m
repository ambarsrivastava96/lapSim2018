function effScore = Efficiency_Sim_iterate(CO2conversionFactor, competition, enduroEnergy , enduroTime)
Tmin = competition.enduranceMin;
Tyours = enduroTime; 
Lapyours = competition.laps;
Laptotalmin = competition.laps;
LaptotalCO2min = competition.laps;

CO2min = competition.efficiency.CO2min;
CO2yours = enduroEnergy*CO2conversionFactor;
CO2yoursEffMin = 60.06*(competition.totalDistance/1000)/100; 
TyoursEffMin = 1.45*competition.enduranceMin;

effFactorYours = ((Tmin/Laptotalmin)/(Tyours/Lapyours))*((CO2min/LaptotalCO2min)/(CO2yours/Lapyours));
effFactorMin = ((Tmin/Laptotalmin)/(TyoursEffMin/Lapyours))*((CO2min/LaptotalCO2min)/(CO2yoursEffMin/Lapyours));
effFactorMax = ((Tmin/Laptotalmin)/(Tmin/Laptotalmin))*((CO2min/LaptotalCO2min)/(CO2min/LaptotalCO2min));

effScore = 100*((effFactorMin/effFactorYours)-1)/((effFactorMin/effFactorMax)-1);
end

