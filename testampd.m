clc
clear all
close all
fs=100;
f1=10;
f2=20;
t=0:1/fs:1;
s=sin(2*pi*f2*t);
index=AMPD(s);
l=int32(size(index,2));
maxx=zeros(1,l);
maxy=zeros(1,l);
indexSize=int32(size(index,2));
for k=1:l
   ival=int32(index(k));
   maxx(k)=t(ival);
   maxy(k)=s(ival);
end
plot(t,s);
hold on
plot(maxx,maxy,'r.');