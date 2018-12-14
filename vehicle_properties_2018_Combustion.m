clear car
%% Setup file with all vehicle properties of MUR2017

global g rho 
g = 9.81;
rho = 1.225; %kg/m^3
%% General Properties
car.name = 'MUR 2018C';
car.electric = 0;

%% Wheel and Tyre Properties
car.rim_RM = 0.231267; %m
car.tyre.width = 0.240; %m

car.tyre.latMuScale = 1;
car.tyre.longMuScale = 1;

car.tyre.latMu = @ (Fz) (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.3);
car.tyre.latMuSkid = @ (Fz) (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.9);

car.tyre.longMuRolling = @ (Fz) (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038 - 0.8);
car.tyre.longMuLaunch = @ (Fz) abs((0.0199.*(-Fz./1000).^3 - 0.4821.*(-Fz./1000)^2 - 2.698.*(-Fz./1000) + 0.0058)./(-Fz./1000));
car.tyre.longMuBraking = @ (Fz) (-0.0229.*(Fz./1000).^3 + 0.8056.*(Fz./1000).^2 + 2.8459.*(Fz./1000) - 0.0065)/(Fz./1000);

car.tyre.rollingResistance = 0.03;

%% Vehicle Dimensions
car.wheelbase = 1.545; % m

car.track.front = 1.18; % m
car.track.rear = 1.18; % m

car.COG_height = 0.27; % metres

car.track.average = (car.track.rear+car.track.front)/2;
car.width = max([car.track.front, car.track.rear])+car.tyre.width;

%% Aero Properties
car.mass.aero = 8.15+5+8; % UT + FW + RW

% car.farea_unsprung = 1.3;  % acting frontal area
% car.farea_sprung = 1.06;
% car.farea_WithAero = 1.16;
% car.farea_NoAero = 0.8;
car.farea_Iterate = 1;

% car.CL_NoAero = 0.000001;
% car.CL_Tray = 2.365/2;
% car.CL_FullAero = 2.365;
car.CL_IterateValue = 2.95; %2.95

% car.CD_NoAero = 0.8 + (0.4/(2.3^2)).*car.CL_NoAero;
% car.CD_Tray = 0.8 + (0.4/(2.3^2)).*car.CL_Tray;
% car.CD_FullAero = 0.8 + (0.4/(2.3^2)).*car.CL_FullAero;
car.DRS = 1; % Change to 1 if car has DRS
car.CD_IterateValue =1.5;% 1.5;
car.CD_DRS = car.CD_IterateValue*0.6;

% % Aero Testing Change Parameters
% car.DRS = 0;
% car.CL_IterateValue = 1.85;
% car.CD_IterateValue = 0.75;
% 
% car.mass.aero = 6; 
% car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
% car.mass.Iterate = car.mass.total;
% 
% car.COG_height = 0.292;


%% Mass Properties
car.mass.driver = 80; % kg
car.mass.no_driver_no_aero = 212-car.mass.aero; % kg - Measured 212kg with aero 3/12/18
car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
car.mass.Iterate = car.mass.total;

% car.mass.unsprung = 45;
% car.mass.sprung = car.mass.total - car.mass.unsprung;


%% Powertrain Properties
%car.shift_RPM = 7500; 

% http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/specifications/24036/05/transmission.html
% http://www.ktmshop.se/documents/01863885eca922f3562b8fd432706a0b.pdf
% http://www.motorcyclespecs.co.za/model/ktm/ktm_525_mxc%2000.htm
car.shiftTime = 0.12; % Time it takes to shift gears

car.diff = 2; % 1 = open, 2 = locked, 3 = LSD, 4 = Torque Vectoring
car.torqueSplit = 0.96; % If LSD, how much percent torque getting sent to outer wheel

car.gear.R = [34/14 31/17 28/19 26/22 23/24 21/26];
car.gear.final = 38/13;  
car.gear.primary = 76/33;

[car.torque,car.RPM] = EngineExcel2Vector('KTM_525_2018_BigBore'); 
car.torque = car.torque;
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

