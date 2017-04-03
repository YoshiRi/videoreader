close all;
clear all;

filename = 'tracked305_tyousei';

vidObj = VideoReader(strcat(filename,'.avi'));

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
Frate = vidObj.Framerate;

%% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;

% Open frame and do output
while hasFrame(vidObj)
   s(k).cdata = rgb2gray( readFrame(vidObj) );
  k = k+1;
end
Numframes = k - 1;

%% ���� or �����[�g��
addpath('C:\Users\yoshi\Documents\GitHub\videoreader\RIPOC_function')
%addpath('../../RIPOC_function')

%% do matching
% initialize
time = zeros(Numframes,1);
valMap = zeros(Numframes,Numframes,4); % buff
val_ref = zeros(Numframes,4,1); % real
peakMap = zeros(Numframes,Numframes,2);
mpeak=[0 0];

% save refimage
RefFramenum = 1;
RF = s(1).cdata;
RFnum = 1;

select = 10;

for i = 1 : Numframes-1
        % hoge
    time(i)=i/vidObj.FrameRate;
    for j = i+1 : Numframes
        % extract image displacement and peak value to evaluate the correctness
        [Xi ,mpeak] = RIPOC_func(s(i).cdata,s(j).cdata);
        peakMap(i,j,1) = mpeak(1); %max
        peakMap(i,j,2) = mpeak(2); %min

        for k = 1 : 4
            valMap(i,j,k) = Xi(k);
        end
        if j > i+select
            break;
        end
    end
end

%%
sname  = strcat(filename,'Result')
save(sname);

%%
