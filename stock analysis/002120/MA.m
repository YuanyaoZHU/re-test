function index= MA(data,N)
L=length(data);
index=zeros(L,1);
index(1:N-1)=0;
for i=N:L
    for j=1:N
        index(i)=index(i)+data(i-j+1);
    end
    index(i)=index(i)/N;
end
end