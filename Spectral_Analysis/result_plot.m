%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   本程序用于对工况LC5.3的图像操作
%   日期：2022年2月19日
%   作者：朱元瑶
%---------------------------------
%   本程序中加载了很多数据，但很多数据只是在仿真过程中的过渡性质数据
%   为了能够明确各数据的来历，现对其进行标注，以便以后查看程序
%   FAST4000.txt：是FAST平台运动响应的最原始数据
%   FAST_time4000.txt:FAST的时间步
%   FAST_RoterSpeed.txt：FAST的风机叶轮转速
%   FAST_GenTorq.txt：FAST发电机转矩
%   FAST_GenPw.txt：FAST发电机功率
%   motion_nowords.txt：是Timo仿真的最终版本
%   motion_final.txt：仿真设置与motion_nowords.txt是一样的，但是仿真时长不完整，是用于检测最终版设置是否正确的过渡性版本
%   motion_4000_rp_gp_ft.txt：此版本是过渡性版本，添加了Timo仿真的输出结果
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
time = load('FAST_time4000.txt');
%FAST = load('FAST4000.txt');
%Timo3 = load('motion_nowords.txt');

%{
Timo = load('motion_final.txt');
Timo2 = load('motion_4000_rp_gp_ft.txt');

Timo4 = load('motion_same_with_FAST.txt');
Timo5 = load('motion_2times_stiffness_of_yaw.txt');
Timo6 = load('motion_1.5Inetial.txt');
Timo7 = load('motion_0.5Inetial.txt');
%}
FAST1 = load('FAST.txt');%数据于2022年5月15日仿真获得，风文件中湍流密度由等级B调整为16.7%
%Timo8 = load('Timo_motion.txt');%数据于2022年5月15日由新模型仿真获得，风文件中湍流密度由等级B调整为16.7%
%Timo9 = load('Timo_motion1.txt');%数据于2022年5月18日由改正过的AeroDyn仿真获得，其他设置与Timo8一致
Timo10 = load('Timo_motion4.txt');
Orca = load('orcaflex_motion.txt');
FAST_wave = load('FAST_wave.txt');
freedom = {'Surge ','Sway','Heave','Roll','Pitch','Yaw'};
%%
for i=1:3
    figure(i);
    plot(time,FAST1(:,i*2-1));

    hold on;
    if i>2
        %plot(Timo(:,1),Timo(:,i*2)*180/3.1415926);
        %plot(Timo2(:,1),Timo2(:,i*2)*180/3.1415926);
        %plot(Timo3(:,1),Timo3(:,i*2)*180/3.1415926);
        %plot(Timo4(:,1),Timo4(:,i*2)*180/3.1415926);
        %plot(Timo5(:,1),Timo5(:,i*2)*180/3.1415926);
        %plot(Timo8(:,1),Timo8(:,i*2)*180/3.1415926);
        %plot(Timo9(:,1),Timo9(:,i*2)*180/3.1415926);
        plot(Timo10(:,1),Timo10(:,i*2)*180/3.1415926);
    else
        %plot(Timo(:,1),Timo(:,i*2));
        %plot(Timo2(:,1),Timo2(:,i*2));
        %plot(Timo3(:,1),Timo3(:,i*2));
        %plot(Timo4(:,1),Timo4(:,i*2));
        %plot(Timo5(:,1),Timo5(:,i*2));
        %plot(Timo8(:,1),Timo8(:,i*2));
        %plot(Timo9(:,1),Timo9(:,i*2));
        plot(Timo10(:,1),Timo10(:,i*2));
    end
    title(freedom(i*2-1));
    legend('FAST','Timo3','Timo8','Timo9','Timo4','Timo5');
    hold off;
end
figure(5);
title(freedom(6));
plot(time,FAST1(:,6));
hold on;
%plot(Timo3(:,1),Timo3(:,7)*180/pi);
%plot(Timo8(:,1),Timo8(:,7)*180/pi);
%plot(Timo9(:,1),Timo9(:,7)*180/pi);
plot(Timo10(:,1),Timo10(:,7)*180/pi);
hold off;
title(freedom(6));
figure(6);
plot(Timo10(:,1),Timo10(:,7));
%% Surge Pitch Heave time series plot
figure(21);
set(gcf,'unit','centimeters','position',[10 2 19 24]);
for i=1:3
    subplot(4,1,i);
    plot(time,FAST1(:,i*2-1),'Color',[0 0 1],'LineWidth',1.5);
    xlim([1000 4000]);
    hold on;
    if i>2
       plot(Timo10(:,1),Timo10(:,i*2)*180/3.1415926,'--','Color',[0.95 0.325 0.098],'LineWidth',1.5);
    else
       plot(Timo10(:,1),Timo10(:,i*2),'--','Color',[0.95 0.325 0.098],'LineWidth',1.5);
    end
    hold off;
    h=legend('NREL FAST','Present Model','Location','NorthWest');
    xlabel('Time [s]');
    
    if i==1
        ylim([5 30]);
        ylabel('Surge [m]');
    elseif i==2
        ylim([-1.2 1.8]);
        ylabel('Heave [m]');
    elseif i==3
        ylim([-2 8]);
        ylabel('Pitch [degree]');
    end
    set(gca,'FontName','Times New Roman','FontSize',15);
    set(h,'FontName','Times New Roman','FontSize',11,'FontWeight','normal','box','off');
