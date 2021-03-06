% need value map and weight map
function v = solve_Mapping(valMap,wMap)

if size(valMap) ~= size(wMap)
    display(size(valMap));
    error('size of Map must be the same size');
    display(size(wMap));
    exit;
end

% 係数行列Aの計算
A = zeros(size(wMap));
% 対角成分の計算
diagA = sum(wMap,1) - sum(wMap,2).';
A = - wMap + diag(diagA) + wMap';
% 追加の拘束条件
alpha = zeros(1,size(A,2));
alpha(1)=1;
% 拘束条件を加えた係数行列
Aa= vertcat(A,alpha);

% ベクトルBの計算
BMap = wMap .* valMap;
B = sum(BMap,1).' - sum(BMap,2);
%追加の拘束条件
beta = zeros(1,1);
beta(1)=0;
Bb= vertcat(B,beta);

% Aのランクが足りない場合はどうしよう…
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