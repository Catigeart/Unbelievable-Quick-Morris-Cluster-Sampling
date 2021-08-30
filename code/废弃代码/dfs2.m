function mat = dfs2(n,m)

global matr mp flag cnt N M;
matr = zeros(2^n,n);
mp = 1;
flag = zeros(1,n);
cnt = 0;
N = n;
M = m;

dfs(1);
mat = matr;

    function dfs(p)
        if cnt==M
            matr(mp,:) = flag(:,:);
            mp = mp+1;
            return
        end
        if p>N
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