function cntR = verify(cel, k)
% 矩阵ee生成情况验证程序。
%{
    params:
        cel: 元胞数组，其中每个元胞放置总矩阵的一部分
        k: 因子数，即矩阵列数
    return:
        cntR: 因子EE计数数组
%}
celLen = length(cel);  % 获得元胞长度
cntR = zeros(1, k);  % 空计数数组
for i = 1:celLen  % 遍历每个元胞
    mat = cel{i};  % 取第i个元胞的矩阵
    matLen = size(mat, 1);  % 取矩阵行数
    for j = 1:matLen  % 对于当前矩阵的每一行
        vec = mat(j, :); % 取第j行行向量
        cntR = verifyMat(vec, mat, j, cntR);  % 
        for k = i+1:celLen  % 对于余下的矩阵，都要比较
            mat_ = cel{k}; % 取出第k个矩阵
            cntR = verifyMat(vec, mat_, 0, cntR);  % 从0开始，相当于检索全部
        end
    end
end

end

function cntR = verifyMat(vec, mat, vecP, cntR)

matLen = size(mat, 1);  % 求当前矩阵行数
for i = vecP+1:matLen  % 从下一行开始
    tmp = mat(i, :); % 取出第i行向量
    note = -1; % note为ee下标
    for j = 1:length(vec)  % 每行位置逐个比较
        if vec(j) ~= tmp(j)  % 如果不相等
            if note == -1  % 如果以前还没有出现过不相等
                note = j;  % 记录不相等下标
            else
                note = -1;  % 否则，说明不止一个不相等，不能形成ee，break
                break;
            end
        end
    end
    if note ~= -1  % 如果有ee
        cntR(note) = cntR(note)+1;  % cntR对应位置+1
    end
end

end