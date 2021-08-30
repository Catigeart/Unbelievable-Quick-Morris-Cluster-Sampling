function C=getFullC(k)

C=zeros(2^k,k);
for i=0:2^k-1
    binStr=dec2bin(i);
    for j=strlength(binStr):-1:1
        C(i+1,k-length(binStr)+j)=str2double(binStr(j));
    end
end

end