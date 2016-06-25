%% 625 for Experiment

vidObj = VideoReader('speed10_down.MOV');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;

%% define cx cy = center.x center.y     Width and Height
cx = vidHeight/2;
cy = vidWidth/2;
Wid = 256;
Hei = 256;

while hasFrame(vidObj)
   s(k).cdata = imcrop(readFrame(vidObj),[ cx-Wid/2,cy-Hei/2,Wid-1,Hei-1]);

%% See the Position
%     crop = imcrop(Map.ans,[ cx-W/2,cy-H/2,W-1,H-1]);
%     s(k).cdata = crop;
    k = k+1;
end

% for k=200: 260
% run('POC.m');
% 
% end


time = zeros(100,1);
zure = zeros(100,1);
for i = 1 : 100
    k=i+199;
    POC;
    zure(i)=dy;
    time(i)=i/vidObj.FrameRate;
    
end

close
AI = s(k).cdata;
BI = s(k+1).cdata;
IA=rgb2gray(AI);
IB=rgb2gray(BI);
