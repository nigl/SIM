function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 16-Dec-2015 16:36:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ButtonRand.
function ButtonRand_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonRand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.BoxDichteVStart,'String','A');
cellNum=str2double(get(handles.BoxLaengeAbschnitte, 'String'));
pLinger=str2double(get(handles.BoxTroedeln, 'String'));
vmax=str2double(get(handles.BoxMaxGeschwindigkeit, 'String'));
densityH=str2double(get(handles.BoxDichteH, 'String'));
densVStart=str2double(get(handles.BoxDichteVStart, 'String'));
densVEnde=str2double(get(handles.BoxDichteVEnde, 'String'));
densVWeite=str2double(get(handles.BoxDichteVWeite, 'String'));
densityV=densVStart:densVWeite:densVEnde;
timesteps=str2double(get(handles.BoxZeitschritte, 'String'));

set(handles.slider1, 'Value', 1);
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', numel(densityV));
set(handles.BoxFlowPoint, 'String', cellNum+1);

sims = cell(numel(densityV), 1);
for i  = 1:numel(densityV)
    %% basic data
    sim.timesteps = timesteps;
    sim.vmax = vmax;
    sim.pLinger = pLinger;
    sim.densityV = densityV(i);
    sim.densityH = densityH;
    
    %% horizontale straße
    [CellsH, ObstaclesH, crossingH] = init_street(cellNum, 1, densityH, vmax, timesteps);
    sim.CellsH = CellsH;
    sim.ObstaclesH = ObstaclesH;
    sim.crossingH = crossingH;
    
    %% vertikale straße
    [CellsV, ObstaclesV, crossingV] = init_street(cellNum, 1, densityV(i), vmax, timesteps);
    % Doppelbelegung der Kreuzung(en) verhindern
    if( CellsV(crossingV,1,1) ~= 0)
        CellsV(crossingV,1,1) = 0;
        CellsV(crossingV,1,2) = 0;
    end
    sim.CellsV = CellsV;
    sim.ObstaclesV = ObstaclesV;
    sim.crossingV = crossingV;
    
    % Anzahl der tatsaechlichen Autos
    sim.numCarsV = sum(sim.CellsV(:, 1, 2) ~= 0);
    sim.numCarsH = sum(sim.CellsH(:, 1, 2) ~= 0);
    sims{i} = sim;
end

handles.sims = sims;
handles.cellNum = cellNum;
guidata(hObject,handles);

idx = floor(get(handles.slider1, 'Value'));
sim = handles.sims{idx};
plotCars2(sim.CellsH(:,1,:), sim.CellsV(:,1,:), handles.cellNum, handles.PlotKreuz);






% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ButtonRand.
function ButtonRand_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ButtonRand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function BoxDichteVStart_Callback(hObject, eventdata, handles)
% hObject    handle to BoxDichteVStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxDichteVStart as text
%        str2double(get(hObject,'String')) returns contents of BoxDichteVStart as a double


% --- Executes during object creation, after setting all properties.
function BoxDichteVStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxDichteVStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxDichteH_Callback(hObject, eventdata, handles)
% hObject    handle to BoxDichteH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxDichteH as text
%        str2double(get(hObject,'String')) returns contents of BoxDichteH as a double


% --- Executes during object creation, after setting all properties.
function BoxDichteH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxDichteH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxLaengeAbschnitte_Callback(hObject, eventdata, handles)
% hObject    handle to BoxLaengeAbschnitte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxLaengeAbschnitte as text
%        str2double(get(hObject,'String')) returns contents of BoxLaengeAbschnitte as a double


% --- Executes during object creation, after setting all properties.
function BoxLaengeAbschnitte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxLaengeAbschnitte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxZeitschritte_Callback(hObject, eventdata, handles)
% hObject    handle to BoxZeitschritte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxZeitschritte as text
%        str2double(get(hObject,'String')) returns contents of BoxZeitschritte as a double


% --- Executes during object creation, after setting all properties.
function BoxZeitschritte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxZeitschritte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonStart.
function ButtonStart_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ButtonStart, 'Enable', 'off');
set(handles.ButtonStart, 'Backgroundcolor', 'red');
drawnow;

for i=1:numel(handles.sims)
    handles.sims{i} = nagelschreckenberg(handles.sims{i});
end

set(handles.ButtonStart, 'Enable', 'on');
set(handles.ButtonStart, 'Backgroundcolor', 'green');

guidata(hObject,handles);





function BoxTroedeln_Callback(hObject, eventdata, handles)
% hObject    handle to BoxTroedeln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxTroedeln as text
%        str2double(get(hObject,'String')) returns contents of BoxTroedeln as a double


% --- Executes during object creation, after setting all properties.
function BoxTroedeln_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxTroedeln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxMaxGeschwindigkeit_Callback(hObject, eventdata, handles)
% hObject    handle to BoxMaxGeschwindigkeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxMaxGeschwindigkeit as text
%        str2double(get(hObject,'String')) returns contents of BoxMaxGeschwindigkeit as a double


% --- Executes during object creation, after setting all properties.
function BoxMaxGeschwindigkeit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxMaxGeschwindigkeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxDichteVEnde_Callback(hObject, eventdata, handles)
% hObject    handle to BoxDichteVEnde (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxDichteVEnde as text
%        str2double(get(hObject,'String')) returns contents of BoxDichteVEnde as a double


% --- Executes during object creation, after setting all properties.
function BoxDichteVEnde_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxDichteVEnde (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxDichteVWeite_Callback(hObject, eventdata, handles)
% hObject    handle to BoxDichteVWeite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxDichteVWeite as text
%        str2double(get(hObject,'String')) returns contents of BoxDichteVWeite as a double


% --- Executes during object creation, after setting all properties.
function BoxDichteVWeite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxDichteVWeite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

idx =  floor(get(handles.slider1, 'Value'));
sim = handles.sims{idx};

set(handles.BoxDichteAnimation, 'String', sim.densityV);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function BoxDichteAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to BoxDichteAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxDichteAnimation as text
%        str2double(get(hObject,'String')) returns contents of BoxDichteAnimation as a double


% --- Executes during object creation, after setting all properties.
function BoxDichteAnimation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxDichteAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BoxFlowPoint_Callback(hObject, eventdata, handles)
% hObject    handle to BoxFlowPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BoxFlowPoint as text
%        str2double(get(hObject,'String')) returns contents of BoxFlowPoint as a double


% --- Executes during object creation, after setting all properties.
function BoxFlowPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoxFlowPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PhillisPlotButton.
function PhillisPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to PhillisPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotDensity(handles.sims, str2double(get(handles.BoxFlowPoint, 'String')), handles.PlotDichte);

idx = floor(get(handles.slider1, 'Value'));
sim = handles.sims{idx};
plotCars2(sim.CellsH, sim.CellsV, handles.cellNum, handles.PlotKreuz);
