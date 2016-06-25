
function [Xi,peak] = POC_func(IA,IB)

[height,width] = size(IA);

A = fft2(IA);
B = fft2(IB);
Ae = A./abs(A);
Be = (conj(B))./abs(B);
SPh = ifft2(Ae.*Be);
Pp = fftshift(SPh);


[mm,x]=max(Pp);
[mx,y]=max(mm);
px=y;
py=x(y);

%cubic hokan
sum = Pp(py-1,px-1)+Pp(py,px-1)+Pp(py+1,px-1)+Pp(py-1,px)+Pp(py,px)+Pp(py+1,px)+Pp(py-1,px+1)+Pp(py,px+1)+Pp(py+1,px+1);

pxx = ( Pp(py-1,px-1)+Pp(py,px-1)+Pp(py+1,px-1) ) * (px-1) + ( Pp(py-1,px)+Pp(py,px)+Pp(py+1,px) ) * px + ( Pp(py-1,px+1)+Pp(py,px+1)+Pp(py+1,px+1) )* (px+1);
pxx = pxx/sum;

pyy = ( Pp(py-1,px-1)+Pp(py-1,px)+Pp(py-1,px+1) ) * (py-1) + ( Pp(py,px-1)+Pp(py,px)+Pp(py,px+1) ) * (py) + ( Pp(py+1,px-1)+Pp(py+1,px)+Pp(py+1,px+1) ) * (py+1);
pyy= pyy/sum;

dx = width/2 - pxx + 1;
dy = height/2 - pyy + 1;

Xi = [dx dy];
peak = mx;

end
