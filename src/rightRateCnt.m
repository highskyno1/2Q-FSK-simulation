function res = rightRateCnt(arg0,arg1)
%rightRateCnt ͳ�������������ʶ�̶�
    rightCnt = 0;
    for i = 1:length(arg0)
        if(arg0(i) == arg1(i))
            rightCnt = rightCnt + 1;
        end
    end
    res = rightCnt / length(arg0);
end

