clear;
clc;
%close all;
%% 获取频域范围内附加质量和阻尼矩阵
rho = 1025;
A_B=load("Spar.txt");
%{
    A_B = 周期    自由度i    自由度j    附加质量A    阻尼系数B
%}
j = sqrt(-1);
size_Spar = size(A_B);
x = [1,1;%1
    1,5;%2
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
A15 = A_B_I(:,4,2)*rho;
A15_Inf = A_Infinity(12,4)*rho;%Spar.1数据中，15自由度的数据除了第一个周期是排第一，其他都排第二。
B15 = A_B_I(:,5,2);
per = A_B_I(:,1,2);
freq = zeros(length(per),1);
omega = zeros(length(per),1);

for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end
B15 = B15.*omega*rho;
K15 = zeros(length(per),1);
for i = 1:length(omega)
    K15(i) = B15(i) + j.*omega(i).*(A15(i)-A15_Inf);%
end

K15_abs = abs(K15);
K15_phase = angle(K15);
%---------------%
%画图
figure(1);
subplot(2,1,1);
plot(omega,K15_abs);
hold on;
subplot(2,1,2);
plot(omega,K15_phase);
hold on;
%% 对自由度11数据进行研究
A11 = A_B_I(:,4,1)*rho;
A11_Inf = A_Infinity(11,4)*rho;%Spar.1数据中，15自由度的数据除了第一个周期是排第一，其他都排第二。
B11 = A_B_I(:,5,1);
per = A_B_I(:,1,1);
freq = zeros(length(per),1);
omega = zeros(length(per),1);
for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end
B11 = B11.*omega*rho;
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
hold on;
plot(omega,K11_abs);
subplot(2,1,2);
plot(omega,K11_phase);
hold on;

figure(20);
subplot(2,1,1);
hold on;
plot(omega,B11);
subplot(2,1,2);
plot(omega,A11(:)-A11_Inf);
hold on;



%%
clear a b G
m=4; %对应b的阶数
n=4; %对应a的阶数
w=omega;
[b,a]= invfreqs(K15,w,m,n); % b/a a的系数对应Q，也就是传递函数的分母部分
for i=1:100
    Q=0;
    for k= 1:n
        Q = a(k)*w.^(n-k+1)+Q;
    %Q=a(1)*omega.^6+a(2)*omega.^5+a(3)*omega.^4+a(4)*omega.^3+a(5)*omega.^2+a(6)*omega+a(7);
    end
    wt = 1./abs(Q);
    [b,a]= invfreqs(K15,w,m,n,wt);    
end

G = freqs(b,a,w);
subplot(2,1,1);
plot(omega,abs(G));
subplot(2,1,2);
plot(omega,angle(G));

figure;
impulse(b,a);
grid on;

[A,B,C,D] = tf2ss(b,a);
%%
N = 100000;
dt = 0.001;
t = dt*(0:N-1);
u = [1 zeros(1,N-1)]/dt;

xx = zeros(n,1);
y = zeros(1,N);

%A(1,:) = -[3.5969 8.0626 8.49 5.3006 1.2374 0.0488];

%C=[41350 193780 183100 61723 3558.2 0];
D = 0;

for k = 1:N
    
    dx = A*xx + B.*u(k);
    xx = dx*dt+xx;    
    y(k) = C*xx + D.*u(k); 
end

figure;
subplot(2,1,1);
plot(t,y);
hold on;
Kt = zeros(1,N);
for i = 1:100
  Kt = Kt + 2/pi*(B15(i)*cos(w(i).*t)*0.05);
end
%subplot(2,1,2);
plot(t,Kt);
legend('SpaceState','Convolution');
subplot(2,1,2);
%impulse(b,a,t);

%%
figure;
subplot(2,1,1);
plot(w,abs(h));
subplot(2,1,2);
plot(w,angle(h));
[bbb,aaa] = invfreqs(h,w,m,n);
[AA,BB,CC,DD] = tf2ss(bbb,aaa);

for k = 1:N
     
    dx = AA*xx + BB.*u(k);
    xx = dx*dt+xx;
    y(k) = CC*xx + DD.*u(k); 
      
    
end
figure;
subplot(2,1,1);
plot(t,y);
subplot(2,1,2);
impulse(bbb,aaa);


%%
clc;clear;close all;
num=[0,0,50];
den=[25,2,1];
step(num,den);
grid on




