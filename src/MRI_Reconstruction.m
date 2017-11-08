function varargout = MRI_Reconstruction(varargin)
% MRI_RECONSTRUCTION MATLAB code for MRI_Reconstruction.fig
%      MRI_RECONSTRUCTION, by itself, creates a new MRI_RECONSTRUCTION or raises the existing
%      singleton*.
%
%      H = MRI_RECONSTRUCTION returns the handle to a new MRI_RECONSTRUCTION or the handle to
%      the existing singleton*.
%
%      MRI_RECONSTRUCTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MRI_RECONSTRUCTION.M with the given input arguments.
%
%      MRI_RECONSTRUCTION('Property','Value',...) creates a new MRI_RECONSTRUCTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MRI_Reconstruction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MRI_Reconstruction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MRI_Reconstruction

% Last Modified by GUIDE v2.5 08-Nov-2017 13:33:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MRI_Reconstruction_OpeningFcn, ...
                   'gui_OutputFcn',  @MRI_Reconstruction_OutputFcn, ...
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


% --- Executes just before MRI_Reconstruction is made visible.
function MRI_Reconstruction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MRI_Reconstruction (see VARARGIN)

% Choose default command line output for MRI_Reconstruction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MRI_Reconstruction wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% INITIAL VALUES
set(handles.lines, 'Value', 3);
set(handles.points, 'Value', 3); 
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = MRI_Reconstruction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pickPhantom.
function pickPhantom_Callback(hObject, eventdata, handles)
% hObject    handle to pickPhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pickPhantom contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pickPhantom
opt = get(handles.pickPhantom, 'Value');
axes(handles.phantomAxes);
switch opt
    case 1
        clearAxes(handles)
    case 2
        imshow('../data/phantom_type1.png');
    case 3
        imshow('../data/phantom_type2.png');
    case 4
        [file, path, ~] = uigetfile({'*.png;*.jpg;*.jpeg;*.JPG;*.JPEG'});
        if ischar(file) && ischar(path)
            imdata = imread(strcat(path, file));
            if size(imdata, 3) == 3
                imdata = rgb2gray(imdata);
            end
            imdata = imresize(imdata, [256,256]);
            imshow(imdata);
        else
            clearAxes(handles)
        end
end

% --- Executes during object creation, after setting all properties.
function pickPhantom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pickPhantom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
phantom = get(handles.pickPhantom, 'Value');
trajectory = get(handles.pickTrajectory, 'Value');

if(isempty(get(handles.phantomAxes, 'Children')))
    return;
end

lines = 2^(get(handles.lines, 'Value') + 3);
points = 2^(get(handles.points, 'Value') + 3);

switch trajectory
    case 1
        return;
    case 2
        MRI = MRI_Cartesian(getimage(handles.phantomAxes), lines, points);
    case 3
        MRI = MRI_Radial(getimage(handles.phantomAxes), lines, points);
end

axes(handles.MRIAxes);
imshow(MRI, [0, max(MRI(:))]);

compareImg = abs(double(getimage(handles.phantomAxes)) - double(MRI)); 
axes(handles.diffAxes); 
imshow(compareImg, [0 max(compareImg(:))]);


% --- Executes on selection change in pickTrajectory.
function pickTrajectory_Callback(hObject, eventdata, handles)
% hObject    handle to pickTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pickTrajectory contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pickTrajectory
opt = get(handles.pickTrajectory, 'Value');
axes(handles.trajectoryAxes);
switch opt
    case 1
        cla;
    case 2
        imshow('../data/cartesian.png');
    case 3
        imshow('../data/radial.png');
end

% --- Executes during object creation, after setting all properties.
function pickTrajectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pickTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clearAxes(handles)
    axes(handles.phantomAxes); cla;
    axes(handles.MRIAxes); cla;
    axes(handles.diffAxes); cla;

function linesText_Callback(hObject, eventdata, handles)
% hObject    handle to linesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of linesText as text
%        str2double(get(hObject,'String')) returns contents of linesText as a double
val = get(hObject, 'String');
if isempty(str2num(val))
    set(hObject, 'String', handles.trajInfo.num_lines);
    warndlg('Number of lines must be numerical');
else
    handles.trajInfo.num_lines = str2num(val);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function linesText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pointsText_Callback(hObject, eventdata, handles)
% hObject    handle to pointsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pointsText as text
%        str2double(get(hObject,'String')) returns contents of pointsText as a double
val = get(hObject, 'String');
if isempty(str2num(val))
    set(hObject, 'String', handles.trajInfo.num_points_per_line);
    warndlg('Number of points must be numerical');
else
    handles.trajInfo.num_points_per_line = str2num(val);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function pointsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lines.
function lines_Callback(hObject, eventdata, handles)
% hObject    handle to lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lines contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lines


% --- Executes during object creation, after setting all properties.
function lines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in points.
function points_Callback(hObject, eventdata, handles)
% hObject    handle to points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns points contents as cell array
%        contents{get(hObject,'Value')} returns selected item from points


% --- Executes during object creation, after setting all properties.
function points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
