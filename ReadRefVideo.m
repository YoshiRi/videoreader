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
figure(1);
plot(time,refnum(:,1),time,refnum(:,2)*100);
grid on;
legend('refnum','peak * 100');
xlabel('time[s]');ylabel('value')

figure(2);
plot(time,val(:,1),time,val(:,2),time,val(:,3),time,val(:,4))
grid on;
legend('dx','dy','\kappa','\theta','Location','best');
xlabel('time[s]');ylabel('image displacement')


%%
% [xi mpeak] = RIPOC_func(s(1).cdata,s(108).cdata);
% Re = imresize(s(108).cdata,1/xi(3));
% Re = imrotate(Re,xi(4));
% Re = imtranslate(Re,[-xi(1), -xi(2)]);
% Fused = imfuse(s(1).cdata,Re);
% imshow(Fused);

%% for making Vref 

val_ref = zeros(Numframes,4,1);
val_diff = zeros(Numframes-1,4);

for i = 1:Numframes
    if refnum(i,1) == 1
        val_ref(i,:) = val(i,:);
    else 
        j = refnum(i,1);
        val_ref(i,:) = val_ref(j,:) + val(i,:);
    end
% if refnum(i+1,1) == i 
%     val_diff(i,:) = (val_ref(i+1,:) - [0,0,1,0] ) .* vidObj.FrameRate;
% else
%     val_diff(i,:) = (val_ref(i+1,:) - val_ref(i,:)) .* vidObj.FrameRate;
% end
end

for i = 1:Numframes-1
          val_diff(i,:) = (val_ref(i+1,:) - val_ref(i,:)) .* vidObj.FrameRate;
end
val_diff2 = diff(val_ref)*vidObj.FrameRate;
val_diff2 = [val_diff];

figure(3);
plot(time,val_ref(:,1),time,val_ref(:,2),time,val_ref(:,3),time,val_ref(:,4))
grid on;
legend('dx','dy','\kappa','\theta','Location','best');
xlabel('time[s]');ylabel('image displacement')


figure(4);
plot(time(1:Numframes-1,1),val_diff(:,1),time(1:Numframes-1,1),val_diff(:,2),time(1:Numframes-1,1),val_diff(:,3),time(1:Numframes-1,1),val_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

%%
% Low pass
% N   = 100;        % FIR filter order
% Fp  = 20e3;       % 20 kHz passband-edge frequency
% Fs  = 96e3;       % 96 kHz sampling frequency
% Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
% Rst = 1e-4;       % Corresponds to 80 dB stopband attenuation
% 
% NUM = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % NUM = vector of coeffs
% 
% LP_FIR = dsp.FIRFilter('Numerator',NUM); % Or use NUM200 or NUM_MIN
% 
% val_diff() * LP_FIR
% ïœêîÇÃê›íË
a = 10;
b = ones(1,10);
LPval_diff = filter(b,a,val_diff);


figure(5);
plot(time(1:Numframes-1,1),LPval_diff(:,1),time(1:Numframes-1,1),LPval_diff(:,2),time(1:Numframes-1,1),LPval_diff(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

%% FFT
L =200;
Fs = vidObj.FrameRate;
P2 = abs( fft(val_ref(1:L,2)) /L );
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure;
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')