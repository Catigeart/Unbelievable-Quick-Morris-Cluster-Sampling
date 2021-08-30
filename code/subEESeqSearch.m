function [lowLp,lowRp,lowAdjust,upLp,upRp,upAdjust]=subEESeqSearch(seq, r)
% 搜索EE子序列。
%{
    params:
        seq: 完整的EE子序列
        r: 目标EE数
    return:
        lowLp: 和小于等于但尽可能接近r值的子序列的左指针
        lowRp: 和小于等于但尽可能接近r值的子序列的右指针
        lowAdjust: 和小于等于但尽可能接近r值的子序列的和与r的差值
        upLp: 和大于等于但尽可能接近r值的子序列的左指针
        upRp: 和大于等于但尽可能接近r值的子序列的右指针
        upAdjust: 和大于等于但尽可能接近r值的子序列的和与r的差值
%}
if r>sum(seq)  % 如果r比序列总和还大，不可能有解
    lowLp = -1;  
    lowRp = -1;
    lowAdjust = 0;
    upLp = -1;
    upRp = -1;
    upAdjust = 0;
    return
elseif r==1  % 如果r==1，直接返回Lp=rp=1
    lowLp = 1;
    lowRp = 1;
    lowAdjust = 0;
    upLp = 1;
    upRp = 1;
    upAdjust = 0;
    return
end

len = length(seq);  % 序列长度
lp = 1;  % 初始化左指针
rp = 1;  % 初始化右指针
upperBound = inf;  % 初始化上界
upperLp = -inf;  % 初始化上界左指针
upperRp = inf;  % 初始化上界右指针
lowerBound = -inf;  % 初始化下界
lowerLp = -inf;  % 初始化下界左指针
lowerRp = inf;  % 初始化下界右指针
subSum = seq(1);  % 初始子序列和为1

while rp < len  % 当rp比len小
    % 一个隐藏的逻辑问题是，rp达到最右端以后，左侧继续搜索仍然可能有解，然而
    % 序列是对称的，继续搜索下去只会得到对称解，可以提前终止
    if subSum < r  % 如果当前子序列和小于r，尝试更新下界
        if subSum > lowerBound
            lowerBound = subSum;
            lowerLp = lp;
            lowerRp = rp;
        elseif subSum==lowerBound && rp-lp<lowerRp-lowerLp
        % 假设有多个子序列和可能刚好等于bound，则取尽可能短的子序列（更集中）
        % 取小于号是因为对于对称的序列，尽可能取先得到的左侧，避免频繁变值
            lowerBound = subSum;
            lowerLp = lp;
            lowerRp = rp;
        end
        rp = rp+1;
        subSum = subSum+seq(rp);
    elseif subSum > r   % 如果当前子序列和大于r，尝试更新上界
        if subSum < upperBound
            upperBound = subSum;
            upperLp = lp;
            upperRp = rp;
        elseif subSum==upperBound && rp-lp<upperRp-upperLp
        % 假设有多个子序列和可能刚好等于bound，则取尽可能短的子序列（更集中）
        % 取小于号是因为对于对称的序列，尽可能取先得到的左侧，避免频繁变值
            upperBound = subSum;
            upperLp = lp;
            upperRp = rp;
        end
        if lp<rp  % 如果左指针小于右指针，左指针前进
            subSum = subSum-seq(lp);
            lp = lp+1;            
        else  % 如果左指针不小于右指针，右指针移动以保证序列遍历
            % 从理论上说这不是必须的，如果lp>rp，子序列和为0，下一步必然rp前进
            % 但从工程上考虑，为避免出现不可预知的程序错误，作保守处理
            rp = rp+1;
            subSum = subSum+seq(rp);
        end
    elseif subSum == r  % 如果当前子序列和等于r，同时更新上界和下界
        % 假设有多个子序列和可能刚好等于bound，则取尽可能短的子序列（更集中）
        % 取小于号是因为对于对称的序列，尽可能取先得到的左侧，避免频繁变值
        if (subSum==lowerBound && rp-lp<lowerRp-lowerLp) ...
                || subSum>lowerBound
            lowerBound = subSum;
            lowerLp = lp;
            lowerRp = rp;
        end
        if (subSum==upperBound && rp-lp<upperRp-upperLp) ...
                || subSum<upperBound
            upperBound = subSum;
            upperLp = lp;
            upperRp = rp;
        end
        % 理论上，此时已经可以结束算法，但是由于没有办法从理论上证明这种刚好
        % 满足r的序列组合是唯一的，因此仍将继续搜索下去
        rp = rp+1;  % 左或右指针右移都没有问题
        subSum = subSum+seq(rp);
    end
end

%{
if upperBound-r<r-lowerBound
    adjust = r-upperBound;
    lp = upperLp;
    rp = upperRp;
else
    adjust = r-lowerBound;
    lp = lowerLp;
    rp = lowerRp;
end
%}

lowLp = lowerLp;
lowRp = lowerRp;
lowAdjust = r-lowerBound;
upLp = upperLp;
upRp = upperRp;
upAdjust = r-upperBound;

end