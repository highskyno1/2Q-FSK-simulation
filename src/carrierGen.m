function [res] = carrierGen(freq,sampleRate,size)
%carrierGen �����ز�
%   ������freq:Ƶ�� sampleRate:������ size:�ز�����
    n=0:size-1;
    t=n/sampleRate;%ʱ������
    res=sin(2*pi*freq*t);
end

