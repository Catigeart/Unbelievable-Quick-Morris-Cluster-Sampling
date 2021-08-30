function re = bigComb(m,n)

re = BigUint(n);
for i = n-1:-1:n-m+1
    re = re*BigUint(i);
end
for i = 2:m
    re = re/BigUint(i);
end

end