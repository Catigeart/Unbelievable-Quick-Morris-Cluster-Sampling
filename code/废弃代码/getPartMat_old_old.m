function partMat = getPartMat(k_, m_, isLeft, rRest)

global k m r eeCol pq hs s linkedList node eeVec cntEEInVec rowLimit tmpMat tmpMatRow

k = k_;
m = m_;
r = rRest;

if isLeft == true  % 如果是左边的矩阵，ee数由0决定
    eeCol = k-m;
else
    eeCol = m;
end

pq = java.util.PriorityQueue;
hs = java.util.HashSet;
linkedList = LinkedList();
node = Node();
s = java.util.Stack();
for i = 1:k
    pq.add(initPQData(i))
end
eeVec = false(1, k);
cntEEInVec = 0;
rowLimit = floor(MAT_MAXSIZE/k);
tmpMat = false(rowLimit, k);
tmpMatRow = 0;

colInfo = pq.poll();  % 出队最小元素
s.push(colInfo)
idx = getIdxFromPQData(colInfo);
ok = false;
while ~ok  % 当还没有求出足够多的解
    ok = verifyR();
    if ~ok
        eeVec(idx) = true;  % 设idx个取ee
        cntEEInVec = 1;
        finished = reBack(1, idx);
        if finished == true
            continue  % 重要！这样才能保证每次取最小元素
        end
    end
    ok = verifyR();  % 每完成一次都要检查解情况
    if ~ok
        eeVec(idx) = false;  % 设idx个不取ee
        cntEEInVec = 0;
        reBack(1, idx);
    end
end

    function ok = verifyR
        % 验证是否各列已经满足r条件
        ok = true;
        iter = pq.iterator();
        while iter.hasNext()
            tmp = iter.next();
            if tmp < r
                ok = false;
                break
            end
        end
    end

    function finished = reBack(step, idx)
        if cntEEInVec > eeCol || k-step+cntEEInVec < eeCol || step > k
            % 不可能出现的异常情况
            ME = MException('Expection:cntEEInVec exception',...
                'This is impossible to happen!');
            throw(ME) 
        end
        if cntEEInVec == eeCol
            % 找到一个可能解
            if eeCol ~= m
                ansVec = ~eeVec;  % 取反
            else
                ansVec = eeVec;
            end
            key = vec2key(ansVec);  % 求哈希键值
            if hs.add(key) == true  % 如果尚未存在此行
                %%TODO:把ansVec加入到矩阵中去%%
                while s.empty == false  % 入队
                    x = s.pop();
                    if eeVec(p) == true  % 更新ee
                        x = updatePQData(x);
                    end
                    pq.add(x);
                end
                finished = true;  % 已经得到一个解，提示重新搜索
            else
                if eeVec(idx) == true  % 回退操作擦除当前步ee
                    eeVec(idx) = false;
                    cntEEInVec = cntEEInVec-1;
                end
                finished = false;
            end
            return  % 向上层返回
        end
        x = pq.poll();  % 出队最小元素
        s.push(x);  % 压入记录栈
        idx = getIdxFromPQData(x);        
        eeVec(idx) = true;  % idx选定ee
        cntEEInVec = cntEEInVec+1;
        finished = reBack(step+1, idx);
        if finished == true  % 如果完成一次求解，回退
            return
        end
        eeVec(idx) = false;  % idx不选定ee
        cntEEInVec = cntEEInVec-1;
        finished = reBack(step+1, idx);
        if finished == true  % 如果完成一次求解，回退
            return
        end     
        x = s.pop();  % 如果未完成求解，应当重新把x入队
        pq.add(x);
    end

    function x = initPQData(i)
        x = i*0.0001;
    end
    function idx = getIdxFromPQData(x)
        idx = (x-floor(x))*1000;
    end
    function x = updatePQData(x)
        x = x+1;
    end
    function key = vec2key(ansVec)
        key = 0;
        pow2 = 0.5;
        for digit = length(ansVec):-1:1
            pow2 = pow2*2;
            key = key+pow2*ansVec(digit);
        end
    end

end