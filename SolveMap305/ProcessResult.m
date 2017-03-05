filename = 'tracked305_tyousei';
flag = 0

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
   s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ cx - Wid/2, cy - Hei/2,Wid-1,Hei-1]) );
if flag == 1
   outputname = ['img/','ref',num2str(k),'.png'];
   imwrite(s(k).cdata,outputname);
end
   k = k+1;
end


%% write reference video
outF = strcat(filename,'_processed.avi');
v = VideoWriter(outF,'UnCompressed AVI');
v.FrameRate = Frate;
open(v);

for i = 1:k-1
    writeVideo(v,s(i).cdata);
end
close(v)
