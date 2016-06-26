function [Xi ,mpeak] = RIPOC_show(AI,BI)
% 2016/6/27 changed
% Input must be 256 * 256 monoculer image
% IA:ref IB:compared
% Xi = [ x,y,1/scale,theta ]
% mpeak = mutching peak

%% �T�C�Y����
 width = 256;
 height = 256;
 cy = height/2;
 cx = width/2;

%% ���֐��̏��� �i�摜�[�̉e��������邽�߁j
% �@�摜��2�����n�j���O���F
han_win = zeros(width);
Rhan_win = zeros(width);
% �AS/N��̏����� �L����J�b�g���鑋
cut_win = zeros(width);

for i = 1 :256
    for j = 1:256
%         dis = sqrt(((cx-i)*(cx-i)+(cx-j)*(cx-j))/128/128/2);
%         han_win(i,j) = 0.5*(1.0 - cos(pi*dis));
            han_win(i,j) = 0.25 * (1.0 + cos(pi*abs(128 - i) / 128.0))*(1.0 + cos(pi*abs(128 - j) / 128.0));
            % Root han_win
            Rhan_win(i,j)=abs(cos(pi*abs(128 - i) / 256)*cos(pi*abs(128 - j) / 256));
%           Rhan_win(i,j)=1;
           if abs(i-cx) < 64 && abs(j-cy) < 64
                cut_win(i,j) = 1.0;
            end
    end
end


%% �摜����

%% ���֐��i�t�B���^�j���|����
IA = Rhan_win .* double(AI);
 IB = Rhan_win .* double(BI);
 
 

%%�؂�o��
% IA = imcrop(AI,[ cx-width/2,cy-height/2,width-1,height-1]);
% IB = imcrop(BI,[ cx-width/2,cy-height/2,width-1,height-1]); 


%% 2DFFT
A=fft2(IA);
B=fft2(IB);

At = A./abs(A);
Bt = (conj(B))./abs(B);

%% �U�������̒��o�@���@�ΐ���
% As=cut_win .* fftshift(log(abs(A)+1));
% Bs=cut_win .* fftshift(log(abs(B)+1));
As= fftshift(log(abs(A)+1));
Bs= fftshift(log(abs(B)+1));

%% Log-Poler Transformation

lpcA = zeros(height,width);
lpcB = zeros(height,width);
cx = width / 2;
cy = height / 2;

% �œK�ȁ@M�F�@512*512=100(82.5) 256*256=55(46.234) �������C�L��J�b�g����Ƃ���63
% �����������ǂ̒��x�̑ΐ��ł܂Ƃ߂邩�Ƃ������b�B�L������o���邾������Čv�Z������
M = 55;
for i= 0:width-1
    for j= 0:height-1
        r =exp(i/M);
        x=r*cos(2*pi*j/height)+cx;
        y=r*sin(2*pi*j/height)+cy;
        if 0 < x && x < width - 1 && 0 < y && y < height - 1
             x0 = floor(x);
             y0 = floor(y);
             x1 = x0 + 1.0;
             y1 = y0 + 1.0;
            w0=x1-x;
            w1=x-x0;
            h0=y1-y;
            h1=y-y0;
            %�@Bilinear�⊮
            val=As(y0+1,x0+1)*w0*h0 + As(y0+1,x1+1)*w1*h0+ As(y1+1,x0+1)*w0*h1 + As(y1+1,x1+1)*w1*h1;
            %�@�قڕ�Ԃłł��Ă������CutOff����
            if i > 180 && i < 270
                 lpcA(j+1,i+1)=val;
            else
                 lpcA(j+1,i+1)=0;
            end
            val=Bs(y0+1,x0+1)*w0*h0 + Bs(y0+1,x1+1)*w1*h0+ Bs(y1+1,x0+1)*w0*h1 + Bs(y1+1,x1+1)*w1*h1;
            if i > 180  && i < 270
                 lpcB(j+1,i+1)=val;
            else
                 lpcB(j+1,i+1)=0;
            end
        end
    end
end

%%%% end LogPoler %%%


PA = fft2(lpcA);
PB = fft2(lpcB);
Ap = PA./abs(PA);
Bp = (conj(PB))./abs(PB);
Pp = fftshift(ifft2(Ap.*Bp));

[mm,x]=max(Pp);
[mx,y]=max(mm);
px=y;
py=x(y);

if mx < 0.05
    xi = [0 0 0 0]
    mpeak = mx
    return;
end

%% Bilinear���
if px == 0 || py == 0
    pxx = px; pyy = py;
else
sum = Pp(py-1,px-1)+Pp(py,px-1)+Pp(py+1,px-1)+Pp(py-1,px)+Pp(py,px)+Pp(py+1,px)+Pp(py-1,px+1)+Pp(py,px+1)+Pp(py+1,px+1);

pxx = ( Pp(py-1,px-1)+Pp(py,px-1)+Pp(py+1,px-1) ) * (px-1) + ( Pp(py-1,px)+Pp(py,px)+Pp(py+1,px) ) * px + ( Pp(py-1,px+1)+Pp(py,px+1)+Pp(py+1,px+1) )* (px+1);
pxx = pxx/sum;

pyy = ( Pp(py-1,px-1)+Pp(py-1,px)+Pp(py-1,px+1) ) * (py-1) + ( Pp(py,px-1)+Pp(py,px)+Pp(py,px+1) ) * (py) + ( Pp(py+1,px-1)+Pp(py+1,px)+Pp(py+1,px+1) ) * (py+1);
pyy= pyy/sum;
end
dx = width/2 - pxx + 1;
dy = height/2 - pyy + 1;

%% Scale�ʂ̕␳
% dx = dx * 82/M;
dx = dx * 47.0/M;

%% ��]�ʂɂ�2�̃s�[�N���o������
theta1 = 360 * dy / height;
theta2 = theta1 + 180;
scale = 1/power(width,dx/width)
% figure;
% mesh(Pp);

%% ��]�E�g��k���� ��␳
% �ʓ|�����p�x�ɂ�2�̃p�^�[��������c
IB_recover1 = ImageRotateScale(IB, theta1,scale,width,height);
IB_recover2 = ImageRotateScale(IB, theta2,scale,width,height);

%% ���s�ړ��ʌ��o �� ��]�ʌ���

