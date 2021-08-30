function [out,remainder] = div(a,b)

% https://blog.csdn.net/xsz591541060/article/details/108325273

% 转数字矩阵（为了逻辑方便，我们将数字反序）
mata = a(end:-1:1)-'0';
matb = b(end:-1:1)-'0';

% 计算位数
la = length(a);
lb = length(b);

% 转数字（按四位分组）
numa = mata(end:-1:1);
numb = 0;
for k = 1:lb
    numb = numb+matb(k)*10^(k-1);
end

% 分组除保存结果
res = zeros(1,la); %
remainder = 0; % 每次计算的余数
for i = 1:la
    divisor = numa(i)+remainder*10; % 被除数 = 上一组的余数*10000+这一组
    remainder = rem(divisor,numb);
    res(i) = (divisor-remainder)/numb; 
end

% 转字符
remainder = num2str(remainder);
out = char(res+'0');
while out(1)=='0'
    out(1) = [];
end
if ~flag
    out = ['-',out];
end

end
