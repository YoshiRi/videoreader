%% get accurate reference from map
clear all;
% Get whole map
load('1228FullMapr.mat');

%% Get value Map
pmat = refnumMap(:,:,2); % get map 
minpeak = 0.075;
Bpmat = im2bw(pmat,minpeak);                        % Get binarized pmat
Spmat = Bpmat.*pmat;                                       % Get sparse peakmat

figure(1);
imshow(Bpmat);
ylabel('Reference Image Number');
xlabel('Compared Image Number');

%% kuso syuusei : give time(n) adequate value
time(n) = time(n-1)*2 - time(n-2);
 
 %% 1. solve theta equation in Proposed
 T_val = zeros(size(valMap,1),4);                         % put the true value
 nT_val = zeros(size(valMap,1),4);                         % put the unchi value
 sT_val = zeros(size(valMap,1),4);
 
 CtaMap = valMap(:,:,4);                                     % get theta map
 rCtaMap = CtaMap .* Bpmat;                              % get theta map
nMap = triu(ones(size(Bpmat)),1) - triu(ones(size(Bpmat)),2); % neighbor map

T_val(2:n,4) = solve_Mapping(rCtaMap,Bpmat);
figure(2);
plot(time,T_val(:,4));
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with FullMap')

nT_val(2:n,4) = solve_Mapping(rCtaMap,nMap);
figure(3);
plot(time,nT_val(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with Neighbor Information')

figure(4);
plot(time,T_val(:,4),'b',time,nT_val(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with Map Information','with Neighbor Information','Location','Best')

sT_val(2:n,4) = solve_Mapping(rCtaMap,Spmat);
figure(5);
plot(time,sT_val(:,4));
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Estimated Reference with FullMap')

figure(6);
plot(time,T_val(:,4),'b',time,nT_val(:,4),'r--',time,sT_val(:,4),'m-.');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('with Map Information','with Neighbor Information','with weighted Map Information','Location','Best')

%% estimate time
f = @() solve_Mapping(rCtaMap,Bpmat);
timeit(f)

%% 
Wvec = zeros((n-1)*n/2,1);
Vvec = zeros((n-1)*n/2,1);
Phi = zeros((n-1)*n/2,n-1);

 T_val_LS = zeros(size(valMap,1),1);

for k = 1:n-1
    l = n - k;
    E = eye(l);
    if k >1
        F = zeros(l,k-1);
        F(:,k-1) = (-1) * ones(l,1);
        E = horzcat(F,E);
    end
    max =k*n - k*(k+1)/2;
    min = (k-1)*n - k*(k-1)/2 + 1;
    
    Phi(min:max,:) = E;
    
    Wvec(min:max) = Bpmat(k,k+1:n);
    Vvec(min:max) =  rCtaMap(k,k+1:n);
end

Wsp = sparse(ndgrid(1:n*(n-1)/2),ndgrid(1:n*(n-1)/2),Wvec,n*(n-1)/2,n*(n-1)/2);
T_val_LS(2:n,:) = solve_Mapping_LS(Vvec,Wsp,Phi);


figure(7);
plot(time,T_val_LS(:,1),'b',time,T_val(:,4),'r--');
xlabel('time [s]');
ylabel('rotational ref [deg]');
grid on;
legend('Least Square Method','Proposed Method','Location','Best')
 
 
%%
f2 = @() solve_Mapping_LS(Vvec,Wsp,Phi);
timeit(f2)

%% 
size(find(rCtaMap))