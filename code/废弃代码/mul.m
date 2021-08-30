function re = mul(a,b)

% https://zhuanlan.zhihu.com/p/61489377

% TODO: 增加小数处理


A = a - '0';
B = b - '0';
D = ifft(fft([zeros(size(B)) A]).*fft([zeros(size(A)) B]));
for ii = length(D):-1:2
    D(ii-1) = D(ii-1) + floor(D(ii)/10);
    D(ii)   = mod(D(ii),10);
end
re = [int2str(D(1)) cast(D(2:end-1)+'0','char')];

end