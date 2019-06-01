function varargout = toolbox_gui(varargin)
% Toolbox GUI MATLAB code for toolbox_gui.fig
%
% Toolbox to aid in the design of wave-based controlllers.
% Functionality includes:
% 1. Rational approximation of a wave-based transfer function.
% 2. Transformation from transfer function in the s-domain to the G-domain.
% 3. Robustness of a system, providing upper and lower bounds of stability.
% 4. Impulse/step response of a system, for disturbance rejection/reference
%    tracking.
% 5. ITSE (WBC) of a system, for disturbance rejection and reference tracking.
% 6. ITpSE (Clasical) of a system, via Lyapunov matrix equations.
% 
% To launch the toolbox, press "Run" on this file (toolbox_gui.m file).
%
% Tabs functionality provided by WFAToolbox Team.
%
%-------------------------------------------------------------------------%
%-------------------------- Begin Initialization -------------------------%
%-------------------------------------------------------------------------%

% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toolbox_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @toolbox_gui_OutputFcn, ...
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

%-------------------------------------------------------------------------%
%--------------------------- End Initialization --------------------------%
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%------------------------- Begin Opening Function ------------------------%
%-------------------------------------------------------------------------%

% --- Executes just before toolbox_gui is made visible.
function toolbox_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toolbox_gui (see VARARGIN)

% Choose default command line output for toolbox_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% set(handles.text204, 'String', 'IT^{p}SE')
% set(handles.text211, 'String', 'IT%^{p}SE of a system via Lyapunov Matrix Equations.')
% UIWAIT makes toolbox_gui wait for user response (see UIRESUME)
% uiwait(handles.toolbox);


%-------------------------------------------------------------------------%
%-------------------------- End Opening Function -------------------------%
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%------------------------------- Begin Tabs ------------------------------%
%-------------------------------------------------------------------------%

% Settings
TabFontSize = 8;
TabNames = {'Introduction', 'Rational Approx.', 'Transformation', 'Robustness', 'Responses', 'ITSE (Wave-Domain)', 'IT^pSE (s-Domain)'};
FigWidth = 0.67;

% Figure resize
set(handles.toolbox,'Units','normalized')
pos = get(handles.toolbox, 'Position');
set(handles.toolbox, 'Position', [pos(1) pos(2) FigWidth pos(4)])

% Tabs Execution
handles = TabAxesText(handles,TabFontSize,TabNames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes toolbox_gui wait for user response (see UIRESUME)
% uiwait(handles.toolbox);

% --- TabAxesText creates axes and text objects for tabs
function handles = TabAxesText(handles,TabFontSize,TabNames)

% Set the colors indicating a selected/unselected tab
handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
handles.unselectedTabColor=handles.selectedTabColor-0.1;

% Create Tabs
TabsNumber = length(TabNames);
handles.TabsNumber = TabsNumber;
TabColor = handles.selectedTabColor;
for i = 1:TabsNumber
    n = num2str(i);
    
    % Get text objects position
    set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');

    % Create axes with callback function
    handles.(['a',n]) = axes('Units','normalized',...
                    'Box','on',...
                    'XTick',[],...
                    'YTick',[],...
                    'Color',TabColor,...
                    'Position',[pos(1) pos(2) pos(3) pos(4)+0.01],...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
                    
    % Create text with callback function
    handles.(['t',n]) = text('String',TabNames{i},...
                    'Units','normalized',...
                    'Position',[pos(3),pos(2)/2+pos(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','middle',...
                    'Margin',0.001,...
                    'FontSize',TabFontSize,...
                    'Backgroundcolor',TabColor,...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);

    TabColor = handles.unselectedTabColor;
end
            
% Manage panels (place them in the correct position and manage visibilities)
set(handles.tab1Panel,'Units','normalized')
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab1text,'Visible','off')
for i = 2:TabsNumber
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
end

% --- Callback function for clicking on tab
function ClickOnTab(hObject,~,handles)
m = str2double(get(hObject,'Tag'));

for i = 1:handles.TabsNumber;
    n = num2str(i);
    if i == m
        set(handles.(['a',n]),'Color',handles.selectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','on')
    else
        set(handles.(['a',n]),'Color',handles.unselectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','off')
    end
end

%-------------------------------------------------------------------------%
%-------------------------------- End Tabs -------------------------------%
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%------------------------------ Begin Output -----------------------------%
%-------------------------------------------------------------------------%

% --- Outputs from this function are returned to the command line.
function varargout = toolbox_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------%
%------------------------------- End Output ------------------------------%
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%---------------------- Begin Rational Approximation ---------------------%
%-------------------------------------------------------------------------%
% --- Executes on selection change in ra_ghatg.
function ra_ghatg_Callback(hObject, eventdata, handles)
% hObject    handle to ra_ghatg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ra_ghatg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ra_ghatg


% --- Executes during object creation, after setting all properties.
function ra_ghatg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_ghatg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ra_num_output_Callback(hObject, eventdata, handles)
% hObject    handle to ra_num_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ra_num_output as text
%        str2double(get(hObject,'String')) returns contents of ra_num_output as a double


% --- Executes during object creation, after setting all properties.
function ra_num_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_num_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ra_den_output_Callback(hObject, eventdata, handles)
% hObject    handle to ra_den_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ra_den_output as text
%        str2double(get(hObject,'String')) returns contents of ra_den_output as a double


% --- Executes during object creation, after setting all properties.
function ra_den_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_den_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ra_num_input_Callback(hObject, eventdata, handles)
% hObject    handle to ra_num_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ra_num_input as text
%        str2double(get(hObject,'String')) returns contents of ra_num_input as a double


% --- Executes during object creation, after setting all properties.
function ra_num_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_num_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ra_den_input_Callback(hObject, eventdata, handles)
% hObject    handle to ra_den_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ra_den_input as text
%        str2double(get(hObject,'String')) returns contents of ra_den_input as a double


% --- Executes during object creation, after setting all properties.
function ra_den_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_den_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ra_firstorder.
function ra_firstorder_Callback(hObject, eventdata, handles)
% hObject    handle to ra_firstorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.ra_firstorder,'Value') == 1)
    set(handles.ra_secondorder,'Value',0);
end
% Hint: get(hObject,'Value') returns toggle state of ra_firstorder


% --- Executes on button press in ra_secondorder.
function ra_secondorder_Callback(hObject, eventdata, handles)
% hObject    handle to ra_secondorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.ra_secondorder,'Value') == 1)
    set(handles.ra_firstorder,'Value',0);
end
% Hint: get(hObject,'Value') returns toggle state of ra_secondorder



function ra_omega0_text_input_Callback(hObject, eventdata, handles)
% hObject    handle to ra_omega0_text_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ra_omega0_text_input as text
%        str2double(get(hObject,'String')) returns contents of ra_omega0_text_input as a double


% --- Executes during object creation, after setting all properties.
function ra_omega0_text_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_omega0_text_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ra_clear_all.
function ra_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to ra_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ra_omega0_text_input,'String','');
set(handles.ra_num_input,'String','');
set(handles.ra_den_input,'String','');
set(handles.ra_num_output,'String','');
set(handles.ra_den_output,'String','');

cla;
cla reset;


% --- Executes on selection change in ra_order_options.
function ra_order_options_Callback(hObject, eventdata, handles)
% hObject    handle to ra_order_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ra_order_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ra_order_options


% --- Executes during object creation, after setting all properties.
function ra_order_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ra_order_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in ra_plot_check.
function ra_plot_check_Callback(hObject, eventdata, handles)
% hObject    handle to ra_plot_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ra_plot_check


% --- Executes on button press in ra_calculate.
function ra_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to ra_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NUM = str2num(get(handles.ra_num_input, 'String'));
DEN = str2num(get(handles.ra_den_input, 'String'));
if (get(handles.ra_order_options,'Value') == 1)
    n = 1;
elseif (get(handles.ra_order_options,'Value') == 2)
    n = 2;
else errordlg('Please choose an order of approximation.', 'Error!')
end
if get(handles.ra_ghatg, 'Value') == 1
    options = 'wave tf';
elseif get(handles.ra_ghatg, 'Value') == 2
    options = 'root wave tf';
else errordlg('Please choose the the function for approximation.', 'Error!')
end
omega = str2num(get(handles.ra_omega0_text_input, 'String'));
ld = length(DEN) - 1; % order of denominator
ln = length(NUM) - 1; % order of numerator
if ld > 15 || ln > 15 % order of input is too large
    message('\nThe order of the numerator or denominator is too large.\n');
end
% Begin Rational Approximation
if strcmp(options, 'root wave tf')
    switch(n)
        case 1
                G = tf([omega],[1/2 omega]);                    % 1st Order approximation
        case 2
                G = tf([omega], [1/8 1/2*omega omega^2]);       % 2nd Order approximation
        otherwise
            error('1st or 2nd Order Approximation can only be calculated'); % error
    end
