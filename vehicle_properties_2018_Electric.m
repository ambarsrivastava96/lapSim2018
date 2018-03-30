%% Setup file with all vehicle properties of MUR2016

global g rho
g = 9.81;
rho = 1.225; %kg/m^3

%% General vehicle properties
car.name = 'Electric Car 2018';
car.electric = 1;
car.wheelbase = 1.575; % m

%% Wheel and tyres

car.rim_RM = 0.231267; %m
car.tyre.width = 0.240; %m

car.tyre.latMuScale = 1;
car.tyre.longMuScale = 1;

car.tyre.latMu = @ (Fz) car.tyre.latMuScale*(-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.3);
car.tyre.latMuSkid = @ (Fz) car.tyre.latMuScale*(-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038-0.9);

car.tyre.longMuRolling = @ (Fz) (-0.12117e-07.*Fz.^2 - 0.00025071.*Fz + 2.5038 - 0.8);
car.tyre.longMuLaunch = @ (Fz) abs((0.0199.*(-Fz./1000).^3 - 0.4821.*(-Fz./1000)^2 - 2.698.*(-Fz./1000) + 0.0058)./(-Fz./1000));
car.tyre.longMuBraking = @ (Fz) (-0.0229.*(Fz./1000).^3 + 0.8056.*(Fz./1000).^2 + 2.8459.*(Fz./1000) - 0.0065)/(Fz./1000);

car.tyre.rollingResistance = 0.03;

%% Vehicle Dimensions
car.wheelbase = 1.545; % m

car.track.front = 1.18; % m
car.track.rear = 1.18; % m

car.COG_height = 0.295; % metres

car.track.average = (car.track.rear+car.track.front)/2;
car.width = max([car.track.front, car.track.rear])+car.tyre.width;

%% Aero Properties
car.mass.aero = 25;
car.farea_Iterate = 1;

car.CL_NoAero = 0.000001;
car.CL_Undertray = 1.7*0.7; % 30% Performance loss from no FW and RW
car.CL_IterateValue = 3.62;

car.DRS = 0; % Change to 1 if car has DRS
car.CD_IterateValue = 1.34;
car.CD_DRS = 0.75;
% % Aero Testing Change Parameters
% car.DRS = 0;
% car.CL_IterateValue = 3.62;
% car.CD_IterateValue = 1.34;
% 
% car.mass.aero = 23; 
% car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
% car.mass.Iterate = car.mass.total;
% 
% car.COG_height = 0.3015;


%% Mass Properties

car.mass.driver = 80; % kg
car.mass.no_driver_no_aero = 235+20.6; % kg
car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
car.mass.Iterate = car.mass.total;

% car.mass.unsprung = 45;
% car.mass.sprung = car.mass.total - car.mass.unsprung;

%% Powertrain Porperties
%car.shift_RPM = 7500; 

% http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/specifications/24036/05/transmission.html
% http://www.ktmshop.se/documents/01863885eca922f3562b8fd432706a0b.pdf
% http://www.motorcyclespecs.co.za/model/ktm/ktm_525_mxc%2000.htm
car.shiftTime = 0.1; % Doesn't get used, but will error if not included
car.gear.R = [1];

car.gear.final = 3.45;
car.gear.primary = 1;

[torque_row,RPM_row] = EngineExcel2Vector('Emrax_208');
numberOfMotors = 2;
car.RPM = RPM_row;
car.torque = numberOfMotors*torque_row;
car.power = car.torque.*car.RPM.*2.*3.141592./(60*1000);
car.peak_power = max(car.power);
car.powerLimit = 80*10^3; %W
car.CO2conversionFactor = 0.65; % From Rules

car.diff = 4; % 1 = open, 2 = locked, 3 = LSD, 4 = Torque Vectoring
car.torqueSplit = 0.96; % If LSD, how much proportion of torque getting sent to outer wheel

car.drivetrain_efficiency = 0.9;
[car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
car.top_speed = findCarTopSpeed(car);

car.energyCapacity = 7.2*3600000;
