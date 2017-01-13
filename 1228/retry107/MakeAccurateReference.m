%% get accurate reference from map

% Get whole map
% load('1228FullMap.mat');
% Get Transposed map
load('1228FullMapTransposed.mat');

%%
pmat = refnumMap(:,:,2);
minpeak = 0.05;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                      % Get sparse peakmat

T_val = zeros(size(valMap,1),4);                         % put the true value

%% 1. solve theta equation
CtaMap = valMap(:,:,4);                                     % get theta map
rCtaMap = CtaMap .* Bpmat;                                     % get theta map

T_val(:,4) = solve_Mapping(CtaMap,Bpmat);

%% 2. solve kappa equation
KMap = valMap(:,:,3);                                        % get kappa map
lKMap = log(KMap);                                            % male log scale map
lnkappa = solve_Mapping(lKMap,Bpmat);          % solve linear equation

T_val(:,3) = exp(lnkappa);                                 % kappa 

%% 3. solve translation equation
TMap = valMap(:,:,1:2);

csMap = cosd(T_val(:,:,4)) .* T_val(:,:,3);
snMap = sind(T_val(:,:,4)) .* T_val(:,:,3);

TrMapx = csMap .* TMap(:,:,1) + snMap.* TMap(:,:,2);
TrMapy = -snMap .* TMap(:,:,1) + csMap.* TMap(:,:,2);

T_val(:,1) = solve_Mapping(TrMapx,Bpmat);          % solve linear equation
T_val(:,2) = solve_Mapping(TrMapy,Bpmat);          % solve linear equation


%% show the result
figure(13);
plot(time,T_val(:,1),time,T_val(:,2),time,T_val(:,3),time,T_val(:,4))
grid on;
legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
title('shapedRef');
