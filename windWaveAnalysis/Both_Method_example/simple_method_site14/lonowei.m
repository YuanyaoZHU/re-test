function [hs,y] = lonowei(h,h_xx,count)
%h is the sample vector; h_xx is the discrete hs values; count is the number of occurrences in each h interval
% H=2:0.1:10; % possible Hs* value
H = 5;
mu = zeros(length(H),1);
sigma = zeros(length(H),1);
alpha = zeros(length(H),1);
beta = zeros(length(H),1);
F_Hs_log = zeros(length(H),1);
f_Hs_log = zeros(length(H),1);
c1 = zeros(length(H),1);
c2 = zeros(length(H),1);
chi2 = zeros(length(H),1);

interval = length(count);
ei = zeros(interval,1); 
 chi = zeros(interval,1); 
for m=1:1:length(H)
    h0 = H(m); % shift point Hs*=h0
    h_log_fit = lognfit(h); % when h<Hs*, Log-normal distribution
    mu(m) = h_log_fit(1); % Log-normal parameter mu
    sigma(m) = h_log_fit(2); % Log-normal parameter sigma
    
    F_Hs_log(m) = logncdf(h0,mu(m),sigma(m)); % CDF value at shift point Hs*
    f_Hs_log(m) = lognpdf(h0,mu(m),sigma(m)); % PDF value at shift point Hs*
    % find weibull parameters using F(Hs*)_Logn=F(Hs*)_Wei, and f(Hs*)_Logn=f(Hs*)_Wei
    c1(m) = log(-log(1-F_Hs_log(m)));
    c2(m) = f_Hs_log(m)/(1-F_Hs_log(m));
    
    alpha(m) = -c2(m)*h0/log(1-F_Hs_log(m)); % Weibull shape parameter alpha
    beta(m) = h0*exp(c1(m)*log(1-F_Hs_log(m))/c2(m)/h0); % Weibull scale parameter beta

    
    % chi-square test to find the best Hs*
    N = sum(count(1:end));
    deta = h_xx(2)-h_xx(1);
     %count is the occurrences in each interval
    for i = 1:1:interval
        if h_xx(i)<=h0
            ei(i) = N*deta*lognpdf(h_xx(i),mu(m),sigma(m));
        else
            ei(i) = N*deta*wblpdf(h_xx(i),beta(m),alpha(m));
        end
        chi(i) = (count(i)-ei(i))^2/ei(i);
    end
    chi2(m) = sum(chi(1:end));
end
[a b]=min(chi2);
y(1)=mu(b); y(2)=sigma(b); y(3)=alpha(b); y(4)=beta(b);
hs = H(b);
