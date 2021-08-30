classdef Node < handle
    % 结点类，继承handle，按址传值。
    properties (GetAccess = public, SetAccess = public)
        data  % 数据域
        next  % 指针域
    end

    methods
        function obj = Node(data)  % 构造函数
            if nargin > 0  % 如果传参
                obj.data = data;  % 对数据域赋值
            end
        end
    end

end