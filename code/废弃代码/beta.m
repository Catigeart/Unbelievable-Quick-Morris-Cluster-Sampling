function cells = beta(k,r)

table = zeros(k+1,k+1);
for i = 1:k+1
    table(i,1) = 1;
    table(i,i) = 1;
    for j = 2:i-1
        table(i,j) = table(i-1,j-1)+table(i-1,j);
    end
end

[lp,rp,adjust] = combSubSeqForC(table(k,:),r);
seq = table(k+1,lp:rp+1);
cells = cell(rp-lp+2,1);
% limitRow = dynamicMatRow(k);
limit = 5; % beta
for i = 1:rp-lp+2
    cel = combCell(k,lp+i-2,seq(i),limit);
    cells(i) = cel;
end

end