end
subplot(4,1,4);
plot(time,FAST1(:,6),'Color',[0 0 1],'LineWidth',1.5);
xlim([1000,4000]);
ylim([-4 6]);
hold on;
plot(Timo10(:,1),Timo10(:,7)*180/3.1415926,'--','Color',[0.95 0.325 0.098],'LineWidth',1.5);
h=legend('NREL FAST','Present Model','Location','NorthWest');
xlabel('Time [s]');
ylabel('Yaw [degree]');
hold off;
set(gca,'FontName','Times New Roman','FontSize',15);
set(h,'FontName','Times New Roman','FontSize',11,'FontWeight','normal','box','off');
%% Surge Pitch Heave time series plot
for i = 1:3
    figure(i+21);
    set(gcf,'unit','centimeters','position',[10 2 26 10]);
    set(gca,'position',[.05 .10 0.9 .8]);
    plot(time,FAST1(:,i*2-1),'Color',[0 0 1],'LineWidth',5);
    xlim([2500 2600]);
    hold on;
    if i>2
       plot(Timo10(:,1),Timo10(:,i*2)*180/3.1415926,':','Color',[0.95 0.325 0.098],'LineWidth',5);
    else
       plot(Timo10(:,1),Timo10(:,i*2),':','Color',[0.95 0.325 0.098],'LineWidth',5);
    end
    hold off;
end
figure(25);
set(gcf,'unit','centimeters','position',[10 2 26 10]);
set(gca,'position',[.05 .10 0.9 .8]);
plot(time,FAST1(:,6),'Color',[0 0 1],'LineWidth',5);
xlim([2500 2600]);
ylim([-4 4]);
hold on;
plot(Timo10(:,1),Timo10(:,7)*180/3.1415926,':','Color',[0.95 0.325 0.098],'LineWidth',5);
hold off;
    
