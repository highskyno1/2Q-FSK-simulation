function [code] = bipolarGen(size)
%bipolarGen ����ָ�����ȵĶ�����˫������Ԫ����
%   ��Ԫ�Ĳ��������������
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

