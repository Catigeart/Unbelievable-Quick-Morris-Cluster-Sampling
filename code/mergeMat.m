function cel = mergeMat(subMatSeq, col)
% 将子矩阵链表元胞数组的矩阵合并。
%{   
    params:
        subMatSeq: 元胞数组，其中每个元素存放链表，链表每个结点存放部分矩阵
        col: 矩阵列数，即k
    return:
        cel: 元胞数组，将完整的大矩阵做部分切分放入元胞中避免爆连续内存
%}
C = Constants();  % 常量对象
rowLimit = ceil(C.MAT_MAXSIZE/col);  % 求矩阵行数限制
len = length(subMatSeq);  % 元胞序列长度
cel = cell(1, 1);  % 初始化元胞数组，因为无法确定元胞数组长度而初始化(1,1)
celP = 1;  % 元胞数组指针，指示当前应当修改的元胞位置
mat = false(rowLimit, col);  % 初始化矩阵
matP = 1;  % 矩阵数组，指示当前应当修改的矩阵行
for i = 1:len  % 遍历每个元胞位置
    LL = subMatSeq{i};  % 提取对应位置链表
    iter = LL.iterator();  % 生成迭代器
    while iter.hasNext()  % 迭代器遍历链表
        tmp = iter.next();  % 提取结点矩阵
        tmpR = size(tmp, 1);  % 计算结点矩阵行数
        if matP+tmpR-1 <= rowLimit  % 如果可以放入矩阵的剩余空间
            mat(matP:matP+tmpR-1, :) = tmp;  % 合并矩阵
            matP = matP+tmpR;  % 更新矩阵指针
        else  % 如果不足以放入矩阵的剩余空间
            if matP ~= rowLimit  % 如果矩阵指针没有达到最大行数量
                mat = mat(1:matP-1, :);  % 裁剪未使用的预分配空间
                cel{celP} = mat;  % 将矩阵放入元胞
                celP = celP+1;  % 元胞指针+1
                mat = false(rowLimit, col);  % 重置矩阵
                matP = 1;  % 重置矩阵指针
            end
        end
    end
end

if matP ~= rowLimit  % 如果完成遍历后，矩阵指针未达到最大行，即未放入元胞
    mat = mat(1:matP-1, :);  % 裁剪多余空间
    cel{celP} = mat;  % 将矩阵放入元胞
end

end