IB_R1=fft2(IB_recover1);
IB_R2=fft2(IB_recover2);
IB1p = (conj(IB_R1))./abs(IB_R1);
IB2p = (conj(IB_R2))./abs(IB_R2);

App = A./abs(A);
Pp1 = fftshift(ifft2(App.*IB1p));
Pp2 = fftshift(ifft2(App.*IB2p));

[mm1,x1]=max(Pp1);
[mx1,y1]=max(mm1);
px1=y1;
py1=x1(y1);

[mm2,x2]=max(Pp2);
[mx2,y2]=max(mm2);
px2=y2;
py2=x2(y2);


%% 2��ނ̉�]�ʂɂ���POC���s���C�s�[�N���o����C�l���傫���ق���^�l�Ƃ���
if mx1 > mx2

    mpeak = mx1;
    
theta = theta1
sum1 = Pp1(py1-1,px1-1)+Pp1(py1,px1-1)+Pp1(py1+1,px1-1)+Pp1(py1-1,px1)+Pp1(py1,px1)+Pp1(py1+1,px1)+Pp1(py1-1,px1+1)+Pp1(py1,px1+1)+Pp1(py1+1,px1+1);

pxx1 = ( Pp1(py1-1,px1-1)+Pp1(py1,px1-1)+Pp1(py1+1,px1-1) ) * (px1-1) + ( Pp1(py1-1,px1)+Pp1(py1,px1)+Pp1(py1+1,px1) ) * px1 + ( Pp1(py1-1,px1+1)+Pp1(py1,px1+1)+Pp1(py1+1,px1+1) )* (px1+1);
pxx1 = pxx1/sum1;

pyy1 = ( Pp1(py1-1,px1-1)+Pp1(py1-1,px1)+Pp1(py1-1,px1+1) ) * (py1-1) + ( Pp1(py1,px1-1)+Pp1(py1,px1)+Pp1(py1,px1+1) ) * (py1) + ( Pp1(py1+1,px1-1)+Pp1(py1+1,px1)+Pp1(py1+1,px1+1) ) * (py1+1);
pyy1= pyy1/sum1;

dx = width/2 - pxx1 + 1
dy = height/2 - pyy1 + 1

figure;
mesh(Pp1);
title('Pp1');
figure;

result = imtranslate(IB_recover1,[-dx, -dy]);
imshow(abs(double(IA)-result),[0 255]);
figure;
imshow(result,[0 255]);
figure;
imshow(IA,[0 255]);
figure;
imshow(IB,[0 255]);

else
    
    mpeak = mx2;
    
theta = theta2;
sum2 = Pp2(py2-1,px2-1)+Pp2(py2,px2-1)+Pp2(py2+1,px2-1)+Pp2(py2-1,px2)+Pp2(py2,px2)+Pp2(py2+1,px2)+Pp2(py2-1,px2+1)+Pp2(py2,px2+1)+Pp2(py2+1,px2+1);

pxx2 = ( Pp2(py2-1,px2-1)+Pp2(py2,px2-1)+Pp2(py2+1,px2-1) ) * (px2-1) + ( Pp2(py2-1,px2)+Pp2(py2,px2)+Pp2(py2+1,px2) ) * px2 + ( Pp2(py2-1,px2+1)+Pp2(py2,px2+1)+Pp2(py2+1,px2+1) )* (px2+1);
pxx2 = pxx2/sum2;

pyy2 = ( Pp2(py2-1,px2-1)+Pp2(py2-1,px2)+Pp2(py2-1,px2+1) ) * (py2-1) + ( Pp2(py2,px2-1)+Pp2(py2,px2)+Pp2(py2,px2+1) ) * (py2) + ( Pp2(py2+1,px2-1)+Pp2(py2+1,px2)+Pp2(py2+1,px2+1) ) * (py2+1);
pyy2= pyy2/sum2;

dx = width/2 - pxx2 + 1
dy = height/2 - pyy2 + 1

figure;
mesh(Pp2);
title('Pp2');
figure;
result = imtranslate(IB_recover2,[-dx, -dy]);
imshow(abs(double(IA)-result),[0 255]);
figure;
imshow(result,[0 255]);
figure;
imshow(IA,[0 255]);
figure;
imshow(IB,[0 255]);
end

 Xi = [dx dy 1/scale theta];

end