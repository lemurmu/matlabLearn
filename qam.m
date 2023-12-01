clc;clear;close all;
M = 16;%����˳��(�ź���������)
k = log2(M);%ÿ���ŵı���λ��
n = 30000;%����ı�������
sps = 1;%ÿ�����ŵ�������(����������)
rng default;%ÿ�ζ�������ͬ�������
dataIn = randi([0 1],n,1); % ����0��1֮������������һ��n*1������
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
% ����dataIn��ʹ��ÿ��ֻ��4��
dataSymbolsIn = bi2de(dataInMatrix);%��ÿ��ת��Ϊʮ��������[0,15]
%�ú�����MATAB R2021b���Ժ��Ƽ�ʹ��
figure; % ����ͼ��
stem(dataSymbolsIn(1:10),'filled');
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');
dataMod = qammod(dataSymbolsIn,M,'bin'); 
% ʹ����Ȼ�����Ʊ�������
dataModG = qammod(dataSymbolsIn,M); 
% Ĭ��ʹ�ø��������
EbNo = 10;
snr = EbNo+10*log10(k)-10*log10(sps);
receivedSignal = awgn(dataMod,snr,'measured');
receivedSignalG = awgn(dataModG,snr,'measured');
sPlotFig = scatterplot(receivedSignal,1,0,'g.');
% scatterplot�����۲�����źŵ�����ͼ
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
dataSymbolsOutG = qamdemod(receivedSignalG,M);
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:); % Return data in column vector
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:); % Return data in column vector
[numErrors,ber] = biterr(dataIn,dataOut);
%�ú����Ƚ��������ݣ������ز�ͬ�ĸ����Լ�ռ��
fprintf('\nThe binary coding bit error rate is %5.2e, based on %d errors.\n', ...
    ber,numErrors)
[numErrorsG,berG] = biterr(dataIn,dataOutG);
fprintf('\nThe Gray coding bit error rate is %5.2e, based on %d errors.\n', ...
    berG,numErrorsG)