%% Setup file with all vehicle properties

global g rho 
g = 9.81;
rho = 1.225; %kg/m^3


%% General vehicle properties

car.wheelbase = 1.545; % m

car.track.front = 1.06; % m
car.track.rear = 1.06; % m

car.COG_height = 0.305; % metres

%car.track.average = (car.track.rear+car.track.front)/2;
car.track.average = (1180+1060)/2000;

car.mass.driver = 70; % kg
car.mass.no_driver_no_aero = 180; % kg
car.mass.aero = 25;
car.mass.total = car.mass.no_driver_no_aero+car.mass.driver+car.mass.aero; % inc. driver
car.mass.Iterate = 275;

car.mass.unsprung = 45;
car.mass.sprung = car.mass.total - car.mass.unsprung;

% Mass percentage distribution in the x-axis
% car.mass_distribution.rear = 0.50; % Percentage of mass in rear half
% car.mass_distribution.front = 1 - car.mass_distribution.rear; % Percentage of mass in front half

% Tyre stiffness
% car.tire_rate = 100*(1000);    % N/m
car.rim_RM = 0.231267;

%% COG locations

% X axis

% a = distance from COG to front axle, b = distance from COG to rear axle
% [car.a, car.b] =  COG_location_x(car); % metres

% If there was a 40%:60% distrubution (Front:Rear). The COG is closer to 
% the rear axle, making b < a. 
% Therefore wheelbase*(1-distribution at axle) = distance from axle
% Distance from front axle to COG
% car.a = car.wheelbase*(1 - car.mass_distribution.front); % m

% Distance from rear axle to COG
% car.b = car.wheelbase*(1 - car.mass_distribution.rear); % m

% Z axis 
% car.COG_height = 0.305; % metres

% Y axis (lateral)
% car.y_offset = 0; % metres
% assuming symmetry, COG lies on centreline

%% Theoretical track width at COG (geometric)
    % Linear line connecting both track widths.
    % (y = m*x+c) m = gradient from front to rear, so negative.
    % x = a, front axle to COG. c = front track width
    
% car.track.at_cog = ...
%     (car.track.rear - car.track.front)*(car.a/car.wheelbase)...
%     +car.track.front;

%% Roll/Ride rate properties

% car.roll_axis_height.front = 0.0075;  % m
% car.roll_axis_height.rear = 0.0125;  % m
% height of RA above or below CoG
% car.roll_axis_height.cg = cg2rollaxis(car); % m

% desired ride travel (MIN is 0.058)
% car.ride_travel.front = 0.026;   % m
% car.ride_travel.rear = 0.026;    % m

%% Aero properties

% Centre of pressure properties
% car.COP_distribution.front = 0.6;
% car.COP_distribution.rear = 0.4;

% car.COP_distribution_sprung.front = 0.4;
% car.COP_distribution_sprung.rear = 0.6;

% car.COP_distribution_unsprung.front = 0.45;
% car.COP_distribution_unsprung.rear = 0.55;

% Centre of Lift * Area it acts on = downforce...or something. Need to ask
% Swindel/Aero

car.farea_unsprung = 1.3;  % acting frontal area
car.farea_sprung = 1.06;
car.farea_WithAero = 1.16;
car.farea_NoAero = 0.8;
car.farea_Iterate = 1.16;

% car.CL_sprung = 3;       % coefficient of lift
% car.CL_unsprung = 0;

car.CL_NoAero = 0.000001;
car.CL_Tray = 2.365/2;
car.CL_FullAero = 2.365;
car.CL_IterateValue = 2.3;

car.CD_NoAero = 0.8 + (0.4/(2.3^2)).*car.CL_NoAero;
car.CD_Tray = 0.8 + (0.4/(2.3^2)).*car.CL_Tray;
car.CD_FullAero = 0.8 + (0.4/(2.3^2)).*car.CL_FullAero;
car.CD_DRS = 0.85; %used for accel run 
car.CD_IterateValue = 1.1;

car.CPM = 1;        % pitching moment coefficient ???
car.CRM = 1;        % rolling moment coefficient ???

%% Dynamics Properties

% Polynomial coefficients [n, 0, 1, 2, 3, ... , n-2, n-1]
% Polynomial coefficients [2, a, b, c]
% y = a + bx + cx^2
% First input is n, the order of the polynomial
% Cf = 0 + 1*load  - 2*load^2 + 3*load^3 + ... + n-1*load^n-1

% EACH ROW IS A DIFFERENT TYRE
% Tyre 1: Hoosier - 18x7.5-10, 7" Rim Width
% Tyre 2: 13"
% Tyre 3: 2013 data
% Assume identical stiffness at all wheels

