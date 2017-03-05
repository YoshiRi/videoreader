% need value map and weight map 
% doing minimization with Linear Least Square method
function v  = solve_Mapping_LS(valVec,W,SpMat)

% if size(valMap) ~= size(wMap)
%     display(size(valMap));
%     display(size(wMap));
%     error('size of Map must be the same size');
% end

% Least-Square-Problem
v = (SpMat.'*W*SpMat)\SpMat.' * valVec;
end