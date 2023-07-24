clc;
clear;
load('Spar1.txt'); %阻尼
load('Spar2.txt'); %周期
load('Spar3.txt'); %附加质量
pho = 1025; %水密度
[x,p1]=size(Spar1);
[y,p2]=size(Spar2);
ma=x/10;
m=zeros(ma,2);
B=zeros(ma,10); %阻尼
A=zeros(ma,10); %附加质量
for i=0:ma-1
    m(i+1,1)=Spar2(i*10+1);%周期
    m(i+1,2)=2*pi/m(i+1,1);%角频率
    for j=1:10
        B(i+1,j)=Spar1(i*10+j)*pho;%阻尼
        A(i+1,j)=Spar3(i*10+j)*pho;%附加质量
    end
end
delta_Omega=0.05;
figure(1); 
plot(m(:,2),B(:,1));%阻尼矩阵B(1,1)
hold on;
plot(m(:,2),B(:,3));%阻尼矩阵B(2,2)
hold on;
plot(m(:,2),B(:,5));%阻尼矩阵B(3,3)
hold off;

figure(2);
plot(m(:,2),B(:,7));%阻尼矩阵B(4,4)
hold on;
plot(m(:,2),B(:,9));%阻尼矩阵B(5,5)
hold on;
plot(m(:,2),B(:,10));%阻尼矩阵B(6,6)
hold off;

figure(3);
plot(m(:,2),B(:,2));%阻尼矩阵B(1,5)
hold on;
plot(m(:,2),B(:,4));%阻尼矩阵B(2,4)
hold off;

figure(4);
plot(m(:,2),A(:,1));%附加质量矩阵A(1,1)
hold on;
plot(m(:,2),A(:,3));%附加质量矩阵A(2,2)
hold on;
plot(m(:,2),A(:,5));%附加质量矩阵A(3,3)
hold off;

figure(5);
plot(m(:,2),A(:,7));%附加质量矩阵A(4,4)
hold on;
plot(m(:,2),A(:,9));%附加质量矩阵A(5,5)
hold on;
plot(m(:,2),A(:,10));%附加质量矩阵A(6,6)
hold off;

figure(6);
plot(m(:,2),A(:,2));%附加质量矩阵A(1,5)
hold on;
plot(m(:,2),A(:,8));%附加质量矩阵A(5,1)
hold on;
plot(m(:,2),A(:,4));%附加质量矩阵A(2,4)
hold on;
plot(m(:,2),A(:,6));%附加质量矩阵A(4,2)
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
            p=B(k,i)*cos(m(k,2)*Kt(jj))+p;
        end
        K(jj,i)=2/pi*p*delta_Omega;
    end
end
figure;
plot(Kt(:),K(:,1));
%% 输出 RETARDATION 文件
fid=fopen('RETARDATION.txt','w');
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   3     3\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,5),K((i-1)*5+2,5),K((i-1)*5+3,5),K((i-1)*5+4,5),K((i-1)*5+5,5));
end
fprintf(fid,'%E\n',K(101,5));
%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   1     1\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,1),K((i-1)*5+2,1),K((i-1)*5+3,1),K((i-1)*5+4,1),K((i-1)*5+5,1));
end
fprintf(fid,'%E\n',K(101,1));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   1     5\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,2),K((i-1)*5+2,2),K((i-1)*5+3,2),K((i-1)*5+4,2),K((i-1)*5+5,2));
end
fprintf(fid,'%E\n',K(101,2));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   5     1\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,8),K((i-1)*5+2,8),K((i-1)*5+3,8),K((i-1)*5+4,8),K((i-1)*5+5,8));
end
fprintf(fid,'%E\n',K(101,8));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   5     5\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,9),K((i-1)*5+2,9),K((i-1)*5+3,9),K((i-1)*5+4,9),K((i-1)*5+5,9));
end
fprintf(fid,'%E\n',K(101,9));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   6     6\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,10),K((i-1)*5+2,10),K((i-1)*5+3,10),K((i-1)*5+4,10),K((i-1)*5+5,10));
end
fprintf(fid,'%E\n',K(101,10));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   2     2\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,3),K((i-1)*5+2,3),K((i-1)*5+3,3),K((i-1)*5+4,3),K((i-1)*5+5,3));
end
fprintf(fid,'%E\n',K(101,3));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   2     4\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,4),K((i-1)*5+2,4),K((i-1)*5+3,4),K((i-1)*5+4,4),K((i-1)*5+5,4));
end
fprintf(fid,'%E\n',K(101,4));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   4     2\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,6),K((i-1)*5+2,6),K((i-1)*5+3,6),K((i-1)*5+4,6),K((i-1)*5+5,6));
end
fprintf(fid,'%E\n',K(101,6));

