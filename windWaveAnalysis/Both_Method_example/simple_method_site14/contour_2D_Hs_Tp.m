%%  Hs-Tp 2D contour

pf = 1/(365.25*24*yr);
beta = norminv((1-pf),0,1);
r = (0:0.01:2*pi)';
h = zeros(size(r));
tp = zeros(size(r));
u2 = beta*sin(r);
u3 = beta*cos(r);

% Hs marginal - Lognormal-Weibull
mu_Hs_cs = mu_Hs;
sigma_Hs_cs = sigma_Hs;
for i=1:1:length(r)
h(i) = logninv(normcdf(u2(i),0,1),mu_Hs_cs,sigma_Hs_cs);% use paramters by fitting variance
if h(i) >= Hs_shift
% Weibull distribution for Hs|U
alpha_Hs_cs = alpha_Hs;
beta_Hs_cs = beta_Hs;
h(i) = wblinv(normcdf(u2(i),0,1),beta_Hs_cs,alpha_Hs_cs);
end 
end
    
% Tp-conditional - Log-normal
mu_Tp_Hs_cs = Tp_mu_fitting(a_Tp_Hs,h);
sigma2_Tp_Hs_cs = Tp_sigma2_fitting(b_Tp_Hs,h);
tp = logninv(normcdf(u3,0,1),mu_Tp_Hs_cs,sigma2_Tp_Hs_cs.^0.5);

figure(22);
plot(tp,h,'+-','LineWidth',2,'MarkerSize',3);
xlabel('Peak period [s]','FontSize',12)
ylabel('Significant wave height [m]','FontSize',12);
set(gca,'fontsize',12)
title('Hs and Tp contour line');
legend([num2str(yr) '-year']);
grid on
hold on