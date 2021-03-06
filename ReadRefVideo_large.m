%% 625 for Experiment

vidObj = VideoReader('627Hand.wmv');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
slarge = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;

%% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;
lWid = 320;
lHei = 320;


while hasFrame(vidObj)
    Orig = readFrame(vidObj);
   s(k).cdata = rgb2gray( imcrop(Orig,[ cx - Wid/2, cy - Hei/2,Wid-1,Hei-1]) );
   slarge(k).cdata = rgb2gray( imresize(imcrop(Orig,[ cx - lWid/2, cy - lHei/2,lWid-1,lHei-1]),[Wid Hei]) );
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
RF = slarge(1).cdata;


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
        [Xi mpeak] = RIPOC_func(slarge(i-1).cdata,s(i).cdata);
        if mpeak > 0.05 % update ref
            RefFramenum = i-1;
            RF = slarge(i-1).cdata;
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
for i = 1:Numframes
if val(i,4) > 180
    val(i,4) = val(i,4) - 360;
end
end
% cut additional data
val(find(val(:,1)==0),:) = [];
time(find(time(:,1)==0),:) = [];
refnum(find(refnum(:,1)==0),:) = [];


%% plot res
figure(3);
plot(time,refnum(:,1),time,refnum(:,2)*100);
grid on;
legend('refnum','peak * 100');
xlabel('time[s]');ylabel('value')

figure(4);
plot(time,val(:,1),time,val(:,2),time,val(:,3),time,val(:,4))
grid on;
legend('dx','dy','1/scale','\theta');
xlabel('time[s]');ylabel('image displacement')


%%
% [xi mpeak] = RIPOC_func(s(1).cdata,s(108).cdata);
% Re = imresize(s(108).cdata,1/xi(3));
% Re = imrotate(Re,xi(4));
% Re = imtranslate(Re,[-xi(1), -xi(2)]);
% Fused = imfuse(s(1).cdata,Re);
% imshow(Fused);

