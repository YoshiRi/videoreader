%% read data1
filename = 'MappingNeighbor'
vidObj = VideoReader(strcat(filename,'.avi'));
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k=1;

Wid = 256;
Hei = 256;
while hasFrame(vidObj)
   s(k).cdata = readFrame(vidObj) ;
    k = k+1;
end


%% read data2
filename = 'MappingFull'
vidObj = VideoReader(strcat(filename,'.avi'));
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s2 = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k=1;
%%
v = VideoWriter('RedRectMappingNeighbor.avi');
v2 = VideoWriter('RedRectMappingFull.avi');
v.FrameRate = vidObj.FrameRate; % Framerate
v2.FrameRate = vidObj.FrameRate; % Framerate

open(v);
open(v2);


while hasFrame(vidObj)
   Map = RedSquare(readFrame(vidObj),[58 294 256 256]) ;
   s2(k).cdata = Map;
   Map2 = RedSquare(s(k).cdata, [58 294 256 256]) ;
    s(k).cdata = Map2;
   writeVideo(v2,s2(k).cdata);
   writeVideo(v,s(k).cdata);

   k = k+1;
end

close(v);
close(v2);



