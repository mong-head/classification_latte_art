function varargout = gui_latte(varargin)
% GUI_LATTE MATLAB code for gui_latte.fig
%      GUI_LATTE, by itself, creates a new GUI_LATTE or raises the existing
%      singleton*.
%
%      H = GUI_LATTE returns the handle to a new GUI_LATTE or the handle to
%      the existing singleton*.
%
%      GUI_LATTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_LATTE.M with the given input arguments.
%
%      GUI_LATTE('Property','Value',...) creates a new GUI_LATTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_latte_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_latte_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_latte

% Last Modified by GUIDE v2.5 08-Jun-2019 19:45:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_latte_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_latte_OutputFcn, ...
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


% --- Executes just before gui_latte is made visible.
function gui_latte_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_latte (see VARARGIN)

% Choose default command line output for gui_latte
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_latte wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_latte_OutputFcn(hObject, eventdata, handles) 
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

[file,path] = uiputfile('*.jpg','latte art image');
latte_image = sprintf('%s%s',path,file);
axes(handles.axes1);
imshow(latte_image);

[latte_label,latte_score] = new_image_classify(latte_image);
set(handles.label,'String',latte_label);
set(handles.score,'String',latte_score+"%");
drawnow;
