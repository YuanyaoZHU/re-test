function y = Func(theta)
%FUNC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global K_w1;
global s;
global m;
global n;
x1 = theta(1:n+1);
x2 = theta(n+2:n+m+1);
y = s.*(K_w1.*Q(x2)-P(x1));
end

