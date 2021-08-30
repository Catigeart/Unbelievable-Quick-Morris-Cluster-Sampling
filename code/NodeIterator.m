classdef NodeIterator < Iterator
    % �����������̳е����������࣬���ڵ�������   
    properties
        node  % ���ָ��
    end
    
    methods
        function obj = NodeIterator(node)
            % ���캯����ӦΪͷ��㡣
            obj.node = node;
        end
        
        function ok = hasNext(obj)
            % �ж��Ƿ�����¸���㡣
            if isempty(obj.node.next)
                ok = false;
            else
                ok = true;
            end
        end
        
        function data = next(obj)
            % �������¸�����������ָʾ�¸�λ�ã�Ȼ�󷵻�ָʾλ�õ����ݡ�
            if ~isempty(obj.node.next)
                obj.node = obj.node.next;
            end
            data = obj.node.data;  
        end
    end
end

