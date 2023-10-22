datasort;
Hs_plot = (0:0.2:20)';
U_plot = (0:0.2:40)';

%% Maginal distribution of wind speed U (Weibull)
temp1 = data_U.data(:,1);
wei_U = wblfit(temp1); %fitting with 2 parameter Weibul distribution
alpha_U = wei_U(2); % parameter alpha
beta_U = wei_U(1); % parameter beta
pdf_U_fit = wblpdf(temp1,beta_U,alpha_U);
cdf_U_fit = wblcdf(temp1,beta_U,alpha_U);

F_U = empdistr(temp1);
emprical_U = F_U(:,2);% cummulative distributions of the sample

clear figure;h1 = figure('Position',[800 400 340 280]);
plot(log(temp1),log(-log(1-emprical_U)),'go','MarkerSize',4,'LineWidth',1.5);
hold on; plot(log(temp1),log(-log(1-cdf_U_fit)),'r-','LineWidth',1.5);
legend('raw data','Weibull fitting');grid on;
% title('Weibull Probability Plot');
xlabel('log(U_w)','fontsize',7);ylabel('log(-log(1-F))','fontsize',7);set(gca,'fontsize',7); hold off;

figure(2); %compare fitting cdf with raw data
subplot(2,1,1)
plot(U_xx,cdf_U_m,'r*',temp1,cdf_U_fit,'Linewidth',2); %cdf
legend('raw data','Weibull');
title('Cumulative Density Function F(W)');
subplot(2,1,2)
plot(U_xx,pdf_U_m,'r*',temp1,pdf_U_fit,'Linewidth',2); %pdf
xlabel('Wind speed (m/s)');
legend('raw data','Weibull');
title('Probability Density Function f(W)');
%% Maginal distribution of Hs (Lognormal-Weibull(tail))
temp1 = sortrows(data_Hs.data(:,2),1); % Hs value
[Hs_shift,Lwp_Hs] = lonowei(temp1,Hs_xx,count_Hs);%find shift point and logn-wei parameters
mu_Hs = Lwp_Hs(1);
sigma_Hs = Lwp_Hs(2);
alpha_Hs = Lwp_Hs(3);
beta_Hs = Lwp_Hs(4);

for i=1:1:length(temp1)
    if temp1(i)<= Hs_shift
        cdf_Hs_fit(i) = logncdf(temp1(i),mu_Hs,sigma_Hs);% lognormal
        pdf_Hs_fit(i) = lognpdf(temp1(i),mu_Hs,sigma_Hs);
    else
        cdf_Hs_fit(i) = wblcdf(temp1(i),beta_Hs,alpha_Hs);% weibull
        pdf_Hs_fit(i) = wblpdf(temp1(i),beta_Hs,alpha_Hs);
    end
end

figure(3);F_Hs = empdistr(temp1);
emprical_Hs = F_Hs(:,2);% cummulative distributions of the sample

clear figure; h2 = figure('Position',[800 400 340 280]); % check fittings
wei_Hs = wweibplot(temp1);
hold on;
plot(log(temp1),log(-log(1-cdf_Hs_fit)),'r-','Linewidth',1.5)
legend('raw data','Weibull fitting','Lonowe fitting');grid on;
% title('Weibull Probability Plot');
xlabel('log(Hs)','fontsize',7);ylabel('log(-log(1-F))','fontsize',7);set(gca,'fontsize',7);hold off;

figure(5); %compare fitting cdf with raw data
subplot(2,1,1)
plot(Hs_xx,cdf_Hs_m,'r*',temp1,cdf_Hs_fit,'Linewidth',2);
legend('raw data','Lognormal-Weibull');
title('Cumulative Density Function F(Hs)');
subplot(2,1,2)
plot(Hs_xx,pdf_Hs_m,'r*',temp1,pdf_Hs_fit,'Linewidth',2);
xlabel('Significant wave height (m)');
legend('raw data','Lognormal-Weibull');
title('Probability Density Function f(Hs)');
%% Conditional distribution of Hs|U (Weibull)
alpha_Hs_U = zeros(size(U_xx));beta_Hs_U = zeros(size(U_xx));mu_Hs_U = zeros(size(U_xx));
sigma_Hs_U = zeros(size(U_xx));sigma2_Hs_U = zeros(size(U_xx));
mean_Hs_U = zeros(size(U_xx));std_Hs_U = zeros(size(U_xx));
mean_logHs_U = zeros(size(U_xx));std_logHs_U = zeros(size(U_xx));

