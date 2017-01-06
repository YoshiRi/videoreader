function val = LinearInterpolate(Image,x1,y1)

x2 = floor(x1);
y2 = floor(y1);

dx = x1-x2;
dy = y1-y2;

val = double(Image(y2,x2)) * (1-dx)*(1-dy) + ...
    double(Image(y2,x2+1)) * dx * (1-dy) + ...
    double(Image(y2+1,x2))* (1-dx)*dy + ...
    double(Image(y2+1,x2+1)) *dx * dy;

end
