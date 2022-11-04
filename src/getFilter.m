function result = getFilter(fcuts,mags,devs,freq)
%getFilter ��ȡ�ж�ѩ��ȷ����˲���
%   fcuts:����ͨ���������Ƶ��
%   mags:����ͨ�������
%   devs:����ͨ����������Ʋ�ϵ��
%   freq:������
%{
    demo
    fcuts = [200 900 1100 2000]; %����ͨ���������Ƶ��
    mags = [1 0 1];             %����ͨ�������
    devs = [0.1 0.01 0.1];      %����ͨ����������Ʋ�ϵ��
%}
    [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,freq);  %�����������N��beta��ֵ
    result = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');   %�����˲���
end

