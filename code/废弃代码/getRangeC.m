function C=getRangeC(k)

C=false(2^k,k);
row=1;
for i=0:k
    n=(1:k);
    idxs=nchoosek(n,i);
    for j=1:size(idxs,1)
        C(row,idxs(j,:))=true;
        row=row+1;
    end
end
    
end