%% Accurate Reference with Map test

datalength = 500;

GrandTruth = zeros(datalength,4);

GrandTruth(:,1) = 0.6 * ndgrid(1:datalength,1);
GrandTruth(:,2) = - 0.2 *ndgrid(1:datalength,1);
GrandTruth(:,3) =  1 + (50 - ndgrid(1:datalength,1))/500 ;
GrandTruth(:,4) =  20 * sind( ndgrid(1:datalength,1)) ;

Noise = 5 * randn(datalength,datalength,4)/100;
scale = ndgrid(2:datalength,1);
%% �ς̃f�[�^���Ƃ��܂������Ȃ�
data = GrandTruth(2:datalength,4);

Map = remakemap(data);
nMap = Map.*(1+Noise(:,:,4));

wMap=triu(ones(size(nMap)),1); %great map
wMap2 = triu(ones(size(nMap)),1) - triu(ones(size(nMap)),2);

v =  solve_Mapping(nMap,wMap); % solved
v2 =  solve_Mapping(nMap,wMap2); % solved
a = sum(wMap2 .* nMap)';
b = triu(ones(size(nMap)))' * a;
v3 = b(2:datalength);

figure(1);
plot(GrandTruth(2:datalength,4),'r--');
hold on;
plot(v,'b');
plot(v2,'m-.');
% plot(v3,'k:');
grid on;
hold off;
legend('Ground Truth','Estimated with Full Map','Estimated with Neighbor Map')
xlabel('iteration')
ylabel('value')

figure(2);
plot(scale,abs(v-GrandTruth(2:datalength,4)),'b',scale,abs(v2-GrandTruth(2:datalength,4)),'m-.');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
xlabel('iteration')
ylabel('absolute error')

% �_�O���t
sum1 = (v-GrandTruth(2:datalength,4)).'*(v-GrandTruth(2:datalength,4));
sum2 = (v2-GrandTruth(2:datalength,4)).'*(v2-GrandTruth(2:datalength,4));

figure(3);
bar(diag([sum1,sum2]),'stack');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
ylabel('total error')

%% �a�̃f�[�^ �Ȃ� ��������
nMap2 = Map+Noise(:,:,4);

wMap=triu(ones(size(nMap)),1); %great map
wMap2 = triu(ones(size(nMap)),1) - triu(ones(size(nMap)),2);

[w, A]=  solve_Mapping(nMap2,wMap); % solved
[w2 ,A2]=  solve_Mapping(nMap2,wMap2); % solved
figure(4);
plot(GrandTruth(2:datalength,4),'r--');
hold on;
plot(w,'b');
plot(w2,'m-.');
% plot(v3,'k:');

grid on;
hold off;
legend('Ground Truth','Estimated with Full Map','Estimated with Neighbor Map','Location','Best')
xlabel('iteration')
ylabel('value')

scale = ndgrid(2:datalength,1);
figure(5);
plot(scale,abs(w-GrandTruth(2:datalength,4)),'b',scale,abs(w2-GrandTruth(2:datalength,4)),'m-.');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
xlabel('iteration')
ylabel('absolute error')

% �_�O���t
sum1 = (w-GrandTruth(2:datalength,4)).'*(w-GrandTruth(2:datalength,4));
sum2 = (w2-GrandTruth(2:datalength,4)).'*(w2-GrandTruth(2:datalength,4));

figure(6);
bar(diag([sum1,sum2]),'stack');
% bar([sum1,sum2],'grouped');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
ylabel('total error')


% �ŗL�l�����Ă݂��B ���R��
eig(A);
eig(A2);

%% ����log

 data = GrandTruth(2:datalength,3);
Map = remakemap_multiply(data);
nMap = Map.*(1+Noise(:,:,3));
nMap2 = Map+Noise(:,:,3);

lnMap = log(nMap);
lnMap(~isfinite(lnMap))=0;
lnMap2 = log(nMap2);
lnMap2(~isfinite(lnMap2))=0;


[v, A]=  solve_Mapping(lnMap,wMap); % solved
[v2 ,A2]=  solve_Mapping(lnMap,wMap2); % solved

v=exp(v);
v2=exp(v2);

figure(7);
plot(GrandTruth(2:datalength,3),'r--');
hold on;
plot(v,'b');
plot(v2,'m-.');
% plot(v3,'k:');
grid on;
hold off;
legend('Ground Truth','Estimated with Full Map','Estimated with Neighbor Map')
xlabel('iteration')
ylabel('value')


figure(8);
plot(scale,abs(v-GrandTruth(2:datalength,3)),'b',scale,abs(v2-GrandTruth(2:datalength,3)),'m-.');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
xlabel('iteration')
ylabel('absolute error')

[w, A]=  solve_Mapping(lnMap2,wMap); % solved
[w2 ,A2]=  solve_Mapping(lnMap2,wMap2); % solved

w=exp(w);
w2=exp(w2);

figure(9);
plot(GrandTruth(2:datalength,3),'r--');
hold on;
plot(w,'b');
plot(w2,'m-.');
% plot(v3,'k:');
grid on;
hold off;
legend('Ground Truth','Estimated with Full Map','Estimated with Neighbor Map')
xlabel('iteration')
ylabel('value')


figure(10);
plot(scale,abs(w-GrandTruth(2:datalength,3)),'b',scale,abs(w2-GrandTruth(2:datalength,3)),'m-.');
grid on;
legend('Estimated with Full Map','Estimated with Neighbor Information','Location','Best')
xlabel('iteration')
ylabel('absolute error')
