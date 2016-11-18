%% 715 for Experiment

filename = '1005_xyz';
inF = strcat(filename,'.wmv')
vidObj = VideoReader(inF);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;

%% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;

while hasFrame(vidObj)
   s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ cx - Wid/2, cy - Hei/2,Wid-1,Hei-1]) );
   outputname = ['img/','ref',num2str(k),'.png'];
   imwrite(s(k).cdata,outputname);
   k = k+1;
end


%% write reference video
outF = strcat(filename,'.avi');
v = VideoWriter(outF,'Uncompressed AVI');
v.FrameRate = 30;
open(v);

for i = 1:k-1
    writeVideo(v,s(i).cdata);
end
close(v)