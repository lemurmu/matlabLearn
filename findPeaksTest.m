clc
clear all
close all
fs=1000;
f1=200;
f2=100;
t=0:1/fs:1;
s=sin(2*pi*f2*t);
findpeaks(s);%Ѱ�ҷ�ֵ
