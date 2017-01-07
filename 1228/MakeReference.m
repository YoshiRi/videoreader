%% function MakeReference(filename)
clear all
 addpath('../');

% read data
filename = '1228'

% get video
vidObj = VideoReader('1228.avi');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'));

% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;

%% get cropped video
k = 1;
% while hasFrame(vidObj)
%    s(k).cdata = rgb2gray( imcrop(readFrame(vidObj),[ cx - Wid/2, cy - Hei/2,Wid-1,Hei-1]) );
%    k = k+1;
% end
while hasFrame(vidObj)
   s(k).cdata = rgb2gray(  readFrame(vidObj) );
   k = k+1;
end

whos s



%% Put value
Numframes = k - 1;
% initialize
time = zeros(Numframes,1);
val = zeros(Numframes,4,1); % buff
val_ref = zeros(Numframes,4,1); % real
refnum = zeros(Numframes,2);
% save refimage
RefFramenum = 1;
RF = s(1).cdata;

for i = 1 : Numframes
    % extract image displacement and peak value to evaluate the correctness
    [Xi mpeak] = RIPOC_func(RF,s(i).cdata);
    % hoge
    time(i)=i/vidObj.FrameRate;
    for j = 1 : 4
        val(i,j) = Xi(j);
        val_ref(i,j) = Xi(j);
        refnum(i,1) = 1;
        refnum(i,2) = mpeak;
    end
    
    if i==1
        continue; 
    end
    % if i >=2
    RF = s(i).cdata;    
    % put value
    j = i-1;
    cs = cosd(val_ref(j,4)) * val_ref(j,3);
    sn = sind(val_ref(j,4)) * val_ref(j,3);
    val_ref(i,1) = val_ref(j,1) + val(i,1)*cs + val(i,2)*sn;
    val_ref(i,2) = val_ref(j,2) - val(i,1)*sn + val(i,2)*cs;
    val_ref(i,3) = val_ref(j,3) * val(i,3);
    val_ref(i,4) = val_ref(j,4) + val(i,4);
end
save(strcat(filename,'test107.mat'));

%%
figure(3);
plot(time,val_ref(:,1),time,val_ref(:,2),time,val_ref(:,3),time,val_ref(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('shapedRef');
