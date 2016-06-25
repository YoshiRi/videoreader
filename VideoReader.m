%% 625 for Experiment

vidObj = VideoReader('626EXP.wmv');
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
   s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ cx-Wid/2,cy-Hei/2,Wid-1,Hei-1]) );
   k = k+1;
end

Numframes = k;

time = zeros(Numframes,1);
val = zeros(Numframes,4,1);
refnum = zeros(Numframes,2);

init = 1;
RF = s(1).cdata;
RefFrames(init) = RF; 

for i = 1 : Numframes   
    [Xi mpeak] = RIPOC_func(RF,s(i).cdata);
    
    if mpeak > 0.05
        for j = 1 : 4
            val(i,j) = Xi;
            refnum(i) = 
        end
    time(i)=i/vidObj.FrameRate;
    
end

close
AI = s(k).cdata;
BI = s(k+1).cdata;
IA=rgb2gray(AI);
IB=rgb2gray(BI);
