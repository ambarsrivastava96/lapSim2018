function [Braking_dist, Braking_time, energyRecover, K] = func_iter_Braking_dist(car, grade, v_initial, v_final, dt);


%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3

v = v_initial;
V = [v];
x = 0;
X = [x];
t = 0;
T = [t];
a = 0;
A = [a];

while (v > v_final)
    
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v^2;
    D = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v^2;
    
    Load_transfer = (car.mass.Iterate)*abs(a)*car.COG_height/(car.wheelbase);
    
    Fz_f = 0.5*(car.mass.Iterate)*g*cosd(grade) + Load_transfer + DF/2 - (car.mass.Iterate)*g*(car.COG_height/car.wheelbase)*sind(grade);
    Fz_r = 0.5*(car.mass.Iterate)*g*cosd(grade) - Load_transfer + DF/2 + (car.mass.Iterate)*g*(car.COG_height/car.wheelbase)*sind(grade);
    
    mu_front = func_Coeff_Friction_long_braking(Fz_f/2);
    mu_rear = func_Coeff_Friction_long_braking(Fz_r/2);
    
    Fric_front = -mu_front*Fz_f;
    Fric_rear = -mu_rear*Fz_r;
    
    sumF = Fric_front + Fric_rear - D - (car.mass.Iterate)*g*sind(grade);
        
    a = sumF/(car.mass.Iterate);
    
    %Longitundinal acceleration limited by load transfer
    if (abs(a) > (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF/2)/(car.COG_height*(car.mass.Iterate))))
        
        a = -(car.wheelbase*(0.5*(car.mass.Iterate)*g + DF/2)/(car.COG_height*(car.mass.Iterate)));
        
    end
     
    v = v + a*dt;
    x = x + v*dt + 0.5*a*dt^2;
    t = t + dt;
    
    T = [T, t + dt];
    X = [X, x + v*dt + 0.5*a*dt^2];
    V = [V,  v + a*dt];
    A = [A, a];
end

Braking_dist = x;
Braking_time = t;

energyRecover = 0.5*car.mass.Iterate*(v_final^2-v_initial^2);

K.t = T;
K.x = X;
K.v = V;
K.a = A;
K.p = zeros(1,length(T));

end


