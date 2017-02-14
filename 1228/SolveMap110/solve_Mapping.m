% need value map and weight map
function [v A] = solve_Mapping(valMap,wMap)

% if size(valMap) ~= size(wMap)
%     display(size(valMap));
%     display(size(wMap));
%     error('size of Map must be the same size');
% end

% ŒW”s—ñA‚ÌŒvZ : Map‚æ‚è1‚Â¬‚³‚¢
n=size(wMap,1);
% ‘ÎŠp¬•ª‚ÌŒvZ
diagAvec = sum(wMap,1).' + sum(wMap,2);     % c‘«‚·‰¡
diagA = diag(diagAvec(2:n));                                      % 1s–Ú‚Í‚¢‚ç‚È‚¢

tri = wMap(2:n,2:n); 
A = -tri+diagA-tri.';

% ƒxƒNƒgƒ‹B‚ÌŒvZ
BMap = wMap .* valMap;
Bb = sum(BMap,1).' - sum(BMap,2);                 % cˆø‚­‰¡
B= Bb(2:n);

v = A\B;
end