% Wave-Transfer Function
elseif strcmp(options, 'wave tf')
    switch(n)
        case 1
                G = tf([omega], [1 omega]);                     % 1st Order approximation
        case 2
                G = tf([omega^2], [(1/2) omega (omega^2)]);     % 2nd Order approximation
        otherwise 
            error('1st or 2nd Order Approximation can only be calculated'); % error
    end
end
% Output rational approximation of transfer function
tf_num = tf([NUM(ln+1)],[1]); % output numerator
tf_den = tf([DEN(ld+1)],[1]); % output denominator
for i = 1:(ln)
    tf_num = tf_num + NUM(i)*(G^((ln+1)-i)); % add numerator transfer function
end
for j = 1:(ld)
    tf_den = tf_den + DEN(j)*(G^((ld+1)-j)); % add denominator transfer functions
end
tf_sys = tf_num/tf_den; % output
% Stability Check
% Basic stability check if roots are positive, produce warning
[vec_num, vec_den] = tfdata(tf_sys,'v'); % find the numerator and denominator of the transfer function
p = real(roots(vec_den));
if p(p>0)
    warndlg('The rational approximation of the system entered is unstable.', 'Warning!');
end
transfer_function = evalc('tf_sys');
fprintf('%s', transfer_function);
set(handles.ra_num_output,'String',num2str(vec_num));
set(handles.ra_den_output,'String',num2str(vec_den));


%-------------------------------------------------------------------------%
%----------------------- End Rational Approximation ----------------------%
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%-------------------------- Begin Transformation -------------------------%
%-------------------------------------------------------------------------%

% --- Executes on selection change in transformation_mode_options.
function transformation_mode_options_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns transformation_mode_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from transformation_mode_options


% --- Executes during object creation, after setting all properties.
function transformation_mode_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformation_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function transformation_num_s_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_num_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transformation_num_s as text
%        str2double(get(hObject,'String')) returns contents of transformation_num_s as a double


% --- Executes during object creation, after setting all properties.
function transformation_num_s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformation_num_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function transformation_den_s_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_den_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transformation_den_s as text
%        str2double(get(hObject,'String')) returns contents of transformation_den_s as a double


% --- Executes during object creation, after setting all properties.
function transformation_den_s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformation_den_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function transformation_num_G_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_num_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transformation_num_G as text
%        str2double(get(hObject,'String')) returns contents of transformation_num_G as a double


% --- Executes during object creation, after setting all properties.
function transformation_num_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformation_num_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function transformation_den_G_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_den_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transformation_den_G as text
%        str2double(get(hObject,'String')) returns contents of transformation_den_G as a double

% --- Executes during object creation, after setting all properties.
function transformation_den_G_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transformation_den_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in transformation_transform.
function transformation_transform_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Input Error Checking
num = str2num(get(handles.transformation_num_s,'String'));
den = str2num(get(handles.transformation_den_s,'String'));

n = length(num);
d = length(den);

if (n==0 || d==0)
    errordlg('Pleade complete input fields.','Input Error');
    return;
end

numx = get(handles.transformation_num_s,'String');
denx = get(handles.transformation_den_s,'String');

num = str2num(numx);
den = str2num(denx);

m = length(num); % length of numerator
n = length(den); % length of denominator

% Assign iteration variable to largest order of transfer fucntion
if (m>n)
    r = m;
else
    r = n;
end

syms G; % symbolic variable, which replaces s

if (get(handles.transformation_mode_options,'Value') == 1) % if G transformation selected
    % Substitue s with (G^n-r)(1-G)^2r
    for i=0:r % for every value between 0 and the max order of transfer function
        w = r-i; % assign magnitude of power of G
        switch i
            case 0
                t0a = [1]; % (1-G)^0 
                u = transformation_gpower(w); % G^(n-0)
                p0a = conv(t0a, u);
                p0b = [zeros(1,(22-length(p0a))) p0a];
                p0c = poly2sym(p0a, G);
            case 1
                t1a = [-1 1]; % (1-G)^1
                t1b = conv(t1a, [-1 1]); % (1-G)^2
                u = transformation_gpower(w); % G^(n-1)
                p1a = conv(t1b, u);
                p1b = [zeros(1,(22-length(p1a))) p1a];
                p1c = poly2sym(p1a, G);
            case 2 
                t2a = conv(t1b, [-1 1]); % (1-G)^3
                t2b = conv(t2a, [-1 1]); % (1-G)^4
                u = transformation_gpower(w);
                p2a = conv(t2b, u);
                p2b = [zeros(1,(22-length(p2a))) p2a];
                p2c = poly2sym(p2a, G);
            case 3
                t3a = conv(t2b, [-1 1]); % (1-G)^5
                t3b = conv(t3a, [-1 1]); % (1-G)^6
                u = transformation_gpower(w);
                p3a = conv(t3b, u);
                p3b = [zeros(1,(22-length(p3a))) p3a];
                p3c = poly2sym(p3a, G);
            case 4
                t4a = conv(t3b, [-1 1]); % (1-G)^7
                t4b = conv(t4a, [-1 1]); % (1-G)^8
                u = transformation_gpower(w);
                p4a = conv(t4b, transformation_gpower(w));
                p4b = [zeros(1,(22-length(p4a))) p4a];
                p4c = poly2sym(p4a, G);
            case 5
                t5a = conv(t4b, [-1 1]); % (1-G)^9
                t5b = conv(t5a, [-1 1]); % (1-G)^10
                u = transformation_gpower(w);
                p5a = conv(t5b, u);
                p5b = [zeros(1,(22-length(p5a))) p5a];
                p5c = poly2sym(p5a, G);
            case 6
                t6a = conv(t5b, [-1 1]); % (1-G)^11
                t6b = conv(t6a, [-1 1]); % (1-G)^12
                u = transformation_gpower(w);
                p6a = conv(t6b, u);
                p6b = [zeros(1,(22-length(p6a))) p6a];
                p6c = poly2sym(p6a, G);
            case 7
                t7a = conv(t6b, [-1 1]); % (1-G)^13
                t7b = conv(t7a, [-1 1]); % (1-G)^14
                u = transformation_gpower(w);
                p7a = conv(t7b, u);
                p7b = [zeros(1,(22-length(p7a))) p7a];
                p7c = poly2sym(p7a, G);
            case 8
                t8a = conv(t7b, [-1 1]); % (1-G)^15
                t8b = conv(t8a, [-1 1]); % (1-G)^16
                u = transformation_gpower(w);
                p8a = conv(t8b, u);
                p8b = [zeros(1,(22-length(p8a))) p8a];
                p8c = poly2sym(p8a, G);
            case 9
                t9a = conv(t8b, [-1 1]); % (1-G)^17
                t9b = conv(t9a, [-1 1]); % (1-G)^18
                u = transformation_gpower(w);
                p9a = conv(t9b, u);
                p9b = [zeros(1,(22-length(p9a))) p9a];
                p9c = poly2sym(p9a, G);
            case 10
                t10a = conv(t9b, [-1 1]); % (1-G)^19
                t10b = conv(t10a, [-1 1]); % (1-G)^20
                u = transformation_gpower(w);
                p10a = conv(t10b, u);
                p10b = [zeros(1,(22-length(p10a))) p10a];
                p10c = poly2sym(p10a, G);
        end
    end

    % Numerator
    switch m
        case 1
            yn = num(1)*p0b;
        case 2            
            yn = num(1)*p1b + num(2)*p0b;
        case 3            
            yn = num(1)*p2b + num(2)*p1b + num(3)*p0b;
        case 4            
            yn = num(1)*p3b + num(2)*p2b + num(3)*p1b + num(4)*p0b;
        case 5            
            yn = num(1)*p4b + num(2)*p3b + num(3)*p2b + num(4)*p1b + num(5)*p0b;
        case 6            
            yn = num(1)*p5b + num(2)*p4b + num(3)*p3b + num(4)*p2b + num(5)*p1b + num(6)*p0b;
        case 7
            yn = num(1)*p6b + num(2)*p5b + num(3)*p4b + num(4)*p3b + num(5)*p2b + num(6)*p1b + num(7)*p0b;
        case 8
            yn = num(1)*p7b + num(2)*p6b + num(3)*p5b + num(4)*p4b + num(5)*p3b + num(6)*p2b + num(7)*p1b + num(8)*p0b;
        case 9
            yn = num(1)*p8b + num(2)*p7b + num(3)*p6b + num(4)*p5b + num(5)*p4b + num(6)*p3b + num(7)*p2b + num(8)*p1b + num(9)*p0b;
        case 10
            yn = num(1)*p9b + num(2)*p8b + num(3)*p7b + num(4)*p6b + num(5)*p5b + num(6)*p4b + num(7)*p3b + num(8)*p2b + num(9)*p1b + num(10)*p0b;
        case 11
            yn = num(1)*p10b + num(2)*p9b + num(3)*p8b + num(4)*p7b + num(5)*p6b + num(6)*p5b + num(7)*p4b + num(8)*p3b + num(9)*p2b + num(10)*p1b + num(11)*p0b;
    end

    % Denominator
    switch n
        case 1
            yd = den(1)*p0b;
        case 2            
            yd = den(1)*p1b + den(2)*p0b;
        case 3            
            yd = den(1)*p2b + den(2)*p1b + den(3)*p0b;
        case 4            
            yd = den(1)*p3b + den(2)*p2b + den(3)*p1b + den(4)*p0b;
        case 5            
            yd = den(1)*p4b + den(2)*p3b + den(3)*p2b + den(4)*p1b + den(5)*p0b;
        case 6            
            yd = den(1)*p5b + den(2)*p4b + den(3)*p3b + den(4)*p2b + den(5)*p1b + den(6)*p0b;
        case 7
            yd = den(1)*p6b + den(2)*p5b + den(3)*p4b + den(4)*p3b + den(5)*p2b + den(6)*p1b + den(7)*p0b;
        case 8
            yd = den(1)*p7b + den(2)*p6b + den(3)*p5b + den(4)*p4b + den(5)*p3b + den(6)*p2b + den(7)*p1b + den(8)*p0b;
        case 9
            yd = den(1)*p8b + den(2)*p7b + den(3)*p6b + den(4)*p5b + den(5)*p4b + den(6)*p3b + den(7)*p2b + den(8)*p1b + den(9)*p0b;
        case 10
            yd = den(1)*p9b + den(2)*p8b + den(3)*p7b + den(4)*p6b + den(5)*p5b + den(6)*p4b + den(7)*p3b + den(8)*p2b + den(9)*p1b + den(10)*p0b;
        case 11
            yd = den(1)*p10b + den(2)*p9b + den(3)*p8b + den(4)*p7b + den(5)*p6b + den(6)*p5b + den(7)*p4b + den(8)*p3b + den(9)*p2b + den(10)*p1b + den(11)*p0b;
    end
    
