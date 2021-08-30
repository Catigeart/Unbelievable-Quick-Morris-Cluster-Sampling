function ce = partCombCell(n,m,total,limit,ee)
    global N
    N = n;
    
    while ok==false
        dfs(1);
        target = target+1;
    end
    
    function [vec,ok] = dfs(p)
        if p==N
            ok = hashCheck(vec);
            return
        end
        
    end
    
    function ok = hashCheck(vec)
        % TODO: hash check
        ok = true;
    end


end