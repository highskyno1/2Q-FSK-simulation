function result = getFilter(fcuts,mags,devs,freq)
%getFilter 获取切尔雪夫等幅纹滤波器
%   fcuts:定义通带和阻带的频率
%   mags:定义通带和阻带
%   devs:定义通带或阻带的纹波系数
%   freq:采样率
%{
    demo
    fcuts = [200 900 1100 2000]; %定义通带和阻带的频率
    mags = [1 0 1];             %定义通带和阻带
    devs = [0.1 0.01 0.1];      %定义通带或阻带的纹波系数
%}
    [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,freq);  %计算出凯塞窗N，beta的值
    result = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');   %生成滤波器
end

