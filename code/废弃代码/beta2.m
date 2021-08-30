function cells = beta2(k,r)
    % TODO: 组合数刷表仍然很容易爆表，如果要承受更大的k，必须用大数类替代
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
    len = length(seq);
    cells = cell(rp-lp+2+2,1);
    limit = dynamicMatRow(k);
    % limit = 5; % beta

    left = false;
    right = false;
    % 减丢小，加增大
    % WARNING: 向量数量调整写错了，要把r数转化为向量数
    % total_adjust = adjust*r, and each vector of the current block has 
    % lp+i-2 EE, so should add ad least ceil((adjust*r/(lp+i-2)) or minus
    % at least floor(adjust*r/lp+i-2) vectors
    
    % TODO: 修正BUG
    % 很显然暴力减向量会出问题，因为不能保证减去的向量位置是均匀的。如果要减，
    % 组合的写法要从dfs改成均匀增加+哈希。哈希也会遇到爆表的问题。
    % 好吧哪怕把暴力减向量改掉也得考虑均匀加向量的问题，组合数写法要重来。
    if adjust<0
        if seq(1)<=seq(len)
            left = true;
        else
            right = true;
        end
    elseif adjust>0
        if lp==1
            right = true;
        elseif rp+1==k+1
            left = true;
        else
            if seq(1)<seq(len)
                right = true;
            else
                left = true;
            end
        end
    end
    
    if adjust>0 && left==true
        m = lp-1;
        cel = combCell(k,m,adjust,limit);
        cells(1) = {cel};
    end
    % i=1
    total = seq(1);
    if adjust<0 && left==true
        total = total+adjust;
    end
    cel = combCell(k,lp+1-2,total,limit);
    cells(2) = {cel};
    for i = 2:len-1
        cel = combCell(k,lp+i-2,seq(i),limit);
        cells(i+1) = {cel};
    end
    if len~=1 % 最后一个区块，避免重复计算
        total = seq(len);
        if adjust<0 && right==true
            total = total+adjust;
        end
        cel = combCell(k,lp+len-2,total,limit);
        cells(len+1) = {cel};
    end
    if adjust>0 && right==true
        m = rp+2;
        cel = combCell(k,m,adjust,limit);
        cells(len+2) = {cel};
    end
end