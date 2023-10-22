%%  W-Hs-Tp 3D contour surface

pf = 1/(365.25*24*yr);
beta = norminv((1-pf),0,1);
% n_p = 100;
[u1,u2,u3]=sphere(n_p);
u1=u1*beta; u2=u2*beta; u3=u3*beta;

beta_U_cs = beta_U;
alpha_U_cs = alpha_U;
Uw = wblinv(normcdf(u1,0,1),beta_U_cs,alpha_U_cs);%wind velocity

%Weibull for Hs|U
alpha_Hs_U_cs = Hs_alpha_fitting(a_Hs_U, Uw);
beta_Hs_U_cs = Hs_beta_fitting(b_Hs_U, Uw);
h = wblinv(normcdf(u2,0,1),beta_Hs_U_cs,alpha_Hs_U_cs); %Hs|U


mean_tp_cs = zeros(size(h)); std_tp_cs = zeros(size(h));mu_lgtp_cs = zeros(size(h));theta_cs=zeros(size(h));
sigma2_lgtp_cs = zeros(size(h)); sigma_lgtp_cs = zeros(size(h));ratio_wind = zeros(size(h));ratio_2D_fit_cs = zeros(size(h));
mean_tp_h_cs = mean_tp_h_fitting(mean_tp_h_fit_p,h);
mean_uw_h_cs = mean_uw_h_fitting(mean_uw_h_fit_p,h);
ratio_cs = ratio_fitting(ratio_p,h);

for i=1:1:size(h,1)
    for j=1:1:size(h,2)
        ratio_wind(i,j) = (Uw(i,j)-mean_uw_h_cs(i,j))/mean_uw_h_cs(i,j);

        mean_tp_cs(i,j) = mean_tp_h_cs(i,j)*(1+theta_mean*ratio_wind(i,j));
        std_tp_cs(i,j) = ratio_cs(i,j)*mean_tp_cs(i,j);
        temp = mean_tp_cs(i,j)/(1+ratio_cs(i,j)^2)^0.5;
        mu_lgtp_cs(i,j) = log(temp);
        sigma2_lgtp_cs(i,j) = log(1+ratio_cs(i,j)^2);
        sigma_lgtp_cs(i,j) = sigma2_lgtp_cs(i,j)^0.5;
    end
end
tp = logninv(normcdf(u3,0,1),mu_lgtp_cs,sigma_lgtp_cs);
% 
% figure(23);
% surf(tp,h,Uw);
% grid on
% xlabel('Peak period [s]','FontSize',12)
% ylabel('Significant wave height [m]','FontSize',12);
% zlabel('Wind speed [m]','FontSize',12);
% title([num2str(yr) '-year contour surface'],'FontSize',14);
% set(gca,'fontsize',12)
% set(gcf,'renderer','zbuffer');