%% wave time series plot
figure(7);
set(gcf,'unit','centimeters','position',[10 2 26 10]);
set(gca,'position',[.1 .18 0.85 .75]);
wave=load('wave.txt');
plot(time,FAST_wave(:,1),'Color',[0 0 1],'LineWidth',1);
hold on;
plot(wave(:,1),wave(:,2),':','Color',[0.95 0.325 0.098],'LineWidth',1.3);
xlim([1000 4000]);
ylim([-6 8]);
legend('NREL FAST','Present Model','Location','NorthWest');
xlabel('Time [s]');
ylabel('Elevation [m]')
hold off;
set(gca,'FontName','Times New Roman','FontSize',15);
%% wave time series detail
figure(8);
set(gcf,'unit','centimeters','position',[10 2 26 10]);
set(gca,'position',[.05 .10 0.9 .8]);
wave=load('wave.txt');
plot(time,FAST_wave(:,1),'Color',[0 0 1],'LineWidth',5);
hold on;
plot(wave(:,1),wave(:,2),'--','Color',[0.95 0.325 0.098],'LineWidth',5);
xlim([2500 2600]);
ylim([-5 4]);
%legend('FAST','present model','Location','NorthWest');
hold off;
%% wave spectrum density

    [S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST_wave(:,1),50,'Hamming');
    %[S_Timo,F_Timo] = Spectrum_Analysis_FFT(wave(:,2),50,'Hamming');
    
    figure(9);
       
    N = length(F_FAST);
    S=zeros(1,N);
    omega1=zeros(N,1);
    Hs = 6;
    Tp = 10;
    for n = 1:N
        omega1(n,1) = F_FAST(n)*2*pi;
        S(1,n)=JONSWAP(omega1(n,1),Hs,Tp);
    end
    

    plot(F_FAST*2*pi,S,'Color',[0 0 1],'LineWidth',2.5);
    xlim([0 2]);
    hold on;
    plot(F_FAST*2*pi,S_FAST,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
    hold off;
    legend('Target JONSWAP PSD','present wave PSD','Location','NorthEast');
    
    
%% 对FAST和Simo的数据进行谱分析
figure(4)
set(gcf,'unit','centimeters','position',[10 2 19 24]);
set(gca,'position',[.10 .15 1 .95]);
for i = 1:3
    subplot(4,2,i);
    [S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST1(20001:end,i*2-1),50,'Hamming');
    [S_Orca,F_Orca] = Spectrum_Analysis_FFT(Orca(4001:end,i*2),10,'Hamming');
    %[S_FAST2,F_FAST2] = Spectrum_Analysis_FFT(FAST2(20001:end,i*2-1),50,'Hamming');
    %[S_Simo,F_Simo] = Spectrum_Analysis_FFT(Simo(801:end,i*2),2,'Hamming');
    if i>2
        %[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo(20001:end,i*2)*180/3.1415926,50,'Hamming');
        [S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo10(20001:end,i*2)*180/3.1415926,50,'Hamming');
    else
        %[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo8(1:30000,i*2),50,'Hamming');
        [S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo10(20001:end,i*2),50,'Hamming');
    end
    loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
    hold on;
    %loglog(F_FAST2,S_FAST2);
    %loglog(F_Simo,S_Simo);
    loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
    %loglog(F_Orca,S_Orca);
    h = legend('NREL FAST','Present Model');
    %set(h,'FontName','Times New Roman','FontSize',10);
    if i == 2
        axis([10^-3 10^1 10^-6 10^2]);
        yticks([10^-6 10^-4 10^-2 10^0 10^2]);
    else
        axis([10^-3 10^1 10^-4 10^4]);
        yticks([10^-4 10^-2 10^0 10^2 10^4]);
    end
    xticks([10^-3 10^-2 10^-1 10^0 10^1]);
    %xlabel('Frequency [Hz]','FontName','Times New Roman');
    %ylabel(freedom(i*2-1),'FontName','Times New Roman');
    hold off;
    %title(freedom(i*2-1));
    set(gca,'FontName','Times New Roman','FontSize',12);
    set(h,'FontName','Times New Roman','FontSize',10,'box','off');
end
subplot(4,2,4);
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST1(20001:end,6),50,'Hamming');
%[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo8(1:30000,7)*180/3.1415926,50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo10(20001:end,7)*180/3.1415926,50,'Hamming');
%[S_Orca,F_Orca] = Spectrum_Analysis_FFT(Orca(4001:end,7),10,'Hamming');
loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
    hold on;
loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
%loglog(F_Orca,S_Orca);
    %legend('FAST','Timo');
    axis([10^-3 10^1 10^-6 10^4]);
    xticks([10^-3 10^-2 10^-1 10^0 10^1]);
    yticks([10^-6 10^-4 10^-2 10^0 10^2 10^4 10^6]);
    hold off;
    h= legend('NREL FAST','Present Model');
    set(gca,'FontName','Times New Roman','FontSize',12);
    set(h,'FontName','Times New Roman','FontSize',10,'box','off');
%%
figure(7);
plot(Timo7(:,1),Timo7(:,7)*180/3.1415826);
meanT7 = mean(Timo7(:,7)*180/3.1415826);
hold on;
%figure(8);
plot(time,FAST(:,6));
meanF6 = mean(FAST(:,6));
hold off;
%% Roter Speed time series
figure(9);
FAST_RoterSpeed = load('FAST_RoterSpeed.txt');
plot(time,FAST_RoterSpeed);
hold on;
plot(Timo3(:,1),-Timo3(:,8)*60/3.1415926/2);
hold off;
%% Roter Speed Spectral Analysis
figure(4);
FAST1_RoterSpeed = load('FAST1_RoterSpeed.txt');
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST1_RoterSpeed(20001:end),50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(-Timo10(20001:end,8)*60/3.1415926/2,50,'Hamming');

subplot(4,2,5);
loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
hold on;
loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
hold off;
axis([10^-3 10^1 10^-6 10^4]);
xticks([10^-3 10^-2 10^-1 10^0 10^1]);
yticks([10^-6 10^-4 10^-2 10^0 10^2 10^4]);
legend('NREL FAST','Present Model');
set(gca,'FontName','Times New Roman','FontSize',12);
%legend('FAST','Timo');
%title('Roter Speed Spectral Analysis');
h = legend('NREL FAST','Present Model');
set(h,'FontName','Times New Roman','FontSize',10,'box','off');

