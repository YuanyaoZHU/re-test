function y = Q(x)
%Q �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global w;
global m;
y=0;
for i = 1:m
    y = w.^(i-1)*x(i)+y;
%y=w.^6+w.^5*x(6)+w.^4*x(5)+w.^3*x(4)+w.^2*x(3)+w*x(2)+x(1);
end
y = y + w.^m;


