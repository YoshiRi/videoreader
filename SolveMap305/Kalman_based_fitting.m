% _n now _o old _new new
%%

% Get whole map
load('Exp305FullMap.mat');

%% Get value Map
pmat = peakMap(:,:,1);                                      % get largest peak map 
minpeak = 0.075;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                       % Get sparse peakmat

CtaMap = valMap(:,:,4);                                     % get theta map
rCtaMap = CtaMap .* Bpmat;                              % get theta map
KMap = valMap(:,:,3);                                        % get kappa map
lKMap = log(KMap);                                            % make log scale map
lKMap(~isfinite(lKMap))=0;


% kuso syuusei
n = Numframes;
time(n) = time(n-1)*2 - time(n-1);

figure(1);
mesh(Spmat);

figure(2);
mesh(rCtaMap);

%% input and out put
n = size(Bpmat,1);
uvec = diag(rCtaMap(1:n-1,2:n));
yvec = rCtaMap(1,2:n).';
xvec = zeros(size(uvec));
Svec = zeros(size(uvec));

length = size(find(yvec),1); %non-zero datalength

%% kalman
% initial value 
x0 = 0;
S_i = 10000;
% % system
% D=1;E=1;F=1;G=1;H=1;
% % カルマンゲインの更新
%  K_n = S_o*H.'*(H*S_o*H.'+ V);
% % 誤差共分散の更新
%  S_n = S_o - K_n*H*S_o;
% % 推定値の更新
%  x_n = x_o + K_n*(y_n - H*x_o);
% % フィルタ方程式
%  x_new = D*x_n+E*u;
% % 共分散行列のフィルタ方程式
%  S_n = F*S_o *F.'+ G*W*G.';

% noise scatter
V = 0.001;
W = 0.001;

Gvec = ones(length,1);

xlast=x0; Slast = S_i;
for i = 1:length
    % 予測Phase
    xest = xlast + uvec(i);
    Sest = Slast + W*Gvec(i);
    % Calc Gain
    K = Sest/(Sest + V);
    % Correction
    Scor = Sest - K*Sest;
    xcor = xest + K*(yvec(i)-xest);
    
    xvec(i)=xcor;
    Svec(i)=Scor;
    xlast=xcor;
    Slast=Scor;
    
end

%% hikaku
load('ReferenceExp305.mat');


figure(3);
plot(time(1:length),Svec(1:length));
xlabel('time [s]');
ylabel('Covariance Val in rotation');
grid on;
legend('with Kalman Filter','Location','Best')

figure(4);
plot(time,T_val(:,4),'b',time,nT_val(:,4),'r--',time(1:length),xvec(1:length),'m-.');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with Map Information','with Neighbor Information','with Kalman Filter','Location','Best')


%% scaling?

%% input and out put
n = size(Bpmat,1);
uvec = diag(lKMap(1:n-1,2:n));
yvec = lKMap(1,2:n).';
xvec = zeros(size(uvec));
Svec = zeros(size(uvec));

length = size(find(yvec),1); %non-zero datalength

%% kalman
% initial value 
x0 = 1;
S_i = 10000;

% noise scatter
V = 0.001;
W = 0.001;

Gvec = ones(length,1);

xlast=x0; Slast = S_i;
for i = 1:length
    % 予測Phase
    xest = xlast + uvec(i);
    Sest = Slast + W*Gvec(i);
    % Calc Gain
    K = Sest/(Sest + V);
    % Correction
    Scor = Sest - K*Sest;
    xcor = xest + K*(yvec(i)-xest);
    
    xvec(i)=exp(xcor);
    Svec(i)=Scor;
    xlast=xcor;
    Slast=Scor;
    
end


figure(5);
plot(time(1:length),Svec(1:length));
xlabel('time [s]');
ylabel('Covariance Val in scaling');
grid on;
legend('with Kalman Filter','Location','Best')


figure(6);
plot(time,T_val(:,3),'b',time,nT_val(:,3),'r--',time(1:length),xvec(1:length),'m-.');
xlabel('time [s]');
ylabel('scaling');
grid on;
legend('with Map Information','with Neighbor Information','with Kalman Filter','Location','Best')
