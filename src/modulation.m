function [res] = modulation(code,carrierLow,carrierHigh)
%modulation ��Ƶ���ƺ���
%   ����: code:��Ԫ carrierLow:��Ƶ�ز� carrierHigh:��Ƶ�ز�
    res = zeros(1,length(code)*length(carrierLow));
    for i = 1:length(code)
        if code(i) > 0
            res((i-1)*length(carrierLow)+1:i*length(carrierLow)) = carrierHigh;
        else
            res((i-1)*length(carrierLow)+1:i*length(carrierLow)) = carrierLow;
        end
    end     
end

