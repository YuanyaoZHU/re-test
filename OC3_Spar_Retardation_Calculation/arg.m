clc;
clear;
rng default % for reproducibility
d = linspace(0,3);
y = exp(-1.3*d)+ 5*d+ 0.05*randn(size(d));

fun = @(r)exp(-d*r(1))+d*r(2)-y;

x0 = [4,0];
x = lsqnonlin(fun,x0);
%%
plot(d,y,'ko',d,exp(-x(1)*d)+x(2)*d,'b-')
legend('Data','Best fit')
xlabel('t')
ylabel('exp(-tx)')