elseif (get(handles.transformation_mode_options,'Value') == 2) % G_hat
    
    c0 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]; % (1-G_hat)^0
    c1 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 1]; % (1-G_hat)^1
    c2 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -2 0 1]; % (1-G_hat)^2
    c3 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 3 0 -3 0 1]; % (1-G_hat)^3
    c4 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -4 0 6 0 -4 0 1]; % (1-G_hat)^4
    c5 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 5 0 -10 0 10 0 -5 0 1]; % (1-G_hat)^5
    c6 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -6 0 15 0 -20 0 15 0 -6 0 1]; % (1-G)^6
    c7 = [0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 7 0 -21 0 35 0 -35 0 21 0 -7 0 1]; % (1-G)^7
    c8 = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 -8 0 28 0 -56 0 70 0 -56 0 28 0 -8 0 1]; % (1-G)^8
    c9 = [0 0 0 0 0 0 0 0 0 0 0 -1 0 9 0 -36 0 84 0 -126 0 126 0 -84 0 36 0 -9 0 1]; % (1-G)^9
    c10 = [0 0 0 0 0 0 0 0 0 0 1 0 -10 0 45 0 -120 0 210 0 -252 0 210 0 -120 0 45 0 -10 0 1]; % (1-G)^10

    for i=0:r
        switch i
            case 0
                t0a = transformation_gpower(r-i);
                p0a = conv(c0,t0a);
                p0b = [zeros(1,(22-length(p0a))) p0a];
                p0c = poly2sym(p0a, G);
            case 1
                t1a = transformation_gpower(r-i);
                p1a = conv(c1,t1a);
                p1b = [zeros(1,(22-length(p1a))) p1a];
                p1c = poly2sym(p1a, G);
            case 2
                t2a = transformation_gpower(r-i);
                p2a = conv(t2a,c2);
                p2b = [zeros(1,(22-length(p2a))) p2a];
                p2c = poly2sym(p2a, G);
            case 3
                t3a = transformation_gpower(r-i);
                p3a = conv(t3a,c3);
                p3b = [zeros(1,(22-length(p3a))) p3a];
                p3c = poly2sym(p3a, G);
            case 4
                t4a = transformation_gpower(r-i);
                p4a = conv(t4a,c4);
                p4b = [zeros(1,(22-length(p4a))) p4a];
                p4c = poly2sym(p4a, G);
            case 5
                t5a = transformation_gpower(r-i);
                p5a = transformation_conv(t5a,c5);
                p5b = [zeros(1,(22-length(p5a))) p5a];
                p5c = poly2sym(p5a, G);
            case 6
                t6a = transformation_gpower(r-i);
                p6a = conv(t6a,c6);
                p6b = [zeros(1,(22-length(p6a))) p6a];
                p6c = poly2sym(p6a, G);
            case 7
                t7a = transformation_gpower(r-i);
                p7a = conv(t7a,c7);
                p7b = [zeros(1,(22-length(p7a))) p7a];
                p7c = poly2sym(p7a, G);
            case 8
                t8a = transformation_gpower(r-i);
                p8a = conv(t8a,c8);
                p8b = [zeros(1,(22-length(p8a))) p8a];
                p8c = poly2sym(p8a, G);
            case 9
                t9a = transformation_gpower(r-i);
                p9a = conv(t9a,c9);
                p9b = [zeros(1,(22-length(p9a))) p9a];
                p9c = poly2sym(p9a, G);
            case 10
                t10a = transformation_gpower(r-i);
                p10a = conv(t10a,c10);
                p10b = [zeros(1,(22-length(p10a))) p10a];
                p10c = poly2sym(p10a, G);
        end
    end

    % Numerator
    switch m
        case 1
            yn = num(1)*p0b;
        case 2            
            yn = num(1)*p1b + num(2)*p0b;
        case 3            
            yn = num(1)*p2b + num(2)*p1b + num(3)*p0b;
        case 4            
            yn = num(1)*p3b + num(2)*p2b + num(3)*p1b + num(4)*p0b;
        case 5            
            yn = num(1)*p4b + num(2)*p3b + num(3)*p2b + num(4)*p1b + num(5)*p0b;
        case 6            
            yn = num(1)*p5b + num(2)*p4b + num(3)*p3b + num(4)*p2b + num(5)*p1b + num(6)*p0b;
        case 7
            yn = num(1)*p6b + num(2)*p5b + num(3)*p4b + num(4)*p3b + num(5)*p2b + num(6)*p1b + num(7)*p0b;
        case 8
            yn = num(1)*p7b + num(2)*p6b + num(3)*p5b + num(4)*p4b + num(5)*p3b + num(6)*p2b + num(7)*p1b + num(8)*p0b;
        case 9
            yn = num(1)*p8b + num(2)*p7b + num(3)*p6b + num(4)*p5b + num(5)*p4b + num(6)*p3b + num(7)*p2b + num(8)*p1b + num(9)*p0b;
        case 10
            yn = num(1)*p9b + num(2)*p8b + num(3)*p7b + num(4)*p6b + num(5)*p5b + num(6)*p4b + num(7)*p3b + num(8)*p2b + num(9)*p1b + num(10)*p0b;
        case 11
            yn = num(1)*p10b + num(2)*p9b + num(3)*p8b + num(4)*p7b + num(5)*p6b + num(6)*p5b + num(7)*p4b + num(8)*p3b + num(9)*p2b + num(10)*p1b + num(11)*p0b;
    end

    % Denominator
    switch n
        case 1
            yd = den(1)*p0b;
        case 2            
            yd = den(1)*p1b + den(2)*p0b;
        case 3            
            yd = den(1)*p2b + den(2)*p1b + den(3)*p0b;
        case 4            
            yd = den(1)*p3b + den(2)*p2b + den(3)*p1b + den(4)*p0b;
        case 5            
            yd = den(1)*p4b + den(2)*p3b + den(3)*p2b + den(4)*p1b + den(5)*p0b;
        case 6            
            yd = den(1)*p5b + den(2)*p4b + den(3)*p3b + den(4)*p2b + den(5)*p1b + den(6)*p0b;
        case 7
            yd = den(1)*p6b + den(2)*p5b + den(3)*p4b + den(4)*p3b + den(5)*p2b + den(6)*p1b + den(7)*p0b;
        case 8
            yd = den(1)*p7b + den(2)*p6b + den(3)*p5b + den(4)*p4b + den(5)*p3b + den(6)*p2b + den(7)*p1b + den(8)*p0b;
        case 9
            yd = den(1)*p8b + den(2)*p7b + den(3)*p6b + den(4)*p5b + den(5)*p4b + den(6)*p3b + den(7)*p2b + den(8)*p1b + den(9)*p0b;
        case 10
            yd = den(1)*p9b + den(2)*p8b + den(3)*p7b + den(4)*p6b + den(5)*p5b + den(6)*p4b + den(7)*p3b + den(8)*p2b + den(9)*p1b + den(10)*p0b;
        case 11
            yd = den(1)*p10b + den(2)*p9b + den(3)*p8b + den(4)*p7b + den(5)*p6b + den(6)*p5b + den(7)*p4b + den(8)*p3b + den(9)*p2b + den(10)*p1b + den(11)*p0b;
    end

