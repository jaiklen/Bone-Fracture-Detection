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

% Last Modified by GUIDE v2.5 20-Dec-2020 01:01:15

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global InputImage;
InputImage=uigetfile('.jpg');
InputImage=imread(InputImage);
%InputImage = imresize(InputImage,[200,300]);
axes(handles.axes1);
imshow(InputImage);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global GrayImage;
global InputImage;
global DenoisedImage;
global SharpenedImage;
global GaussianFilter;
GrayImage = rgb2gray(InputImage);
%figure, imshow(GrayImage), title('Gray Scale of the  Original X-Ray Image');
LaplacianFilter = [ 0 -1 0 ;-1 5 -1; 0 -1 0];
SharpenedImage = conv2(GrayImage,LaplacianFilter,'same');
%figure(2), imshow(uint8(SharpenedImage));
hsize = 25;
sigma = 0.1; 
GaussianFilter = fspecial('gaussian',hsize,sigma);
DenoisedImage = imfilter(SharpenedImage,GaussianFilter);

axes(handles.axes2);
imshow(uint8(DenoisedImage));
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global DenoisedImage;

global CannyImage;
operator = 'canny';
CannyImage = edge(DenoisedImage,operator);
axes(handles.axes3);
imshow((CannyImage));
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function text_edit_Callback(hObject, eventdata, handles)

% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_edit as text
%        str2double(get(hObject,'String')) returns contents of text_edit as a double


% --- Executes during object creation, after setting all properties.
function text_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global CannyImage;
global MinHoughPeakDistance;
global H,global T,global R, global pks,global maxHough, global HoughThresh;
global Peaks;
global NumPeaks;
MinHoughPeakDistance = 5;
[H,T,R] = hough(CannyImage,'RhoResolution',1,'Theta',-89.5:3:89.5);
maxHough = max(H, [], 1);
HoughThresh = (max(maxHough) + min(maxHough))/2;
[pks, Peaks] = findpeaks(maxHough,'MINPEAKHEIGHT',HoughThresh, 'MinPeakDistance', MinHoughPeakDistance);
NumPeaks = numel(Peaks);
axes(handles.axes4);
plot(T(Peaks), maxHough(Peaks), 'rx', 'MarkerSize', 12);
% Plot Hough detection results
%figure, plot(T, maxHough);
hold on
plot(T, maxHough);
hold off
hold on
plot([min(T) max(T)], [HoughThresh, HoughThresh], 'g');
hold off
ylabel('Max Hough Transform');
xlabel('Theta-value');
%plot(handles.axes4,T, maxHough);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global NumPeaks;
global Result;
Result = 'Fracture Not Found';
if NumPeaks > 1
    Result = 'Fracture Found';
end

disp(Result);
set(handles.text_edit,'string', Result);
%result='Total no. of cell = ';

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
