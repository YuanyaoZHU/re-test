%%  Uw-Hs 2D contour

pf = 1/(365.25*24*yr);
beta = norminv((1-pf),0,1);
r = (0:0.01:2*pi)';
h = zeros(size(r));
Uw = zeros(size(r));
mu_Hs_U_cs = zeros(size(r));
sigma2_Hs_U_cs = zeros(size(r));
alpha_Hs_U_cs = zeros(size(r));
beta_Hs_U_cs = zeros(size(r));

u1 = beta.*sin(r);
u2 = beta.*cos(r); 
beta_U_cs = beta_U; 
alpha_U_cs = alpha_U; 
Uw = wblinv(normcdf(u1,0,1),beta_U_cs,alpha_U_cs);%wind velocity

% Weibull distribution for Hs|U
alpha_Hs_U_cs = Hs_alpha_fitting(a_Hs_U, Uw);
beta_Hs_U_cs = Hs_beta_fitting(b_Hs_U, Uw);
h = wblinv(normcdf(u2,0,1),beta_Hs_U_cs,alpha_Hs_U_cs);

h1=max(h);
uw1=max(Uw);
for i=1:length(h)
   if h(i)==h1
       break
   end
end
for j=1:length(Uw)
   if Uw(j)==uw1
       break
   end
end
figure(21);
plot(h,Uw,'+-','LineWidth',2,'MarkerSize',3);
hold on
plot(h1,Uw(i),'ro',h(j),uw1,'ro','LineWidth',2,'MarkerFaceColor',[1 0 0],'MarkerSize',7);
xlabel('Hs [m]','FontSize',12)
ylabel('Wind speed [m/s]','FontSize',12);
set(gca,'fontsize',12)
grid on;
legend([num2str(yr) '-year']);
title('Uw and Hs contour line');
hold off;