else
    message = 'No mode of operation set'
end

% Outputs
yn_out = yn(find(yn~=0):end);
yd_out = yd(find(yd~=0):end);

set(handles.transformation_num_G,'String',num2str(yn_out));
set(handles.transformation_den_G,'String',num2str(yd_out));

% Function to itse_wbc_calculate powers of G
function [s] = transformation_gpower(w)
    switch w
        case 0
            s = [0];
        case 1
            s = [1];
        case 2
            s = [1 0];
        case 3
            s = [1 0 0];
        case 4
            s = [1 0 0 0];
        case 5
            s = [1 0 0 0 0];
        case 6
            s = [1 0 0 0 0 0];
        case 7
            s = [1 0 0 0 0 0 0];
        case 8
            s = [1 0 0 0 0 0 0 0];
        case 9
            s = [1 0 0 0 0 0 0 0 0];
        case 10
            s = [1 0 0 0 0 0 0 0 0 0];
    end

% Function to itse_wbc_calculate powers of G_hat
function [s] = transformation_spower(w)
    switch w
        case 0
            s = [0 0 0 0 0 0 0 0 0 0];
        case 1
            s = [0 0 0 0 0 0 0 0 0 1];
        case 2
            s = [0 0 0 0 0 0 0 0 1 0];
        case 3
            s = [0 0 0 0 0 0 0 1 0 0];
        case 4
            s = [0 0 0 0 0 0 1 0 0 0];
        case 5
            s = [0 0 0 0 0 1 0 0 0 0];
        case 6
            s = [0 0 0 0 1 0 0 0 0 0];
        case 7
            s = [0 0 0 1 0 0 0 0 0 0];
        case 8
            s = [0 0 1 0 0 0 0 0 0 0];
        case 9
            s = [0 1 0 0 0 0 0 0 0 0];
        case 10
            s = [1 0 0 0 0 0 0 0 0 0];
    end

% --- Executes on button press in transformation_clear_all.
function transformation_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to transformation_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.transformation_num_G,'String','');
set(handles.transformation_den_G,'String','');
set(handles.transformation_num_s,'String','');
set(handles.transformation_den_s,'String','');


%-------------------------------------------------------------------------%
%--------------------------- End Transformation --------------------------%
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%---------------------------- Begin Robustness ---------------------------%
%-------------------------------------------------------------------------%

function robustness_num_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_num as text
%        str2double(get(hObject,'String')) returns contents of robustness_num as a double



% --- Executes during object creation, after setting all properties.
function robustness_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robustness_den_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_den as text
%        str2double(get(hObject,'String')) returns contents of robustness_den as a double




% --- Executes during object creation, after setting all properties.
function robustness_den_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function robustness_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_iterations as text
%        str2double(get(hObject,'String')) returns contents of robustness_iterations as a double



% --- Executes during object creation, after setting all properties.
function robustness_iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robustness_accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_accuracy as text
%        str2double(get(hObject,'String')) returns contents of robustness_accuracy as a double



% --- Executes during object creation, after setting all properties.
function robustness_accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robustness_nominal_stability_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_nominal_stability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_nominal_stability as text
%        str2double(get(hObject,'String')) returns contents of robustness_nominal_stability as a double


% --- Executes during object creation, after setting all properties.
function robustness_nominal_stability_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_nominal_stability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function robustness_upper_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_upper as text
%        str2double(get(hObject,'String')) returns contents of robustness_upper as a double


% --- Executes during object creation, after setting all properties.
function robustness_upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function robustness_lower_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robustness_lower as text
%        str2double(get(hObject,'String')) returns contents of robustness_lower as a double


% --- Executes during object creation, after setting all properties.
function robustness_lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robustness_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in robustness_calculate.
function robustness_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Input Error Checking
num = str2num(get(handles.robustness_num,'String'));
den = str2num(get(handles.robustness_den,'String'));
iterations = str2num(get(handles.robustness_iterations,'String'));
accuracy = str2num(get(handles.robustness_accuracy,'String'));

n = length(num);
d = length(den);
i = length(iterations);
t = length(accuracy);

if (n==0 || d==0 || i==0 || t==0)
    errordlg('Pleade complete input fields.','Input Error');
    return;
end

num1 = str2num(get(handles.robustness_num,'String'));
den1 = str2num(get(handles.robustness_den,'String'));

h = tf([num1],[den1]);
[numh,denh] = tfdata(h,'v'); % extract numerator and denominator

iterations = str2num(get(handles.robustness_iterations,'String')); % number of iterations
accuracy = str2num(get(handles.robustness_accuracy,'String')); % accuracy of upper and lower bound approximations
    
% Let z = 1/G
num = flip(numh);
den = flip(denh);

r=1; % initialise varying paramater at nominal 1

% Check if nominal is stable
s = robustness_stable(num,den,r);

if (s==1) % if nominal system is stable
    message = 'Stable';

    upper = robustness_increment(num, den, iterations, accuracy);
    lower = robustness_decrement(num, den, iterations, accuracy);
    
    set(handles.robustness_upper,'String',num2str(upper));
    set(handles.robustness_lower,'String',num2str(lower));
else
    message = 'Unstable'
end
set(handles.robustness_nominal_stability,'String',message);



% Function to check if given transfer function with the varying paramater
% b is stable
function x = robustness_stable(num,den,r)
    p = length(robustness_f(num,den,r));
    s = 0;
    % For every root check if it is less than 1, if so increment count
    for i = 1:p
        y=robustness_f(num,den,r);
        if abs(y(i))>1
            s = 0;
        else
            s = s + 1;
        end
    end
    
    % If count of stable roots equals total roots, the system is stable
    if s == p
        x = 1;
    else
        x = 0;
    end

function y=robustness_f(num,den,r)
    y = abs(roots(den + r*num));


function upper = robustness_increment(num, den, iterations, tolerance)
    r=1;
    for i = 1:iterations
        r = r + tolerance;
        s = robustness_stable(num,den,r);
        if (i==iterations)
            upper = 'Not reached';
            break;
        elseif (s==1)
            upper = r;
        else
            break;
        end
    end
        
function lower = robustness_decrement(num, den, iterations, tolerance)
    r=1;
    for i = 1:iterations
        r = r - tolerance;
        s = robustness_stable(num,den,r);
        if (i==iterations)
            lower = 'Not reached';
            break
        elseif (s==1)
            lower = r;
        else
            break;
        end
    end


% --- Executes on button press in robustness_clear_all.
function robustness_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to robustness_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.robustness_num,'String','');
set(handles.robustness_den,'String','');
set(handles.robustness_iterations,'String','');
set(handles.robustness_accuracy,'String','');
set(handles.robustness_nominal_stability,'String','');
set(handles.robustness_upper,'String','');
set(handles.robustness_lower,'String','');



%-------------------------------------------------------------------------%
%----------------------------- End Robustness ----------------------------%
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
%----------------------- Begin Impulse/Step Response ---------------------%
%-------------------------------------------------------------------------%

% --- Executes on button press in responses_plot.
function responses_plot_Callback(hObject, eventdata, handles)
% hObject    handle to responses_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overshoot_output_text, 'String', '');
set(handles.responses_settling_time_text, 'String', '');
num = str2num(get(handles.responses_num,'String'));
den = str2num(get(handles.responses_den,'String'));

n = length(num);
d = length(den);

if (n==0 || d==0)
    errordlg('Pleade complete input fields.','Input Error');
    return;
end

num = str2num(get(handles.responses_num,'String'));
den = str2num(get(handles.responses_den,'String'));
h = tf(num, den);

%---------------------------- Impulse Response ---------------------------%

