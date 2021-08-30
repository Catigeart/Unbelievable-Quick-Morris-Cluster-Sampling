function partMat = getPartMat(k_, m_, isLeft, rRest)
% （优先队列已证实是错误解）回溯法+优先队列，求得“不完整”的子矩阵。
%{    
    params:
        k_: k，即矩阵列数
        m_: m, 对应矩阵序列中的第m+1个矩阵，每行k列中有m个1
        isLeft: 真值，标志子矩阵相对序列的位置，如果在左侧，ee数=0数，反之=1数
        rRest: 子矩阵每列至少要达到的ee数
    return:
        partMat: “不完整”的子矩阵
%}
global k m totEE pq hs linkedList rowLimit mat matSize1 eeMask cntEE

k = k_;  % 将k传入全局变量
m = m_;  % 将m传入全局变量
r = rRest;  % 将rRest传入r
if isLeft == true  % 如果在左边，ee数=0数
    totEE = k-m;
else  % 如果在右边，ee数=1数
    totEE = m;
end
C = Constants();  % 常量对象
pq = java.util.PriorityQueue;  % 优先队列，动态维护回溯次序
hs = java.util.HashSet;  % 哈希表，记录当前向量是否已被选取
linkedList = LinkedList();  % 建立空链表
for i = 1:k  % 将k个因子入队
    pq.add(initData(i));  % 初始化优先队列
end

rowLimit = round(C.MAT_MAXSIZE/k);  % 矩阵最大行数约束
mat = false(rowLimit, k);  % 初始化空矩阵
matSize1 = 0;  % 矩阵行数量，起指针作用

ok = false;  % ok标志是否r已找齐
while ~ok
    eeMask = false(1, k);  % 重置eeMask
    cntEE = 0;  % 当前向量ee数
    % arr = pq2arr(pq);
    reBack(1);  % 第一步回溯
    ok = verifyR(pq, r);  % 验证是否满足r数量
end

if matSize1 ~= 0  % 如果最后一个矩阵没有被放入结点中
    mat = mat(1:matSize1, :);  % 矩阵空间裁剪
    %{
    node.data = mat;  % 把矩阵放入结点中
    linkedList.append(node);  % 把结点加入链表
    %}
    linkedList.append(mat);
end

partMat = linkedList;  % 将链表赋值给返回变量，总矩阵用链表表示

    function finished = reBack(step)
    %{
        回溯函数。
        params:
            step: 标志当前是第step步决策
        return:
            finished: 标志是否已求得一个合法解
    %}
        if cntEE > totEE || k-step+1+cntEE < totEE ...  % 如果无法满足ee
                || (step == k+1 && cntEE ~= totEE)  % 如果遍历完成仍不满足
            finished = false;  % 提示未找到解
            return
        end
        
        if cntEE == totEE  % 如果ee数满足要求        
            if totEE ~= m  % 如果totEE与m不同
                ansMask = ~eeMask;  % 则说明ansMask与eeMask取反
            else
                ansMask = eeMask;  %否则即为原样（ans指示1的位置）
            end
            dataArr = pq2arr(pq);  % 把优先队列转化为队列元素数组
            idxArr = getIdxFromData(dataArr);  % 从队列元素数组提取索引素组
            keys = idxArr(:, ansMask);  % 求出向量中1的集合
            key = arr2key(keys);  % 转换为哈希表键
            if hs.add(key) == true  % 如果插入成功，说明当前无此记录
                %%%% 重置记录 %%%%
                p = 1;
                tmp = zeros(1, k);
                while p < step  % 当前已进行step-1次决策
                    tmp(p) = pq.poll();  % 出队元素
                    if eeMask(p)  % 如果对应第p轮产生了ee
                        tmp(p) = updateData(tmp(p));  % 更新ee次数
                    end
                    p = p+1;
                end
                for q = 1:step-1
                    pq.add(tmp(q));  % 对更新后的信息重新入队
                end
                %%%% 加入到矩阵当中 %%%%
                vec = false(1, k);  % 初始化0向量
                for j = 1:length(keys)  % 遍历keys集
                    vec(keys(j)) = true;  % 对1位置赋值
                end
                matSize1 = matSize1+1;  % 行数+1
                mat(matSize1, :) = vec;  % 填充新向量
                if matSize1 == rowLimit  % 如果矩阵已满
                    %{
                    node.data = mat;  % 把矩阵放入结点
                    linkedList.append(node); % 把结点加入链表
                    node = Node();  % 生成新结点
                    %}
                    linkedList.append(mat);
                    mat = false(rowLimit, k);  % 生成新矩阵
                    matSize1 = 0; % 新矩阵行数为0
                end
                
                finished = true;  % 找到一个解，完成标志为真
            else
                finished = false; % 未找到一个解，完成标志为假
            end
            return;
        end
        
        eeMask(step) = true;  % 当前步取ee
        cntEE = cntEE+1;  % ee计数+1
        finished = reBack(step+1);  % 对下一步进行回溯
        eeMask(step) = false; % 清除当前步ee标记
        cntEE = cntEE-1;  % ee计数-1
        if finished  % 如果完成标志为真
            return  % 返回
        end
        finished = reBack(step+1);  % 否则对不选取ee进行回溯
        return  % 不管是否finish，都得return了
    end

