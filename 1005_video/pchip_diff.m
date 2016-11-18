function diffs = pchip_diff(x,y,tx)
%  get time derivative value using cubic spline  
% the boundary slope = 0
% 
%%%  inputs 
% x: x axis break points val, y : y axis break points val, 
% tx : actual x val , dim : dimention
%
% %% output
% diffs : differential val for any points

pp = pchip(x,[y.']);
[breaks,coefs,l,k,d] = unmkpp(pp);

n = size(coefs,2);
l =  size(coefs,1);

% get derivative 
if n == 1
diffs = tshow .* 0;
end

dcoefs = zeros(l,n-1);
for i = 1 : n-1
    dcoefs(:,i) = coefs(:,i) .* (n - i );
end

dd = mkpp(breaks,dcoefs);

diffs = ppval(dd,tx);
end