if (get(handles.responses_type_options,'Value') == 1)

    % Read in transfer function
    [bG,aG] = tfdata(h,'v'); % extract numerator and denominator

    % Multiply by G
    bG1 = [bG 0];

    % Length
    length_a=length(aG);
    length_b=length(bG1);

    % Transformation
    az = flip(aG);
    bz = flip(bG1);

    if length_a>length_b
        bz = [bz zeros(1,(length_a-length_b))];
    else
        az = [az zeros(1,(length_b-length_a))];
    end

    % Partial fraction expansion
    [r,p,k] = residue(bz,az);

    % Length
    length_r = length(r);
    length_p = length(p);

    % Creare Bessel functiont terms
    t = [0:0.1:20]; % normalised time
    b=zeros(80,length(t));
    for i=1:80
        b(i,:) = besselj(i,2*t);
    end
    b0 = besselj(2*0,2*t);

    for i=1:length_r
        switch i
            case 1
                alpha0=0;
                for j=i:length_r
                    alpha0=real(sum(r(i)));
                end
                x = alpha0*(b(1,:)+b(3,:));
                x_hat = alpha0*(b0+b(2,:));
            case 2
                alpha1=0;
                for j=i:length_r
                    alpha1=alpha1+real(sum(r(i).*(p(i).^2)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:));
            case 3
                alpha2=0;
                for j=i:length_r
                    alpha2=alpha2+real(sum(r(i).*(p(i).^3)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:));
            case 4
                alpha3=0;
                for j=i:length_r
                    alpha3=alpha3+real(sum(r(i).*(p(i).^4)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:));
            case 5
                alpha4=0;
                for rpi=0:40
                    alpha4=alpha4+real(sum(r(i).*(p(i).^5)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:));
            case 6
                alpha5=0;
                for rpi=0:40
                    alpha5=alpha5+real(sum(r(i).*(p(i).^6)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:)) + alpha5*(b(11,:)+b(13,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:)) + alpha5*(b(5,:)+b(7,:));
            case 7
                alpha6=0;
                for rpi=0:40
                    alpha6=alpha6+real(sum(r(i).*(p(i).^7)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:)) + alpha5*(b(11,:)+b(13,:)) + alpha6*(b(13,:)+b(15,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:)) + alpha5*(b(5,:)+b(7,:)) + alpha6*(b(6,:)+b(8,:));
            case 8
                alpha7=0;
                for rpi=0:40
                    alpha7=alpha7+real(sum(r(i).*(p(i).^8)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:)) + alpha5*(b(11,:)+b(13,:)) + alpha6*(b(13,:)+b(15,:)) + alpha7*(b(15,:)+b(17,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:)) + alpha5*(b(5,:)+b(7,:)) + alpha6*(b(6,:)+b(8,:)) + alpha7*(b(7,:)+b(9,:));
            case 9
                alpha8=0;
                for rpi=0:40
                    alpha8=alpha8+real(sum(r(i).*(p(i).^9)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:))  + alpha5*(b(11,:)+b(13,:)) + alpha6*(b(13,:)+b(15,:)) + alpha7*(b(15,:)+b(17,:)) + alpha8*(b(17,:)+b(19,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:)) + alpha5*(b(5,:)+b(7,:)) + alpha6*(b(6,:)+b(8,:)) + alpha7*(b(7,:)+b(9,:)) + alpha8*(b(8,:)+b(10,:));
            case 10
                alpha9=0;
                for rpi=0:40
                    alpha9=alpha9+real(sum(r(i).*(p(i).^10)));
                end
                x = alpha0*(b(1,:)+b(3,:)) + alpha1*(b(3,:)+b(5,:)) + alpha2*(b(5,:)+b(7,:)) + alpha3*(b(7,:)+b(9,:)) + alpha4*(b(9,:)+b(11,:)) + alpha5*(b(11,:)+b(13,:)) + alpha6*(b(13,:)+b(15,:)) + alpha7*(b(15,:)+b(17,:)) + alpha8*(b(17,:)+b(19,:)) + alpha9*(b(19,:)+b(21,:));
                x_hat = alpha0*(b0+b(2,:)) + alpha1*(b(1,:)+b(3,:)) + alpha2*(b(2,:)+b(4,:)) + alpha3*(b(3,:)+b(5,:)) + alpha4*(b(4,:)+b(6,:)) + alpha5*(b(5,:)+b(7,:)) + alpha6*(b(6,:)+b(8,:)) + alpha7*(b(7,:)+b(9,:)) + alpha8*(b(8,:)+b(10,:)) + alpha9*(b(9,:)+b(11,:));
        end
    end

    % Plot step response
    axes(handles.responses_axes) 
    if (get(handles.responses_mode_options,'Value') == 1) % G
        plot(t,x);
        data = x;
    elseif (get(handles.responses_mode_options,'Value') == 2) % G_hat
        plot(t,x_hat);
        data = x_hat;
    else
        message = 'No mode of operation set'
    end
    title('Impulse Response')
    xlabel('Time') % x-axis label
    ylabel('Amplitude') % y-axis label
    
    %---------------------------- Step Response ---------------------------%
      
elseif (get(handles.responses_type_options,'Value') == 2)
    
    % Read in transfer function
    [bG,aG] = tfdata(h,'v'); % extract numerator and denominator

    % Multiply by G
    bG1 = [bG 0];

    % Length
    length_a = length(aG);
    length_b = length(bG1);

    % Transformation
    az = flip(aG);
    bz = flip(bG1);

    az = [az zeros(1,(length_b-length_a))];

    % Partial Fraction Expansion
    [r,p,k] = residue(bz,az);
    % k = [2 0 -2];

    % Length
    length_k = length(k);
    k = [k zeros(1,(length_b-length_k))];
    length_r = length(r);
    length_p = length(p);

    % Creare Bessel functiont terms
    t = [0:0.1:20]; % normalised time
    b=zeros(80,length(t));
    for i=1:80
        b(i,:) = besselj(i,2*t);
    end
    b0 = besselj(2*0,2*t);

    for i=1:length_r
        switch i
            case 1
                for rpi=0:40
                    alpha0=real(sum(r(i)));
                end
                x = 1 - alpha0*(b0+b(2,:));
                x_hat = 1 - alpha0*(b0+b(2,:));
            case 2
                for rpi=0:40
                    alpha1=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:));
                x_hat = 1-alpha0*(1-b0-b(2,:)) - alpha1*(1-b0-2*b(2,:)-b(4,:));
            case 3
                for rpi=0:40
                    alpha2=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:));
            case 4
                for rpi=0:40
                    alpha3=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:));
            case 5
                for rpi=0:40
                    alpha4=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:));
            case 6
                for rpi=0:40
                    alpha5=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:));
            case 7
                for rpi=0:40
                    alpha6=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:));
            case 8
                for rpi=0:40
                    alpha7=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:));
            case 9
                for rpi=0:40
                    alpha8=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:)) - alpha8*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+b(18,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:)) - alpha8*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+b(18,:));
            case 10
                for rpi=0:40
                    alpha9=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:)) - alpha8*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+b(18,:)) - alpha9*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+2*b(18,:)+b20);
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:)) - alpha8*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+b(18,:)) - alpha9*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+2*b(16,:)+2*b(18,:)+b20);
        end
    end

    switch length_k
        case 1
            y = x - k(1)*(b0+b2);
            y_hat = x - k(1)*(b0+b2);
        case 2
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4);
        case 3
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6);
        case 4
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8);
        case 5
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10);
        case 6
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12);        
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12);        
        case 7
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14);
        case 8
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16);
        case 9
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16) - k(9)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+b18);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16) - k(9)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+b18);
        case 10
            y = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16) - k(9)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+b18) - k(10)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+2*b18+b20);
            y_hat = x - k(1)*(b0+b2) - k(2)*(b0+2*b2+b4) - k(3)*(b0+2*b2+2*b4+b6) - k(4)*(b0+2*b2+2*b4+2*b6+b8) - k(5)*(b0+2*b2+2*b4+2*b6+2*b8+b10) - k(6)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+b12) - k(7)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+b14) - k(8)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+b16) - k(9)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+b18) - k(10)*(b0+2*b2+2*b4+2*b6+2*b8+2*b10+2*b12+2*b14+2*b16+2*b18+b20);
    end

    % Plot Step Response
    axes(handles.responses_axes)
    if (get(handles.responses_mode_options,'Value') == 1) % G
        if (length_k>=1)
            plot(t,y);
            title('Step Response')
            xlabel('Time') % x-axis label
            ylabel('Amplitude') % y-axis label
            data = y;
        else
            plot(t,x);
            title('Step Response')
            xlabel('Time') % x-axis label
            ylabel('Amplitude') % y-axis label
            data = x;
        end
    elseif (get(handles.responses_mode_options,'Value') == 2) % G_hat
        if (length_k>=1)
            plot(t,y_hat);
            message = 'Step response for G_hat not available yet.'
            title('Step Response')
            xlabel('Time') % x-axis label
            ylabel('Amplitude') % y-axis label
            data = y_hat;
        else
            plot(t,1);
            message = 'Step response for G_hat not available yet.'
            title('Step Response (Not Yet Available)')
            xlabel('Time') % x-axis label
            ylabel('Amplitude') % y-axis label
            data = 1;
        end
    else
        message = 'No mode of operation set'
    end
end
    
