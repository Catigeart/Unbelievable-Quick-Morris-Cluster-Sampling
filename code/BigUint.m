classdef BigUint
   
    properties
        data
    end
    
    methods
        
        function self = BigUint(n)
            self.data = num2str(n);
        end
        
        % 重载运算符：+,-,*,/,>,<,>=,<=,~=,==
        function out = plus(obj1,obj2)
            % https://blog.csdn.net/xsz591541060/article/details/108325273
            a = obj1.data;
            b = obj2.data;
            % 转数字矩阵(为了逻辑方便，我们将数字反序）
            mata = a(end:-1:1)-'0';
            matb = b(end:-1:1)-'0';

            % 计算位数
            la = length(a);
            lb = length(b);

            % 初始化
            if la>=lb
                digitStart = lb;
                matout = [mata,0];
                mattmp = matb;
            else
                digitStart = la;
                matout = [matb,0];
                mattmp = mata;
            end

            % 循环求解
            for k = digitStart:-1:1
                % 位求和，满十进一
                tmp = matout(k)+mattmp(k);
                if tmp<10
                    matout(k) = tmp;
                else
                    matout(k) = tmp-10;
                    matout(k+1) = matout(k+1)+1;
                end
            end

            % 转字符
            out = char(matout(end:-1:1)+'0');
            if out(1) == '0'
                out(1) = [];
            end
            out = BigUint(out);
        end
        
        function out = minus(obj1,obj2)
            % https://blog.csdn.net/xsz591541060/article/details/108325273
            a = obj1.data;
            b = obj2.data;
            % 转数字矩阵(为了逻辑方便，我们将数字反序）
            mata = a(end:-1:1)-'0';
            matb = b(end:-1:1)-'0';

            % 计算位数
            la = length(a);
            lb = length(b);

            % 初始化
            isEqual = 0;
            if la>lb % 默认用大的减小的（正负号由大小关系决定）
                digitEnd = lb;
                matout = [mata,0];
                mattmp = matb;
                flag = 1; % 结果为正
            elseif la<lb
                digitEnd = la;
                matout = [matb,0];
                mattmp = mata;
                flag = 0;   % 结果为负
            else
                % 对比第一个不相等的位数，谁大谁小
                idx = find(a~=b,1);
                if ~isempty(idx)
                    if a(idx)>b(idx)
                        digitEnd = lb;
                        matout = [mata,0];
                        mattmp = matb;
                        flag = 1; % 结果为正
                    else
                        digitEnd = la;
                        matout = [matb,0];
                        mattmp = mata;
                        flag = 0;   % 结果为负
                    end
                else % 如果为空，说明两个数完全一致
                    isEqual = 1;
                end
            end

            if ~isEqual 
                % 循环求解
                for k = 1:digitEnd
                    % 位求差，不足借一
                    if matout(k)>=mattmp(k)
                        matout(k) = matout(k)-mattmp(k);
                    else
                        matout(k) = 10+matout(k)-mattmp(k);
                        borrow = 1;
                        while 1 % 不够减时往前借，直到借到为止。
                            if matout(k+borrow)>=1 % 够借ok
                                matout(k+borrow) = matout(k+borrow)-1;
                                break
                            else % 不够，再往前
                                matout(k+borrow) = 10+matout(k+borrow)-1;
                                borrow = borrow+1;
                            end
                        end
                    end
                end
                % 转字符
                out = char(matout(end:-1:1)+'0');
                while out(1)=='0'      
                        out(1) = [];
                end
                if ~flag
                    out = ['-',out];
                end
            else
                out = '0';
            end
        end
        
        function re = mtimes(obj1,obj2)
            % https://zhuanlan.zhihu.com/p/61489377
            a = obj1.data;
            b = obj2.data;
            A = a - '0';
            B = b - '0';
            D = ifft(fft([zeros(size(B)) A]).*fft([zeros(size(A)) B]));
            for ii = length(D):-1:2
                D(ii-1) = D(ii-1) + floor(D(ii)/10);
                D(ii)   = mod(D(ii),10);
            end
            re = [int2str(D(1)) cast(D(2:end-1)+'0','char')];
            re = BigUint(re);
        end
        
        function [out,remainder] = mrdivide(obj1,obj2)
            % https://blog.csdn.net/xsz591541060/article/details/108325273
            a = obj1.data;
            b = obj2.data;
            % 转数字矩阵（为了逻辑方便，我们将数字反序）
            mata = a(end:-1:1)-'0';
            matb = b(end:-1:1)-'0';

            % 计算位数
            la = length(a);
            lb = length(b);

            % 转数字（按四位分组）
            numa = mata(end:-1:1);
            numb = 0;
            for k = 1:lb
                numb = numb+matb(k)*10^(k-1);
            end

            % 分组除保存结果
            res = zeros(1,la); %
            remainder = 0; % 每次计算的余数
            for i = 1:la
                divisor = numa(i)+remainder*10; % 被除数 = 上一组的余数*10000+这一组
                remainder = rem(divisor,numb);
                res(i) = (divisor-remainder)/numb; 
            end

            % 转字符
            remainder = num2str(remainder);
            out = char(res+'0');
            while out(1)=='0'
                out(1) = [];
            end
            if ~flag
                out = ['-',out];
            end
            out = BigUint(out);
        end
        
        function out = cmp(obj1,obj2)
            len1 = length(obj1.data);
            len2 = length(obj2.data);
            if len1>len2
                out = 1;
            elseif len1 < len2
                out = -1;
            else
                a = obj1.data;
                b = obj2.data;
                for i=1:len1
                    if a(i)>b(i)
                        out = 1;
                        return
                    elseif a(i)<b(i)
                        out = -1;
                        return
                    end
                end
                out = 0;
            end
        end
        
        function tf = lt(obj1,obj2)
            if cmp(obj1,obj2)==-1
                tf = true;
            else
                tf = false;
            end
        end
        
        function tf = gt(obj1,obj2)
            if cmp(obj1,obj2)==1
                tf = true;
            else
                tf = false;
            end
        end
        
        function tf = le(obj1,obj2)
            if cmp(obj1,obj2)<1
                tf = true;
            else
                tf = false;
            end
        end
        
        function tf = ge(obj1,obj2)
            if cmp(obj1,obj2)>-1
                tf = true;
            else
                tf = false;
            end
        end
        
        function tf = ne(obj1,obj2)
            if cmp(obj1,obj2)~=0
                tf = true;
            else
                tf = false;
            end
        end
        
        function tf = eq(obj1,obj2)
            if cmp(obj1,obj2)==0
                tf = true;
            else
                tf = false;
            end
        end
        
    end
    
end