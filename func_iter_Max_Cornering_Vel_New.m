function [v_max] = func_iter_Max_Cornering_Vel_New(car, radius, grade)

g = 9.81; %m/s
rho = 1.225; %kg/m^3

Fz = car.mass.Iterate*g;
%---------------------------------------------------------
%Alter car.CL_IterateValue depending on Yaw angle prescribed by radius
% 
% Yaw_perf = func_iter_Yaw_perf(car, radius);
% CL = car.CL_IterateValue*Yaw_perf;

%---------------------------------------------------------

%Assume initial velocity
v = 5;
a_lat = v^2/(radius);

Fz_l = Fz/2;
Fz_r = Fz/2;

mu_left = car.tyre.latMu(Fz_l/2)*car.tyre.latMuScale;
mu_right = car.tyre.latMu(Fz_r/2)*car.tyre.latMuScale;

Fy = (mu_left*Fz_l + mu_right*Fz_r);
Fy_old = 10e6;

while (abs(Fy - Fy_old) > 0.001)
    
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v^2;
    
%     Load_transfer = (car.mass.Iterate)*a_lat*car.COG_height/car.track.average;
%     Fz_l = (Fz)/2 + Load_transfer + 0.5*DF;
%     Fz_r = (Fz)/2 - Load_transfer + 0.5*DF;
    
    Load_transfer_y_f = (car.mass.Iterate)*a_lat*car.COG_height/car.track.front; % Front Inside to Outside load transfer 
    Load_transfer_y_r = (car.mass.Iterate)*a_lat*car.COG_height/car.track.rear; % Rear Inside to Outside load transfer
    if Load_transfer_y_f+Load_transfer_y_r > Fz/2+DF/2
        Load_transfer_y_f = (Fz/2+DF/2)*(car.track.front/(car.track.front+car.track.rear));
        Load_transfer_y_r = (Fz/2+DF/2)*(car.track.rear/(car.track.front+car.track.rear));
    end
    % Calculate Wheel Loads
    Fz_f_i= 0.25*(Fz)*cosd(grade) - Load_transfer_y_f/2+ DF/4 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    Fz_r_i = 0.25*(Fz)*cosd(grade) - Load_transfer_y_r/2+ DF/4 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    
    Fz_f_o = 0.25*(Fz)*cosd(grade) + Load_transfer_y_f/2 + DF/4 - (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    Fz_r_o = 0.25*(Fz)*cosd(grade) + Load_transfer_y_r/2+ DF/4 + (car.mass.Iterate)*(car.COG_height/car.wheelbase)*g*sind(grade);
    
    % Lift Inner rear wheel if locked diff
    if car.diff == 2 || car.torqueSplit == 1
        Fz_r_o = Fz_r_o + Fz_r_i;
        Fz_r_i = 0;
    end

    % Calculate Amount of Tractive Force required for constant velocity
    Fx_resist = car.tyre.rollingResistance*(Fz_f_i + Fz_f_o + Fz_r_i + Fz_r_o);
    Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v^2;
    Fx_req = (car.mass.Iterate)*g*sind(grade)+Fx_resist+Drag;
    
    % Different rear tyre force distributions for different diff types
    switch car.diff
        case 1 % Open diff
            Fx_r_i = Fx_req/2;
            Fx_r_o = Fx_req/2; 
        case 2 % Locked diff
            Fx_r_i = 0;
            Fx_r_o = Fx_req; 
        case 3 % LSD
            Fx_r_i = (1-car.torqueSplit)*Fx_req;
            Fx_r_o = car.torqueSplit*Fx_req; 
        case 4 % Torque Vectoring
            outterLoadDistribution = (Fz_r_o/(Fz_r_o+Fz_r_i));
            Fx_r_i = (1-outterLoadDistribution)*Fx_req;
            Fx_r_o = outterLoadDistribution*Fx_req; 
    end
    
    testFz = 1000;
    lastTestFz = 0;
    Fz_r_i_long = Fx_r_i/(car.tyre.longMuRolling(testFz)*car.tyre.longMuScale);
    while abs(testFz-Fz_r_i_long)>0.01
        delta = abs(testFz-lastTestFz)/2;
        lastTestFz = testFz; 
        if testFz > Fz_r_i_long
            testFz = testFz-delta;
        else
            testFz = testFz+delta;
        end
        Fz_r_i_long = Fx_r_i/(car.tyre.longMuRolling(testFz)*car.tyre.longMuScale);
    end
    
    testFz = 1000;
    lastTestFz = 0;
    Fz_r_o_long = Fx_r_o/(car.tyre.longMuRolling(testFz)*car.tyre.longMuScale);
    while abs(testFz-Fz_r_o_long)>0.01
        delta = abs(testFz-lastTestFz)/2;
        lastTestFz = testFz; 
        if testFz > Fz_r_o_long
            testFz = testFz-delta;
        else
            testFz = testFz+delta;
        end
        Fz_r_o_long = Fx_r_o/(car.tyre.longMuRolling(testFz)*car.tyre.longMuScale);
    end
    
    Fz_r_i_lat = Fz_r_i - Fz_r_i_long;
    Fz_r_o_lat = Fz_r_o - Fz_r_o_long;
    
    Fy_r_i = Fz_r_i_lat*car.tyre.latMu(Fz_r_i_lat)*car.tyre.latMuScale;
    Fy_r_o = Fz_r_o_lat*car.tyre.latMu(Fz_r_o_lat)*car.tyre.latMuScale;
    Fy_f_i = Fz_f_i*car.tyre.latMu(Fz_r_o_lat)*car.tyre.latMuScale;
    Fy_f_o = Fz_f_o*car.tyre.latMu(Fz_r_o_lat)*car.tyre.latMuScale;
    
    Fy_old = Fy;
    Fy = Fy_r_i + Fy_r_o + Fy_f_i + Fy_f_o;
    
    a_lat = Fy/(car.mass.Iterate);
    
    %Lateral acceleration limited by load transfer
    if (abs(a_lat) > (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate))))
        
        a_lat = (car.track.average*((Fz)/2 + 0.5*DF)/(car.COG_height*(car.mass.Iterate)));
%         disp('Roll');
%     else
%         disp('hi');
    end
    
    v = (radius*a_lat)^0.5;
    
    if (v > car.top_speed)
        
        v = car.top_speed;
        check = 1;
    end
    
    if (v > car.top_speed && check == 1)
        
        v = car.top_speed - 0.01;
        break;
    end
end

v_max = v;
end