%--------------------------- Settling Time ----------------------------%    
if (get(handles.responses_settling_time_checkbox,'Value') == 1)
    %     a = str2num(get(handles.responses_num,'String'));
    %     settling_den = str2num(get(handles.responses_den,'String'));
    % Initialise Plotting Colours
    RGB_lightblue = [0,0.537254901960784,0.811764705882353];
    % Read in Data
    step_data = data; % create step data vector

    
    % Find n% settling time
    if get(handles.n_settimes_list, 'Value') == 1
        n = 0.01;
    elseif get(handles.n_settimes_list, 'Value') == 2
        n = 0.02;
    elseif get(handles.n_settimes_list, 'Value') == 3
        n = 0.03;
    elseif get(handles.n_settimes_list, 'Value') ==4
        n = 0.04;
    elseif get(handles.n_settimes_list, 'Value') == 5
        n = 0.05;
    else
        msgbox('Please specify the desired settling time.', 'Error','error');
    end
    
    % t = [0:.001:20];
    if (get(handles.responses_type_options,'Value') == 2)
        final = 1;
    end
    % Find 1st Peak & Trough less than 2% of Final Value
    [maxpks, maxlocs] = findpeaks(step_data); % find the locations of the peaks
    step_data_inv = 1.01*max(step_data) - step_data; % reverse data for finding troughs
    [minpks, minlocs] = findpeaks(step_data_inv); % find the locations of the troughs
    % Compare Final Value calculations
    no_pks = [length(maxlocs) length(minlocs)]; % length vector of number of peaks
    no_pks = min(no_pks); % find smallest number - of troughs of peaks
    final_vals = zeros(1, no_pks); % initialise vector
    for k = 1:no_pks
        final_vals(k) = step_data(minlocs(k)) + (step_data(maxlocs(k)) - step_data(minlocs(k)))/2; % find final values
    end
    final_new = round(mean(final_vals)*10)/10; % find the average of the final values
    if final_new ~= final % if the average final value is not = 1, print error
        final_new = final; % force the final value = 1
    end

    % itse_wbc_calculate Position of 2% Band
    [nup_rows, nup_cols] = find(step_data(1,:) >= (final_new+n), 1, 'last');% find last point outside 2% band (> 1+n)
    [ndwn_rows, ndwn_cols] = find(step_data(1,:) <= (final_new-n), 1, 'last'); % find last point outside 2% band (< 1-n)
    if isempty(nup_cols) || isempty(ndwn_cols)
        msgbox('Could not calculate settling time. This comes as a result of the system not having perfect tracking, not settling within the desired band within 20 normalised time units or the response not exceeding the desired band in the first place.', 'Error','error');
        error('Could not calculate settling time. This comes as a result of the system not having perfect tracking, not settling within the desired band within 20 normalised time units or the response not exceeding the desired band in the first place.')
    elseif ((ndwn_cols) == length(step_data)) || (nup_cols == length(step_data)) || (final_new ~= final)% error check for step input which
        msgbox('Could not calculate settling time. This comes as a result of the system not having perfect tracking, not settling within the desired band within 20 normalised time units or the response not exceeding the desired band in the first place.', 'Error','error');
        error('Could not calculate settling time. This comes as a result of the system not having perfect tracking, not settling within the desired band within 20 normalised time units or the response not exceeding the desired band in the first place.')
    end
    if nup_cols > ndwn_cols
        m_vals = round(step_data(1,nup_cols)*1000)/1000; % round to 3rd decimal place
        if (m_vals ~= 1+n)
        st_error_flag = 1; % settling time error flag - denotes settling time is +/- 0.1 normalised time units out
        m_vals = final_new + n;
        end
    else 
        m_vals = round(step_data(1,ndwn_cols)*10000)/10000; % round to 3rd decimal place
        if (m_vals ~= 1-n)
        m_vals = final_new - n;
        st_error_flag = 1; % settling time error flag - denotes settling time is +/- 0.1 normalised time units out
        end
    end

    axes(handles.responses_axes)
    hold on

    % Plot n% Settling Time Point on axis
    % inputs needed - x,y coordinates & timespan (t) of plot
    % take in coordinates of location of final peak

    if m_vals > final_new
        min_point = (1-n)*(m_vals/(1+n)); % (1+n)% of final value - mirrored n% band
        min_band = min_point*(ones(1, length(t))); % horizontal line
        max_band = m_vals*ones(1,length(t)); % horizontal line
        plot(t(nup_cols), step_data(nup_cols), 'kx') % plot 2% band marker
        plot(t(nup_cols), [0:0.01:step_data(nup_cols)], 'r-') % plot 2% band marker
        st_string = sprintf('%0.0f%% Settling Time: %0.2f\n Normalised Time Units', n*100, t(nup_cols)); % output details
        set(handles.responses_settling_time_text,'String',st_string); % edit GUI text
    else
        min_point = m_vals; % (1-n)% of final value - point entering n% band
        min_band = min_point*ones(1,length(t)); % horizontal line 
        max_point = (1+n)*(min_point/(1-n)); % (1+n)% of final value - mirrored n% band
        max_band = max_point*(ones(1, length(t))); % horizontal line
        plot(t(ndwn_cols), step_data(ndwn_cols), 'kx') % plot 2% band marker
        plot(t(ndwn_cols), [0:0.01:step_data(ndwn_cols)], 'r-') % plot 2% band marker
        st_string = sprintf('%0.0f%% Settling Time: %0.2f\n Normalised Time Units', n*100, t(nup_cols)); % print to output
        set(handles.responses_settling_time_text,'String', st_string); % edit GUI text
    end
    % Plot 2% Settling Time Band
    plot(t, min_band, 'k--', t, max_band, 'k--') % plot the 2% bands
    hold off
end
        % ------------- Overshoot--------------------------------%
if get(handles.responses_overshoot_checkbox, 'Value')%% insert overshoot
    step_data = data; % create step data vector
    final = 1;
    if (length(find((step_data > final)~=0)) <= 1) % If the response is not above zero
        errordlg('Overshoot could not be found', 'Error!')
    end
    % Find 1st Peak & Trough less than 2% of Final Value
    [maxpks, maxlocs] = findpeaks(step_data); % find the locations of the peaks
    % find overshoot
    [os_row, os_col] = find((step_data == maxpks(1))~=0);
    axes(handles.responses_axes)
    hold on
    plot(t(os_col), step_data(os_col), 'kx'); 
    plot(t(1:os_col), maxpks(1)*ones(os_col,1), 'k--');
    plot(t(os_col), [0:0.1:step_data(os_col)], 'r-');
    string = sprintf('%.2f%% \nOvershoot', (maxpks(1)-final)*100);
    set(handles.overshoot_output_text, 'String', string)
    hold off
%         fprintf('The Overshoot is %.2f%%\n', (maxpks(1)-final)*100);
end





% --- Executes on button press in responses_clear_all.
function responses_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to responses_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.responses_num,'String','');
set(handles.responses_den,'String','');

cla;
cla(handles.responses_axes);
cla reset;

% --- Executes on button press in responses_reference_tracking.
function responses_reference_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to responses_reference_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of responses_reference_tracking
set(handles.responses_disturbance_rejection,'Value',0);

% --- Executes on button press in responses_disturbance_rejection.
function responses_disturbance_rejection_Callback(hObject, eventdata, handles)
% hObject    handle to responses_disturbance_rejection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of responses_disturbance_rejection
set(handles.responses_reference_tracking,'Value',0);
set(handles.responses_settling_time_checkbox, 'Value', 0);


function responses_num_Callback(hObject, eventdata, handles)
% hObject    handle to responses_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of responses_num as text
%        str2double(get(hObject,'String')) returns contents of responses_num as a double



% --- Executes during object creation, after setting all properties.
function responses_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to responses_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function responses_den_Callback(hObject, eventdata, handles)
% hObject    handle to responses_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of responses_den as text
%        str2double(get(hObject,'String')) returns contents of responses_den as a double



% --- Executes during object creation, after setting all properties.
function responses_den_CreateFcn(hObject, eventdata, handles)
% hObject    handle to responses_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in responses_settling_time_checkbox.
function responses_settling_time_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to responses_settling_time_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.responses_type_options,'Value') == 1)
    set(handles.responses_settling_time_checkbox, 'Value', 0)
end
if get(handles.responses_mode_options,'Value') == 2
    set(handles.responses_settling_time_checkbox, 'Value', 0);
end
% Hint: get(hObject,'Value') returns toggle state of responses_settling_time_checkbox



% --- Executes on selection change in responses_mode_options.
function responses_mode_options_Callback(hObject, eventdata, handles)
% hObject    handle to responses_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.responses_mode_options,'Value') == 2
    set(handles.responses_overshoot_checkbox, 'Value', 0)
    set(handles.responses_settling_time_checkbox, 'Value', 0);
end
% Hints: contents = cellstr(get(hObject,'String')) returns responses_mode_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from responses_mode_options


% --- Executes during object creation, after setting all properties.
function responses_mode_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to responses_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in responses_type_options.
function responses_type_options_Callback(hObject, eventdata, handles)
% hObject    handle to responses_type_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.responses_type_options,'Value') == 1)
    set(handles.responses_settling_time_checkbox, 'Value', 0)
    set(handles.responses_overshoot_checkbox, 'Value', 0)
end
% Hints: contents = cellstr(get(hObject,'String')) returns responses_type_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from responses_type_options


% --- Executes during object creation, after setting all properties.
function responses_type_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to responses_type_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in n_settimes_list.
function n_settimes_list_Callback(hObject, eventdata, handles)
% hObject    handle to n_settimes_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns n_settimes_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from n_settimes_list


% --- Executes during object creation, after setting all properties.
function n_settimes_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_settimes_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in responses_overshoot_checkbox.
function responses_overshoot_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to responses_overshoot_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.responses_type_options,'Value') == 1)
    set(handles.responses_overshoot_checkbox, 'Value', 0)
