close all
% spline and PCHIP
x = -3:3;
y = [-1 -1 -1 0 1 1 1];
t = -3:.01:3;
p = pchip(x,y,t);
s = spline(x,[0 y 0],t);

% plot
figure(1)

% plot area
ha=area([0 3],[10 10],-10);         % “h‚é”ÍˆÍ([X_1 X_2],[y1 y2])
set(ha,'FaceColor',[1.0 1.0 0.9]);      % “h‚è‚Â‚Ô‚µF
set(ha,'LineStyle','none');             % “h‚è‚Â‚Ô‚µ•”•ª‚É˜g‚ğ•`‚©‚È‚¢
set(gca,'layer','top');                 % grid‚ğ“h‚è‚Â‚Ô‚µ‚Ì‘O–Ê‚Éo‚·
hAnnotation = get(ha,'Annotation');
hLegendEntry = get(hAnnotation','LegendInformation');
set(hLegendEntry,'IconDisplayStyle','off');     % legend‚É“ü‚ê‚È‚¢‚æ‚¤‚É‚·‚é

% plot line
ylim([-1.5  1.5])
hold on
plot(x,y,'o',t,p,'-',t,s,'-.')
legend('data','pchip','spline','Location','SouthEast')
xlabel('time[s]');
ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
grid on

hold off

%%

tshow =  0:0.01:5;
sp = spline(time,[0 val_ref(:,1)' 0],tshow);
pch = pchip(time,val_ref(:,1),tshow);

figure(100);
plot(tshow,sp,tshow,pch)
grid on;
legend('cubic spline','pchip','Location','best')
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

%% 1

dsp1 = spline_diff(time, val_ref(:,1),time);
dpch1 = pchip_diff(time,val_ref(:,1),time);

figure(101);
% plot(time(1:Numframes-1,1),val_diff(:,1),'r-.',time(1:Numframes-1,1),val_diff2(:,1),'b--',time,dsp1,'m-',time,dpch1,'k');
plot(time(1:Numframes-1,1),val_diff2(:,1),'--',time,dsp1,'-.',time,dpch1,'');
grid on;
legend('central differ','cubic spline','pchip','Location','best')

xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 


%% 3

dsp1 = spline_diff(time, val_ref(:,3),time);
dpch1 = pchip_diff(time,val_ref(:,3),time);

figure(103);
% plot(time(1:Numframes-1,1),val_diff(:,1),'r-.',time(1:Numframes-1,1),val_diff2(:,1),'b--',time,dsp1,'m-',time,dpch1,'k');
plot(time(1:Numframes-1,1),val_diff2(:,3),'--',time,dsp1,'-.',time,dpch1,'');
grid on;
legend('central differ','cubic spline','pchip','Location','best')

xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 

%%
DFTandShow(time,dsp1);
DFTandShow(time,dpch1)
DFTandShow(time,val_diff2(:,1))
