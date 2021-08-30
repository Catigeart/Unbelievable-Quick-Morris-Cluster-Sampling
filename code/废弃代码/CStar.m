function cells = CStar(k,r)

% 第n行的m个数可表示为 C(n-1，m-1)，即为从n-1个不同元素中取m-1个元素的组合数
% k对应交互关系为第n行组合数序列
% C(m,n)=n!/m!(n-m)!,C(0,n)=1,C(m,n)=C(m-n,n);
% C(m,n)=n(n-1)(n-2)...(n-m+1)/m!

% 直接用组合数阶乘公式算会溢出，此处用杨辉三角递推刷表。
table = zeros(k+1,k+1);
for i = 1:k
    table(i,1) = 1;
    table(i,i) = 1;
    for j = 2:i-1
        table(i,j) = table(i-1,j-1)+table(i-1,j);
    end
end

seq = table(k,:);
[lp,rp,adjust] = combSubSeqForC(seq,r);

matSeq = table(k+1,lp:rp+1);
% 丢边丢小边，加边加大边
if adjust~=0
    if lp==1
        isLeft = true;
    elseif rp==k+1
        isLeft = false;
    else
        if table(k,lp)<=table(k,rp)
            if adjust<0
                isLeft = true;
            else
                isLeft = false;
            end
        else
            if adjust<0
                isLeft = false;
            else
                isLeft = true;
            end
        end
    end
end
cells = cell(rp-lp+1,1);
limitRow = dynamicMatRow(k);
if rp == lp
    % TODO: 当只有一个区块且裁剪时会导致重复裁剪
end
if adjust~=0
    if Left==true
        if adjust>0
            cel = combCell(limitRow,k,1,totalRow);
        elseif adjust<0
        end
    end
end
for i = 2:rp-lp+1
    

end