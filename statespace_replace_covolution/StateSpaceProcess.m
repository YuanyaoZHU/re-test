clear;
clc;
close all;
%% ��ȡƵ��Χ�ڸ����������������
rho = 1025;
A_B=load("Spar.txt");
%{
    A_B = ����    ���ɶ�i    ���ɶ�j    ��������A    ����ϵ��B
%}
j = sqrt(-1);
size_Spar = size(A_B);
N_f = 10; %���ɶȸ���
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

for fn=1:10 %fnΪfreedom number��д
    p=1;
    for i = 1: size_Spar(1)
        if x(fn,1) == A_B(i,2) && x(fn,2)==A_B(i,3)
            A_B_I(p,:,fn) = A_B(i,:); 
            p=p+1;
        end
    end
end
size_ABI = size(A_B_I);
%A_B_IΪ���������������
%% ��ȡ�����Ƶ�ʴ��ĸ�������
A_Infinity = load("Spar_Infinity.txt");
A_Inf = A_Infinity(11:20,:)*rho;
%{
    A_Infinity = ����    ���ɶ�i    ���ɶ�j    ��������A
%}
%% �����Ƶ��
per = A_B_I(:,1,1);
N_w = length(per);%��Ƶ�ʵ�����
freq = zeros(length(per),1);
omega = zeros(length(per),1);
for i = 1:length(per)
    freq(i,1) = 1/per(i,1);
    omega(i,1) = 2*pi*freq(i);
end
%%
A_all(:,:) = A_B_I(:,4,:)*rho;% N_w Ϊ��Ƶ��������1��ʾ����������ֵ��10��ʾ��10�����ɶ�
B_all = zeros(N_w,N_f);
for k = 1:N_f
    for i = 1:N_w
        B_all(i,k) = A_B_I(i,5,k).*omega(i)*rho;
    end
end
K_all = zeros(N_w,N_f);
K_abs = zeros(N_w,N_f);
K_phase = zeros(N_w,N_f);
for k = 1:N_f
    for i = 1:N_w  
        K_all(i,k) = B_all(i,k) + j*omega(i)*(A_all(i,k)-A_Inf(k,4));
    end
    K_abs(:,k) = abs(K_all(:,k));
    K_phase(:,k) = angle(K_all(:,k));
    %---------------%
    %��ͼ
    figure(k);
    subplot(3,1,1);
    hold on;
    plot(omega,abs(K_all(:,k)),'r');
    subplot(3,1,2);
    plot(omega,angle(K_all(:,k)),'r');
    hold on;    
end

%%
m=4; %��Ӧb�Ľ���
n=4; %��Ӧa�Ľ���
w=omega;
N = 20000;%ʱ�����
dt = 0.001;
t = dt*(0:N-1);

for k = 1:N_f
    clear a b G Q;    
    [b,a]= invfreqs(K_all(:,k),w,m,n); % b/a a��ϵ����ӦQ��Ҳ���Ǵ��ݺ����ķ�ĸ����    
    for i = 1:20
        Q = polyval(a,w);
        wt = 1./abs(Q);
        [b,a]= invfreqs(K_all(:,k),w,m,n,wt); 
    end
    [S(k).A,S(k).B,S(k).C,S(k).D] = tf2ss(b,a);
    %---��ͼ--
    figure(k);
    G = freqs(b,a,w);
    subplot(3,1,1);    
    plot(w,abs(G),'b');
    hold off;
    legend('K_w','K_s');
    
    subplot(3,1,2);
    plot(w,angle(G),'b');
    hold off;
    legend('K_w','K_s');
    
    subplot(3,1,3);
    Kt = zeros(1,N);
    for i = 1:N_w
      Kt = Kt + 2/pi*(B_all(i,k)*cos(w(i).*t)*0.05);
    end
    %subplot(2,1,2);
    plot(t,Kt,'r');
    hold on;
    Imp = impulse(b,a,t);
    plot(t,Imp,'b')
    hold off; 
    legend('K_w','K_s');
    
    
end

fun = @(X)((fliplr((fliplr(X))'))');
for i =1:N_f
     s1 = 'S';
     s2 = num2str(i);
     %s3 = '.mat';
     fileNameC = [s1,s2];
     fileName =  convertCharsToStrings(fileNameC);
    %fileName = fullfile(s1,s2);
%     A = fun(S(i).A);
%     B = fun(S(i).B);
%     C = fun(S(i).C);
%    fileName = "S";
    A = S(i).A;
    B = S(i).B;
    C = S(i).C;
    D = S(i).D;
    
    s3 = 'A';
   
    s4 = 'B';
   
    s5 = 'C';

    s6 = 'D';
    
%    S_name = {[s3,s2],[s4,s2],[s5,s2]};
    save(fileName,'A','B','C','D');
%     name = [S_name{1}];
%     eval([name,'=A']);
%     
%     name = [S_name{2}];
%     eval([name,'=B']);
%     
%     name = [S_name{3}];
%     eval([name,'=C']);
end
%save(fileName,'A1','B1','C1','A2','B2','C2','A3','B3','C3','A4','B4','C4','A5','B5','C5','A6','B6','C6','A7','B7','C7','A8','B8','C8','A9','B9','C9','A10','B10','C10');





