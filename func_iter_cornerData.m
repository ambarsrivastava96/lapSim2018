function K_c = func_iter_cornerData(car, v_corner_max, corner_length, corner_radius, grade, dt, g, rho)
    t_corner = abs(corner_length)/v_corner_max;
    ay = v_corner_max^2/(corner_radius);
    
    Drag = 0.5*car.CD_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    DF = 0.5*car.CL_IterateValue*rho*car.farea_Iterate*v_corner_max^2;
    Fx_resist = car.tyre.rollingResistance*(car.mass.Iterate*g+DF);
    Force = Fx_resist + Drag + (car.mass.Iterate)*g*sind(grade);
    p_corner = Force*v_corner_max/car.drivetrain_efficiency;
    
    [~,  gear_no] = func_iter_RPM_locater(car, v_corner_max);
    
    K_c.t = 0:dt:t_corner;
    K_c.x = K_c.t*v_corner_max;
    K_c.v = v_corner_max*ones(1,length(K_c.t(1,:)));
    K_c.a = zeros(1,length(K_c.t(1,:)));
    K_c.ay = ay*ones(1,length(K_c.t(1,:)));
    K_c.p = p_corner*ones(1,length(K_c.t(1,:)));
    K_c.gear = gear_no*ones(1,length(K_c.t(1,:)));
   
    
end