end
if get(handles.responses_mode_options,'Value') == 2
    set(handles.responses_overshoot_checkbox, 'Value', 0)
end
% Hint: get(hObject,'Value') returns toggle state of responses_overshoot_checkbox



%-------------------------------------------------------------------------%
%------------------------ End Impulse/Step Response ----------------------%
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
%---------------------------- Begin ITSE (WBC) ---------------------------%
%-------------------------------------------------------------------------%

% --- Executes on button press in itpse_classical_classical_system.
function itpse_classical_classical_system_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_classical_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itpse_classical_classical_system



% --- Executes on button press in itpse_classical_ise.
function itpse_classical_ise_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_ise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itpse_classical_ise


% --- Executes on button press in itpse_classical_itse.
function itpse_classical_itse_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_itse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itpse_classical_itse



% --- Executes on button press in itpse_classical_it2se.
function itpse_classical_it2se_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_it2se (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itpse_classical_it2se



% --- Executes on button press in itse_wbc_wave_based_system.
function itse_wbc_wave_based_system_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_wave_based_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itse_wbc_wave_based_system

% --- Executes on button press in itse_wbc_itse_reference_tracking.
function itse_wbc_itse_reference_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_itse_reference_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itse_wbc_itse_reference_tracking


% --- Executes on button press in itse_wbc_itse_disturbance_rejection.
function itse_wbc_itse_disturbance_rejection_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_itse_disturbance_rejection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of itse_wbc_itse_disturbance_rejection



function itse_wbc_num_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itse_wbc_num as text
%        str2double(get(hObject,'String')) returns contents of itse_wbc_num as a double


% --- Executes during object creation, after setting all properties.
function itse_wbc_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itse_wbc_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function itse_wbc_den_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itse_wbc_den as text
%        str2double(get(hObject,'String')) returns contents of itse_wbc_den as a double


% --- Executes during object creation, after setting all properties.
function itse_wbc_den_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itse_wbc_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in itse_wbc_mode_options.
function itse_wbc_mode_options_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns itse_wbc_mode_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from itse_wbc_mode_options


% --- Executes during object creation, after setting all properties.
function itse_wbc_mode_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itse_wbc_mode_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in itse_wbc_type_options.
function itse_wbc_type_options_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_type_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns itse_wbc_type_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from itse_wbc_type_options


% --- Executes during object creation, after setting all properties.
function itse_wbc_type_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itse_wbc_type_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in itse_wbc_calculate.
function itse_wbc_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itse_wbc_den as text
%        str2double(get(hObject,'String')) returns contents of itse_wbc_den as a double


num = str2num(get(handles.itse_wbc_num,'String'));
den = str2num(get(handles.itse_wbc_den,'String'));

% Input Error Checking
n = length(num);
d = length(den);

if (n==0 || d==0)
    errordlg('Pleade complete input fields.','Input Error');
    return;
end

h = tf(num, den);

%---------------------------- Impulse Response ---------------------------%

if (get(handles.itse_wbc_type_options,'Value') == 1)

    % Read in transfer function
    [bG,aG] = tfdata(h,'v'); % extract numerator and denominator

    % Multiply by G
    bG1 = [bG 0];

    % Length
    length_a=length(aG);
    length_b=length(bG1);

    % Transformation
    az = flip(aG);
    bz = flip(bG1);

    if length_a>length_b
        bz = [bz zeros(1,(length_a-length_b))];
    else
        az = [az zeros(1,(length_b-length_a))];
    end

    % Partial fraction expansion
    [r,p,k] = residue(bz,az);

    % Length
    length_r = length(r);
    length_p = length(p);

    % Creare Bessel functiont terms
    t = [0:0.1:20]; % normalised time
    b=zeros(80,length(t));
    for i=1:80
        b(i,:) = besselj(i,2*t);
    end
    b0 = besselj(2*0,2*t);

    for i=1:length_r
        switch i
            case 1
                alpha0=0;
                for j=i:length_r
                    alpha0=real(sum(r(i)));
                end
                itse = alpha0^2;
            case 2
                alpha1=0;
                for j=i:length_r
                    alpha1=alpha1+real(sum(r(i).*(p(i).^2)));
                end
                itse = alpha0^2 + 2*alpha1^2;
            case 3
                alpha2=0;
                for j=i:length_r
                    alpha2=alpha2+real(sum(r(i).*(p(i).^3)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3;
            case 4
                alpha3=0;
                for j=i:length_r
                    alpha3=alpha3+real(sum(r(i).*(p(i).^4)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2;
            case 5
                alpha4=0;
                for rpi=0:40
                    alpha4=alpha4+real(sum(r(i).*(p(i).^5)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2;
            case 6
                alpha5=0;
                for rpi=0:40
                    alpha5=alpha5+real(sum(r(i).*(p(i).^6)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2 + 6*alpha5^2;
            case 7
                alpha6=0;
                for rpi=0:40
                    alpha6=alpha6+real(sum(r(i).*(p(i).^7)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2 + 6*alpha5^2 + 7*alpha6^2;
            case 8
                alpha7=0;
                for rpi=0:40
                    alpha7=alpha7+real(sum(r(i).*(p(i).^8)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2 + 6*alpha5^2 + 7*alpha6^2 + 8*alpha7^2;
            case 9
                alpha8=0;
                for rpi=0:40
                    alpha8=alpha8+real(sum(r(i).*(p(i).^9)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2 + 6*alpha5^2 + 7*alpha6^2 + 8*alpha7^2 + 9*alpha8^2;
            case 10
                alpha9=0;
                for rpi=0:40
                    alpha9=alpha9+real(sum(r(i).*(p(i).^10)));
                end
                itse = alpha0^2 + 2*alpha1^2 + 3*alpha2^3 + 4*alpha3^2 + 5*alpha4^2 + 6*alpha5^2 + 7*alpha6^2 + 8*alpha7^2 + 9*alpha8^2 + 10*alpha9^2;
        end
    end

    if (get(handles.itse_wbc_mode_options,'Value') == 1) % G
        itse % ITSE
    elseif (get(handles.itse_wbc_mode_options,'Value') == 2) % G_hat
        itse % ITSE
    else
        itse = 'No mode of operation set'
    end
    set(handles.itse_wbc_answer,'String',num2str(itse));
    
%--------------------------- Reference Tracking --------------------------%
      
elseif (get(handles.itse_wbc_type_options,'Value') == 2)
    
    % Read in transfer function
    [bG,aG] = tfdata(h,'v'); % extract numerator and denominator

    % Multiply by G
    bG1 = [bG 0];

    % Length
    length_a = length(aG);
    length_b = length(bG1);

    % Transformation
    az = flip(aG);
    bz = flip(bG1);

    az = [az zeros(1,(length_b-length_a))];

    % Partial Fraction Expansion
    [r,p,k] = residue(bz,az);
    % k = [2 0 -2];

    % Length
    length_k = length(k);
    k = [k zeros(1,(length_b-length_k))];
    length_r = length(r);
    length_p = length(p);

    % Creare Bessel functiont terms
    t = [0:0.1:20]; % normalised time
    b=zeros(80,length(t));
    for i=1:80
        b(i,:) = besselj(i,2*t);
    end
    b0 = besselj(2*0,2*t);

    for i=1:length_r
        switch i
            case 1
                for rpi=0:40
                    alpha0=real(sum(r(i)));
                end
            case 2
                for rpi=0:40
                    alpha1=real(sum(r(i).*(p(i).^rpi)));
                end
            case 3
                for rpi=0:40
                    alpha2=real(sum(r(i).*(p(i).^rpi)));
                end
            case 4
                for rpi=0:40
                    alpha3=real(sum(r(i).*(p(i).^rpi)));
                end
            case 5
                for rpi=0:40
                    alpha4=real(sum(r(i).*(p(i).^rpi)));
                end
            case 6
                for rpi=0:40
                    alpha5=real(sum(r(i).*(p(i).^rpi)));
                end
            case 7
                for rpi=0:40
                    alpha6=real(sum(r(i).*(p(i).^rpi)));
                end
            case 8
                for rpi=0:40
                    alpha7=real(sum(r(i).*(p(i).^rpi)));
                end
                x = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:));
                x_hat = 1 - alpha0*(b0+b(2,:)) - alpha1*(b0+2*b(2,:)+b(4,:)) - alpha2*(b0+2*b(2,:)+2*b(4,:)+b(6,:)) - alpha3*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+b(8,:)) - alpha4*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+b(10,:)) - alpha5*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+b(12,:)) - alpha6*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+b(14,:)) - alpha7*(b0+2*b(2,:)+2*b(4,:)+2*b(6,:)+2*b(8,:)+2*b(10,:)+2*b(12,:)+2*b(14,:)+b(16,:));
            case 9
                for rpi=0:40
                    alpha8=real(sum(r(i).*(p(i).^rpi)));
                end
            case 10
                for rpi=0:40
                    alpha9=real(sum(r(i).*(p(i).^rpi)));
                end
            end
    end

    % ITSE for G
    for j=1:length_r
        switch j
            case 1
                beta0 = 1;
                beta1 = (1-k(1));
                itse = (beta1^2)/2;
            case 2
                beta2 = (1-k(1)) + (1-k(1)-alpha0-k(2));
                itse = (beta1^2)/2 + (3*beta2^2)/2;
            case 3
                beta3 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2;
            case 4
                beta4 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2;
            case 5
                beta5 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2;
            case 6
                beta6 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2 + (11*beta6^2)/2;
            case 7
                beta7 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2 + (11*beta6^2)/2 + (13*beta7^2)/2;
            case 8
                beta8 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2 + (11*beta6^2)/2 + (13*beta7^2)/2 + (15*beta8^2)/2;
            case 9
                beta9 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8)-alpha7-k(9));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2 + (11*beta6^2)/2 + (13*beta7^2)/2 + (15*beta8^2)/2 + (17*beta9^2)/2;
            case 10
                beta10 = (1-k(1)) + (1-k(1)-alpha0-k(2)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8)-alpha7-k(9)) + (1-k(1)-alpha0-k(2)-alpha1-k(3)-alpha2-k(4)-alpha3-k(5)-alpha4-k(6)-alpha5-k(7)-alpha6-k(8)-alpha7-k(9)-alpha8-k(10));
                itse = (beta1^2)/2 + (3*beta2^2)/2 + (5*beta3^2)/2 + (7*beta4^2)/2 + (9*beta5^2)/2 + (11*beta6^2)/2 + (13*beta7^2)/2 + (15*beta8^2)/2 + (17*beta9^2)/2 + (19*beta10^2)/2;
        end
    end

    if (get(handles.itse_wbc_mode_options,'Value') == 1) % G
        itse; % ITSE
    elseif (get(handles.itse_wbc_mode_options,'Value') == 2) % G_hat
        itse = 'Not yet available'
    else
        itse = 'No mode of operation set'
    end
    set(handles.itse_wbc_answer,'String',num2str(itse));
end


%------------------------- W(1) Reference Tracking -----------------------%


%     % IF reference tracking
%     if (get(handles.itse_wbc_itse_reference_tracking,'Value') == 1)
%     a = tf(num, den);
%     % CHECK STABILITY
%     roots = pole(a);
%     if abs(roots)<1
%         msg = 'Unstable system. Modulus of roots must be less than 1.';
%         error(msg)
%     end
%     
%     % CHECK SPECIAL CASE FOR WBC: IF Denominator is = 1
%     check_den = length(den);
%     if (check_den == 1 && den(1) == 1 && sum(num) == 1)
%         [row,col] = find(num>0,1,'last');
%         num_l = length(num);
%         n = num_l - col;
%         W = fliplr(num(1, 1:col));
%         w_num = length(W);
%         max = 15; % max value for W(G) in special case
%     end
%     
%     % IF SPECIAL CASE IS VALID
%     if (exist('w_num', 'var') == 1) && (w_num <=max)
%         W = [W zeros(1, max-w_num)];
%         omega = 1;
%         pitse = 1/2*(1/omega^2)*(n^2 + ((1 - W(1))^2)*(2*n + 1) + ...
%             ((1 - W(1) - W(2))^2)*(2*n + 3) + ... 
%             ((1 - W(1) - W(2) - W(3))^2)*(2*n + 5) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4))^2)*(2*n + 7) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5))^2)*(2*n + 9) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6))^2)*(2*n + 11) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7))^2)*(2*n + 13) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8))^2)*(2*n + 15) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9))^2)*(2*n + 17) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8)- W(9) - W(10))^2)*(2*n + 19) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11))^2)*(2*n + 21) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12))^2)*(2*n + 23)) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13))^2)*(2*n + 25) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13) - W(14))^2)*(2*n + 27) + ...
%             ((1 - W(1) - W(2) - W(3) - W(4) - W(5) - W(6) - W(7) - W(8) - W(9) - W(10) - W(11) - W(12) - W(13) - W(14) - W(15))^2)*(2*n + 29);
%     % ELSE TAKE GENERAL CASE
    
