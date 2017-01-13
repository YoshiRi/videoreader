% need value map and weight map
function v = solve_Mapping(valMap,wMap)

if size(valMap) ~= size(wMap)
    display(size(valMap));
    error('size of Map must be the same size');
    display(size(wMap));
    exit;
end

% ŒW”s—ñA‚ÌŒvZ
A = zeros(size(wMap));
% ‘ÎŠp¬•ª‚ÌŒvZ
diagA = sum(wMap,1) - sum(wMap,2).';
A = - wMap + diag(diagA) + wMap';
% ’Ç‰Á‚ÌS‘©ğŒ
alpha = zeros(1,size(A,2));
alpha(1)=1;
% S‘©ğŒ‚ğ‰Á‚¦‚½ŒW”s—ñ
Aa= vertcat(A,alpha);

% ƒxƒNƒgƒ‹B‚ÌŒvZ
BMap = wMap .* valMap;
B = sum(BMap,1).' - sum(BMap,2);
%’Ç‰Á‚ÌS‘©ğŒ
beta = zeros(1,1);
beta(1)=0;
Bb= vertcat(B,beta);

% A‚Ìƒ‰ƒ“ƒN‚ª‘«‚è‚È‚¢ê‡‚Í‚Ç‚¤‚µ‚æ‚¤c
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