function varargout = LapSim2018(varargin)
% LAPSIM2018 MATLAB code for LapSim2018.fig
%      LAPSIM2018, by itself, creates a new LAPSIM2018 or raises the existing
%      singleton*.
%
%      H = LAPSIM2018 returns the handle to a new LAPSIM2018 or the handle to
%      the existing singleton*.
%
%      LAPSIM2018('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAPSIM2018.M with the given input arguments.
%
%      LAPSIM2018('Property','Value',...) creates a new LAPSIM2018 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LapSim2018_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LapSim2018_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LapSim2018

% Last Modified by GUIDE v2.5 09-Feb-2018 10:05:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LapSim2018_OpeningFcn, ...
                   'gui_OutputFcn',  @LapSim2018_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before LapSim2018 is made visible.
function LapSim2018_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LapSim2018 (see VARARGIN)

% Choose default command line output for LapSim2018
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes2)
matlabImage = imread('MUR_logo.png');
image(matlabImage)
axis off
axis image

% This sets up the initial plot - only do when we are invisible
% so window can get raised using LapSim2018.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes LapSim2018 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LapSim2018_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);

oldpointer = get(handles.figure1, 'pointer'); 
set(handles.figure1, 'pointer', 'watch') 
drawnow;
car = handles.car; 
competition= handles.competition; 
[Score,Time,Energy,K] = competitionScores(car,competition);
handles.K = K;
guidata(hObject,handles);
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(K.t,K.v)
        hold on
    case 2
        plot(K.t,K.x)
        hold on
    case 3
        plot(K.t,K.a)
        hold on
    case 4
        plot(K.t,K.p)
        hold on
end

data = [Time.Accel Score.Accel;
    Time.Skidpan Score.Skidpan;
    Time.AutoX Score.AutoX;
    Time.Enduro Score.Enduro;
    Time.CO2 Score.Efficiency;
    0 Score.total];
set(handles.uitable2,'Data',data);
set(handles.figure1, 'pointer', oldpointer)


% popup_sel_index = get(handles.popupmenu1, 'Value');
% switch popup_sel_index
%     case 1
%         plot(rand(5));
%     case 2
%         plot(sin(1:0.01:25.99));
%     case 3
%         bar(1:.5:10);
%     case 4
%         plot(membrane);
%     case 5
%         surf(peaks);
% end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
K = handles.K;
s = get(hObject,'Value');
switch s
        case 1
        plot(K.t,K.v)
        hold on
    case 2
        plot(K.t,K.x)
        hold on
    case 3
        plot(K.t,K.a)
        hold on
    case 4
        plot(K.t,K.p)
        hold on
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldpointer = get(handles.figure1, 'pointer'); 
set(handles.figure1, 'pointer', 'watch') 
drawnow;
clear car competition
handles.pushbutton2.Value = 0;
vehicle_properties_2018_Electric;
handles.car = car;
competition_properties_2017_E_FSAE_AUS;
handles.competition = competition; 
guidata(hObject,handles);

data = [car.mass.Iterate;
    car.COG_height;
    car.CL_IterateValue;
    car.CD_IterateValue;
    car.shiftTime;
    car.peak_power;
    max(car.torque);
    car.wheelbase;
    car.track.average;
    car.powerLimit; 
    car.gear.final;
    car.drivetrain_efficiency;
    ];
    
set(handles.uitable1,'Data',data);
set(handles.figure1, 'pointer', oldpointer)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton3.
function pushbutton3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldpointer = get(handles.figure1, 'pointer'); 
set(handles.figure1, 'pointer', 'watch') 
drawnow;
clear car competition
handles.pushbutton3.Value = 0;
vehicle_properties_2017_Combustion;
handles.car = car;
competition_properties_2017_C_FSAE_AUS;
handles.competition = competition; 
guidata(hObject,handles);

data = [car.mass.Iterate;
    car.COG_height;
    car.CL_IterateValue;
    car.CD_IterateValue;
    car.shiftTime;
    car.peak_power;
    max(car.torque);
    car.wheelbase;
    car.track.average;
    car.powerLimit; 
    car.gear.final;
    car.drivetrain_efficiency;
    ];
    
set(handles.uitable1,'Data',data);
set(handles.figure1, 'pointer', oldpointer)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
DRS = get(hObject,'Value');
car = handles.car;
car.DRS = DRS;
handles.car = car;
guidata(hObject,handles);




% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
car = handles.car;
row = eventdata.Indices(1);

switch row
    case 1
        car.mass.Iterate = eventdata.NewData;
    case 2
        car.COG_height = eventdata.NewData;
    case 3
        car.CL_IterateValue = eventdata.NewData;
    case 4
        car.CD_IterateValue = eventdata.NewData;
    case 5
        car.shiftTime = eventdata.NewData;
    case 6
        powerDiff = eventdata.NewData - car.peak_power;
        car.power = car.power + powerDiff;
        car.torque = car.power./(car.RPM*2.*3.141592./(60*1000));
        [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    case 7
        torqueDiff = eventdata.NewData - max(car.torque);
        car.torque = car.torque + torqueDiff;
        [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    case 8
        car.powerLimit = eventdata.NewData;
    case 9
        car.gear.final = eventdata.NewData;
        [car.shiftingRpm, car.top_speed, car.FVG_Matrix, car.F_matrix, car.V_matrix, car.shiftV] = calcShiftRPM(car);
    case 10 
        car.drivetrain_efficiency = eventdata.NewData; 
end
handles.car = car;
guidata(hObject,handles);
