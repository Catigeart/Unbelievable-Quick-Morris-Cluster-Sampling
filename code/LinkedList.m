classdef LinkedList < handle
    % 链表类，继承handle，按址传值。
    properties (GetAccess = public, SetAccess = public)
        head  % 头结点指针
        tail  % 尾结点指针
        len  % 链表长度
    end

    methods
        function obj = LinkedList(LL)
            % 链表构造函数，若无参则为空链表，若以另一个链表传参则复制链表
            obj.head = Node();
            obj.head.data = [];  % 空头结点
            obj.tail = obj.head;
            obj.len = 0;
            if nargin == 1  % 如果传入链表作为参数
                iter = LL.iterator();
                if iter.hasNext()
                    data = iter.next();
                    node = Node(data);
                    obj.tail.next = node;
                    obj.tail = obj.tail.next;
                    obj.len = obj.len+1;
                    while iter.hasNext()
                        iter.next();
                        obj.len = obj.len+1;
                    end
                end
            end
            obj.tail.next = [];  % 尾指针置空
        end
        
        function append(obj, data)
            % 在链表尾部新增元素
            node = Node(data);
            obj.tail.next = node;
            obj.tail = obj.tail.next;
            obj.tail.next = [];
            obj.len = obj.len+1;
        end
        
        function iter = iterator(obj)
            % 生成迭代器
            iter = NodeIterator(obj.head);
        end
        
        function len = size(obj)
            % 返回长度
            len = obj.len;
        end
    end
    
    methods(Static)
        % 与迭代器相关的静态方法
        function insertByIter(iter, data)
            % 以迭代器指示位置，于迭代器位置后插入结点
            node = Node(data);
            node.next = iter.node.next;
            iter.node.next = node;
        end
        
        function updateByIter(iter, data)
            % 以迭代器指示位置，于迭代器位置更新结点
            iter.node.data = data;
        end
    end
end