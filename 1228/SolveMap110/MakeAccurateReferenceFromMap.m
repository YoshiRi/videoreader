%% get accurate reference from map

% Get whole map
load('1228FullMapr.mat');

%% Get value Map
pmat = refnumMap(:,:,2); % get map 
minpeak = 0.075;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                      % Get sparse peakmat

figure(1);
imshow(Bpmat);
xlabel('Reference Image Number');
ylabel('Compared Image Number');


 
 %% 1. solve theta equation
 T_val = zeros(size(valMap,1),4);                         % put the true value
 CtaMap = valMap(:,:,4);                                     % get theta map
 rCtaMap = CtaMap .* Bpmat;                              % get theta map

% T_val(:,4) = solve_Mapping(rCtaMap,Bpmat);

%%
wMap = Bpmat;
% ŒW”s—ñA‚ÌŒvZ : Map‚æ‚è1‚Â¬‚³‚¢
n=size(wMap,1);
% ‘ÎŠp¬•ª‚ÌŒvZ
nwMap = wMap(1:n-1,2:n);
figure(2);
imshow(nwMap)
diagA = diag(sum(nwMap,1).' + sum(nwMap,2));
tri = nwMap - diag(diag(nwMap));
figure(3);
imshow(tri);

A = -tri+diagA-tri.';
figure(4);
imshow(A);

% ƒxƒNƒgƒ‹B‚ÌŒvZ
BMap = wMap .* CtaMap;
figure(5)
imshow(BMap);
Bb = sum(BMap,2) - sum(BMap,1).';
B= Bb(2:n);

v = A\B;
figure(6);
plot(v);
%%


% %% 2. solve kappa equation
% KMap = valMap(:,:,3);                                        % get kappa map
% lKMap = log(KMap);                                            % male log scale map
% lnkappa = solve_Mapping(lKMap,Bpmat);          % solve linear equation
% 
% T_val(:,3) = exp(lnkappa);                                 % kappa 
% 
% %% 3. solve translation equation
% TMap = valMap(:,:,1:2);
% 
% csMap = cosd(T_val(:,:,4)) .* T_val(:,:,3);
% snMap = sind(T_val(:,:,4)) .* T_val(:,:,3);
% 
% TrMapx = csMap .* TMap(:,:,1) + snMap.* TMap(:,:,2);
% TrMapy = -snMap .* TMap(:,:,1) + csMap.* TMap(:,:,2);
% 
% T_val(:,1) = solve_Mapping(TrMapx,Bpmat);          % solve linear equation
% T_val(:,2) = solve_Mapping(TrMapy,Bpmat);          % solve linear equation
% 
% 
% %% show the result
% figure(13);
% plot(time,T_val(:,1),time,T_val(:,2),time,T_val(:,3),time,T_val(:,4))
% grid on;
% legend('\xi_x_{ref}','\xi_y_{ref}','\kappa_{ref}','\theta_{ref}','Location','best');
% xlabel('time[s]');ylabel('$\frac{d}{dt}\xi_{ref}$','Interpreter','latex'); 
% title('shapedRef');