for i = 1:1:n_U
    %     
%     figure(7);
%     subplot(2,1,1); plot(Hs_xx,cdf_Hs_U_m(i,:)','r*',temp1,cdf_H
    eval(['temp1 = data_U.U' num2str(i) '.data(:,2);']);
    
    wei_Hs_U = wblfit(temp1); %fitting with 2 parameter Weibul distribution
    alpha_Hs_U(i) = wei_Hs_U(2);
    beta_Hs_U(i) = wei_Hs_U(1);
    pdf_Hs_U_fit = wblpdf(temp1,beta_Hs_U(i),alpha_Hs_U(i));
    cdf_Hs_U_fit = wblcdf(temp1,beta_Hs_U(i),alpha_Hs_U(i));
    
    mean_Hs_U(i) = mean(temp1);std_Hs_U(i) =std(temp1);
    
    F_Hs_U = empdistr(temp1);emprical_Hs_U = F_Hs_U(:,2);% cdf of the sample
%         eval(['temp1 = data_U.U' num2str(i) '.data(:,2);']);
%     
%         clear figure;h33 = figure('Position',[800 400 340 280]); % compare fitting with sample distribution
%     plot(log(temp1),log(-log(1-emprical_Hs_U)),'go',log(temp1),log(-log(1-cdf_Hs_U_fit)),'r-','MarkerSize',4,'LineWidth',1.5);
%     legend('raw data','Weibull fitting','fontsize',7);grid on;
% %     title('Weibull Probability Plot');
%   xlim([-1 3]); xlabel('log(Hs)','fontsize',7);    ylabel('log(-log(1-F))','fontsize',7);set(gca,'fontsize',7);hold off;

%     legend('raw data','Weibull'); title('Cumulative Density Function F(Hs|U_w)');
%     subplot(2,1,2);    plot(Hs_xx,pdf_Hs_U_m(i,:),'r*',temp1,pdf_Hs_U_fit,'Linewidth',2);
%     legend('raw data','Weibull'); title('Probability Density Function f(Hs|U_w)');xlabel('Significant wave height [m]');
end

% fit Weibull parameters
a0_Hs_U = [2;0.01;1.7];
a_Hs_U = nlinfit(U_xx,alpha_Hs_U,@Hs_alpha_fitting,a0_Hs_U);%fit parameter alpha as a fun. of U
alpha_Hs_U_fit = Hs_alpha_fitting(a_Hs_U, U_plot);
b0_Hs_U = [2;0.02;1.8];
b_Hs_U = nlinfit(U_xx,beta_Hs_U,@Hs_beta_fitting,b0_Hs_U);%fit parameter beta as a fun. of U
beta_Hs_U_fit = Hs_beta_fitting(b_Hs_U, U_plot);

mean_Hs_U_fit = beta_Hs_U_fit.*gamma(1./alpha_Hs_U_fit+1);
std_Hs_U_fit = beta_Hs_U_fit.*(gamma(2./alpha_Hs_U_fit+1)-(gamma(1./alpha_Hs_U_fit+1)).^2).^0.5;

figure(8);h6 = figure('Position',[800 400 340 280]); %compare alpha and beta (as a function of U) before and after fitting
plot(U_xx,alpha_Hs_U,'go',U_plot,alpha_Hs_U_fit,'r-',U_xx,beta_Hs_U,'cd',U_plot,beta_Hs_U_fit,'r--','Linewidth',1.5);
legend(' \alpha (raw data)','\alpha (fitting)','\beta (raw data)','\beta (fitting)','fontsize',7);grid on;
xlabel('Uw [m/s]','fontsize',7);ylabel('Weibull parameters','fontsize',7);set(gca,'fontsize',7)

figure(9); %check the fitting by compare mean value and std
plot(U_xx, mean_Hs_U,'rs',U_plot,mean_Hs_U_fit,'r-',U_xx,std_Hs_U,'bd',U_plot,std_Hs_U_fit,'b-','Linewidth',2);
legend('Mean (raw data)','Mean (fit)','STD (raw data)','STD (fit)');
xlabel('Wind speed (m/s)');
ylabel('Mean value and standard deviation');
%% Conditional distribution of Tp|Hs, no wind speed
mu_Tp_Hs = zeros(n_Hs,1);
sigma_Tp_Hs = zeros(n_Hs,1);

for i=1:1:n_Hs % Hs class i
    eval(['temp1 = sortrows(data_Hs.Hs' num2str(i) '.data(:,3),1);']); %find the Tp data for this Hs class i
    m_Tp=length(temp1);
    
    
%     h3 = figure('Position',[800 400 340 280]);
%     wnormplot(log(temp1));xlabel('log(Tp)'); legend('raw data','Lognormal fitting');
%     
    log_Tp_Hs = lognfit(temp1);
    mu_Tp_Hs(i) = log_Tp_Hs(1); % parameter mu
    sigma_Tp_Hs(i) = log_Tp_Hs(2); % parameter sigma
    sigma2_Tp_Hs(i) = sigma_Tp_Hs(i)^2; % parameter sigma squared
    mean_Tp_Hs(i) = mean(temp1);
    mean_logTp_Hs(i)=mean(log(temp1));
    std_Tp_Hs(i) = std(temp1);
    var_Tp_Hs(i) = std_Tp_Hs(i)^2;
    std_logTp_Hs(i)=std(log(temp1));
    pdf_Tp_Hs_fit = lognpdf(temp1,mu_Tp_Hs(i),sigma_Tp_Hs(i));
    cdf_Tp_Hs_fit = logncdf(temp1,mu_Tp_Hs(i),sigma_Tp_Hs(i));
    
%     figure(11);
%     subplot(2,1,1);
%     plot(Tp_xx,cdf_Tp_Hs_m(i,:),'r*',temp1,cdf_Tp_Hs_fit,'Linewidth',2);
%     legend('raw data','Log-normal');
%     title('Cumulative Density Function F(Tp|Hs)');
%     subplot(2,1,2);
%     plot(Tp_xx,pdf_Tp_Hs_m(i,:),'r*',temp1,pdf_Tp_Hs_fit,'Linewidth',2);
%     legend('raw data','Log-normal');
%     title('Probability Density Function f(Tp|Hs)');
%     xlabel('Tp (s)');
end
a0_Tp_Hs = [1.5;0.5;0];
% a0_Tp_Hs = [4;-2;-0.1];
a_Tp_Hs = nlinfit(Hs_xx,mu_Tp_Hs,@Tp_mu_fitting,a0_Tp_Hs);%fit parameter mu as a func. of Hs
mu_Tp_Hs_fit = Tp_mu_fitting(a_Tp_Hs,Hs_plot);
%
b0_Tp_Hs = [-0.001;0.0002];
b_Tp_Hs = nlinfit(Hs_xx,sigma2_Tp_Hs',@Tp_sigma2_fitting,b0_Tp_Hs);
sigma2_Tp_Hs_fit = Tp_sigma2_fitting(b_Tp_Hs,Hs_plot);

h4 = figure('Position',[800 400 350 320]); %compare fitting parameters with raw data
subplot(2,1,1);plot(Hs_xx, mu_Tp_Hs,'go',Hs_plot,mu_Tp_Hs_fit,'r-','MarkerSize',4,'Linewidth',1.5);
legend('raw data','fitting','fontsize',7);set(gca,'fontsize',7);grid on;ylabel('\mu','fontsize',9)
subplot(2,1,2);plot(Hs_xx,sigma2_Tp_Hs,'cd',Hs_plot,sigma2_Tp_Hs_fit,'r--','MarkerSize',4,'Linewidth',1.5);
legend('raw data)','fitting','fontsize',7);grid on;
xlabel('Hs [m]','fontsize',7);set(gca,'fontsize',7);ylabel('\sigma^2','fontsize',9)

figure(13);% compare mean and std from fitting and raw data
subplot(2,1,1);
plot(Hs_xx,mean_logTp_Hs,'rs',Hs_plot,mu_Tp_Hs_fit,'r-','Linewidth',2);
legend(' mean (raw data)','mean (fit)');
subplot(2,1,2);
plot(Hs_xx,std_logTp_Hs,'bd',Hs_plot,sigma2_Tp_Hs_fit.^0.5,'b-','Linewidth',2);
legend(' std (raw data)','std (fit)');
xlabel('Hs (m)');
%% contours
yr = 50;
n_p = 100;
% % contour_2D_U_Hs; % 2D contour line of wind speed and Hs
% contour_2D_Hs_Tp;% 2D contour line of Hs and Tp
contour_3D;
