% need value map and weight map
function [v A] = solve_Mapping(valMap,wMap)

% if size(valMap) ~= size(wMap)
%     display(size(valMap));
%     display(size(wMap));
%     error('size of Map must be the same size');
% end

% �W���s��A�̌v�Z : Map���1������
n=size(wMap,1);
% �Ίp�����̌v�Z
diagAvec = sum(wMap,1).' + sum(wMap,2);     % �c������
diagA = diag(diagAvec(2:n));                                      % 1�s�ڂ͂���Ȃ�

tri = wMap(2:n,2:n); 
A = -tri+diagA-tri.';

% �x�N�g��B�̌v�Z
BMap = wMap .* valMap;
Bb = sum(BMap,1).' - sum(BMap,2);                 % �c������
B= Bb(2:n);

v = A\B;
end