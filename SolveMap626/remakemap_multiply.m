function Map = remakemap(v)

n = size(v,1)+1;
Map = zeros(n);

Map(1,2:n) = v;

for i = 2:n-1
    for j = i+1:n
        Map(i,j) =  Map(1,j) / Map(1,i);
    end
end

end