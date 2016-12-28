%% make shaped ref
% for x and y and z moving

Frate = 15;
Numframes = 100;

% initialize
time = zeros(Numframes,1);
val = zeros(Numframes,4);
ffval = zeros(Numframes,4);

refnum = ones(Numframes,1);
speed0 = [0 0 0 0];
speed1 = [0 25 0 0];
val(1,:) = [0 0 1 0];

for i = 1:Numframes
    time(i) =  (i-1)/Frate;
    if i ~= 1 && time(i) < 2 
        ffval(i,:) = speed1;
        val(i,:) = val(i-1,:) + speed1 / Frate;
    elseif  time(i) == 2
        ffval(i,:) = speed0;
        val(i,:) = [0 50 1 0];
    elseif time(i) >= 2 && time(i) < 6
        t= time(i) - 2;
%         Cta = 2*pi /36 * t^2;
%         val(i,:) = [ -50 * sind(Cta) ,50 *cosd(Cta), 1 ,0];
%         ffval(i,:) = [ -50 * cosd(Cta) * 2* pi / 18 * t ,   -50 * sind(Cta) * 2*pi /18 * t  ,0,0] ;
        ffval(i,:) = (t-2)*speed1/2;
        val(i,:) = val(i-1,:) + (t^2 /2-2*t)*speed1 /2/ Frate;
    end
end


%% Print to file
% time refnum ref1 ref2 
% fileID = fopen('refdata1.txt','w');
output= horzcat(time(:,1), refnum(:,1),  val(:,1),val(:,2),val(:,3),val(:,4) ,  ffval(:,1),ffval(:,2),ffval(:,3),ffval(:,4) );
outputfile = strcat('shapedref_circle','.txt')  
dlmwrite(outputfile,output); 

