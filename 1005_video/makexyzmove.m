%% make shaped ref
% for x and y and z moving

Frate = 15;
Numframes = 75;

% initialize
time = zeros(Numframes,1);
val = zeros(Numframes,4);
ffval = zeros(Numframes,4);

refnum = ones(Numframes,1);

speed = [6 6 -0.01 0];
val(1,:) = [0 0 1 0];

for i = 1:Numframes
    time(i) =  (i-1)/Frate;
    ffval(i,:) = speed;
    if i ~= 1
        val(i,:) = val(i-1,:) + speed / Frate;
    end
end


%% Print to file
% time refnum ref1 ref2 
% fileID = fopen('refdata1.txt','w');
output= horzcat(time(:,1), refnum(:,1),  val(:,1),val(:,2),val(:,3),val(:,4) ,  ffval(:,1),ffval(:,2),ffval(:,3),ffval(:,4) );
outputfile = strcat('shapedref','.txt')  
dlmwrite(outputfile,output); 

