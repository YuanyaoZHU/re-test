function y = P(x)
%P �ú���Ϊ���ݺ����ķ��Ӳ���
%   x---��Ƶ��
%   y---���ݺ���P
global w;
global n;
    y=0;
for i=1:n+1
    y = w.^(i-1)*x(i)+y;
end

