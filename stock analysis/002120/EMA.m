function MA = EMA(P,N)
    T=length(P);
    MA = zeros(T,1);
    MA(1) = P(1);
    for i=2:T
        W=2/(N+1);
        MA(i)   =   W*P(i)+(1-W)*MA(i-1);
    end
end