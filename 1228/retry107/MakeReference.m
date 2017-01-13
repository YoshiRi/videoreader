%% function MakeReference(filename)
clear all

% read data
filename = '1228'

vidObj = VideoReader(strcat(filename,'.wmv'));

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
   k = k+1;
end
Numframes = k - 1;


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
RFnum = 1;

for i = 1 : Numframes
    % extract image displacement and peak value to evaluate the correctness
    [Xi mpeak] = RIPOC_func(RF,s(i).cdata);
    % hoge
    time(i)=i/vidObj.FrameRate;
    refnum(i,2) = mpeak;

    if mpeak > 0.025
        for j = 1 : 4
            val(i,j) = Xi(j);
            val_ref(i,j) = Xi(j);
            refnum(i,1) = RFnum;
        end
        if i==1
            continue; 
        end
        % put value
        cs = cosd(val_ref(RFnum,4)) * val_ref(RFnum,3);
        sn = sind(val_ref(RFnum,4)) * val_ref(RFnum,3);
        val_ref(i,1) = val_ref(RFnum,1) + val(i,1)*cs + val(i,2)*sn;
        val_ref(i,2) = val_ref(RFnum,2) - val(i,1)*sn + val(i,2)*cs;
        val_ref(i,3) = val_ref(RFnum,3) * val(i,3);
        val_ref(i,4) = val_ref(RFnum,4) + val(i,4);
        RF = s(i).cdata; % set current image as next reference
        RFnum = i; % set current image as next reference
    else
        refnum(i,1) = 0;
    end
    
    if refnum(i-1) == 0 %前の値がポンコツ丸だった場合
        val_ref(i-1,1) = (val_ref(i,1) + val(i-2,1))/2 ;
        val_ref(i-1,2) = (val_ref(i,2) + val(i-2,2))/2 ;
        val_ref(i-1,3) = sqrt(val_ref(i,3) * val(i-2,3));
        val_ref(i-1,4) = (val_ref(i,4) + val(i-2,4))/2;        
    end
    
end
save(strcat(filename,'test107.mat'));

%%
figure(3);
plot(time,val_ref(:,1),time,val_ref(:,2),time,val_ref(:,3),time,val_ref(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('shapedRef');

%%
VideoMapping;
