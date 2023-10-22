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

%Tp|Hs
mu_Tp_Hs_cs = Tp_mu_fitting(a_Tp_Hs,h);
sigma2_Tp_Hs_cs = Tp_sigma2_fitting(b_Tp_Hs,h);
tp = logninv(normcdf(u3,0,1),mu_Tp_Hs_cs,sigma2_Tp_Hs_cs.^0.5);

% figure(23);
% surf(tp,h,Uw);
% grid on
% xlabel('Peak period [s]','FontSize',12)
% ylabel('Significant wave height [m]','FontSize',12);
% zlabel('Wind speed [m]','FontSize',12);
% title([num2str(yr) '-year contour surface'],'FontSize',14);
% set(gca,'fontsize',12)