% С��ʱƵ����
clc
clear all
close all
% ԭʼ�ź�
fs=1000;
f1=50;
f2=100;
t=0:1/fs:1;
s=sin(2*pi*f1*t)+sin(2*pi*f2*t);
figure
plot(t, s)
% ����С���任
wavename='cmor3-3';
totalscal=256;
Fc=centfrq(wavename); % С��������Ƶ��
c=2*Fc*totalscal;
scals=c./(1:totalscal);
f=scal2frq(scals,wavename,1/fs); % ���߶�ת��ΪƵ��
coefs=cwt(s,scals,wavename); % ������С��ϵ��
figure
imagesc(t,f,abs(coefs));
set(gca,'YDir','normal')
colorbar;
xlabel('ʱ�� t/s');
ylabel('Ƶ�� f/Hz');
title('С��ʱƵͼ');