%% Accurate Reference with Map test

datalength = 10;

GrandTruth = zeros(datalength,4);

GrandTruth(:,1) = 0.6 * ndgrid(1:datalength,1);
GrandTruth(:,2) = - 0.2 *ndgrid(1:datalength,1);
GrandTruth(:,3) =  1 + (50 - ndgrid(1:datalength,1))/500 ;
GrandTruth(:,4) =  20 * sind( ndgrid(1:datalength,1)) ;

Noise = 3 * randn(datalength,datalength,4)/100;

%%
val_refMap = zeros(datalength,datalength,4);

for i = 1:datalength
    
end