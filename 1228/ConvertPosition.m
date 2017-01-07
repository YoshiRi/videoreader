% Compared Image coordinate to Reference Image coordinate

function position = ConvertPosition(pose,val,width,height,xmin,ymin)
% val : dx dy kappa theta :: kappa = 1/scale from RIPOC function
% pose : [x y]
length = size(pose,2);

yraw = pose(2,:);                                  % [ 1 2 ... height ] 
xraw = pose(1,:);                                   % [ 1 2 ... height ]

cy = height/2 +1/2;
cx = width/2 + 1/2;

centered = [xraw- cx;yraw-cy] ;

invscale = val(3); iCta = val(4);
invR = invscale * [cosd(iCta) sind(iCta); -sind(iCta) cosd(iCta)];

reviced = invR * centered;

translation = repmat([val(1) ;val(2)],1,length);  %dx = tate,dy = yoko ï¥ÇÁÇÌÇµÇ¢Åc
cooridinate = reviced - translation;

dx = xmin -1/2 ;
dy = ymin -1/2 ;

origin = repmat([dx; dy],1,length);  %dx = tate,dy = yoko ï¥ÇÁÇÌÇµÇ¢Åc

position = cooridinate - origin;                            % out put [ x1 x2 ... ;y1 y2 ...];
end

