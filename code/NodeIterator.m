classdef NodeIterator < Iterator
    % 结点迭代器，继承迭代器抽象类，用于迭代链表。   
    properties
        node  % 结点指针
    end
    
    methods
        function obj = NodeIterator(node)
            % 构造函数，应为头结点。
            obj.node = node;
        end
        
        function ok = hasNext(obj)
            % 判断是否存在下个结点。
            if isempty(obj.node.next)
                ok = false;
            else
                ok = true;
            end
        end
        
        function data = next(obj)
            % 若存在下个结点则迭代器指示下个位置，然后返回指示位置的数据。
            if ~isempty(obj.node.next)
                obj.node = obj.node.next;
            end
            data = obj.node.data;  
        end
    end
end

