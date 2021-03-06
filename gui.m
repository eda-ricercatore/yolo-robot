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

% Last Modified by GUIDE v2.5 18-Dec-2013 11:01:10

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

axis off;
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


% --- Executes on selection change in lstOutputBox.
function lstOutputBox_Callback(hObject, eventdata, handles)
% hObject    handle to lstOutputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lstOutputBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstOutputBox


% --- Executes during object creation, after setting all properties.
function lstOutputBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstOutputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnImportVideo.
function btnImportVideo_Callback(hObject, eventdata, handles)
% hObject    handle to btnImportVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% open prompt to select file
[filename, pathname] = uigetfile('videos/*.avi', 'Select the file to be imported');
importfile = strcat(pathname, filename);
vid = VideoReader(importfile);
handles.vid = vid;

% Rolling Cell to keep track of latest plates
last_plates = {'AA-AA-AA', 'AA-AA-AB', 'AA-AA-AC', 'AA-AA-AD', 'AA-AA-AE'};
spotted_plates = {'','','',''};
spotted_plates_idx = 1;

% Immediately start processing video
totalframes = vid.NumberOfFrames;
framerate   = vid.FrameRate;
for i = 1:totalframes
    % show frame in axes
    frame = read(vid,i);
    [box,crop,hit] = detectPlate(frame);

    % Clear axes and display next frame
    axes(handles.axsVideoOutput);
    cla;

    %if statement to check that platenum is not the same as the previous
    %entry before adding to listbox

    image(frame);
    % check invoeren om runtime te optimaliseren (intensity difference
    % oid).
    if hit > 0
        hold on;

        for j = 1:hit
            rectangle('Position',box(j,:),'EdgeColor','r','LineWidth',2);
            [plateimg, platenum] = plateident(crop{j});
            axes(handles.axsSeg);
            imshow(plateimg);
            axis off;
            plate = validatePlate(platenum);
            if ~strcmp(plate,'')
                last_plates{rem(i,5)+1} = plate;
                index = processRollingCell(last_plates);
                if index
                    spotted_plate = last_plates{index};
                    if ~ismember(spotted_plate,spotted_plates(:,1))
                        maker = getCarMaker(spotted_plate);
                        if ~strcmp(maker,'')
                            spotted_plates{spotted_plates_idx,1} = spotted_plate;
                            spotted_plates{spotted_plates_idx,2} = i;
                            spotted_plates{spotted_plates_idx,3} = i/framerate;
                            spotted_plates{spotted_plates_idx,4} = maker;
                            spotted_plates_idx = spotted_plates_idx + 1;
                            set(handles.platesTable,'Data',spotted_plates);
                        end
                    end
                end
            end

%             oldString = get(handles.lstOutputBox,'String');
%             set(handles.lstOutputBox,'String', plate);
            %check om te zien of platenum al in listbox zit, anders
            %toevoegen
        end
    end

    set(handles.txtFrame,'String',strcat(int2str(i),' / ',int2str(totalframes)));
    axis off;
    guidata(hObject,handles);
end

% --- Executes on button press in btnProcessVideo.
% function btnProcessVideo_Callback(hObject, eventdata, handles)
% hObject    handle to btnProcessVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% licensevid = read(handles.vid);
% totalframes = length(licensevid(1,1,1,:));
% for i = 1:totalframes
%     % show frame in axes
%     frame = read(handles.vid,i);
%     [box,crop,hit] = detectPlate(frame);
%     axes(handles.axsVideoOutput);
%     plate = im2bw(lapgauss(crop));
%     platenum = plateident(plate);
%     
%     %if statement to check that platenum is not the same as the previous
%     %entry before adding to listbox
%     
%     image(frame);
%     if hit
%         hold on;
%         rectangle('Position',box,'EdgeColor','r','LineWidth',2);
%     end
%     
%     set(handles.txtFrame,'String',strcat(int2str(i),' / ',int2str(totalframes)));
%     axis off;
%     % take frame and perform SIFT
%     
%     % cut license plate file and send to decipher.m, log frame nr and time
% 
%     % print deciphered license plate in lstOutputBox
% 
% end
