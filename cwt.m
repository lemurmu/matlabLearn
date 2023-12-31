% 小波时频分析
clc
clear all
close all
% 原始信号
fs=1000;
f1=50;
f2=100;
t=0:1/fs:1;
s=sin(2*pi*f1*t)+sin(2*pi*f2*t);
figure
plot(t, s)
% 连续小波变换
wavename='cmor3-3';
totalscal=256;
Fc=centfrq(wavename); % 小波的中心频率
c=2*Fc*totalscal;
scals=c./(1:totalscal);
f=scal2frq(scals,wavename,1/fs); % 将尺度转换为频率
coefs=cwt(s,scals,wavename); % 求连续小波系数
figure
imagesc(t,f,abs(coefs));
set(gca,'YDir','normal')
colorbar;
xlabel('时间 t/s');
ylabel('频率 f/Hz');
title('小波时频图');