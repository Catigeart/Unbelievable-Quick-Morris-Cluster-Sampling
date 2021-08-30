function ce = partCombCell(n,m,total,limit,ee)

    ce = cell(ceil(total/limit),1);
    cp = 0;
    mat = false(limit,n);
    mp = 1;
    cntEE = zeros(1,n);
    while upperEE(cntEE,ee)==false
        % TODO: 局部排序优化
        target = min(cntEE);
        cntM = 0;
        flag = false(1,n);
        while cntM~=m
            for i = 1:n
                if cntM==m
                    break
                end
                if cntEE(i)==target
                    mat(mp,i) = true;
                    flag(i) = true;
                    cntM = cntM+1;
                %{
                else
                    mat(mp,i) = false;
                    flag(i) = false;
                    %}
                end
            end
            target = target+1;
        end
        mp = mp+1;
        if mp > limit
            ce(cp) = mat2cell(mat,limit,n);
            cp = cp+1;
            mat = zeros(limit,n);
            mp = 1;
        end
        for i = 1:n
            if flag(i)==true
                cntEE(i) = cntEE(i)+1;
            end
        end
    end
    if cp==length(ce) % 最后一个矩阵还没有放进去
        mat = mat(1:mp-1,:);
        ce(cp) = mat2cell(mat,mp-1,n);
    end

end

function judge = upperEE(cntEE,ee)

    judge = true;
    for i = 1:length(cntEE)
        if cntEE(i)<ee
            judge = false;
            return
        end
    end
    return

end