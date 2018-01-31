%% Setup file with all vehicle properties of MUR2016

global g rho 
g = 9.81;
rho = 1.225; %kg/m^3


%% General vehicle properties
car.name = 'Electric Car 2017';
car.electric = 1;
car.wheelbase = 1.864; % m

car.track.front = 1.22; % m
car.track.rear = 1.1; % m

car.COG_height = 0.318; % metres

car.track.average = (car.track.rear+car.track.front)/2;
car.tyre.width = .240; 
car.width = max([car.track.front, car.track.rear])+car.tyre.width;

car.mass.driver = 80; % kg
car.mass.no_driver_no_aero = 249; % kg
car.mass.aero = 0;
car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
car.mass.Iterate = car.mass.total;

car.mass.unsprung = 45;
car.mass.sprung = car.mass.total - car.mass.unsprung;

car.rim_RM = 0.231267;

%% Aero Properties
car.farea_Iterate = 0.7476;

car.CL_NoAero = 0.000001;
car.CL_Undertray = 1.7*0.7; % 30% Performance loss from no FW and RW
car.CL_IterateValue = car.CL_NoAero;

car.CD_DRS = 0.48; 
car.CD_IterateValue = car.CD_DRS;


%% Engine Porperties
%car.shift_RPM = 7500; 

% http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/specifications/24036/05/transmission.html
% http://www.ktmshop.se/documents/01863885eca922f3562b8fd432706a0b.pdf
% http://www.motorcyclespecs.co.za/model/ktm/ktm_525_mxc%2000.htm
car.shiftTime = 0.1;
car.gear.R = [1];

car.gear.final = 4.3;
car.gear.primary = 1;

[torque_row,RPM_row] = EngineExcel2Vector('Emrax_208');
numberOfMotors = 1;
car.RPM = RPM_row;
car.torque = numberOfMotors*torque_row;
car.power = car.torque.*car.RPM.*2.*3.141592./(60*1000);
car.peak_power = max(car.power);
car.powerLimit = 80*10^3; %W

car.drivetrain_efficiency = 1;
[car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
%car.top_speed = findCarTopSpeed(car);

car.energyCapacity = 7.2*3600000;

car.corneringVelocity = [];