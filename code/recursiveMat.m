function matSeq = recursiveMat(k)
% 递推求元胞链表矩阵序列。
%{
    params:
        k: k，因子数，即矩阵列数
    return:
        matSeq: 矩阵序列，为元胞数组，数组元素为链表，链表结点存放部分矩阵块
%}
seqs = cell(2, k+1);  % 初始化元胞数组
prev = 1;  % 指示上一个行编号
cur = 2;  % 指示当前行编号
for ki = 1:k  %  % 第1到k,列为m=0:k，C_0_0不用打表，从第二行开始
    for mi = 1:ki+1
        LL = LinkedList();
        if mi == 1  % m == 0
            LL.append(false(1, ki));
        elseif ki == mi-1  % k == m
            LL.append(true(1, ki));            
        else
            LL1 = seqs{prev, mi-1};
            LL2 = seqs{prev, mi};
            LL1 = addCol(LL1, true);
            LL2 = addCol(LL2, false);
            LL = addRow(LL1, LL2);
        end
        seqs{cur, mi} = LL;
    end
    [prev, cur] = deal(cur, prev);
end

matSeq = seqs(prev, :);
%{
MTable = cell(k, k+1);  % 第1到k,列为m=0:k，C_0_0不用打表，从第二行开始
for ki = 1:k
    for mi = 1:ki+1
        if mi == 1  % m == 0
            MTable(ki, mi) = {false(1, ki)};
        elseif ki == mi-1  % k == m
            MTable(ki, mi) = {true(1, ki)};
        else
            M1 = cell2mat(MTable(ki-1,mi));
            M2 = cell2mat(MTable(ki-1,mi-1));
            row1 = size(M1, 1);
            row2 = size(M2, 1);
            MTable(ki, mi) = {[M1 false(row1,1);
                               M2 true(row2,1)]};
        end
    end
end
    
matSeq = MTable(k, :);    
%}

end

function LLNew = addCol(LL, colBool)
% 矩阵横向扩充（列扩充）
%{
    params:
        LL: 待扩充的矩阵链表，LinkedList的缩写
        colBool: 新列的真值，指示是true还是false
%}
C = Constants();
LLNew = LinkedList(LL);  % 复制到新链表然后返回
iter = LLNew.iterator();  % 生成迭代器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while iter.hasNext()  % 迭代器迭代链表
    mat = iter.next();  % 取出当前指示结点的矩阵
    row = size(mat, 1);  % 得到矩阵行数
    if colBool == false  % 扩充0列
        matNew = [mat false(row, 1)];
    else  % 扩充1列
        matNew = [mat true(row, 1)];
    end
    col = size(mat, 2);  % 得到矩阵列数
    if row*col > C.MAT_MAXSIZE  % 检测矩阵尺寸是否超出最大尺寸限制
        % 矩阵分裂
        cutRow = floor(row/2);
        mat1 = matNew(1:cutRow,:);
        mat2 = matNew(cutRow+1:row,:);
        LLNew.updateByIter(iter, mat1);
        LLNew.insertByIter(iter, mat2);        
    else  % 如果不分裂，原地更新矩阵
        LLNew.updateByIter(iter, matNew);
    end
end

end

function LLNew1 = addRow(LL1, LL2)
% 矩阵纵向合并（行扩充）
%{
    params:
        LL1: 矩阵链表1
        LL2: 矩阵链表2
    return:
        LLNew1: 新链表，LL2接到LL1上，代表行的扩充
%}
C = Constants();  % 常量对象
LLNew1 = LinkedList(LL1);  % 复制到新链表
LLNew2 = LinkedList(LL2);
[r1, c1] = size(LLNew1.tail.data);  % 得到链表1尾结点矩阵尺寸
[r2, c2] = size(LLNew2.head.next.data);  % 得到链表2第一个矩阵的尺寸
if r1*c1*r2*c2 < C.MAT_MAXSIZE  % 如果合并矩阵不会超过尺寸限制
    mat = [LLNew1.tail.data;LLNew2.head.next.data];  % 合并矩阵
    LLNew1.tail.data = mat;
    LLNew1.tail.next = LLNew1.head.next.next;
else
    LLNew1.tail.next = LLNew2.head.next;  % 否则直接链表2接到链表1上
end
    
end