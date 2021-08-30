function cel = combCell(limitRow,n,m,totalRow)

if totalRow<=limitRow
    cel = cell(1,1);
else
    cel = cell(ceil(totalRow/limitRow));
end
celP = 1;
mat = false(limitRow,n);
matP = 1;
chooseFlag = false(1,n);
cntFlag = 0;
totalCnt = 0;
dfs(1);
mat = mat(1:matP-1,:);
cel(celP) = mat2cell(mat,matP-1,n);

    function dfs(p)
        if p>n || totalCnt==totalRow
            return
        elseif cntFlag==m
            mat(matP,:) = chooseFlag(:,:);
            matP = matP+1;
            totalCnt = totalCnt+1;
            if matP>limitRow
                cel(celP)=mat2cell(mat,limitRow,n);
                celP = celP+1;
                mat = false(limitRow,n);
                matP = 1;
            end
            return
        end
        chooseFlag(p) = true;
        cntFlag = cntFlag+1;
        dfs(p+1);
        cntFlag = cntFlag-1;
        chooseFlag(p) = false;
        dfs(p+1);
    end

end