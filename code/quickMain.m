function compressMat = quickMain(k, r)
% 速度优化主函数，优先取更多区块而不求解残缺子矩阵，返回十进制编码压缩后的矩阵。
%{
    params:
        k: k，因子数，即矩阵列数
        r: r，每个因子应满足的最少EE数量
    return:
        compressMat: 十进制编码压缩后的矩阵，为列向量
%}
[eeSeq, ~] = tableSeqs(k); % 得到EE序列
eeSeq = eeSeq(1:length(eeSeq)-1);
[~,~,~,eeLp,eeRp,~] = subEESeqSearch(eeSeq, r);  % 得到大于等于r的EE子序列
if eeLp == -1  % 如果没有找到合法序列
    compressMat = [];  % 矩阵为空
    return;
end

mats = quickRecurMat(k);  % 压缩矩阵序列
subMats = mats(eeLp:eeRp+1);  % 压缩矩阵子序列
compressMat = [];  % 声明压缩矩阵
for i = 1:length(subMats)  % 压缩矩阵合并
    compressMat = [compressMat;subMats{i}];
end

end