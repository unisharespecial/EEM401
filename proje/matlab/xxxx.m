function varargout = xxxx(varargin)
% XXXX M-file for xxxx.fig
%      XXXX, by itself, creates a new XXXX or raises the existing
%      singleton*.
%
%      H = XXXX returns the handle to a new XXXX or the handle to
%      the existing singleton*.
%
%      XXXX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XXXX.M with the given input arguments.
%
%      XXXX('Property','Value',...) creates a new XXXX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xxxx_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xxxx_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xxxx

% Last Modified by GUIDE v2.5 16-Dec-2010 15:40:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xxxx_OpeningFcn, ...
                   'gui_OutputFcn',  @xxxx_OutputFcn, ...
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


% --- Executes just before xxxx is made visible.
function xxxx_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xxxx (see VARARGIN)

% Choose default command line output for xxxx
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xxxx wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xxxx_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
handles.I = imread('C:\Documents and Settings\Administrator\Desktop\DSP proje_20794753\31.jpg');
imshow(handles.I);
axes(handles.axes3);
handles.Y = imread('C:\Documents and Settings\Administrator\Desktop\DSP proje_20794753\logo.jpg');
imshow(handles.Y);
% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);





% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.J = imnoise(handles.I,'speckle',0.130);
axes(handles.axes2);
imshow(handles.J);
handles.MI=rgb2gray(handles.J);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
handles.NI=uint8(conv2(double(handles.MI),mask1));
axes(handles.axes4);
imshow(handles.NI);
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.K = imnoise(handles.I,'salt & pepper',0.130);
axes(handles.axes2);
imshow(handles.K);
handles.MI=rgb2gray(handles.K);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
handles.NI=uint8(conv2(double(handles.MI),mask1));
axes(handles.axes4);
imshow(handles.NI);
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.L = imnoise(handles.I,'poisson');
axes(handles.axes2);
imshow(handles.L);
handles.MI=rgb2gray(handles.L);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
handles.NI=uint8(conv2(double(handles.MI),mask1));
axes(handles.axes4);
imshow(handles.NI);
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.N = imnoise(handles.I,'gaussian',1,5);
axes(handles.axes2);
imshow(handles.N);
handles.MI=rgb2gray(handles.N);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
handles.NI=uint8(conv2(double(handles.MI),mask1));
axes(handles.axes4);
imshow(handles.NI);
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.N = imnoise(handles.I,'gaussian',1,5);
handles.O = imnoise(handles.N,'poisson');
handles.P = imnoise(handles.N,'salt & pepper',0.065);
handles.R = imnoise(handles.N,'speckle',0.130);
axes(handles.axes2);
imshow(handles.R);
handles.MI=rgb2gray(handles.R);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
handles.NI=uint8(conv2(double(handles.MI),mask1));
axes(handles.axes4);
imshow(handles.NI);
guidata(hObject, handles);
