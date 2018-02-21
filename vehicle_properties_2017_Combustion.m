%% Setup file with all vehicle properties of MUR2017

global g rho 
g = 9.81;
rho = 1.225; %kg/m^3


%% General vehicle properties
car.name = 'MUR 2017C';
car.electric = 0;
car.wheelbase = 1.575; % m

car.track.front = 1.17; % m
car.track.rear = 1.08; % m

car.COG_height = 0.3; % metres

car.track.average = (car.track.rear+car.track.front)/2;
car.tyre.width = .240; 
car.width = max([car.track.front, car.track.rear])+car.tyre.width;

car.mass.driver = 86; % kg
car.mass.no_driver_no_aero = 197; % kg
car.mass.aero = 23;
car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
car.mass.Iterate = car.mass.total;

car.mass.unsprung = 45;
car.mass.sprung = car.mass.total - car.mass.unsprung;

car.rim_RM = 0.231267;

%% Aero Properties
car.farea_unsprung = 1.3;  % acting frontal area
car.farea_sprung = 1.06;
car.farea_WithAero = 1.16;
car.farea_NoAero = 0.8;
car.farea_Iterate = 1;

car.CL_NoAero = 0.000001;
car.CL_Tray = 2.365/2;
car.CL_FullAero = 2.365;
car.CL_IterateValue = 3.62; %3.62

car.CD_NoAero = 0.8 + (0.4/(2.3^2)).*car.CL_NoAero;
car.CD_Tray = 0.8 + (0.4/(2.3^2)).*car.CL_Tray;
car.CD_FullAero = 0.8 + (0.4/(2.3^2)).*car.CL_FullAero;
car.DRS = 0; % Change to 1 if car has DRS
car.CD_IterateValue = 1.34;
car.CD_DRS = 0.75;


%% Engine Properties
%car.shift_RPM = 7500; 

% http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/specifications/24036/05/transmission.html
% http://www.ktmshop.se/documents/01863885eca922f3562b8fd432706a0b.pdf
% http://www.motorcyclespecs.co.za/model/ktm/ktm_525_mxc%2000.htm
car.shiftTime = 0.2;
car.gear.R = [34/14 31/17 28/19 26/22 23/24 21/26];

car.gear.final = 37/13; %Checked, and correct 
car.gear.primary = 76/33;

[torque_row,RPM_row] = EngineExcel2Vector('TorqueCurve_KTM_525_Stock_Dyno');
car.RPM = RPM_row;
car.torque = torque_row;
% car.torque = 1.1*car.torque; 
car.power = car.torque.*car.RPM.*2.*3.141592./(60*1000);
car.peak_power = max(car.power);
% car.top_speed = 42.1;
car.drivetrain_efficiency = 0.9;
car.powerLimit = inf;
[car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
car.top_speed = findCarTopSpeed(car);
car.energyCapacity = inf;
car.thermalEfficiency = 0.18;
car.CO2conversionFactor = 1.65*(1/7.125)*(1/car.thermalEfficiency); % 1.65 From Rules, convert to L, inefficency losses

car.corneringVelocity = [];