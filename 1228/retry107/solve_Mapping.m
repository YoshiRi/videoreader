% need value map and weight map
function v = solve_Mapping(valMap,wMap)

if size(valMap) ~= size(wMap)
    display(size(valMap));
    error('size of Map must be the same size');
    display(size(wMap));
    exit;
end

% �W���s��A�̌v�Z
A = zeros(size(wMap));
% �Ίp�����̌v�Z
diagA = sum(wMap,1) - sum(wMap,2).';
A = - wMap + diag(diagA) + wMap';
% �ǉ��̍S������
alpha = zeros(1,size(A,2));
alpha(1)=1;
% �S���������������W���s��
Aa= vertcat(A,alpha);

% �x�N�g��B�̌v�Z
BMap = wMap .* valMap;
B = sum(BMap,1).' - sum(BMap,2);
%�ǉ��̍S������
beta = zeros(1,1);
beta(1)=0;
Bb= vertcat(B,beta);

% A�̃����N������Ȃ��ꍇ�͂ǂ����悤�c
if rank(Aa) < size(A,1)
    display(rank(A));
    display(rank(Aa));
    v = Aa;
    error('Aa is not full rank');
    return;
end
v = Aa\Bb;
% v = linsolve(Aa,B);
end