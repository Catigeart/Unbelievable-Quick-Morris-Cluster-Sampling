classdef Iterator < handle
% 迭代器抽象类，继承handle，按址传值。
    methods(Abstract)
        % 抽象方法
        hasNext(~); 
        next(~);
    end
    
end

