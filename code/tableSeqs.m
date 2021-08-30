function [eeSeq, matSeq] = tableSeqs(n)
% 杨辉三角递推求EE序列和矩阵行数序列（后者已弃用）
%{
    第一行是C_0^0，生成C_0^0到C_n^m的杨辉三角表。
    params:
        n: 代表最大的待选取物品数
    return:
        eeSeq: 由矩阵交互生成的ee数所组成的序列
        matSeq: 矩阵行数序列
%}
table = zeros(n+1,n+1);  % 初始化递推表
for i = 1:n+1
    table(i,1) = 1;
    table(i,i) = 1;
    for j = 2:i-1
        table(i,j) = table(i-1,j-1)+table(i-1,j); % 组合数递推公式
    end
end

eeSeq = table(n, :);
matSeq = table(n+1, :);

end