%% 625 for Experiment

vidObj = VideoReader('626EXP.wmv');
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
   k = k+1;
end

%% Put value
Numframes = k - 1;
% initialize
time = zeros(Numframes,1);
val = zeros(Numframes,4,1);
refnum = zeros(Numframes,2);
% save refimage
RefFramenum = 1;
RF = s(1).cdata;


for i = 1 : Numframes
    % extract image displacement and peak value to evaluate the correctness
    [Xi mpeak] = RIPOC_func(RF,s(i).cdata);
    % hoge
    time(i)=i/vidObj.FrameRate;
    
    % put value
    if mpeak > 0.05  % if extraction is succeed
        for j = 1 : 4
            val(i,j) = Xi(j);
            refnum(i,1) = RefFramenum;
            refnum(i,2) = mpeak;
        end
    else
        [Xi mpeak] = RIPOC_func(s(i-1).cdata,s(i).cdata);
        if mpeak > 0.05 % update ref
            RefFramenum = i-1;
            RF = s(i-1).cdata;
            for j = 1 : 4
                val(i,j) = Xi(j);
            refnum(i,1) = RefFramenum;
            refnum(i,2) = mpeak;
            end
        else % if update missed skip
            for j = 1 : 4
                val(i,j) = val(i-1,j);
                refnum(i,1) = RefFramenum;
                refnum(i,2) = mpeak;
            end
        end        
    end
end

%% showing
for i = 1:270
if val(i,4) > 180
    val(i,4) = val(i,4) - 360;
end
end
% cut additional data
val(find(val(:,1)==0),:) = [];
time(find(time(:,1)==0),:) = [];
refnum(find(refnum(:,1)==0),:) = [];


%
figure;
plot(time,refnum);
figure;
plot(time,val(:,1),time,val(:,2),time,val(:,3),time,val(:,4))

legend('dx','dy','scale','\theta');
