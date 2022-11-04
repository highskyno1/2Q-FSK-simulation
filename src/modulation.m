function [res] = modulation(code,carrierLow,carrierHigh)
%modulation 调频调制函数
%   参数: code:码元 carrierLow:低频载波 carrierHigh:高频载波
    res = zeros(1,length(code)*length(carrierLow));
    for i = 1:length(code)
        if code(i) > 0
            res((i-1)*length(carrierLow)+1:i*length(carrierLow)) = carrierHigh;
        else
            res((i-1)*length(carrierLow)+1:i*length(carrierLow)) = carrierLow;
        end
    end     
end