%%
fprintf(fid,'nret ielem jelem\n');
fprintf(fid,' 101   4     4\n');
for i=1:20
   fprintf(fid,'%E\t %E\t %E\t %E\t %E\t\n',K((i-1)*5+1,7),K((i-1)*5+2,7),K((i-1)*5+3,7),K((i-1)*5+4,7),K((i-1)*5+5,7));
end
fprintf(fid,'%E\n',K(101,7));

fprintf(fid,'#');
fclose(fid);
%% 此步之后为2023年6月7日新加内容，采用Space-State 方法拟合延迟函数
j = sqrt(-1);
K_w = zeros(ma,10);
for i=1:ma
    for k=1:10
        K_w(i,k)=B(i,k)+j*m(i,2)*(A(i,k)-A(end,k));
    end
end

%%
In=zeros(100,1);
In(1:100,1)=1;
N=101;
u = [1 zeros(1,N-1)];
dt=0.25;
xx=zeros(6,N);
yy=zeros(1,N);
%%
for k = 1:N-1
    
    xx(:,k+1)= ss5.A*xx(:,k)+ ss5.B*u(k);
    %xx(:,k+1)=dx*dt+xx(:,k);
    yy(k)= ss5.C*xx(:,k)+ ss5.D*u(k);
    
end
figure(2);
plot(Kt(1:end-1),yy(1:end-1));
%%
 N=101;
 AA=zeros(6,6);
 BB = zeros(6,1);
 dt=0.1;
 DD = 0;
 AA(1,:)=[-3.5969 -8.0626 -8.49 -5.3006 -1.2374 -0.0488];
 AA(2:6,1:5)=eye(5);
 BB(1,1)=1;
 CC = [41350 193780 183100 61723 3558.2 0];
 for k = 1:N-1
    
    dx= AA*xx(:,k)+ BB*u(k);
    xx(:,k+1)=dx*dt+xx(:,k);
    yy(k)= CC*xx(:,k)+ DD*u(k);
    
end
figure(2);
plot((1:N-1)*dt,yy(1:end-1)); 
%%
N=101;
u = [1 zeros(1,N-1)];
dt=0.01;
xx=zeros(6,N);
yy=zeros(1,N);
a=[355.8 1470 1910 1667 945.1 86.96];
b=[-1.41e08 -3.186e08 6.971e07 -3.213e08 8.508e07 -5.625e07 1.347e07];
S.A=zeros(6,6);
S.B=zeros(6,1);
S.C=zeros(1,6);
S.D=0;
S.A(1:5,2:6)= eye(5);
S.A(6,:)=a;
S.B(6,1)=1;
for i = 1:6
    S.C(1,i)=b(i)-a(i)*b(end);
end
S.D = b(end);
 for k = 1:N-1    
    dx= S.A*xx(:,k)+ S.B*u(k);
    xx(:,k+1)=dx*dt+xx(:,k);
    yy(k)= S.C*xx(:,k)+ S.D*u(k);    
 end
figure(3);
plot((1:N-1)*dt,yy(1:end-1)); 

s=1+j;
plot(m(:,2),real(K_w(:,1)));
hold on;




