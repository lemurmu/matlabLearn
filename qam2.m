clc;
clear all;
close all;
nsymbol=100000;%��ʾһ���ж��ٸ����ţ����ﶨ��100000������
M=16;%M��ʾQAM���ƵĽ���,��ʾ16QAM��16QAM���ø���ӳ��(����������ͼ�����ø���ӳ��)
N=64;
graycode=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];%����ӳ��������
graycode1=[0 1 3 2 6 7 5 4 8 9 11 10 14 15 13 12 24 25 27 26 30 31 29 28 16 17 19 18 22 23 21 20 48 49 51 50 54 55 53 52 56 57 59 58 62 63 61 60 40 41 43 42 46 47 45 44 32 33 35 34 38 39 37 36];%����ӳ��ʮ���Ƶı�ʾ
EsN0=5:20;%����ȷ�Χ
snr1=10.^(EsN0/10);%��dbת��Ϊ����ֵ
msg=randi([0,M-1],1,nsymbol);%0��15֮���������һ����,���ĸ���Ϊ��1��nsymbol���õ�ԭʼ����
msg1=graycode(msg+1);%�����ݽ��и���ӳ��
msgmod=qammod(msg1,M);%����matlab�е�qammod������16QAM���Ʒ�ʽ�ĵ���(����0��15������M��ʾQAM���ƵĽ���)�õ����ƺ����

A=1;%����
fc=1000;%��Ƶ
fs=200000;%������
Rs=200000;%��Ԫ����
sample_per_code=fs/Rs;%ÿ�����ŵĲ�������
sample_len=sample_per_code*nsymbol;%�ܲ�������
ts=1/fs;%ʱ����
le=0:sample_len-1;
c=A*exp(1i*2*pi*fc*ts*le);
tx_qam = real(msgmod.*c); %�ز�����
I=real(tx_qam);
Q=imag(tx_qam);
fileID1=fopen('iqData.bin','w');
for x=1:nsymbol
   fwrite(fileID1,I(x),'short'); 
   fwrite(fileID1,Q(x),'short'); 
end
fclose(fileID1);

scatterplot(msgmod);%����matlab�е�scatterplot����,��������ͼ
spow=norm(msgmod).^2/nsymbol;%ȡa+bj��ģ.^2�õ����ʳ��������ŵõ�ÿ�����ŵ�ƽ������
%64QAM
nsg=randi([0,N-1],1,nsymbol);
nsg1=graycode1(nsg+1);
nsgmod=qammod(nsg1,N);
scatterplot(nsgmod);%����matlab�е�scatterplot����,��������ͼ
spow1=norm(nsgmod).^2/nsymbol;

for i=1:length(EsN0)
    sigma=sqrt(spow/(2*snr1(i)));%16QAM���ݷ��Ź�����������Ĺ���
    sigma1=sqrt(spow1/(2*snr1(i)));%64QAM���ݷ��Ź�����������Ĺ���
    rx=msgmod+sigma*(randn(1,length(msgmod))+1i*randn(1,length(msgmod)));%16QAM�����˹���԰�����
    rx1=nsgmod+sigma*(randn(1,length(nsgmod))+1i*randn(1,length(nsgmod)));%64QAM�����˹���԰�����
    y=qamdemod(rx,M);%16QAM�Ľ��
   y1=qamdemod(rx1,N);%64QAM�Ľ��
   decmsg=graycode(y+1);%16QAM���ն˸�����ӳ�䣬���������������Ϣ��ʮ����
   decnsg=graycode1(y1+1);%64QAM���ն˸�����ӳ��
   [err1,ber(i)]=biterr(msg,decmsg,log2(M));%һ�������ĸ����أ��ȽϷ��Ͷ��ź�msg�ͽ���ź�decmsgת��Ϊ�����ƣ�ber(i)����ı�����
   [err2,ser(i)]=symerr(msg,decmsg);%16QAM��ʵ��������
   [err1,ber1(i)]=biterr(nsg,decnsg,log2(N));
   [err2,ser1(i)]=symerr(nsg,decnsg);%64QAM��ʵ��������
end
%16QAM
scatterplot(rx);%����matlab�е�scatterplot����,��rx������ͼ
p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser_theory=1-(1-p).^2;%16QAM����������
ber_theory=1/log2(M)*ser_theory;

%64QAM
scatterplot(rx1);
p1=2*(1-1/sqrt(N))*qfunc(sqrt(3*snr1/(N-1)));
ser1_theory=1-(1-p1).^2;%64QAM����������
ber1_theory=1/log2(N)*ser1_theory;%�õ��������

%��ͼ
figure()
semilogy(EsN0,ber,'o', EsN0, ser, '*',EsN0, ser_theory, '-', EsN0, ber_theory, '-');
title('16-QAM�ز������ź���AWGN�ŵ��µ������������')
xlabel('EsN0');
ylabel('������ʺ��������');
legend('�������', '�������','�����������','�����������');
%������ͬ,16��64QAM�����ź���AWGN�ŵ������ܱȽ�
figure()
semilogy(EsN0,ser_theory,'o',EsN0,ser1_theory,'o');%ber ser���ط���ֵ ser1���������� ber1�����������
title('16��64QAM�����ź���AWGN�ŵ������ܱȽ�');grid;
xlabel('Es/N0(dB)');%�����
ylabel('������');%������
legend('16QAM����������','64QAM����������');
