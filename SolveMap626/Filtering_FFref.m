%% read data

clear all;
close all;

load('Reference626EXP');

vidObj = VideoReader('626EXP.wmv');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;

% define cx cy = center.x center.y     Width and Height
cy = vidHeight/2;
cx = vidWidth/2;
Wid = 256;
Hei = 256;
Numframes = n;

%% 
val_diff = zeros(Numframes-1,4);
val_diffn = zeros(Numframes-1,4);
val_diffs = zeros(Numframes-1,4);



for i = 1:Numframes-1
          if i == 1
              val_diff(i,:) =  (T_val(i+1,:) -[0,0,1,0]) .* (2 *vidObj.FrameRate);
              val_diffn(i,:) =  (nT_val(i+1,:) -[0,0,1,0]) .* (2 *vidObj.FrameRate);
              val_diffs(i,:) =  (sT_val(i+1,:) -[0,0,1,0]) .* (2 *vidObj.FrameRate);
          else
              val_diff(i,:) =  (T_val(i+1,:) - T_val(i-1,:)) .* (2 *vidObj.FrameRate);
              val_diffn(i,:) =  (nT_val(i+1,:) - nT_val(i-1,:)) .* (2 *vidObj.FrameRate);
              val_diffs(i,:) =  (sT_val(i+1,:) - sT_val(i-1,:)) .* (2 *vidObj.FrameRate);
          end
end

figure(3);
plot(time,T_val(:,1),time,T_val(:,2),time,T_val(:,3),time,T_val(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 


figure(4);
plot(time(1:Numframes-1,1),val_diff(:,1),time(1:Numframes-1,1),val_diff(:,2),time(1:Numframes-1,1),val_diff(:,3),time(1:Numframes-1,1),val_diff(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('$\frac{d}{dt}\xi_{ref}$ with Map','Interpreter','latex');

figure(5);
plot(time(1:Numframes-1,1),val_diffn(:,1),time(1:Numframes-1,1),val_diffn(:,2),time(1:Numframes-1,1),val_diffn(:,3),time(1:Numframes-1,1),val_diffn(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('$\frac{d}{dt}\xi_{ref}$ with neighbor','Interpreter','latex');

figure(6);
plot(time(1:Numframes-1,1),val_diffs(:,1),time(1:Numframes-1,1),val_diffs(:,2),time(1:Numframes-1,1),val_diffs(:,3),time(1:Numframes-1,1),val_diffs(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('$\frac{d}{dt}\xi_{ref}$ with neighbor','Interpreter','latex');

%%

%  移動平均 ゼロ位相差
a = 10;
b = ones(1,10);
%LPval_diff = filter(b,a,val_diffn);
LPval_diff = filtfilt(b,a,val_diff);
LPval_diffs = filtfilt(b,a,val_diffs);


%  ローパス
N   = 10;        % FIR filter order
Fp  = 0.005;       % 10 Hz passband-edge frequency
Fs  = vidObj.FrameRate;       % 33 Hz sampling frequency
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation

NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge');

a =1;
b = NUM;
LPval_diff2 = filtfilt(b,a,val_diff);
LPval_diff2s = filtfilt(b,a,val_diff);

% lp2=dsp.FIRFilter('Numerator',NUM);


figure(7);
plot(time(1:Numframes-1,1),LPval_diff(:,1),time(1:Numframes-1,1),LPval_diff(:,2),time(1:Numframes-1,1),LPval_diff(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

figure(8);
plot(time(1:Numframes-1,1),LPval_diff2(:,1),time(1:Numframes-1,1),LPval_diff2(:,2),time(1:Numframes-1,1),LPval_diff2(:,3),time(1:Numframes-1,1),LPval_diff2(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

figure(9);
plot(time(1:Numframes-1,1),LPval_diffs(:,1),time(1:Numframes-1,1),LPval_diffs(:,2),time(1:Numframes-1,1),LPval_diffs(:,3),time(1:Numframes-1,1),LPval_diffs(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

figure(10);
plot(time(1:Numframes-1,1),LPval_diff2s(:,1),time(1:Numframes-1,1),LPval_diff2s(:,2),time(1:Numframes-1,1),LPval_diff2s(:,3),time(1:Numframes-1,1),LPval_diff2s(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

% 今回は平均移動フィルタを採用

%% Print to file
% time refnum ref1 ref2 
% fileID = fopen('refdata1.txt','w');
refnum = ones(Numframes,1);
lower = horzcat(time(1:Numframes-1,1), refnum(1:Numframes-1,1),  T_val(1:Numframes-1,1),T_val(1:Numframes-1,2),T_val(1:Numframes-1,3),T_val(1:Numframes-1,4)   ,LPval_diff(:,1),LPval_diff(:,2),LPval_diff(:,3),LPval_diff(:,4));
init = [0,1,0,0,1,0,0,0,0,0];
output = vertcat(init,lower);
dlmwrite('626EXP_Ref.txt',output); 
 