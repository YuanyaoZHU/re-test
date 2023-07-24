function y = P(x)
%P 该函数为传递函数的分子部分
%   x---角频率
%   y---传递函数P
global w;
global n;
    y=0;
for i=1:n+1
    y = w.^(i-1)*x(i)+y;
end

