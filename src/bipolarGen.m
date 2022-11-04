function [code] = bipolarGen(size)
%bipolarGen 产生指定长度的二进制双极性码元数组
%   码元的产生采用随机函数
    foo = rand(1,size);
    for i = 1:length(foo)
        if foo(i) > 0.5
            foo(i) = 1;
        else
            foo(i) = -1;
        end
    end
    code = foo;
end

