function varargout = CrossSim(varargin)
% CROSSSIM MATLAB code for CrossSim.fig
%      CROSSSIM, by itself, creates a new CROSSSIM or raises the existing
%      singleton*.
%
%      H = CROSSSIM returns the handle to a new CROSSSIM or the handle to
%      the existing singleton*.
%
%      CROSSSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROSSSIM.M with the given input arguments.
%
%      CROSSSIM('Property','Value',...) creates a new CROSSSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CrossSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CrossSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CrossSim

% Last Modified by GUIDE v2.5 06-Dec-2012 16:56:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CrossSim_OpeningFcn, ...
                   'gui_OutputFcn',  @CrossSim_OutputFcn, ...
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


% --- Executes just before CrossSim is made visible.
function CrossSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CrossSim (see VARARGIN)

% Choose default command line output for CrossSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
data = get(handles.main_fig,'UserData');
data.stop = false;
data.running = 0;
set(handles.main_fig,'UserData',data);

% UIWAIT makes CrossSim wait for user response (see UIRESUME)
% uiwait(handles.main_fig);

% --- Outputs from this function are returned to the command line.
function varargout = CrossSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in sim_button.
function sim_button_Callback(hObject, eventdata, handles)
% hObject    handle to sim_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.main_fig,'UserData');
set(handles.sim_button, 'String', 'Pause simulation');

switch data.running
    case 0
        
        if (get(handles.type_1d,'Value') == 1)
            type = 1;
            city_gen;
            city = 'city.mat';
        else
            type = 2;
            city_gen_2d;
            city = 'city_2d.mat';
        end
        
        load(city);
        
        cyc = str2double(get(handles.cycles,'String'));
        p = str2double(get(handles.speed,'String'));
        newFig = figure;
        set(newFig,'Name','CrossSim Simulator');
        b = Builder(city);
        s = Simulation(b);
        d = Drawer(b);
        
        if (get(handles.custom_mode,'Value') == 1)
            mode = 1;
        elseif (get(handles.opt_mode,'Value') == 1)
            mode = 2;
        else
            mode = 3;
        end
        
        c = 1;
        switch (type)
            case 1
                switch (mode)
                    case 1
                        load('custom.mat');
                        gts = gts_1d;
                    case 2
                        disp('Optimalization has started');
                        gts = gaoptim(b, cyc);
                        disp('Optimalization has finished');
                    case 3
                        gts = zeros(1,(cyc-1)*b.numbers(1)) + 20;
                        rts = 0;
                        off = 0;
                end
            case 2
                switch (mode)
                    case 1
                        load('custom.mat');
                        gts = gts_2d;
                        rts = rts_2d;
                        off = off_2d;
                    case 2
                        disp('Optimalization has started');
                        [gts, rts, off] = time_calc(b);
                        disp('Optimalization has finished');
                    case 3
                        gts = zeros(1,b.numbers(1)) + 20;
                        rts = zeros(1,b.numbers(1)) + 10;
                        for i = 1:b.numbers(1)
                            off(i) = mod(i,3)*10;
                        end
                end
        end
        
        s.init(gts,rts,off,rn(c:c+b.numbers(2)),type);
        
        isPaused = 0;
        
        data.stop = false;
        data.running = 1;
        set(handles.main_fig, 'UserData', data);
        
        keep_running = 1;

        while (keep_running == 1 && max(b.cycles) < cyc)
            
            while (isPaused == 1)
                data = get(handles.main_fig,'UserData');
                if data.running == 1
                    isPaused=0;
                end
                data = get(handles.main_fig,'UserData');
                if data.stop
                    keep_running=0;
                    isPaused=0;
                end
                pause(0.5);
            end
            
            figure(newFig);
            
            switch (type)
                case 1
                    s.simulate_1(gts,1,rn(c:c+b.numbers(2)));
                case 2
                    s.simulate_2(gts,rts,off,1,rn(c:c+b.numbers(2)));
            end
            
            d.draw();
            pause(p);
            M(c) = getframe(gcf);
            c = c + 1;
            
            data = get(handles.main_fig,'UserData');
            if data.stop
                keep_running=0;
            end
            
            data = get(handles.main_fig,'UserData');
            if data.running == 2
                isPaused=1;
            end
            
        end
        
        close(newFig);
        if (get(handles.save_cb, 'Value') == 1)
            movie2avi(M, get(handles.filename, 'String'), 'fps', 5);
        end
        set(handles.sim_button, 'String', 'Start simulation');
        data.stop = true;
        data.running = 0;
        set(handles.main_fig, 'UserData', data);
        
    case 1
        data.running = 2;
        set(handles.main_fig, 'UserData', data);
        set(handles.sim_button, 'String', 'Continue simulation');
        
    case 2
        data.running = 1;
        set(handles.main_fig, 'UserData', data);
        set(handles.sim_button, 'String', 'Pause simulation');
