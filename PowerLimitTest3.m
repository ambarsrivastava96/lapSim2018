% Power Limit VS Lap time graph

competition_properties_2017_E_FSAE_AUS;
vehicle_properties_2018_Electric;

PL = 20E3:10E3:80E3;
n = length(PL);
times = zeros(1,n);

for i = 1:n
    car.powerLimit = PL(i);
    [~, times(n), ~, ~, ~] = AutoX_Sim_New(car, competition);
end

plot(times,PL);