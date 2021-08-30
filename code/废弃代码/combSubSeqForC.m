function [lp,rp,adjust] = combSubSeqForC(seq,r)

if r>sum(seq)
    lp = -1;
    rp = -1;
    adjust = 0;
    return
elseif r==1
    lp = 1;
    rp = 1;
    adjust = 0;
    return
end

len = length(seq);
lp = 1;
rp = lp+1;
upperBound = inf;
upperLp = -inf;
upperRp = inf;
lowerBound = -inf;
lowerLp = -inf;
lowerRp = inf;
subSum = seq(lp)+seq(rp);
% TODO: need to prove only one best solution
% 猜想：等差值情况下，序列越短越“划算”
% 所以至少维护两组lp和rp
while rp < len
    if subSum <= r
        if subSum > lowerBound
            lowerBound = subSum;
            lowerLp = lp;
            lowerRp = rp;
        elseif subSum==lowerBound && rp-lp<lowerRp-lowerLp
            lowerBound = subSum;
            lowerLp = lp;
            lowerRp = rp;
        end
        rp = rp+1;
        subSum = subSum+seq(rp);
    elseif subSum > r
        if subSum < upperBound
            upperBound = subSum;
            upperLp = lp;
            upperRp = rp;
        elseif subSum==upperBound && rp-lp<upperRp-upperLp
            upperBound = subSum;
            upperLp = lp;
            upperRp = rp;
        end
        if lp<rp
            subSum = subSum-seq(lp);
            lp = lp+1;            
        else
            rp = rp+1;
            subSum = subSum+seq(rp);
        end
    end
end

if upperBound-r<r-lowerBound
    adjust = r-upperBound;
    lp = upperLp;
    rp = upperRp;
else
    adjust = r-lowerBound;
    lp = lowerLp;
    rp = lowerRp;
end

end