%-------------------------------------------------------------------------%


% --- Executes on button press in itse_wbc_clear_all.
function itse_wbc_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.itse_wbc_num,'String','');
set(handles.itse_wbc_den,'String','');
set(handles.itse_wbc_answer,'String','');

function itse_wbc_answer_Callback(hObject, eventdata, handles)
% hObject    handle to itse_wbc_answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itse_wbc_answer as text
%        str2double(get(hObject,'String')) returns contents of itse_wbc_answer as a double


% --- Executes during object creation, after setting all properties.
function itse_wbc_answer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itse_wbc_answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------%
%----------------------------- End ITSE (WBC) ----------------------------%
%-------------------------------------------------------------------------%


% ----------------------------------------------------------------------- %
% ------------------------ Begin ITpSE Classical ------------------------ %
% ----------------------------------------------------------------------- %


% --- Executes on selection change in itpse_classical_options.
function itpse_classical_options_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns itpse_classical_options contents as cell array
%        contents{get(hObject,'Value')} returns selected item from itpse_classical_options


% --- Executes during object creation, after setting all properties.
function itpse_classical_options_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itpse_classical_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function itpse_classical_num_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itpse_classical_num as text
%        str2double(get(hObject,'String')) returns contents of itpse_classical_num as a double


% --- Executes during object creation, after setting all properties.
function itpse_classical_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itpse_classical_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itpse_classical_den_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itpse_classical_den as text
%        str2double(get(hObject,'String')) returns contents of itpse_classical_den as a double


% --- Executes during object creation, after setting all properties.
function itpse_classical_den_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itpse_classical_den (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itpse_classical_answer_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itpse_classical_answer as text
%        str2double(get(hObject,'String')) returns contents of itpse_classical_answer as a double


% --- Executes during object creation, after setting all properties.
function itpse_classical_answer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itpse_classical_answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in itpse_classical_calculate.
function itpse_classical_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Input Error Checking
num = str2num(get(handles.itpse_classical_num,'String'));
den = str2num(get(handles.itpse_classical_den,'String'));

n = length(num);
d = length(den);

if (n==0 || d==0)
    errordlg('Pleade complete input fields.','Input Error');
    return;
end


% Calculates integral of time by the square error for any transfer
% function. Takes input of transfer function and order of integral being
% sought, i.e. IT^nSE.
NUM = str2num(get(handles.itpse_classical_num, 'String'));
DEN = str2num(get(handles.itpse_classical_den, 'String'));
ISE = (get(handles.itpse_classical_options, 'Value')==1);
ITSE = (get(handles.itpse_classical_options, 'Value')==2);
IT2SE = (get(handles.itpse_classical_options, 'Value')==3);

% Input Check on Radio Buttons -- Choose value of n
if ((ISE == 1) && (ITSE == 0) && (IT2SE == 0)) % Calculate ISE
    n = 0;
elseif ((ITSE == 1) && (ISE == 0) && (IT2SE == 0)) % Calculate ITSE
    n = 1;
elseif ((IT2SE == 1)  && (ITSE == 0) && (ISE == 0)) % Calculate IT2SE
    n = 2;
else error('Choose one criterion value only') % Too many radio buttons pressed
end

% function [itpse_classical_itse] = ITPSE_CLASSICAL_ITSE(NUM, DEN, n);
% Revision: 2.1 - include input as NUM and DEN

% Confirm stability
    stable = 1; % flag for instability
    [R, P, K] = residue(NUM, DEN); % P(j) are roots to denominator
    Y = sign(real(P)); % Find sign of real part of roots
    for j = 1:length(P) % Loop through roots
        if (Y(j) == 1), stable = -1; % if roots negative, flag
        end
    end

% Find IT^(order)SE
if (stable == 1) % If roots are stable
itse = zeros(3,1);
[A, B, C, D] = tf2ss(NUM, DEN);
P0 = (B*B');
N = 0;
while n >= N
    P = lyap(A, P0);
    N = N + 1;
    P0 = P;
    Chat = -C*(inv(A)); 
    itse(N,1) = Chat*P*(Chat'); % calculate ISE
end
else for N = 1:3 % % Roots not stable = ISE is infinity
    itse(N,1) = inf; % Output infinity, unstable system is useless
    end
    error('System input is not stable')
end
x = itse((n+1),1);
% % Set outputs
set(handles.itpse_classical_answer,'String',num2str(x));


% --- Executes on button press in itpse_classical_clear_all.
function itpse_classical_clear_all_Callback(hObject, eventdata, handles)
% hObject    handle to itpse_classical_clear_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.itpse_classical_num,'String','');
set(handles.itpse_classical_den,'String','');
set(handles.itpse_classical_answer,'String','');


% ----------------------------------------------------------------------- %
% -------------------------- End ITpSE Classical ------------------------ %
% ----------------------------------------------------------------------- %
