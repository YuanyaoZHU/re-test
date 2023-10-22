datasort;
Hs_plot = (0:0.2:20)';U_plot = (0:0.2:40)';%for plottings

%% Maginal distribution of wind speed U (Weibull)
temp1 = data_U.data(:,1);
wei_U = wblfit(temp1); %fitting with 2 parameter Weibul distribution
alpha_U = wei_U(2); % parameter alpha
beta_U = wei_U(1); % parameter beta
pdf_U_fit = wblpdf(temp1,beta_U,alpha_U);
cdf_U_fit = wblcdf(temp1,beta_U,alpha_U);

F_U = empdistr(temp1);
emprical_U = F_U(:,2);% cummulative distributions of the sample

clear figure;figure(1); % compare
plot(log(temp1),log(-log(1-emprical_U)),'b*',log(temp1),log(-log(1-cdf_U_fit)),'r--','MarkerSize',4,'LineWidth',2);
legend('raw data','Weibull fitting');
title('Weibull Probability Plot');
xlabel('ln(U_w)');
ylabel('ln(-ln(1-F))');

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

%% Conditional distribution of Hs for given Uw (Weibull)
alpha_Hs_U = zeros(size(U_xx));beta_Hs_U = zeros(size(U_xx));mu_Hs_U = zeros(size(U_xx));
sigma_Hs_U = zeros(size(U_xx));sigma2_Hs_U = zeros(size(U_xx));
mean_Hs_U = zeros(size(U_xx));std_Hs_U = zeros(size(U_xx));
mean_logHs_U = zeros(size(U_xx));std_logHs_U = zeros(size(U_xx));

for i = 1:1:n_U
    eval(['temp1 = data_U.U' num2str(i) '.data(:,2);']);
    wei_Hs_U = wblfit(temp1); %fitting with 2 parameter Weibul distribution
    alpha_Hs_U(i) = wei_Hs_U(2);
    beta_Hs_U(i) = wei_Hs_U(1);
    pdf_Hs_U_fit = wblpdf(temp1,beta_Hs_U(i),alpha_Hs_U(i));
    cdf_Hs_U_fit = wblcdf(temp1,beta_Hs_U(i),alpha_Hs_U(i));
    
    mean_Hs_U(i) = mean(temp1);std_Hs_U(i) =std(temp1);
    
    F_Hs_U = empdistr(temp1);emprical_Hs_U = F_Hs_U(:,2);% cdf of the sample
    
%     clear figure;figure(6); % compare fitting with sample distribution
%     plot(log(temp1),log(-log(1-emprical_Hs_U)),'b*',log(temp1),log(-log(1-cdf_Hs_U_fit)),'r--','MarkerSize',4,'LineWidth',2);
%     legend('raw data','Weibull fitting');
%     title('Weibull Probability Plot');
%     xlabel('log(Hs)');
%     ylabel('log(-log(1-F))');
%     
%     figure(7);
%     subplot(2,1,1); plot(Hs_xx,cdf_Hs_U_m(i,:)','r*',temp1,cdf_Hs_U_fit,'Linewidth',2);
%     legend('raw data','Weibull'); title('Cumulative Density Function F(Hs|U_w)');
%     subplot(2,1,2);    plot(Hs_xx,pdf_Hs_U_m(i,:),'r*',temp1,pdf_Hs_U_fit,'Linewidth',2);
%     legend('raw data','Weibull'); title('Probability Density Function f(Hs|U_w)');xlabel('Significant wave height [m]');
end

% fit Weibull parameters
a0_Hs_U = [0.5;1;0];
a_Hs_U = nlinfit(U_xx,alpha_Hs_U,@Hs_alpha_fitting,a0_Hs_U);%fit parameter alpha as a fun. of U
alpha_Hs_U_fit = Hs_alpha_fitting(a_Hs_U, U_plot);
b0_Hs_U = [-1;1;0];
b_Hs_U = nlinfit(U_xx,beta_Hs_U,@Hs_beta_fitting,b0_Hs_U);%fit parameter beta as a fun. of U
beta_Hs_U_fit = Hs_beta_fitting(b_Hs_U, U_plot);

mean_Hs_U_fit = beta_Hs_U_fit.*gamma(1./alpha_Hs_U_fit+1);%calculate mean and std based on fitted parameter
std_Hs_U_fit = beta_Hs_U_fit.*(gamma(2./alpha_Hs_U_fit+1)-(gamma(1./alpha_Hs_U_fit+1)).^2).^0.5;

figure(8); %compare alpha and beta (as a function of U) before and after fitting
plot(U_xx,alpha_Hs_U,'rs',U_plot,alpha_Hs_U_fit,'r-',U_xx,beta_Hs_U,'bd',U_plot,beta_Hs_U_fit,'b-','Linewidth',2);
legend(' \alpha (raw data)','\alpha (fit)','\beta (raw data)','\beta (fit)');xlabel('Wind speed (m/s)');ylabel('Weibull parameters');

figure(9); %check the fitting by compare mean value and std
plot(U_xx, mean_Hs_U,'rs',U_plot,mean_Hs_U_fit,'r-',U_xx,std_Hs_U,'bd',U_plot,std_Hs_U_fit,'b-','Linewidth',2);
legend('Mean (raw data)','Mean (fit)','STD (raw data)','STD (fit)');xlabel('Wind speed (m/s)');ylabel('Mean value and standard deviation');

%% Conditional distribution of Tp for given both Hs and Uw
Tp_distribution_new;

%% contours
yr = 50;n_p = 100; 
contour_3D_new;

