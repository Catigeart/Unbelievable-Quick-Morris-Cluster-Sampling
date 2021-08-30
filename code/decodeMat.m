function cel = decodeMat(compressMat, col)
% 解码矩阵，将十进制编码的向量还原成0-1矩阵。
%{
    params:
        compressMat: 列向量，其中每个元素为以十进制数表示的压缩向量。
        col: 向量的列数，即k。
    return: 
        cel: 元胞数组，将过大的矩阵切分放置到元胞数组中不同的元胞中。
%}
C = Constants();  % 常量对象
rowLimit = ceil(C.MAT_MAXSIZE/col);  % 矩阵行数限制
row = length(compressMat);  % 总行向量数
cntCell = ceil(row/rowLimit);  % 总元胞数
cel = cell(cntCell, 1);  % 初始化元胞数组
celP = 1;  % 元胞数组指针，指示当前应修改的元胞位置
mat = false(rowLimit, col);  % 初始化矩阵
matP = 1;  % 矩阵指针，指示当前应修改的矩阵位置
for i = 1:row  % 遍历所有压缩行向量
    vec = decode(compressMat(i), col);  % 解码还原向量
    mat(matP, :) = vec;  % 将向量置入矩阵中
    if matP == rowLimit  % 如果矩阵指针已经达到行数限制
        cel{celP} = mat; % 将矩阵置入元胞中
        celP = celP+1;  % 元胞指针+1
        mat = false(rowLimit, col);  % 重置矩阵
        matP = 1;  % 重置矩阵指针
    else  % 矩阵指针未达到行数限制
        matP = matP+1;  % 矩阵指针+1
    end
end
if matP ~= rowLimit  % 如果遍历完成后矩阵指针未达到行数限制，相当于未放入元胞
    mat = mat(1:matP-1, :);  % 裁剪预申请的过剩空间
    cel{celP} = mat;  % 将矩阵置入元胞中
end

end

function vec = decode(n, col)    
%{
    将十进制数解码成0-1向量。
    params:
        n: 压缩的十进制数.
        col: 列数，即k。
%}
vec = false(1, col);  % 初始化行向量
for i = col:-1:1  % 模2取余法，逆序填入向量
    vec(i) = logical(mod(n, 2));  % 模2，并将余数压缩成logical数据类型
    n = floor(n/2);  % 向下取整，去除n/2的小数（重要）
end
        
end