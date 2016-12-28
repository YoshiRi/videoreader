%% 1228 for Experiment

 addpath('../');


%% read data
filename = '1228'
vidObj = VideoReader(strcat(filename,'.wmv'));
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
            end
            refnum(i,1) = RefFramenum;
            refnum(i,2) = mpeak;    
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
% refnum and ref frame
figure(1); 
plot(time,refnum(:,1),time,refnum(:,2)*100);
grid on;
legend('refnum','peak * 100');
xlabel('time[s]');ylabel('value')

% raw data
figure(2);
plot(time,val(:,1),time,val(:,2),time,val(:,3),time,val(:,4))
grid on;
legend('dx','dy','\kappa','\theta','Location','best');
xlabel('time[s]');ylabel('image displacement')


%% for making Vref 

val_ref = zeros(Numframes,4,1);
val_diff = zeros(Numframes-1,4);
val_diff2 = zeros(Numframes-1,4);

% Referenceをつなげる
for i = 1:Numframes
    if refnum(i,1) == 1
        val_ref(i,:) = val(i,:);
    else 
        j = refnum(i,1);
        % rotate and scaleing for translation
        cs = cosd(val_ref(j,4)) * val_ref(j,3);
        sn = sind(val_ref(j,4)) * val_ref(j,3);
        val_ref(i,1) = val_ref(j,1) + val(i,1)*cs + val(i,2)*sn;
        val_ref(i,2) = val_ref(j,2) - val(i,1)*sn + val(i,2)*cs;
        val_ref(i,3) = val_ref(j,3) * val(i,3);
        val_ref(i,4) = val_ref(j,4) + val(i,4);
    end
end

% do time derivative
% val_diff2 : 中心差分
for i = 1:Numframes-1
          val_diff(i,:) = (val_ref(i+1,:) - val_ref(i,:)) .* vidObj.FrameRate;
          if i == 1
              val_diff2(i,:) =  (val_ref(i+1,:) -[0,0,1,0]) .* (2 *vidObj.FrameRate);
          else
              val_diff2(i,:) =  (val_ref(i+1,:) - val_ref(i-1,:)) .* (2 *vidObj.FrameRate);
          end
end


figure(3);
plot(time,val_ref(:,1),time,val_ref(:,2),time,val_ref(:,3),time,val_ref(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('shapedRef');

figure(4);
plot(time(1:Numframes-1,1),val_diff(:,1),time(1:Numframes-1,1),val_diff(:,2),time(1:Numframes-1,1),val_diff(:,3),time(1:Numframes-1,1),val_diff(:,4))
grid on;
% legend('$\xi_x_{ref}$','$\dot{\xi_y}_{ref}$','$\dot{\kappa}_{ref}$','$\dot{\theta}_{ref}$','Interpreter','latex','Location','best');
% xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('後退差分');

figure(5);
plot(time(1:Numframes-1,1),val_diff2(:,1),time(1:Numframes-1,1),val_diff2(:,2),time(1:Numframes-1,1),val_diff2(:,3),time(1:Numframes-1,1),val_diff(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex');
title('中心差分');

%% Filtering

%  移動平均 ゼロ位相差
a1 = 20;
b1 = ones(1,20);
%LPval_diff = filter(b,a,val_diff2);
LPval_diff = filtfilt(b1,a1,val_diff2);

%  ローパス
N   = 10;        % FIR filter order
Fp  = 0.005;       % 10 Hz passband-edge frequency
Fs  = vidObj.FrameRate;       % 33 Hz sampling frequency
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation
NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge');
a2 =1;
b2 = NUM;
LPval_diff2 = filtfilt(lpFilt,val_diff2);

% butterworse 10dim 
% 15 fps Cutoff : 0.75 fps -> 0.75 * 2*pi /15
 [b2,a2] = butter(15, 0.75 * 2 /15);
LPval_diff2 = filtfilt(b2,a2,val_diff2);



figure(6);
plot(time(1:Numframes-1,1),LPval_diff(:,1),time(1:Numframes-1,1),LPval_diff(:,2),time(1:Numframes-1,1),LPval_diff(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('移動平均フィルタ15点');

figure(7);
plot(time(1:Numframes-1,1),LPval_diff2(:,1),time(1:Numframes-1,1),LPval_diff2(:,2),time(1:Numframes-1,1),LPval_diff2(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('ローパスフィルタbutterworse');


%% add Image Jacob-1
Z0 = 667.5;
f = 820;
T0 = 0;
cs = cosd(T0); sn = sind(T0);
Jinv = [ Z0/f *cs -Z0/f * sn 0 0;
            Z0/f *sn Z0/f * cs 0 0;
            0 0 Z0 0;
            0 0 0 -1];
Vref1 = zeros(Numframes-1,4);
Vref2 = zeros(Numframes-1,4);
Vrefr = zeros(Numframes-1,4);
        
for i = 1:Numframes-1
    ref = Jinv * LPval_diff(i,:)'
    Vref1(i,:) = ref';
    ref = Jinv * LPval_diff2(i,:)'
    Vref2(i,:) = ref';
    ref = Jinv * val_diff(i,:)'
    Vrefr(i,:) = ref';
end

figure(8);
plot(time(1:Numframes-1,1),Vref1(:,1),time(1:Numframes-1,1),Vref1(:,2),time(1:Numframes-1,1),Vref1(:,3),time(1:Numframes-1,1),Vref1(:,4))
grid on;
legend('X_{ref}','Y_{ref}','Z_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('移動平均')

figure(9);
plot(time(1:Numframes-1,1),Vref2(:,1),time(1:Numframes-1,1),Vref2(:,2),time(1:Numframes-1,1),Vref2(:,3),time(1:Numframes-1,1),Vref2(:,4))
grid on;
legend('X_{ref}','Y_{ref}','Z_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('ローパス')


figure(10);
plot(time(1:Numframes-1,1),Vrefr(:,1),time(1:Numframes-1,1),Vrefr(:,2),time(1:Numframes-1,1),Vrefr(:,3),time(1:Numframes-1,1),Vrefr(:,4))
grid on;
legend('X_{ref}','Y_{ref}','Z_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('生データ')


%% Print to file
% time refnum ref1 ref2 
% fileID = fopen('refdata1.txt','w');
output= horzcat(time(1:Numframes-1,1), refnum(1:Numframes-1,1),  val_ref(1:Numframes-1,1),val_ref(1:Numframes-1,2),val_ref(1:Numframes-1,3),val_ref(1:Numframes-1,4)   ,LPval_diff(:,1),LPval_diff(:,2),LPval_diff(:,3),LPval_diff(:,4));
dlmwrite('refdata1.txt',output); 
output2= horzcat(time(1:Numframes-1,1), refnum(1:Numframes-1,1),  val_ref(1:Numframes-1,1),val_ref(1:Numframes-1,2),val_ref(1:Numframes-1,3),val_ref(1:Numframes-1,4)   ,LPval_diff2(:,1),LPval_diff2(:,2),LPval_diff2(:,3),LPval_diff2(:,4));
dlmwrite('refdata2.txt',output2); 
 
%
  save('1228exp.mat');
  
 %%  Save as Img and Video
 SaveRefVideo(filename);