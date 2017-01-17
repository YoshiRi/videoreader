% crop1
% 58   314
%  294   550

%% read data
filename = 'MappingNeighbor'
vidObj = VideoReader(strcat(filename,'.avi'));
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k=1;

%% write data
v = VideoWriter('CroppedMappingNeighbor.avi');
v.FrameRate = vidObj.FrameRate; % Framerate
open(v);

Wid = 256;
Hei = 256;
while hasFrame(vidObj)
   s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ 58, 294,Wid-1,Hei-1]) );
   writeVideo(v,s(k).cdata);
    k = k+1;
end

close(v);

%% sono2
%% read data
filename = 'MappingFull'
vidObj = VideoReader(strcat(filename,'.avi'));
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s2 = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k=1;

%% write data
v = VideoWriter('CroppedMappingFull.avi');
v2 = VideoWriter('CroppedMappingHikaku.avi');
v.FrameRate = vidObj.FrameRate; % Framerate
v2.FrameRate = vidObj.FrameRate; % Framerate

open(v);
open(v2);

Wid = 256;
Hei = 256;
while hasFrame(vidObj)
   s2(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ 58, 294,Wid-1,Hei-1]) );
   writeVideo(v,s2(k).cdata);
   writeVideo(v2,vertcat(s(k).cdata,s2(k).cdata));
   k = k+1;
end

close(v);
close(v2);

%% 
