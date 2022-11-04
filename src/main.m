%{
    ����Ŀ������Ƶ����ͨ��ϵͳ�ķ���
    ���ʹ��˫�˲�������������������źŷֱ����ͨ����ͬ������FIR�˲�����
    ��������п��о���ʵ����Ԫ���֡�
    2020/4/9 21:20
%}
clear all;
%�Ƿ�ԭ��չʾ
%0ʱ��ʾ��������������ȱ仯ʵ��
%1ʱ��ʾԭ��չʾ������ԭ��ͼ�����ͼ
isPlot = 0;
%������Ԫ��
if isPlot
    %�������ԭ��ͼ���ͼ�����Ԫ��
    codeSize = 5;
else
    codeSize = 1e5;
end
%����Ҫ���͵���Ԫ
sourceCode = bipolarGen(codeSize);

%����������ͬƵ�ʵ��ز��ź�
%������ȡ5000Hz�������ο�˹�ض�������������ΪƵ�ʵ�����
sampleRate = 5000;
%����������������ܻ����������Ƶ��Ӱ��ʵ����
sampleSize = 50;
%100Hz��Ƶ�ز�
carrierLow = carrierGen(100,sampleRate,sampleSize);
%200Hz��Ƶ�ز�
carrierHigh = carrierGen(200,sampleRate,sampleSize);
%�����ز�ͼ��
if isPlot
    figure(1)
    plot(carrierLow)
    hold on;
    plot(carrierHigh)
    title('�ز��ź�');
    legend('��Ƶ�ز�','��Ƶ�ز�');
end

%%��Ƶ����%%
modulat = modulation(sourceCode,carrierLow,carrierHigh);
if isPlot
    figure(2)
    %���Ƶ�Ƶ���
    plot(modulat)
    title('Ƶ�ʵ��ƽ��');
end

%����80~120Hz�Ĵ�ͨ�˲���
fcuts = [0 80 120 150]; %����ͨ���������Ƶ��
mags = [0 1 0];             %����ͨ�������
devs = [0.1 0.01 0.1];      %����ͨ����������Ʋ�ϵ��
lowFilter = getFilter(fcuts,mags,devs,sampleRate);
%����180~220Hz�Ĵ�ͨ�˲���
fcuts = [150 180 220 250]; %����ͨ���������Ƶ��
mags = [0 1 0];             %����ͨ�������
devs = [0.1 0.01 0.1];      %����ͨ����������Ʋ�ϵ��
highFilter = getFilter(fcuts,mags,devs,sampleRate);
%�˲�������
if isPlot
    figure(4)
    freqz(lowFilter)
    title('��Ƶ��ͨ�˲�������ͼ');
    figure(5) 
    freqz(highFilter)
    title('��Ƶ��ͨ�˲�������ͼ');
end

if ~isPlot
    %��ʼ�����
    startSnr = -30;
    %���������
    endSnr = 10;
    %����Ȳ��Լ��
    divSnr = 0.1;
    %�����ʼ�¼��
    errorRate = zeros(1,(endSnr-startSnr)/divSnr);
    %�о�������������ȵĹ�ϵ���������߳�
    parfor index = 1:(endSnr-startSnr)/divSnr
        %%ͨ����˹�ŵ�����Ϊ��Ӹ�˹����%%
        %�����(db)
        snr = startSnr + (index-1)*divSnr;
        %ƽ������(dbW)
        meanPower = powerCnt(modulat)/length(modulat);
        send = awgn(modulat,snr,meanPower);
        
        %%�����ʹ��������ͨ�˲���%%
        %�˲������յ����ź���fir�˲������о��
        res_high = conv(send,highFilter);
        res_low = conv(send,lowFilter);
        
        %%һ���ز������ڱȽϾ��Է���%%
        %��ȡ�˲�����м䲿��
        low_input = arrayCut(res_low,codeSize*sampleSize);
        high_input = arrayCut(res_high,codeSize*sampleSize);
        %�о�
        result = compare(low_input,high_input,sampleSize);
        
        %�뷢��ǰ���ɵ���Ԫ���бȽ�,�õ���ȷ��
        rightRate = rightRateCnt(result,sourceCode);
        disp(['��ǰ�����',num2str(snr),'dBW,','��ȷ��',num2str(rightRate*100),'%']);
        %��¼������
        errorRate(index) = (1 - rightRate)*100;
    end
    %��������������
    figure(7)
    plot(linspace(startSnr,endSnr,length(errorRate)),errorRate);
    xlabel('�����(dB)');
    ylabel('������(%)');
    title('������������ȵı仯����');
else
    %%ͨ����˹�ŵ�����Ϊ��Ӹ�˹����%%
    %�����(db)
    snr = 5;
    %ƽ������(dbW)
    meanPower = powerCnt(modulat)/length(modulat);
    send = awgn(modulat,snr,meanPower);
    if isPlot
        figure(3)
        %�����������
        title('���ն˽��յ��Ĳ���');
        plot(send);
    end
    
    %%�����ʹ��������ͨ�˲���%%
    %�˲������յ����ź���fir�˲������о��
    res_high = conv(send,highFilter);
    res_low = conv(send,lowFilter);
    if isPlot
        figure(6)
        plot(res_low)
        hold on;
        plot(res_high)
        title('�˲����');
        legend('��Ƶ��ͨ�˲����','��Ƶ��ͨ�˲����');
    end
end