Hs_plot = (0:0.2:15)';
U_plot = (0:0.2:40)';
%% Conditional distribution of Tp|(Hs,Uw)
obs = (zeros(n_U,n_Hs))';mu_tp_wh_lgfit=(zeros(n_U,n_Hs))'; sigma_tp_wh_lgfit=(zeros(n_U,n_Hs))';
mean_tp_wh = (zeros(n_U,n_Hs))';std_tp_wh = (zeros(n_U,n_Hs))';
mean_lgtp_wh = (zeros(n_U,n_Hs))';std_lgtp_wh = (zeros(n_U,n_Hs))';obs_h=zeros(n_Hs,1);
mean_tp_h = zeros(n_Hs,1);mean_uw_h = zeros(n_Hs,1);norm_tp_wh=(zeros(n_U,n_Hs))';
norm_uw_h = (zeros(n_U,n_Hs))'; norm_fit_p=zeros(n_Hs,1);std_tp_h=zeros(n_Hs,1);
for j=1:1:n_Hs % Hs class i
    eval(['temp1 = data_Hs.Hs' num2str(j) '.data;']);
    mean_tp_h(j) = mean(temp1(:,3));
    std_tp_h(j) = std(temp1(:,3));
    obs_h(j) = length(temp1(:,1));
    mean_uw_h(j) = mean(temp1(:,1));
    norm_uw_h(j,:) = (U_xx-mean_uw_h(j))/mean_uw_h(j);%normalized Uw|Hs
    
    for i=1:1:n_U
        eval(['temp2 = sortrows(data_Hs.Hs' num2str(j) '.U' num2str(i) '(:,3),1);']); %find the Tp data for this Hs class i
        obs(j,i) = length(temp2);
        if obs(j,i)>20
            mean_tp_wh(j,i) = mean(temp2);
            std_tp_wh(j,i) = std(temp2);
            cov_tp_wh(j,i) = std_tp_wh(j,i)/mean_tp_wh(j,i);
            mean_lgtp_wh(j,i) = mean(log(temp2));
            std_lgtp_wh(j,i) = std(log(temp2));
%              figure(10); wnormplot(log(temp2));xlabel('log(Tp)');
            log_Tp_Hs_U = lognfit(temp2);
            mu_tp_wh_lgfit(j,i) = log_Tp_Hs_U(1); % parameter mu from fitting
            sigma_tp_wh_lgfit(j,i) = log_Tp_Hs_U(2); % parameter sigma from fitting
            norm_tp_wh (j,i) = (mean_tp_wh(j,i)-mean_tp_h(j))/mean_tp_h(j);%normalized Tp|Hs
        else
            mean_tp_wh(j,i) = NaN;
            std_tp_wh(j,i) = NaN;
             cov_tp_wh(j,i) = NaN;
            mean_lgtp_wh(j,i) = NaN;
            std_lgtp_wh(j,i) = NaN;
        end
        temp_x = norm_uw_h(j,:);temp_y = norm_tp_wh(j,:);
        ind = (temp_y~=0);
        a_0=1;temp_x = temp_x(ind);temp_y = temp_y(ind);
        if sum(ind)>4
            norm_fit_p(j) = nlinfit(temp_x,temp_y,@norm_fitting,a_0);% fit normalized Tp as f(Uw) get theta
            norm_tp_wh_fit = norm_fitting(norm_fit_p(j),temp_x);
            figure(1);subplot(5,4,j)
            plot(temp_x,temp_y,'b*',temp_x,norm_tp_wh_fit,'r-','MarkerSize',4,'LineWidth',1.5);
            title([num2str(Hs_x(j)) '<Hs<' num2str(Hs_x(j+1))],'FontSize',8);
            xlabel('Normalized W','FontSize',6);  ylabel('Normalized Tp','FontSize',6);
            set(gca,'fontsize',8)
        end
    end
