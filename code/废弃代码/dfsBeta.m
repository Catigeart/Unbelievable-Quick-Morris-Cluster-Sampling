function mat = dfsBeta(n,m)


global mat = zeros(2^n,n);
global mp = 1;
global flag = zeros(1,n);
global cnt = 0;
dfs(1);

    function dfs(p)
        if p>n
            return
        end
        if cnt==m
            mat(mp,:) = flag(:,:);
            mp = mp+1;
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