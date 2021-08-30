function [dp,note] = Limit01Bag(arr,r)
% w(i)=v(i)=arr(i)
[dp,note] = DP01bag(arr,arr,r);

end

function [dp,note] = DP01bag(w,v,b)
% w=weight, v=value, b=max_weight
n = length(w);
% WARNING: 1~b+1 col mark 0~b weight_limitation
dp = zeros(n,b+1);
note = zeros(n,b+1);
for y = 0:b
    if y >= w(1)
        dp(1,y+1) = v(1);
        note(1,y+1) = 1;
    end
end

for k = 2:n
    for y = 0:b
        if y >= w(k)
            if dp(k-1,y+1) < dp(k-1,y+1-w(k))+v(k)
                dp(k,y+1) = dp(k-1,y+1-w(k))+v(k);
                note(k,y+1) = k;
            else
                dp(k,y+1) = dp(k-1,y+1);
                note(k,y+1) = note(k-1,y+1);
            end
        else
            dp(k,y+1) = dp(k-1,y+1);
            note(k,y+1) = note(k-1,y+1);
        end
    end
end

end