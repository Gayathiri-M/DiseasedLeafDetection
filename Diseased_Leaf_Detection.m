function varargout = Diseased_Leaf_Detection(varargin)
% DISEASED_LEAF_DETECTION MATLAB code for Diseased_Leaf_Detection.fig
%      DISEASED_LEAF_DETECTION, by itself, creates a new DISEASED_LEAF_DETECTION or raises the existing
%      singleton*.
%
%      H = DISEASED_LEAF_DETECTION returns the handle to a new DISEASED_LEAF_DETECTION or the handle to
%      the existing singleton*.
%
%      DISEASED_LEAF_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISEASED_LEAF_DETECTION.M with the given input arguments.
%
%      DISEASED_LEAF_DETECTION('Property','Value',...) creates a new DISEASED_LEAF_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Diseased_Leaf_Detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Diseased_Leaf_Detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Diseased_Leaf_Detection

% Last Modified by GUIDE v2.5 29-Nov-2020 10:47:19

% --- CopyRight ---@Group11 ---Diseased Leaf Detection ---Level II Sem
% I--University of Ruhuna.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Diseased_Leaf_Detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Diseased_Leaf_Detection_OutputFcn, ...
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


% --- Executes just before Diseased_Leaf_Detection is made visible.
function Diseased_Leaf_Detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Diseased_Leaf_Detection (see VARARGIN)

% Choose default command line output for Diseased_Leaf_Detection
handles.output = hObject;
set(handles.axes1,'XColor','w');
set(handles.axes1,'YColor','w');

set(handles.axes2,'XColor','w');
set(handles.axes2,'YColor','w');

set(handles.axes3,'XColor','w');
set(handles.axes3,'YColor','w');

set(handles.axes4,'XColor','w');
set(handles.axes4,'YColor','w');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Diseased_Leaf_Detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Diseased_Leaf_Detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InputButton.
function InputButton_Callback(hObject, eventdata, handles)
%Getting image path
[fname, path]=uigetfile({'*.jpg*';'*.jpgC*';'*.jpeg*';'*.png*';'*.bmp*'},'Select a leaf image');

%setting image name and loading it in
I=imread([path,fname]);

%Resizing image
I1= imresize(I,[425 425]);
I2 = imresize(I1,[425,425]);

%display it in axes1
axes(handles.axes1);
imshow(I2)
title('Inserted Image');
axis off;

%saving image data handle in other functions
handles.ImgData1=I2;

guidata(hObject,handles);

% --- Executes on button press in ContrastButton.
function ContrastButton_Callback(hObject, eventdata, handles)

%Loading image, saved in handles
I = handles.ImgData1;

%setting contrast of images
Ic = imadjust(I,stretchlim(I));

%Resizing image
Ic= imresize(Ic,[425 425]);
IC= imresize(Ic,[425 425]);

%display it in axes1
axes(handles.axes2);
imshow(IC)
title('Contrast Enhanced Image');
axis off;

%saving contrast enhanced image data 
handles.ImgData2=IC;

guidata(hObject,handles);


% --- Executes on button press in EnhanceButton.
function EnhanceButton_Callback(hObject, eventdata, handles)
%loading the contrast enhanced image
I=handles.ImgData2;

%Extract the individual component images.
rgb = im2double(I);
r = rgb(:, :, 1);
g = rgb(:, :, 2);
b = rgb(:, :, 3);

% Implement the conversion equations.
num = 0.5*((r - g) + (r - b));
den = sqrt((r - g).^2 + (r - b).*(g - b));
theta = acos(num./(den + eps));

H = theta;
H(b > g) = 2*pi - H(b > g);
H = H/(2*pi);

num = min(min(r, g), b);
den = r + g + b;
den(den == 0) = eps;
S = 1 - 3.* num./den;

H(S == 0) = 0;

I = (r + g + b)/3;

% Combine all three results into an hsi image.
hsi = cat(3, H, S, I);

%saving hsi image data
handles.ImgData3=hsi;

%displaying image
axes(handles.axes3);
imshow(hsi)
title('HSI Image');
axis off;

guidata(hObject,handles);


% --- Executes on button press in SegmentButton.
function SegmentButton_Callback(hObject, eventdata, handles)

%Loading Thresholded image
I=handles.ImgData3;

%resizing image to fit in axes
I=imresize(I,[425 425]);
I=imresize(I,[425 425]);

%grayscaling
Ig=rgb2gray(I);

%adjusting the contrast of grayscaled image
Ig=histeq(Ig);

%Thresholding
Itg=Ig<150;

%removing noise in thresholded image
Itg=medfilt2(Itg);


%Patch counting function

i=handles.ImgData2;
i1=im2bw(i);

axes(handles.axes4);
imshow(i1)
title('Checking status....');
pause(3)


i1=double(i1);
i2=imfill(i1,'holes');
[L Ne]=bwlabel(double(i2));

prop=regionprops(L,'Area','Centroid');

total=0;


for n=1:size(prop,20)
    patch=prop(n).Centroid;
    X=patch(1);
    Y=patch(2);
    if prop(n).Area>175
        total=total+1;
    else
        total=total;
         
    end
end

c=total;

%checking whether there is any patch and if so pirinting diseased
if(c>0)
   set(handles.edit1,'String','Diseased Leaf');
elseif(c==0)
   set(handles.edit1,'String','Healthy Leaf');
else
    set(handles.edit1,'String','');
end


%displaying image
axes(handles.axes4);

imshow(Ig)
title('Segmented Image');

axis off;

%saving thresholded & smoothened image data 
handles.i=Itg;

guidata(hObject,handles);

% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)

c=[0.8 1.0 0.8];

cla(handles.axes1,'reset');
set(handles.axes1,'Color',c);
set(handles.axes1,'XColor','w');
set(handles.axes1,'YColor','w');

cla(handles.axes2,'reset');
set(handles.axes2,'Color',c);
set(handles.axes2,'XColor','w');
set(handles.axes2,'YColor','w');

cla(handles.axes3,'reset');
set(handles.axes3,'Color',c);
set(handles.axes3,'XColor','w');
set(handles.axes3,'YColor','w');

cla(handles.axes4,'reset');
set(handles.axes4,'Color',c);
set(handles.axes4,'XColor','w');
set(handles.axes4,'YColor','w');

set(handles.edit1,'String','');

guidata(hObject,handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
exit();
guidata(hObject,handles);
