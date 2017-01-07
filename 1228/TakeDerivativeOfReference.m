%% function TakeDerivativeOfReference
Numframes = size(val_ref,1);
fnum = 5;

val_diff2 = zeros(Numframes-1,4);

for i = 1:Numframes-1
          if i == 1
              val_diff2(i,:) =  (val_ref(i+1,:) -[0,0,1,0]) .* (2 *vidObj.FrameRate);
          else
              val_diff2(i,:) =  (val_ref(i+1,:) - val_ref(i-1,:)) .* (2 *vidObj.FrameRate);
          end
end

figure(fnum);
plot(time(1:Numframes-1,1),val_diff2(:,1),time(1:Numframes-1,1),val_diff2(:,2),time(1:Numframes-1,1),val_diff2(:,3),time(1:Numframes-1,1),val_diff2(:,4))
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

% butterworse 10dim 
% 15 fps Cutoff : 0.75 fps -> 0.75 * 2*pi /15
 [b2,a2] = butter(15, 0.75 * 2 /15);
LPval_diff2 = filtfilt(b2,a2,val_diff2);



figure((fnum+1));
plot(time(1:Numframes-1,1),LPval_diff(:,1),time(1:Numframes-1,1),LPval_diff(:,2),time(1:Numframes-1,1),LPval_diff(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('移動平均フィルタ15点');

figure(fnum+2);
plot(time(1:Numframes-1,1),LPval_diff2(:,1),time(1:Numframes-1,1),LPval_diff2(:,2),time(1:Numframes-1,1),LPval_diff2(:,3),time(1:Numframes-1,1),LPval_diff(:,4))
grid on;
legend('dx_{ref}','dy_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('ローパスバタワース 0.75fps');

%% Print to file
% time refnum ref1 ref2 
% fileID = fopen('refdata1.txt','w');
% output= horzcat(time(1:Numframes-1,1), refnum(1:Numframes-1,1),  val_ref(1:Numframes-1,1),val_ref(1:Numframes-1,2),val_ref(1:Numframes-1,3),val_ref(1:Numframes-1,4)   ,LPval_diff(:,1),LPval_diff(:,2),LPval_diff(:,3),LPval_diff(:,4));
% dlmwrite('refdata1.txt',output); 
% output2= horzcat(time(1:Numframes-1,1), refnum(1:Numframes-1,1),  val_ref(1:Numframes-1,1),val_ref(1:Numframes-1,2),val_ref(1:Numframes-1,3),val_ref(1:Numframes-1,4)   ,LPval_diff2(:,1),LPval_diff2(:,2),LPval_diff2(:,3),LPval_diff2(:,4));
% dlmwrite('refdata2.txt',output2); 
