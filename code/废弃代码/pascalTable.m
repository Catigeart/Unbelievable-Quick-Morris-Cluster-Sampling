function table = pascalTable(n)

table = zeros(n+1,n+1);
for i = 1:n+1
    table(i,1) = 1;
    table(i,i) = 1;
    for j = 2:i-1
        table(i,j) = table(i-1,j-1)+table(i-1,j);
    end
end

end