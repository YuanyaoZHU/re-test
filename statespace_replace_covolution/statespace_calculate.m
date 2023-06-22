clear;
clc;
%% 获取频域范围内附加质量和阻尼矩阵
A_B=load("Spar.txt");
%{
    A_B = 周期    自由度i    自由度j    附加质量A    阻尼系数B
%}
j = sqrt(-1);
size_Spar = size(A_B);
x = [1,5;%1
    1,1;%2
    2,2;%3
    2,4;%4
    3,3;%5
    4,2;%6
    4,4;%7
    5,1;%8
    5,5;%9
    6,6];%10
A_B_I = zeros(size_Spar(1)/10,5,10);

for fn=1:10 %fn为freedom number缩写
    p=1;
    for i = 1: size_Spar(1)
        if x(fn,1) == A_B(i,2) && x(fn,2)==A_B(i,3)
            A_B_I(p,:,fn) = A_B(i,:); 
            p=p+1;
        end
    end
end
size_ABI = size(A_B_I);
%A_B_I为经过调整后的数据
%% 获取无穷大频率处的附加质量
A_Infinity = load("Spar_Infinity.txt");
%{
    A_Infinity = 周期    自由度i    自由度j    附加质量A
%}
%% 对自由度15数据进行研究
A15 = A_B_I(:,4,1);
A15_Inf = A_Infinity(12,4);%Spar.1数据中，15自由度的数据除了第一个周期是排第一，其他都排第二。
B15 = A_B_I(:,5,1);
per = A_B_I(:,1,1);
freq = zeros(length(per),1);
omega = zeros(length(per),1);
for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end

K15 = zeros(length(per),1);
for i = 1:length(omega)
    K15(i) = B15(i) + j*omega(i)*(A15(i)-A15_Inf);
end

K15_abs = abs(K15);
K15_phase = angle(K15);
%---------------%
%画图
figure(1);
subplot(4,1,1);
plot(omega,K15_abs);
subplot(4,1,2);
plot(omega,K15_phase);




%%
clear a b G
[a,b]= invfreqs(K15,omega,6,6);


%%
%syms s
%Hs = (a(1)*s^5+a(2)*s^4+a(3)*s^3+a(4)*s^2+a(5)*s+a(6))/(b(1)*s^6+ b(2)*s^5+b(3)*s^4+b(4)*s^3+b(5)*s^2+b(6)*s+b(7));
%G = transferFunction(omega*j,a,b);
G = freqs(a,b,omega);
subplot(4,1,3);
plot(omega,abs(G));
subplot(4,1,4);
plot(omega,angle(G));
%%
syms s
la = length(a);
lb = length(b);
ap = 0;
bp = 0;
for p = 1:la
    ap = ap+a(p)*s^(la-p+1);
end
for p = 1:lb
    bp = bp+b(p)*s^(lb-p+1);
end
Hs = ap/bp;


[A,B,C,D]=tf2ss(a,b);
%%
t = 0:0.01:20;
y = dirac(t);
idx = y == Inf;
y(idx) = 1;
stem(t,y);

for i =1:length(t)
    ht(i) = C*exp(A*t(i))*B;
end
plot(t,ht);


%%
ht = ilaplace(Hs);
figure(2);
fplot(ht);



    


%% 对自由度11数据进行研究
A11 = A_B_I(:,4,2);
A11_Inf = A_Infinity(11,4);%Spar.1数据中，15自由度的数据除了第一个周期是排第一，其他都排第二。
B11 = A_B_I(:,5,2);
per = A_B_I(:,1,1);
freq = zeros(length(per),1);
omega = zeros(length(per),1);
for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end

K11 = zeros(length(per),1);
for i = 1:length(omega)
    K11(i) = B11(i) + j*omega(i)*(A11(i)-A11_Inf);
end

K11_abs = abs(K11);
K11_phase = angle(K11);
%---------------%
%画图
figure(2);
subplot(2,1,1);
plot(omega,K11_abs);
subplot(2,1,2);
plot(omega,K11_phase);

%% 对自由度33数据进行研究
A33 = A_B_I(:,4,5);
A33_Inf = A_Infinity(15,4);%Spar.1数据中，15自由度的数据除了第一个周期是排第一，其他都排第二。
B33 = A_B_I(:,5,5);
per = A_B_I(:,1,1);
freq = zeros(length(per),1);
omega = zeros(length(per),1);
for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end

K33 = zeros(length(per),1);
for i = 1:length(omega)
    K33(i) = B33(i) + j*omega(i)*(A33(i)-A33_Inf);
end

K33_abs = abs(K33);
K33_phase = angle(K33);
%---------------%
%画图
figure(3);
subplot(2,1,1);
plot(omega,K33_abs);
subplot(2,1,2);
plot(omega,K33_phase);






