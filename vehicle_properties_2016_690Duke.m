%% Setup file with all vehicle properties of MUR2016

global g rho 
g = 9.81;
rho = 1.225; %kg/m^3


%% General vehicle properties
car.name = 'MUR 2016 - 690 Duke';
car.wheelbase = 1.545; % m

car.track.front = 1.06; % m
car.track.rear = 1.06; % m

car.COG_height = 0.270; % metres

car.track.average = (car.track.rear+car.track.front)/2;
% car.track.average = (1180+1060)/2000;
car.tyre.width = .240; 
car.width = max([car.track.front, car.track.rear])+car.tyre.width;

car.mass.driver = 80; % kg
car.mass.no_driver_no_aero = 175 + 7; % kg + engine diff
car.mass.aero = 25;
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
car.farea_Iterate = 1.16;

car.CL_NoAero = 0.000001;
car.CL_Tray = 2.365/2;
car.CL_FullAero = 2.365;
car.CL_IterateValue = 2.9;

car.CD_NoAero = 0.8 + (0.4/(2.3^2)).*car.CL_NoAero;
car.CD_Tray = 0.8 + (0.4/(2.3^2)).*car.CL_Tray;
car.CD_FullAero = 0.8 + (0.4/(2.3^2)).*car.CL_FullAero;
car.CD_DRS = 0; %used for accel run 
car.CD_IterateValue = 1.1;


%% Engine Porperties
%car.shift_RPM = 6700; 
car.shiftTime = 0.1;
car.gear.R1 = 35/14; 
car.gear.R2 = 28/16;
car.gear.R3 = 28/21;
car.gear.R4 = 23/21;
car.gear.R5 = 22/23;
car.gear.R6 = 20/23;

car.gear.final = 37/12; %Checked, and correct 
car.gear.primary = 79/36;

% car.gear.R1 = 34/14; 
% car.gear.R2 = 31/17;
% car.gear.R3 = 28/19;
% car.gear.R4 = 26/22;
% car.gear.R5 = 23/24;
% car.gear.R6 = 21/26;
% 
% car.gear.final = 37/12; %Checked, and correct 
% car.gear.primary = 76/33;

[torque_row,RPM_row] = EngineExcel2Vector('KTM_690_Duke');
car.RPM = RPM_row;
car.torque = torque_row;
car.power = car.torque.*car.RPM.*2.*3.141592./(60*1000);
car.peak_power = max(car.power);

car.top_speed = 42.1;
% car.top_speed = 31.6; %m/s Based on lap sim calcs, need to make a function to make it spot on 
% car.top_speed = func_iter_Top_Speed(car)

car.drivetrain_efficiency = 0.9;
car.shiftingRpm = calcShiftRPM(car);
