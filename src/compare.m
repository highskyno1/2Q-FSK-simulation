function [res] = compare(inputLow,inputHigh,samplePoint)
%compare 比较一个周期内的低通与高通的输出，并通过判决还原出原波形
%   inputLow：低通滤波器的输出
%   inputHigh：高通滤波器的输出
%   samplePoint：载波的采样点数
    %初始化结果数组
    res = zeros(1,length(inputLow)/samplePoint);
    for i = 1:length(inputLow)/samplePoint
        low_amp = sum(abs(inputLow((i-1)*samplePoint+1:i*samplePoint)));
        high_amp = sum(abs(inputHigh((i-1)*samplePoint+1:i*samplePoint)));
        if(low_amp > high_amp)
            res(i) = -1;
        else
            res(i) = 1;
        end
    end
end

