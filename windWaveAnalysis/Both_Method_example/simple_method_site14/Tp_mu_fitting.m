function y=Tp_mu_fitting(a,Hs)
% alpha(1)=0.001;
% y=a(1)+a(2)*exp(a(3)*Hs);
y=a(1)+a(2)*Hs.^(a(3));
% y=a(1)+a(2)*x+a(3)*U.^a(4);