end


function cycles_Callback(hObject, eventdata, handles)
% hObject    handle to cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cycles as text
%        str2double(get(hObject,'String')) returns contents of cycles as a double

% --- Executes during object creation, after setting all properties.
function cycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.main_fig);


% --- Executes on button press in custom_mode.
function custom_mode_Callback(hObject, eventdata, handles)
% hObject    handle to custom_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of custom_mode


% --- Executes on button press in opt_mode.
function opt_mode_Callback(hObject, eventdata, handles)
% hObject    handle to opt_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of opt_mode


% --- Executes on button press in save_cb.
function save_cb_Callback(hObject, eventdata, handles)
% hObject    handle to save_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_cb


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.type_1d,'Value') == 1)
    type = 1;
    city_gen;
    city = 'city.mat';
else
    type = 2;
    city_gen_2d;
    city = 'city_2d.mat';
end

delete(get(handles.filename, 'String'));
mymovie = avifile(get(handles.filename, 'String'), 'compression','None', 'fps', 5);

load(city);

cyc = str2double(get(handles.cycles,'String'));
p = str2double(get(handles.speed,'String'));
newFig = figure('Visible', 'off');
set(newFig,'Name','CrossSim Simulator');
%set(newFig, 'Visible', 'off');
b = Builder(city);
s = Simulation(b);
d = Drawer(b);

if (get(handles.custom_mode,'Value') == 1)
    mode = 1;
elseif (get(handles.opt_mode,'Value') == 1)
    mode = 2;
else
    mode = 3;
end

c = 1;
switch (type)
    case 1
        switch (mode)
            case 1
                load('custom.mat');
                gts = gts_1d;
            case 2
                disp('Optimalization has started');
                gts = gaoptim(b, cyc);
                disp('Optimalization has finished');
            case 3
                gts = zeros(1,(cyc-1)*b.numbers(1)) + 20;
                rts = 0;
                off = 0;
        end
    case 2
        switch (mode)
            case 1
                load('custom.mat');
                gts = gts_2d;
                rts = rts_2d;
                off = off_2d;
            case 2
                disp('Optimalization has started');
                [gts, rts, off] = time_calc(b);
                disp('Optimalization has finished');
            case 3
                gts = zeros(1,b.numbers(1)) + 20;
                rts = zeros(1,b.numbers(1)) + 10;
                for i = 1:b.numbers(1)
                    off(i) = mod(i,3)*10;
                end
        end
end

s.init(gts,rts,off,rn(c:c+b.numbers(2)),type);

while (max(b.cycles) < cyc)
    
    cla;
    
    switch (type)
        case 1
            s.simulate_1(gts,1,rn(c:c+b.numbers(2)));
        case 2
            s.simulate_2(gts,rts,off,1,rn(c:c+b.numbers(2)));
    end
    
    d.draw();
    c = c + 1;
    
    mymovie = addframe(mymovie, newFig);
    
    
end

set(newFig, 'Visible', 'on');
close(newFig);
mymovie = close(mymovie);
disp('The requested movie is ready');



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over sim_button.
function sim_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sim_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.main_fig,'UserData');
data.stop = true;
data.running = 0;
set(handles.sim_button, 'String', 'Start simulation');
set(handles.main_fig,'UserData',data);
