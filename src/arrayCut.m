function res = arrayCut(array,size)
%arrayCut ������Ҫ�ĳ��ȣ����н�ȡ����
%   ��Ϊ��FIR�˲�֮�󣬽�������������ڽ����˵��
%   �˲����������˵Ĳ����Ƕ���ģ�Ӧ��ȥ����
    start = floor((length(array)-size)/2+1);
    res = array(start:start+size-1);
end

