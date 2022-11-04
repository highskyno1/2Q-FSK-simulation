function res = powerCnt(input)
%powerCnt 功率计算函数
%参数 input:需要计算功率的数组
    res = 10*log10(sum(input.*input));
end

