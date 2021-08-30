function subMatSeq = main(k, r)
% 主函数，求满足指定k，r条件的子矩阵序列。
%{
    params:
        k: 因子数，即矩阵列数
        r: 每个因子应达到的目标EE数
    return:
        subMatSeq: 元胞数组，其中每个元胞放置了一个链表，链表结点为部分矩阵
%}
[eeSeq, ~] = tableSeqs(k);  % 获得k对应的EE序列
eeSeq = eeSeq(1:length(eeSeq)-1);
% 获得EE子序列的左右下标及需要调整的r数
[eeLp, eeRp, eeAdjust,~,~,~] = subEESeqSearch(eeSeq, r);  
if eeLp == -1  % 如果找不到解
    subMatSeq = [];  % 返回空
    return
end

if eeAdjust ~= 0  % 如果存在需要调整的r数
    if eeLp == 1  % 如果ee子序列左下标位于最左端
        isLeft = false;  % 只能取右边的子矩阵
    elseif eeRp == k+1  % 如果ee子序列右下标位于最右端
        isLeft = true;  % 只能取左边的子矩阵
    else  % 否则选择ee比较“稠密”的一端进行部分扩充
        if eeSeq(eeLp) < eeSeq(eeRp)  
            isLeft = false;
        else
            isLeft = true;
        end
    end
end

matSeq = recursiveMat(k);  % 递推求解子矩阵序列
subMatSeq = matSeq(eeLp:eeRp+1);  % 截取子矩阵序列的子序列
if eeAdjust ~= 0  % 如果需要调整
    if isLeft == true  % 如果位于左侧
        m_ = eeLp-1-1;  % m在序列左侧，因为m从0开始而p从1开始因此额外-1
        rRest = eeAdjust;  % 剩余r，即调整数
        partMat = getPartMat(k, m_, isLeft, rRest);  % 求得调整矩阵的链表
        subMatSeq = {partMat subMatSeq{:,:}};  % 并入元胞数组
    else  % 同理。
        m_ = eeRp+1;  % 而这边不用
        rRest = eeAdjust;
        partMat = getPartMat(k, m_, isLeft, rRest);
        subMatSeq = {subMatSeq{:,:} partMat};
    end    
end

end