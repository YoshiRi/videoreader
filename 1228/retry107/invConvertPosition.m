function pose = invConvertPosition(position,val,width,height,xmin,ymin)
% val : dx dy kappa theta :: kappa = 1/scale from RIPOC function
% position : [x y]
length = size(position,2);
dx = xmin -1/2 ;
dy = ymin -1/2 ;

origin = repmat([dx; dy],1,length);  
coordinate = position + origin;

translation = repmat([val(1) ;val(2)],1,length);  %dx = tate,dy = yoko ï¥ÇÁÇÌÇµÇ¢Åc
reviced = coordinate + translation;

scale = 1/val(3); Cta = val(4);
R = scale * [cosd(Cta) -sind(Cta); sind(Cta) cosd(Cta)];

centered = R * reviced;

cy = height/2 + 1/2;
cx = width/2 + 1/2;
center = repmat([cx;cy],1,length);
pose = centered + center;
end

