function [Braking_dist, Braking_time, energyRecover] = func_iter_Braking_dist(car, grade, v_initial, v_final);


%Constants
g = 9.81; %m/s^2
rho = 1.225; %kg/m^3

v = v_initial;  
dt = 0.001;
x = 0;
t = 0;
a_x = 0;

while (v > v_final)
    
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v^2;
    D = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v^2;
    
    Load_transfer = (car.mass.Iterate)*abs(a_x)*car.COG_height/car.wheelbase;
    
    Fz_f = 0.5*(car.mass.Iterate)*g*cosd(grade) + Load_transfer + DF/2 - (car.mass.Iterate)*g*(car.COG_height/car.wheelbase)*sind(grade);
    Fz_r = 0.5*(car.mass.Iterate)*g*cosd(grade) - Load_transfer + DF/2 + (car.mass.Iterate)*g*(car.COG_height/car.wheelbase)*sind(grade);
    
    mu_front = func_Coeff_Friction_long_braking(Fz_f/2);
    mu_rear = func_Coeff_Friction_long_braking(Fz_r/2);
    
    Fric_front = -mu_front*Fz_f;
    Fric_rear = -mu_rear*Fz_r;
    
    sumF = Fric_front + Fric_rear - D - (car.mass.Iterate)*g*sind(grade);
        
    a_x = sumF/(car.mass.Iterate);
    
    %Longitundinal acceleration limited by load transfer
    if (abs(a_x) > (car.wheelbase*(0.5*(car.mass.Iterate)*g + DF/2)/(car.COG_height*(car.mass.Iterate))))
        
        a_x = -(car.wheelbase*(0.5*(car.mass.Iterate)*g + DF/2)/(car.COG_height*(car.mass.Iterate)));
        
    end
     
    v = v + a_x*dt;
    x = x + v*dt + 0.5*a_x*dt^2;
    t = t + dt;
    
end

Braking_dist = x;
Braking_time = t;

energyRecover = 0.5*car.mass.Iterate*(v_final^2-v_initial^2);

end