%% Gen Torq
figure(11);%时历曲线展示
%Timo3 = load('motion_discon.txt');
FAST_GenTorq = load('FAST_GenTorq.txt');
plot(time,FAST_GenTorq);
hold on;
%plot(Timo2(:,1),Timo2(:,9)/97/1000);
plot(Timo10(:,1),Timo10(:,9)/97/1000);
legend('FAST','Timo');
hold off;
%% Gen Power
figure(12);%plot
FAST_GenPw = load('FAST1_GenPw.txt');
plot(time,FAST_GenPw);
hold on;
Timo_GenPw = zeros(200001,1);
for i = 1:200001
    Timo_GenPw(i,1) = -Timo10(i,8)* Timo10(i,9)*0.944/1000;
end
plot(Timo10(:,1),Timo_GenPw(:,1));
hold off;

figure(4);%频域分析
subplot(4,2,6);
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST_GenPw(20001:end),50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo_GenPw(20001:end),50,'Hamming');
loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
hold on;
loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
axis([10^-3 10^1 10^-2 10^8]);
xticks([10^-3 10^-2 10^-1 10^0 10^1]);
yticks([10^-2 10^0 10^2 10^4 10^6 10^8]);
%legend('FAST','T1mo');
hold off;
set(gca,'FontName','Times New Roman','FontSize',12);
h = legend('NREL FAST','Present Model');
set(h,'FontName','Times New Roman','FontSize',10,'box','off');
%% Fairlead Tension
figure(14);
FAST_Tension = load('FAST1_tension.txt');
plot(time,FAST_Tension(:,1));
hold on;
Timo_Tension = zeros(200001,3);
for i = 1:200001
   Timo_Tension(i,1) = sqrt(Timo10(i,10)*Timo10(i,10)+Timo10(i,11)*Timo10(i,11)+Timo10(i,12)*Timo10(i,12));
   Timo_Tension(i,2) = sqrt(Timo10(i,13)*Timo10(i,13)+Timo10(i,14)*Timo10(i,14)+Timo10(i,15)*Timo10(i,15));
   Timo_Tension(i,3) = sqrt(Timo10(i,16)*Timo10(i,16)+Timo10(i,17)*Timo10(i,17)+Timo10(i,18)*Timo10(i,18));
end
plot(Timo10(:,1),Timo_Tension(:,1));
hold off
legend('FAST','Timo');

figure(15);
plot(time,FAST_Tension(:,3));
hold on;
plot(Timo10(:,1),Timo_Tension(:,2));
hold off;
legend('FAST','Timo');

figure(16);
plot(time,FAST_Tension(:,5));
hold on;
plot(Timo10(:,1),Timo_Tension(:,3));
hold off;
legend('FAST','Timo');
%%
figure(4);%频域分析
subplot(4,2,7);
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST_Tension(20001:end,1)*10^-3,50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo_Tension(20001:end,1)*10^-3,50,'Hamming');
loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
hold on;
loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
%legend('FAST','Timo');
%title('Fair.1');
axis([10^-3 10^1 10^-4 10^6]);
xticks([10^-3 10^-2 10^-1 10^0 10^1]);
yticks([10^-4 10^-2 10^0 10^2 10^4 10^6]);
hold off;
legend('NREL FAST','Present Model');
set(gca,'FontName','Times New Roman','FontSize',12);
h = legend('NREL FAST','Present Model');
set(h,'FontName','Times New Roman','FontSize',10,'box','off');

figure(4);
subplot(4,2,8);
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST_Tension(20001:end,3)*10^-3,50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo_Tension(20001:end,2)*10^-3,50,'Hamming');
loglog(F_FAST,S_FAST,'Color',[0 0 1],'LineWidth',3);
hold on;
loglog(F_Timo,S_Timo,'Color',[0.95 0.325 0.098],'LineWidth',1.5);
%legend('FAST','Timo');
%title('Fair.2');
axis([10^-3 10^1 10^-4 10^6]);
xticks([10^-3 10^-2 10^-1 10^0 10^1]);
yticks([10^-4 10^-2 10^0 10^2 10^4 10^6]);
hold off;
legend('NREL FAST','Present Model');
set(gca,'FontName','Times New Roman','FontSize',12);
h = legend('NREL FAST','Present Model');
set(h,'FontName','Times New Roman','FontSize',10,'box','off');
%%
figure(19);
[S_FAST,F_FAST] = Spectrum_Analysis_FFT(FAST_Tension(20001:end,5),50,'Hamming');
[S_Timo,F_Timo] = Spectrum_Analysis_FFT(Timo_Tension(20001:end,3),50,'Hamming');
loglog(F_FAST,S_FAST);
hold on;
loglog(F_Timo,S_Timo);
legend('FAST','Timo');
title('Fair.3');
hold off;
