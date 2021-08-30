function ce = combCell(n,m,total,limit)

    global cel cp mat mp flag cnt tot
    cel = cell(ceil(total/limit),1);
    cp = 1;
    mat = zeros(limit,n);
    mp = 1;
    flag = zeros(1,n);
    cnt = 0;
    tot = 0;
   
    dfs(1);
    if cp==length(cel) % 最后一个矩阵还没有放进去
        mat = mat(1:mp-1,:);
        cel(cp) = mat2cell(mat,mp-1,n);
    end
    ce = cel;

    function dfs(p)
        if tot==total % 残缺区块裁剪
            return
        end
        if cnt==m
            mat(mp,:) = flag(:,:);
            mp = mp+1;
            tot = tot+1;
            if mp > limit
                cel(cp) = mat2cell(mat,limit,n);
                cp = cp+1;
                mat = zeros(limit,n);
                mp = 1;
            end
            return
        end
        if p>n || n-p+1<m-cnt % p边界及预剪枝
            return
        end        
        flag(p) = true;
        cnt = cnt+1;
        dfs(p+1);
        flag(p) = false;
        cnt = cnt-1;
        dfs(p+1);
    end

end