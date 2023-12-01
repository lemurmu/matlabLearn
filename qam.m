clc;clear;close all;
M = 16;%调制顺序(信号星座点数)
k = log2(M);%每符号的比特位数
n = 30000;%处理的比特总数
sps = 1;%每个符号的样本数(过采样因子)
rng default;%每次都产生相同的随机数
dataIn = randi([0 1],n,1); % 产生0和1之间的整数，输出一个n*1的向量
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
% 重组dataIn，使其每行只有4列
dataSymbolsIn = bi2de(dataInMatrix);%将每行转化为十进制数，[0,15]
%该函数在MATAB R2021b及以后不推荐使用
figure; % 创建图窗
stem(dataSymbolsIn(1:10),'filled');
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');
dataMod = qammod(dataSymbolsIn,M,'bin'); 
% 使用自然二进制编码排序
dataModG = qammod(dataSymbolsIn,M); 
% 默认使用格雷码编码
EbNo = 10;
snr = EbNo+10*log10(k)-10*log10(sps);
receivedSignal = awgn(dataMod,snr,'measured');
receivedSignalG = awgn(dataModG,snr,'measured');
sPlotFig = scatterplot(receivedSignal,1,0,'g.');
% scatterplot用来观察接收信号的星座图
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig)
dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
dataSymbolsOutG = qamdemod(receivedSignalG,M);
dataOutMatrix = de2bi(dataSymbolsOut,k);
dataOut = dataOutMatrix(:); % Return data in column vector
dataOutMatrixG = de2bi(dataSymbolsOutG,k);
dataOutG = dataOutMatrixG(:); % Return data in column vector
[numErrors,ber] = biterr(dataIn,dataOut);
%该函数比较两种数据，并返回不同的个数以及占比
fprintf('\nThe binary coding bit error rate is %5.2e, based on %d errors.\n', ...
    ber,numErrors)
[numErrorsG,berG] = biterr(dataIn,dataOutG);
fprintf('\nThe Gray coding bit error rate is %5.2e, based on %d errors.\n', ...
    berG,numErrorsG)