end

    theta = norm_fit_p; ind = (theta~=0);  theta0 = theta(ind);
    theta_mean = mean(theta0)
    theta_mean_plot = ones(size(Hs_xx(ind))).*theta_mean;
    figure(3);  plot(Hs_xx(ind),norm_fit_p(ind),'b*',Hs_xx(ind),theta_mean_plot,'r--','MarkerSize',6,'LineWidth',2);title('\theta');xlabel('Hs [m]');ylabel('\theta value');set(gca,'fontsize',10);legend('raw data','fit')
    
    c0 = [2.5;0.5];
    mean_tp_h_fit_p = nlinfit(Hs_xx,mean_tp_h,@mean_tp_h_fitting,c0); % fit mean Tp as f(h)
    mean_tp_h_fit = mean_tp_h_fitting(mean_tp_h_fit_p,Hs_xx);
    figure(2); subplot(2,1,1); plot(Hs_xx,mean_tp_h,'b*',Hs_xx,mean_tp_h_fit,'r-','MarkerSize',5,'LineWidth',1.5);title('Fit mean Tp(h)');ylabel('mean Tp(h)');legend('raw data','fit')
    d0 = [3;0.5];
    mean_uw_h_fit_p = nlinfit(Hs_xx,mean_uw_h,@mean_uw_h_fitting,d0);% fit mean Uw as f(h)
    mean_uw_h_fit = mean_uw_h_fitting(mean_uw_h_fit_p,Hs_xx);
    figure(2); subplot(2,1,2); plot(Hs_xx,mean_uw_h,'b*',Hs_xx,mean_uw_h_fit,'r-','MarkerSize',5,'LineWidth',1.5);title('Fit mean w(h)');xlabel('Hs [m]');ylabel('mean w(h)');set(gca,'fontsize',10);

    % ratio between std(Tp) and mean(Tp), it's only a function of Hs
    ratio = zeros(n_Hs,1);
    for i=1:n_Hs
        ratio(i) = std_tp_h(i)/ mean_tp_h(i);
    end
    
    ratio_p0 = [0.25;-0.1;];
    ratio_p = nlinfit(Hs_xx,ratio,@ratio_fitting,ratio_p0);
    ratio_fit = ratio_fitting(ratio_p,Hs_xx);
    ratio_plot = ratio_fitting(ratio_p,Hs_plot);
    figure(4);plot(Hs_xx,ratio,'b*',Hs_plot,ratio_plot,'r-','MarkerSize',6,'LineWidth',2);title('ratio between \sigma(Tp) and \mu(Tp)');xlabel('Hs [m]')
    
    std_tp_fit = zeros(n_Hs,n_U);mean_tp_fit = zeros(n_Hs,n_U);sigma2_lgtp_fit = zeros(n_Hs,n_U);
    delta_mean_tp = zeros(n_Hs,n_U);delta_std_tp = zeros(n_Hs,n_U);mu_lgtp_fit = zeros(n_Hs,n_U);
    sigma_lgtp_fit = zeros(n_Hs,n_U);delta_mu_lgtp = zeros(n_Hs,n_U);delta_sigma_lgtp = zeros(n_Hs,n_U);
    for i=1:n_Hs
        for j=1:n_U
            mean_tp_fit(i,j) = mean_tp_h_fit(i)*(1+theta_mean*(U_xx(j)-mean_uw_h_fit(i))/mean_uw_h_fit(i));
            std_tp_fit(i,j) = ratio_fit(i)*mean_tp_fit(i,j);
            mu_lgtp_fit(i,j) = log(mean_tp_fit(i,j)/(1+ratio_fit(i)^2)^0.5);
            sigma2_lgtp_fit(i,j) = log(1+ratio_fit(i)^2);
            sigma_lgtp_fit(i,j) = sigma2_lgtp_fit(i,j)^0.5;
            if (mean_tp_wh(i,j)>0)
                delta_mean_tp(i,j) = (mean_tp_fit(i,j)-mean_tp_wh(i,j))/mean_tp_wh(i,j)*100;
                delta_std_tp(i,j) = (std_tp_fit(i,j)-std_tp_wh(i,j))/std_tp_wh(i,j)*100;
                delta_mu_lgtp(i,j) = (mu_lgtp_fit(i,j)-mean_lgtp_wh(i,j))/mean_lgtp_wh(i,j)*100;
                delta_sigma_lgtp(i,j) = (sigma_lgtp_fit(i,j)-std_lgtp_wh(i,j))/std_lgtp_wh(i,j)*100;
            else
                delta_mean_tp(i,j) = NaN;
                delta_std_tp(i,j) = NaN;
                delta_mu_lgtp(i,j) = NaN;
                delta_sigma_lgtp(i,j) = NaN;
            end
        end
    end
    figure(5);subplot(1,2,1);surf(Hs_xx,U_xx,delta_mean_tp');ylabel('Uw [m/s]');xlabel('Hs [m]');title('delta \mu(Tp) (%)','FontSize',10);zlabel('delta \mu(Tp) (%)');grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',10)
    subplot(1,2,2);surf(Hs_xx,U_xx,delta_mu_lgtp');ylabel('Uw [m/s]');xlabel('Hs [m]');title('delta \mu(lnTp) (%)','FontSize',10);grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',10);
    figure(6);subplot(1,2,1);surf(Hs_xx,U_xx,delta_std_tp');ylabel('Uw [m/s]');xlabel('Hs [m]');title('delta \sigma(Tp) (%)','FontSize',10);grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',10)
    subplot(1,2,2);surf(Hs_xx,U_xx,delta_sigma_lgtp');ylabel('Uw [m/s]');xlabel('Hs [m]');title('delta \sigma(lnTp) (%)','FontSize',10);grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',10)
    
    h6 = figure('Position',[800 400 340 550]);
    subplot(2,1,1);surf(Hs_xx,U_xx,mean_tp_wh');ylabel('Uw [m/s]','fontsize',7);xlabel('Hs [m]','fontsize',7);title('Mean value of T_p  [s] ','FontSize',7);zlabel('\mu(Tp) [s]','fontsize',7);grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',7)
    subplot(2,1,2);surf(Hs_xx,U_xx,std_tp_wh');ylabel('Uw [m/s] ', 'FontSize',7);xlabel('Hs [m]','fontsize',7);title('Standard deviation of T_p  [s] ','FontSize',7);zlabel('\sigma(Tp) [s]');grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',7)
    
     h7 = figure('Position',[800 400 340 550]);
    subplot(2,1,1);surf(Hs_xx,U_xx,mean_tp_wh');ylabel('Uw [m/s]','fontsize',7);xlabel('Hs [m]','fontsize',7);title('Mean value of T_p  [s] ','FontSize',7);zlabel('\mu(Tp) [s]','fontsize',7);grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',7)
    subplot(2,1,2);surf(Hs_xx,U_xx,cov_tp_wh');ylabel('Uw [m/s] ', 'FontSize',7);xlabel('Hs [m]','fontsize',7);title('COV of T_p  [s] ','FontSize',7);zlabel('\sigma(Tp) [s]');grid on;axis([0,10,0,25]); set(gca,'YTick',0.5:2:24.5); set(gca,'XTick',0.25:1:10.25);set(gca,'fontsize',7)
    