function re = tmpDiv(a,b)

lenA = length(a);
lenB = length(b);
re = '';
p = 1;
b = num2str(b);
% a最终会变成余数
while lenB+p<=lenA+1
    tmp = str2num(a(p:lenB+p));
    if b<=tmp
        cnt = 0;
        while b<=tmp
            tmp = tmp-b;
            cnt = cnt+1;
        end
        
        a = [num2str(minus) a(lenB+p+1:lenA)];
        lenA = length(a);
    elseif b>tmp && lenB+p+1<=lenA+1
        tmp = str2num(a(p:lenB+p+1));
    end
    
end

end