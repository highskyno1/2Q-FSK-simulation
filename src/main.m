%{
    本项目用于移频键控通信系统的仿真
    解调使用双滤波器方案，即对输入的信号分别进行通带不同的两个FIR滤波器，
    对输出进行块判决，实现码元复现。
    2020/4/9 21:20
%}
clear all;
%是否原理展示
%0时表示做误码率随信噪比变化实验
%1时表示原理展示，绘制原理图与分析图
isPlot = 0;
%测试码元数
if isPlot
    %如果绘制原理图，就减少码元数
    codeSize = 5;
else
    codeSize = 1e5;
end
%生成要发送的码元
sourceCode = bipolarGen(codeSize);

%生成两个不同频率的载波信号
%采样率取5000Hz，根据奈奎斯特定理，采样率至少为频率的两倍
sampleRate = 5000;
%采样点数，过大可能会产生寄生扩频，影响实验结果
sampleSize = 50;
%100Hz低频载波
carrierLow = carrierGen(100,sampleRate,sampleSize);
%200Hz高频载波
carrierHigh = carrierGen(200,sampleRate,sampleSize);
%绘制载波图形
if isPlot
    figure(1)
    plot(carrierLow)
    hold on;
    plot(carrierHigh)
    title('载波信号');
    legend('低频载波','高频载波');
end

%%调频调制%%
modulat = modulation(sourceCode,carrierLow,carrierHigh);
if isPlot
    figure(2)
    %绘制调频结果
    plot(modulat)
    title('频率调制结果');
end

%生成80~120Hz的带通滤波器
fcuts = [0 80 120 150]; %定义通带和阻带的频率
mags = [0 1 0];             %定义通带和阻带
devs = [0.1 0.01 0.1];      %定义通带或阻带的纹波系数
lowFilter = getFilter(fcuts,mags,devs,sampleRate);
%生成180~220Hz的带通滤波器
fcuts = [150 180 220 250]; %定义通带和阻带的频率
mags = [0 1 0];             %定义通带和阻带
devs = [0.1 0.01 0.1];      %定义通带或阻带的纹波系数
highFilter = getFilter(fcuts,mags,devs,sampleRate);
%滤波器分析
if isPlot
    figure(4)
    freqz(lowFilter)
    title('低频带通滤波器分析图');
    figure(5) 
    freqz(highFilter)
    title('高频带通滤波器分析图');
end

if ~isPlot
    %开始信噪比
    startSnr = -30;
    %结束信噪比
    endSnr = 10;
    %信噪比测试间隔
    divSnr = 0.1;
    %误码率记录器
    errorRate = zeros(1,(endSnr-startSnr)/divSnr);
    %研究误码率与信噪比的关系，开启多线程
    parfor index = 1:(endSnr-startSnr)/divSnr
        %%通过高斯信道，人为添加高斯噪声%%
        %信噪比(db)
        snr = startSnr + (index-1)*divSnr;
        %平均功率(dbW)
        meanPower = powerCnt(modulat)/length(modulat);
        send = awgn(modulat,snr,meanPower);
        
        %%解调，使用两个带通滤波器%%
        %滤波，接收到的信号与fir滤波器进行卷积
        res_high = conv(send,highFilter);
        res_low = conv(send,lowFilter);
        
        %%一个载波周期内比较绝对幅度%%
        %截取滤波结果中间部分
        low_input = arrayCut(res_low,codeSize*sampleSize);
        high_input = arrayCut(res_high,codeSize*sampleSize);
        %判决
        result = compare(low_input,high_input,sampleSize);
        
        %与发送前生成的码元进行比较,得到正确率
        rightRate = rightRateCnt(result,sourceCode);
        disp(['当前信噪比',num2str(snr),'dBW,','正确率',num2str(rightRate*100),'%']);
        %记录错误率
        errorRate(index) = (1 - rightRate)*100;
    end
    %绘制误码率曲线
    figure(7)
    plot(linspace(startSnr,endSnr,length(errorRate)),errorRate);
    xlabel('信噪比(dB)');
    ylabel('误码率(%)');
    title('误码率随信噪比的变化曲线');
else
    %%通过高斯信道，人为添加高斯噪声%%
    %信噪比(db)
    snr = 5;
    %平均功率(dbW)
    meanPower = powerCnt(modulat)/length(modulat);
    send = awgn(modulat,snr,meanPower);
    if isPlot
        figure(3)
        %绘制噪声结果
        title('接收端接收到的波形');
        plot(send);
    end
    
    %%解调，使用两个带通滤波器%%
    %滤波，接收到的信号与fir滤波器进行卷积
    res_high = conv(send,highFilter);
    res_low = conv(send,lowFilter);
    if isPlot
        figure(6)
        plot(res_low)
        hold on;
        plot(res_high)
        title('滤波结果');
        legend('低频带通滤波输出','高频带通滤波输出');
    end
end