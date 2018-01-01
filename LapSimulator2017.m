%% Initiate GUI Stuff (DON'T TOUCH)
function varargout = LapSimulator2017(varargin)
% LAPSIMULATOR2017 MATLAB code for LapSimulator2017.fig
%      LAPSIMULATOR2017, by itself, creates a new LAPSIMULATOR2017 or raises the existing
%      singleton*.
%
%      H = LAPSIMULATOR2017 returns the handle to a new LAPSIMULATOR2017 or the handle to
%      the existing singleton*.
%
%      LAPSIMULATOR2017('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAPSIMULATOR2017.M with the given input arguments.
%
%      LAPSIMULATOR2017('Property','Value',...) creates a new LAPSIMULATOR2017 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LapSimulator2017_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LapSimulator2017_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LapSimulator2017

% Last Modified by GUIDE v2.5 04-Feb-2017 17:59:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LapSimulator2017_OpeningFcn, ...
                   'gui_OutputFcn',  @LapSimulator2017_OutputFcn, ...
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
end


% --- Executes just before LapSimulator2017 is made visible.
function LapSimulator2017_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LapSimulator2017 (see VARARGIN)

% Choose default command line output for LapSimulator2017
handles.output = hObject;

vehicle_properties_2016_525Stock;
handles.car = car;
axes(handles.carImage);
imshow('2016car.jpg');

competition_properties_2016_FSAE_AUS;
handles.competition = competition;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LapSimulator2017 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = LapSimulator2017_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% SELECTING CAR AND COMPETITION

% --- Executes on selection change in selectCar.
function selectCar_Callback(hObject, eventdata, handles)
% hObject    handle to selectCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectCar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectCar
contents = cellstr(get(hObject,'String'));
selectedCar = contents{get(hObject,'Value')};
if(strcmp(selectedCar, '2016 525 Stock'))
    vehicle_properties_2016_525Stock
    axes(handles.carImage);
    imshow('2016car.jpg')
elseif(strcmp(selectedCar, '2016 690 Duke'))
    vehicle_properties_2016_690Duke
    axes(handles.carImage);
    imshow('2016CAR690.jpg')
else
    vehicle_properties_2016_525Stock
end
handles.car = car;
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function selectCar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectCar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in selectCompetition.
function selectCompetition_Callback(hObject, eventdata, handles)
% hObject    handle to selectCompetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectCompetition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectCompetition

%Update when more competitions added
contents = cellstr(get(hObject,'String'));
selectedCar = contents{get(hObject,'Value')};
if(strcmp(selectedCar, '2016 FSAE-Australia'))
    competition_properties_2016_FSAE_AUS
elseif(strcmp(selectedCar, '2015 FSAE-Australia'))
    competition_properties_2016_FSAE_AUS 
else
    competition_properties_2016_FSAE_AUS
end
handles.competition = competition;
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function selectCompetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectCompetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%% CHOOSING ITERATE PARAMETER

% --- Executes on button press in noIteration.
function noIteration_Callback(hObject, eventdata, handles)
% hObject    handle to noIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noIteration
handles.selectedParameter = 0;
guidata(hObject,handles);
end

% --- Executes on button press in downforce.
function downforce_Callback(hObject, eventdata, handles)
% hObject    handle to downforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of downforce
handles.selectedParameter = 1;
handles.deviateBelowValue = 0.8;
handles.deviateAboveValue = 0.5;
handles.iterationsValue = 6;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in shiftTime.
function shiftTime_Callback(hObject, eventdata, handles)
% hObject    handle to shiftTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shiftTime
handles.selectedParameter = 8;
handles.deviateBelowValue = 0.1;
handles.deviateAboveValue = 0.1;
handles.iterationsValue = 6;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in mass.
function mass_Callback(hObject, eventdata, handles)
% hObject    handle to mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mass
handles.selectedParameter = 3;
handles.deviateBelowValue = 20;
handles.deviateAboveValue = 20;
handles.iterationsValue = 5;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in trackWidth.
function trackWidth_Callback(hObject, eventdata, handles)
% hObject    handle to trackWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trackWidth
handles.selectedParameter = 5;
guidata(hObject,handles);
end

% --- Executes on button press in torque.
function torque_Callback(hObject, eventdata, handles)
% hObject    handle to torque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of torque
handles.selectedParameter = 7;
handles.deviateBelowValue = 0;
handles.deviateAboveValue = 10;
handles.iterationsValue = 15;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in drag.
function drag_Callback(hObject, eventdata, handles)
% hObject    handle to drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drag
handles.selectedParameter = 2;
handles.deviateBelowValue = 0.5;
handles.deviateAboveValue = 0.5;
handles.iterationsValue = 6;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in power.
function power_Callback(hObject, eventdata, handles)
% hObject    handle to power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of power
handles.selectedParameter = 4;
handles.deviateBelowValue = 0;
handles.deviateAboveValue = 15;
handles.iterationsValue = 5;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes on button press in cogHeight.
function cogHeight_Callback(hObject, eventdata, handles)
% hObject    handle to cogHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cogHeight
handles.selectedParameter = 6;
handles.deviateBelowValue = 0.1;
handles.deviateAboveValue = 0.05;
handles.iterationsValue = 20;
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

%% SETTING ITERATION LIMITS

function deviateAbove_Callback(hObject, eventdata, handles)
% hObject    handle to deviateAbove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviateAbove as text
%        str2double(get(hObject,'String')) returns contents of deviateAbove as a double
handles.deviateAboveValue = str2double(get(hObject,'String'));
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function deviateAbove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviateAbove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function iterations_Callback(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations as text
%        str2double(get(hObject,'String')) returns contents of iterations as a double
handles.iterationsValue = str2double(get(hObject,'String'));
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function deviateBelow_Callback(hObject, eventdata, handles)
% hObject    handle to deviateBelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviateBelow as text
%        str2double(get(hObject,'String')) returns contents of deviateBelow as a double
handles.deviateBelowValue = str2double(get(hObject,'String'));
guidata(hObject,handles);
setIterateValues(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function deviateBelow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviateBelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%% RUN FUNCTION

% --- Executes on button press in runSim.
function runSim_Callback(hObject, eventdata, handles)
% hObject    handle to runSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.selectedParameter
    case 0 %No Iteration
        [Score,Time] = competitionScores(handles.car,handles.competition);
        updateResults(hObject,handles,Score,Time);
    case 1 %Cl 
        Lower_Iteration_Bound = handles.car.CL_IterateValue-handles.deviateBelowValue;
        Upper_Iteration_Bound = handles.car.CL_IterateValue+handles.deviateAboveValue;
        Number_of_Iterations = handles.iterationsValue;
        
        IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);
        
        Timer = 0;
        
        for k = 1:Number_of_Iterations
            handles.car.CL_IterateValue = IterateValue(k);
            
%             str = string(get(handles.statusWindow,'String')) + sprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
%             set(handles.statusWindow,'String', str);
%             drawnow
            fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
            tic
            [Score,Time] = competitionScores(handles.car,handles.competition);
            scores(k) = Score.total;
            toc;
            Timer = Timer + toc;
            Average_time = Timer/k;
            minutes = floor(Average_time*(Number_of_Iterations - k)/60);
            seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
%             str = string(get(handles.statusWindow,'String')) + sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
%             set(handles.statusWindow,'String', str);
%             drawnow
            sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
            IterateValue(k) = handles.car.CL_IterateValue;
            updateResults(hObject,handles,Score,Time);
        end
        axes(handles.scorePlot)
        plot(IterateValue, scores)
        xlabel('Cl');
        ylabel('Dynamic Score Total (w/o EFF)');
    case 2 %Cd
        Lower_Iteration_Bound = handles.car.CL_IterateValue-handles.deviateBelowValue;
        Upper_Iteration_Bound = handles.car.CL_IterateValue+handles.deviateAboveValue;
        Number_of_Iterations = handles.iterationsValue;
        
        IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);
        
        Timer = 0;
        
        for k = 1:Number_of_Iterations
            handles.car.CD_IterateValue = IterateValue(k);
            
%             str = string(get(handles.statusWindow,'String')) + sprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
%             set(handles.statusWindow,'String', str);
%             drawnow
            fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
            tic
            [Score,Time] = competitionScores(handles.car,handles.competition);
            scores(k) = Score.total;
            toc;
            Timer = Timer + toc;
            Average_time = Timer/k;
            minutes = floor(Average_time*(Number_of_Iterations - k)/60);
            seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
%             str = string(get(handles.statusWindow,'String')) + sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
%             set(handles.statusWindow,'String', str);
%             drawnow
            sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
            IterateValue(k) = handles.car.CD_IterateValue;
            updateResults(hObject,handles,Score,Time);
        end
        axes(handles.scorePlot)
        plot(IterateValue, scores)
        xlabel('Cd');
        ylabel('Dynamic Score Total (w/o EFF)');
    case 3 %Mass
         Lower_Iteration_Bound = handles.car.CL_IterateValue-handles.deviateBelowValue;
        Upper_Iteration_Bound = handles.car.CL_IterateValue+handles.deviateAboveValue;
        Number_of_Iterations = handles.iterationsValue;
        
        IterateValue = linspace(Lower_Iteration_Bound, Upper_Iteration_Bound, Number_of_Iterations);
        
        Timer = 0;
        
        for k = 1:Number_of_Iterations
            handles.car.mass.iterate = IterateValue(k);
            
%             str = string(get(handles.statusWindow,'String')) + sprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
%             set(handles.statusWindow,'String', str);
%             drawnow
            fprintf('Running Calculation %2.0f of %2.0f\n', k, Number_of_Iterations);
            tic
            [Score,Time] = competitionScores(handles.car,handles.competition);
            scores(k) = Score.total;
            toc;
            Timer = Timer + toc;
            Average_time = Timer/k;
            minutes = floor(Average_time*(Number_of_Iterations - k)/60);
            seconds = 60*(Average_time*(Number_of_Iterations - k)/60 - floor(Average_time*(Number_of_Iterations - k)/60));
%             str = string(get(handles.statusWindow,'String')) + sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
%             set(handles.statusWindow,'String', str);
%             drawnow
            sprintf('Expected remaining time is %02.0f:%02.0f [mm:ss]\n\n', minutes, seconds);
            IterateValue(k) = handles.car.mass.iterate;
            updateResults(hObject,handles,Score,Time);
        end
        axes(handles.scorePlot)
        plot(IterateValue, scores)
        xlabel('Mass (kg)');
        ylabel('Dynamic Score Total (w/o EFF)');
    case 4 %Power
        
    case 5 %Track Width 
        
    case 6 %COG Height
        
    case 7 %Torque
        
    case 8 %Shift Time
        
end        

% fprintf('Selected car: %s\n', handles.car.name);
% [Score,Time] = competitionScores(handles.car,handles.competition);
% fprintf('Dynamic score = %2.10f\n',Score.total);
% fprintf('AutoX Time = %2.10f\n',Time.AutoX);
% fprintf('Accel Time = %2.10f\n',Time.Accel);

end



%% STATUS WINDOW

function statusWindow_Callback(hObject, eventdata, handles)
% hObject    handle to statusWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of statusWindow as text
%        str2double(get(hObject,'String')) returns contents of statusWindow as a double
end

% --- Executes during object creation, after setting all properties.
function statusWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statusWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%% ADDITIONAL FUNCTIONS
function updateResults(h0bject,handles,Score,Time)
data = get(handles.resultsTable,'data');
data(1,1) = {Time.Accel}; 
data(2,1) = {Time.Skidpan}; 
data(3,1) = {Time.AutoX};
data(4,1) = {Time.Enduro};
data(1,2) = {Score.Accel};
data(2,2) = {Score.Skidpan}; 
data(3,2) = {Score.AutoX}; 
data(4,2) = {Score.Enduro}; 
data(5,2) = {Score.total};
set(handles.resultsTable,'data',data);
end

function setIterateValues(hObject, handles)
set(handles.deviateBelow,'Value', handles.deviateBelowValue);
set(handles.deviateBelow,'String', num2str(handles.deviateBelowValue));
drawnow
set(handles.deviateAbove,'Value', handles.deviateAboveValue);
set(handles.deviateAbove,'String', num2str(handles.deviateAboveValue));
drawnow
set(handles.iterations,'Value', handles.iterationsValue);
set(handles.iterations,'String', num2str(handles.iterationsValue));
drawnow
end
