clc;
clear;
load('Spar1.txt'); %阻尼
load('Spar2.txt'); %周期
load('Spar3.txt'); %附加质量
pho = 1025; %水密度
[x,p1]=size(Spar1);
[y,p2]=size(Spar2);
ma=x/10;
Omega=zeros(ma,2);
B=zeros(ma,10); %阻尼
A=zeros(ma,10); %附加质量
for i=0:ma-1
    Omega(i+1,1)=Spar2(i*10+1);%周期
    Omega(i+1,2)=2*pi/Omega(i+1,1);%角频率
    for j=1:10
        B(i+1,j)=Spar1(i*10+j)*pho;%阻尼
        A(i+1,j)=Spar3(i*10+j)*pho;%附加质量
    end
end
delta_Omega=0.05;
%%
figure(1); 
plot(Omega(:,2),B(:,1));%阻尼矩阵B(1,1)
hold on;
plot(Omega(:,2),B(:,3));%阻尼矩阵B(2,2)
hold on;
plot(Omega(:,2),B(:,5));%阻尼矩阵B(3,3)
hold off;

figure(2);
plot(Omega(:,2),B(:,7));%阻尼矩阵B(4,4)
hold on;
plot(Omega(:,2),B(:,9));%阻尼矩阵B(5,5)
hold on;
plot(Omega(:,2),B(:,10));%阻尼矩阵B(6,6)
hold off;

figure(3);
plot(Omega(:,2),B(:,2));%阻尼矩阵B(1,5)
hold on;
plot(Omega(:,2),B(:,4));%阻尼矩阵B(2,4)
hold off;

figure(4);
plot(Omega(:,2),A(:,1));%附加质量矩阵A(1,1)
hold on;
plot(Omega(:,2),A(:,3));%附加质量矩阵A(2,2)
hold on;
plot(Omega(:,2),A(:,5));%附加质量矩阵A(3,3)
hold off;

figure(5);
plot(Omega(:,2),A(:,7));%附加质量矩阵A(4,4)
hold on;
plot(Omega(:,2),A(:,9));%附加质量矩阵A(5,5)
hold on;
plot(Omega(:,2),A(:,10));%附加质量矩阵A(6,6)
hold off;

figure(6);
plot(Omega(:,2),A(:,2));%附加质量矩阵A(1,5)
hold on;
plot(Omega(:,2),A(:,8));%附加质量矩阵A(5,1)
hold on;
plot(Omega(:,2),A(:,4));%附加质量矩阵A(2,4)
hold on;
plot(Omega(:,2),A(:,6));%附加质量矩阵A(4,2)
hold off;
%% 计算核函数K(t)
K=zeros(100,10);
Kt=zeros(1,100);
for i=1:101
    Kt(i)=(i-1)*0.25;
end
for i=1:10
    for jj=1:101
        p=0;
        for k=1:100
            p=B(k,i)*cos(Omega(k,2)*Kt(jj))+p;
        end
        K(jj,i)=2/pi*p*delta_Omega;
    end
end
figure;
plot(Kt(:),K(:,1));
%%
j = sqrt(-1);
K_w = zeros(ma,10);
for i=1:ma
    for k=1:10
        K_w(i,k)=B(i,k)+j*Omega(i,2)*(A(i,k)-A(end,k));
    end
end
%%
clc;
global K_w1;
global w;
global s;
w=Omega(:,2);
K_w1=K_w(:,1);

global n;
global m;
n=10;
m=10;


%fun = @(x)s.*(K_w1.*(w.^6+w.^5*x(13)+w.^4*x(12)+w.^3*x(11)+w.^2*x(10)+w*x(9)+x(8))-(w.^6*x(7)+w.^5*x(6)+w.^4*x(5)+w.^3*x(4)+w.^2*x(3)+w*x(2)+x(1)));
% x(1-7)=P(0-6); x(8-13) = Q(0-5)
s0=0;
s=1;


for k = 1:20
    x0 = ones(1,m+n+1);
    x = lsqnonlin(@Func,x0);
    s0=s;
    P = x(1,n+1:-1:1);
    Q1 = x(1,m+n+1:-1:n+2);
    
    h = freqs(P,Q1,Omega(:,2));
    [b,a]=invfreqs(h,Omega(:,2),n,m);
    
    QQ = Q(a(1,end:-1:1));
    %Q = x(1,13:-1:8);
    %QQ = w.^6 + Q(1).*w.^5 + Q(2).*w.^4 + Q(3).*w.^3 + Q(4).*w.^2 + Q(5).*w + Q(6);
    for i= 1:100
      s(i) = 1/QQ(i,1); 
    end
    

end



[S1.A,S1.B,S1.C,S1.D]=tf2ss(b,a);

N=1000;
u = [1 zeros(1,N-1)];
dt=0.01;
xx=zeros(n,N);
yy=zeros(1,N);

 for k = 1:N-1    
    dx= S1.A*xx(:,k)+ S1.B*u(k);
    xx(:,k+1)=dx*dt+xx(:,k);
    yy(k)= S1.C*xx(:,k)+ S1.D*u(k);    
 end
figure(3);
plot((1:N-1)*dt,yy(1:end-1)); 




mag = abs(h);
phase = angle(h);
phasedeg = phase*180/pi;

mag2 = abs(K_w(:,1));
phase2 = angle(K_w(:,1));
phasedeg2 = phase2*180/pi;

figure;
subplot(2,1,1)
loglog(Omega(:,2),mag)
hold on;
loglog(Omega(:,2),mag2)
grid on
xlabel('Frequency (rad/s)')
ylabel('Magnitude')
legend('space state','kw');
hold off;

subplot(2,1,2)
semilogx(Omega(:,2),phasedeg)
hold on;
semilogx(Omega(:,2),phasedeg2)
grid on
xlabel('Frequency (rad/s)')
ylabel('Phase (degrees)')
legend('space state','kw');
hold off;

figure;
subplot(2,1,1);
plot(Omega(:,2),real(h));
hold on;
plot(Omega(:,2),real(K_w1));
hold off;

subplot(2,1,2);
plot(Omega(:,2),imag(h));
hold on;
plot(Omega(:,2),imag(K_w1));
hold off;
