load('1228exp.mat');

% length = size(val_ref,1); % 行列と配列の長さ
% [height width] = size(s(1).cdata); % image size
% 
% r = sqrt ( height^2 + width^2 ) / 2; % circle size
% 
% 
% %% １：元になる画像のサイズの決定
% 
% maxl = - val_ref(:,1:2) + repmat(r .* val_ref(:,3),1,2);
% minl =  - val_ref(:,1:2) - repmat(r .* val_ref(:,3),1,2);
% 
% Mxy = [ max(maxl(:,1)) , max(maxl(:,2)) ]; % max x and y value 
% mxy = [ min(minl(:,1)) , min(minl(:,2)) ];% min x and y value
% 
% 
% MWid = floor(Mxy(1))+1- floor(mxy(1)) + 1; % y size of New image
% MHei =  floor(Mxy(2))+1- floor(mxy(2)) + 1; % x size of New image
% xmin = floor(mxy(1)) -1
% ymin = floor(mxy(2)) -1 
% 
% LKM = double(zeros(MHei +1,MWid + 1)); % Making a Map with a 1 line redundant arrayLK
%%

k = 330;
LKinput = double(s(1).cdata);
LKI = double(s(k).cdata);

para = val_ref(k,:);
invscale = para(3); iCta = para(4);
invR = invscale * [cosd(iCta) sind(iCta); -sind(iCta) cosd(iCta)];
Tra = -[para(1) ;para(2)]
M_ = horzcat(invR,Tra);
M = M_ - [ 1 0 0; 0 1 0];
M = M(:);

[parameter,I_roi,T_error] = LucasKanadeAffine_temp(LKinput,M,LKI)
%%
pk = parameter;
invscale_new = (pk(1)+1)^2 + pk(2)^2
theta_new = atan2(pk(3),pk(4)+1)
Tra_new = [pk(5);pk(6)]


%% RIPOC
addpath('../')
npara = RIPOC_func(LKinput,LKI)


%% 
invscale = npara(3); iCta = npara(4);
invR = invscale * [cosd(iCta) sind(iCta); -sind(iCta) cosd(iCta)];
Tra = -[npara(1) ;npara(2)]
M_ = horzcat(invR,Tra);
M = M_ - [ 1 0 0; 0 1 0];
M = M(:);

[nparameter,I_roi,T_error] = LucasKanadeAffine_temp(LKinput,M,LKI);

npk = nparameter;
invscale_new2 = (npk(1)+1)^2 + npk(2)^2
theta_new2 = atan2(npk(3),npk(4)+1)
Tra_new2 = [npk(5);npk(6)]
