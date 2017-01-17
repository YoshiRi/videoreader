function rMap = RedSquare(Map,crop)
ymin = crop(1);
xmin = crop(2);
hei = crop(3);
wid = crop(4);
rMap = Map;

rMap(xmin, ymin:ymin+hei-1, 1)=255;
rMap(xmin, ymin:ymin+hei-1, 2)=0;
rMap(xmin, ymin:ymin+hei-1, 3)=0;

rMap(xmin+wid-1, ymin:ymin+hei-1, 1)=255;
rMap(xmin+wid-1, ymin:ymin+hei-1, 2)=0;
rMap(xmin+wid-1, ymin:ymin+hei-1, 3)=0;

rMap(xmin:xmin+wid-1, ymin, 1)=255;
rMap(xmin:xmin+wid-1, ymin, 2)=0;
rMap(xmin:xmin+wid-1, ymin, 3)=0;

rMap(xmin:xmin+wid-1, ymin+hei-1, 1)=255;
rMap(xmin:xmin+wid-1, ymin+hei-1, 2)=0;
rMap(xmin:xmin+wid-1, ymin+hei-1, 3)=0;

end