function [res] = compare(inputLow,inputHigh,samplePoint)
%compare �Ƚ�һ�������ڵĵ�ͨ���ͨ���������ͨ���о���ԭ��ԭ����
%   inputLow����ͨ�˲��������
%   inputHigh����ͨ�˲��������
%   samplePoint���ز��Ĳ�������
    %��ʼ���������
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

