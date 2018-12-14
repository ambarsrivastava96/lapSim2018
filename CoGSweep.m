% CoG Sweep

COG = 0.5:0.5:4;
vehicle_properties_2018_Combustion;
competition_properties_2017_C_FSAE_AUS;

n = length(COG);
scores = zeros(1,n); 

for i = 1:n
    car.COG_height = COG(i);
    [score,Time,Energy,K] = competitionScores(car,competition);
    scores(i) = score.total; 
end

plot(COG,scores);