% car.tyre.cornering_stiffness = ...
%     [3, -5.2306, 0.8356, -0.0002, 1*10^(-8);... %[3, -(-5.2306), -0.8356, -(-0.0002), -1*10^(-8);
%     3, -31.253, 2.364, -0.0019, 4*10^(-7);...
%     3, -13.369,  1.5192, -0.0007, 1e-07]; % N/deg

% car.tyre.cornering_sensitivity, 
%Fy vs -Fz relationship for tyre

% car.tyre.cornering_sensitivity = ...
%      [3, -1.0459, 2.0814, -6*10^(-5), -5*10^(-8);...        
%      3, 71.6708, 1.5003, 0.0013, -7*10^(-7)]; % N/N

% car.tyre.fz_fx = [2, 200.55, 1.6103]; % Fx = 1.6103*Fz + 0.2005


%% Anti-Roll Bar Properties

% front_tire_stiff = 100000; % N/m
% rear_tire_stiff = 100000; % N/m

% front_arb_motion_ratio = 0.38;
% rear_arb_motion_ratio = 0.6;

% front_arb_arm_length = 97/1000; % m
% rear_arb_arm_length = 90/1000;

%% Engine Porperties
% car.peak_power = 53; %kw? 
car.shift_RPM = 12000; %rpm

%http://www.motorcyclistonline.com/2007/ktm/exc/525_racing/specifications/24036/05/transmission.html
car.gear.R1 = 34/13; %gear ratio? FIX THIS 
car.gear.R2 = 31/17;
car.gear.R3 = 28/19;
car.gear.R4 = 26/22;
car.gear.R5 = 23/24;
car.gear.R6 = 21/26;

car.gear.final = 37/12;
car.gear.primary = 76/33;


%this data is for the CBR
car.RPM =     [1, 500, 7245, 7457, 7664, 7875, 8078, 8287, 8474, ...
              8665, 8868, 9054, 9248, 9454, 9669, 9889, 10114, 10333, ...
              10540, 10759, 10966, 11162, 11371, 11562, 11759, 11950, ...
              12133, 12320, 12490, 12665, 12830, 12986, 13142, 13269, ...
              13354, 13410, 13442, 13455, 13460];
          
car.torque = [0.1, 2, 39.5333, 39.60709, 40.71343, 42.1148, ...
              42.1148, 41.30348, 40.49216, 39.60709, 39.45957, ...
              39.38582, 39.38582, 39.90211, 40.86094, 42.48358,... 
              43.14739, 43.73744, 43.9587, 43.66368, 42.99987, ...
              42.48358, 41.74602, 41.15597, 40.56592, 39.97587, ...
              39.23831, 38.27948, 37.32064, 36.14055, 35.25547, ...
              34.3704, 33.41157, 31.27264, 27.43731, 21.24179,  ...
              16.07885, 10.62089, 6.490547];
          
car.power = car.torque.*car.RPM;

car.top_speed = 33.33; %m/s (120km/h)

car.drivetrain_efficiency = 0.9;

%% Equations from 2014

%COG/RC heights
% car.front_RC_height=.02315;
% car.aft_RC_height=.03205;
% car.COG_total_height=.31;
% car.front_COG_unsprung_height=.26035;
% car.aft_COG_unsprung_height=.26035;
% car.COG_unsprung_height=(car.front_COG_unsprung_height+car.aft_COG_unsprung_height)/2;

%static corner weights
% car.weight_front_right=79.2000;
% car.weight_front_left=79.2000;
% car.weight_aft_right=85.8000;
% car.weight_aft_left=85.8000;

% car.weight_front=car.weight_front_right+car.weight_front_left;
% car.weight_aft=car.weight_aft_right+car.weight_aft_left;
% car.weight_left=car.weight_front_left+car.weight_aft_left;
% car.weight_right=car.weight_front_right+car.weight_aft_right;

% W_i=[car.weight_front_left car.weight_front_right;car.weight_aft_left car.weight_aft_right];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mass distribution
% car.mass_distribution = car.weight_aft/car.weight_total;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%COG location
% [a,b]=calculate_x_COG_position(car);
% car.a=a;                %front track to total COG location
% car.b=b;                %aft track to total COG location
% 
% [yf,ya]=calculate_y_COG_position(car);

%unsprung mass
% car.weight_unsprung_front=24;
% car.weight_unsprung_aft=30;
% car.weight_unsprung_total=car.weight_unsprung_front+car.weight_unsprung_aft;

%sprung mass
% car.weight_sprung_front=car.weight_front_right+car.weight_front_left-car.weight_unsprung_front;
% car.weight_sprung_aft=car.weight_aft_right+car.weight_aft_left-car.weight_unsprung_aft;
% car.weight_sprung_total=car.weight_sprung_front+car.weight_sprung_aft;

%sprung mass COG height
% car.COG_sprung_height=(car.COG_total_height*car.weight_total-car.COG_unsprung_height*car.weight_unsprung_total)/car.weight_sprung_total;

%roll centre at COG location
% car.COG_RC_height=car.front_RC_height+car.a*sind(atand((car.aft_RC_height-car.front_RC_height)/car.wheelbase));

%sprung mass COG roll moment arm (ASSUMPTION: sprung COG location is close
%to total COG location)
% car.sprung_roll_moment_arm=car.COG_sprung_height-car.COG_RC_height;

%aimed total and split roll rates
% car.RG=.55;                         %aimed roll gradient
% car.aft_stiffness_percentage=.55;                          %aft stiffness bias
% car.stiffness_roll_total=car.weight_sprung_total*g*car.sprung_roll_moment_arm/car.RG;       %total required roll stiffness

% car.stiffness_roll_front=car.stiffness_roll_total*(1-car.aft_stiffness_percentage);      %front required roll stiffness
% car.stiffness_roll_aft=car.stiffness_roll_total*car.aft_stiffness_percentage;          %aft required roll stiffness
% 
% car.stiffness_roll=[car.stiffness_roll_front;car.stiffness_roll_aft];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%downforce to the rear
% car.downforce_distribution = 0.55;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%pitch centre height
% car.dive_PC_height=.023;
% car.squat_PC_height=.023;

%pitch moment arm
% car.dive_pitch_moment_arm=car.COG_total_height-car.dive_PC_height;
% car.squat_pitch_moment_arm=car.COG_total_height-car.squat_PC_height;  