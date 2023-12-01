function indexMax=AMPD(data)
N=length(data);
L=ceil(N/2)-1;
M=zeros(L,N);
for k=1:L
    for i=1:N
        if i<k+1||i>N-k
            M(k,i)=1+rand;
        elseif data(i)>data(i-k)&&data(i)>data(i+k)
            M(k,i)=0;
        else
            M(k,i)=1+rand;
        end
    end
end
rowsum=sum(M,2);
[~,MaxWinLen]=min(rowsum);
M=M(1:MaxWinLen,:);
sigma=std(M,0,1);
indexMax=find(~sigma);
end