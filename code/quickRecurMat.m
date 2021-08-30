function mats = quickRecurMat(k)

seqs = cell(2, k+1);  % 定义序列元胞数组
prev = 1;  % 指示上一个序列的行标
cur = 2;  % 指示当前序列的行标
for ki = 1:k  % 第1到k,列为m=0:k，C_0_0不用打表，从第二行开始
    for mi = 1:ki+1
        if mi == 1  % m == 0
            seqs{cur, mi} = 0;
        elseif ki == mi-1  % k == m
            seqs{cur, mi} = 0;
            pow2 = 1;  % 幂次复用避免反复求幂
            for i = 1:k  % 所有位为1相当于2的幂次累加                
                seqs{cur, mi} = seqs{cur, mi}+pow2;
                pow2 = pow2*2;
            end
        else  % 否则递推
            seqs{cur, mi} = [seqs{prev, mi-1}*2+1;seqs{prev, mi}*2];
        end
    end
    [prev, cur] = deal(cur, prev);  % 交换指针
end
            
mats = seqs(prev, :);   % 由于最后做了一次交换指针，因此prev指向最新的答案            

end