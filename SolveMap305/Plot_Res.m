%% Results plot
clear all;
close all;


load('RefresultExp305');

Ref = load('Exp305_Ref2r.txt');

figure(1);
plot(Ref(:,1),Ref(:,3),'m-',Ref(:,1),Ref(:,4),'c-',Ref(:,1),Ref(:,5),'g-',Ref(:,1),Ref(:,6),'k-');
f1 = plot(Ref(:,1),Ref(:,3),'m-',Ref(:,1),Ref(:,4),'c-',Ref(:,1),Ref(:,5),'g-');
grid on
xlabel('time [s]')
ylabel('image displacement')
legend('reference \xi_x^*','reference  \xi_y^*','reference \kappa^*','Location','Best')
set(f1,'LineWidth',3)

%%
%plot(time_r,rst_val(:,1));
n = size(time_r,1);
time = time_r(1:n-1);
rst = rst_val(2:n,:);

figure(2);
plot(Ref(:,1),Ref(:,3),'--',Ref(:,1),Ref(:,4),'--',Ref(:,1),Ref(:,4),'--',Ref(:,1),Ref(:,5),'--',time,rst(:,1),time,rst(:,2),time,rst(:,3),time,rst(:,4));
grid on
xlabel('time [s]')
ylabel('image displacement')

figure(3);
plot(Ref(:,1),Ref(:,3),'m--',Ref(:,1),Ref(:,4),'c--',time,rst(:,1),'r-',time,rst(:,2),'b-');
grid on
xlabel('time [s]')
ylabel('image displacement')
legend('reference \xi_x^*','reference  \xi_y^*','tracked \xi_x','tracked \xi_y','Location','Best')
