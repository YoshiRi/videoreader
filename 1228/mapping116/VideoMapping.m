% input s : s(k).cdata=img
% nT_val : l times 4 matrix x y 1/scale theta
%
% function Map = ImageOverWrite(s,nT_val)
clear all;

addpath('..\retry107')
load('VideoImages.mat');
load('Optimized1228.mat');


length = size(nT_val,1); % �s��Ɣz��̒���
[height width] = size(s(1).cdata); % image size

r = sqrt ( height^2 + width^2 ) / 2; % circle size

% maxl = r*ones(2,1); % define size 
% minl =- r*ones(2,1);  % define size

%% �P�F���ɂȂ�摜�̃T�C�Y�̌���

maxl = - nT_val(:,1:2) + repmat(r .* nT_val(:,3),1,2);
minl =  - nT_val(:,1:2) - repmat(r .* nT_val(:,3),1,2);

Mxy = [ max(maxl(:,1)) , max(maxl(:,2)) ]; % max x and y value 
mxy = [ min(minl(:,1)) , min(minl(:,2)) ];% min x and y value


MWid = floor(Mxy(1))+1- floor(mxy(1)) + 1; % y size of New image
MHei =  floor(Mxy(2))+1- floor(mxy(2)) + 1; % x size of New image
xmin = floor(mxy(1)) -1
ymin = floor(mxy(2)) -1 

Map = double(zeros(MHei +1,MWid + 1)); % Making a Map with a 1 line redundant array

% [cy cx] = [(1+Hei) /2,(1+Wid) /2]; % center of point
%%  2: Map�����

% write to video
v = VideoWriter('Mapping.avi');
v.FrameRate = 8; % Framerate
open(v);

for k = 1:3:length
    display(k);
    Image = double(s(k).cdata);
    Map = FillMap(Map,Image,nT_val(k,:),width,height,xmin,ymin);
    writeVideo(v,uint8(Map));
end

close(v);
% end

%% show the results 
figure;
imshow(Map,[0 255]);
num=floor(length/3);
Title = strcat('MappingImage with ',num2str(num),'Images');
title(Title);
