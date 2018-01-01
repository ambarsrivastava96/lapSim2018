function [shiftingRpm topSpeed FVG_matrix F_matrix V_matrix shiftV]= calcShiftRPM(car)

f = zeros(length(car.torque),length(car.gear.R));
v = zeros(length(car.torque),length(car.gear.R));

for i = 1:length(car.gear.R)
    f(:,i) = ((car.torque).*car.gear.R(i)*car.gear.primary*car.gear.final*car.drivetrain_efficiency/car.rim_RM);
    v(:,i) = (((((car.RPM).*2*pi())/60)/(car.gear.R(i)*car.gear.final*car.gear.primary))*car.rim_RM)';
end

if v(1,1)>v(end,1)
    f = flipud(f);
    v = flipud(v);
end
    
topSpeed = max(v(:,length(car.gear.R)));

for i = 1:length(car.gear.R)-1
    S = InterX([v(:,i)';f(:,i)'],[v(:,i+1)';f(:,i+1)']);
    shiftV(i) = S(1,end);
    shiftF(i) = S(2,end);
end

if length(car.gear.R)==1
    shiftV = [topSpeed];
    shiftF = [f(1,end)];
else
    shiftV = [shiftV topSpeed];
    shiftF = [shiftF f(1,end)];
end

for g = 1:length(car.gear.R)
    shiftingRpm(g) = shiftV(g)./((((2*3.141592)/60)/(car.gear.R(g)*car.gear.final*car.gear.primary))*car.rim_RM);
end

% hold on
% for i = 1:length(car.gear.R)
%     plot(v(:,i)',f(:,i)')
% end
% plot(shiftV,shiftF,'*')
% xlabel('Velocity')
% ylabel('Force')
% hold off


v_all = [];
g_all = [];
F_all = [];
RPM_all = [];
for g = 1:length(car.gear.R)
    for i = 1:length(v(:,g))
        if v(i,g)<=shiftV(g)
            if g == 1 || v(i,g)>max(v_all)
                v_all = [v_all v(i,g)];
                g_all = [g_all g];
                F_all = [F_all f(i,g)];
            end
        end
    end
end

% plot(v_all, F_all);
for i = 1:length(v_all)
    RPM_all(i) = v_all(i)*(60/(2*pi)).*car.gear.R(g_all(i))*car.gear.final*car.gear.primary/car.rim_RM;
end
FVG_matrix = [v_all;
            F_all;
            g_all;
            RPM_all];
F_matrix = f;
V_matrix = v;
end