end

function x = initData(i)
%{
    初始化队列元素。
    params:
        i: 标志第i号元素
    return:
        x: 完成初始化的队列元素
%}
% 用浮点数同时编码计数和编号信息，约定小数部分为因子，整数部分为EE计数
% 元素初始化、取元素、更新元素操作必须配套一致。
x = i*0.0001;  

end

function idx = getIdxFromData(x)
%{
    从队列元素中提取索引信息。
    params:
        x: 队列元素
    return:
        idx: 队列元素对应的因子下标
%}
% 约定小数部分为因子，整数部分为EE计数
% 元素初始化、取元素、更新元素操作必须配套一致。
idx = round((x-floor(x))*10000);  % 从数据中提取小数部分并还原idx

end

function x = updateData(x)
%{
    队列元素EE计数+1。
    params:
        x: 队列元素
    return:
        x: 计数+1后的队列元素
%}
% 约定小数部分为因子，整数部分为EE计数
% 元素初始化、取元素、更新元素操作必须配套一致。
x = x+1;  % 计数+1

end

function arr = pq2arr(pq)  % 指针遍历填充给matrix数组
%{
    将java的优先队列转化为matlab的数组。
    params:
        pq: java的优先队列
    return:
        arr: matlab的行数组
%}
iter = pq.iterator();  % 获取队列迭代器
arr = zeros(1, pq.size());  % 初始化行数组
p = 1;  % arr指针，指示应该修改的arr位置
while iter.hasNext()  % 若优先队列还有下一个元素
    arr(p) = iter.next();  % 将优先队列元素赋值给arr，迭代器位置+1
    p = p+1;  % arr指针+1
end

end

function ok = verifyR(pq, r)
%{
    验证优先队列各元素的EE计数是否已达到r。
    params:
        pq: 优先队列，存储各因子的计数及下标信息
        r: 各列应达到的EE数
    return:
        ok: 成功标志，若已满足条件则为true，否则为false
%}
ok = true;  % 成功标志
iter = pq.iterator();  % 取优先队列迭代器
while iter.hasNext()  % 当优先队列还有下一个元素
    tmp = iter.next();  % 取优先队列元素，迭代器位置+1
    if tmp < r  % 如果该元素比r小
        ok = false;  % 成功标志置假
        break  % 跳出循环
    end
end
    
end

function key = arr2key(keys)
%{
    将二进制向量编码成十进制数作为哈希表的键值。
    params:
`       keyIdxArr: 键下标集合
    return:
        key: 原0-1向量逆序编码生成的十进制数
%}
    key = 0;
    for i = 1:length(keys) 
        key = key+2^(keys(i)-1);
    end
end