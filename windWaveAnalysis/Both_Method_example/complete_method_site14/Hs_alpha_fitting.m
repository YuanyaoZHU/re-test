function y=Hs_alpha_fitting(a,U)
% a(1)=0.001;
% y=a(1)+a(2)*exp(a(3)*U);
y=a(1)+a(2)*U.^a(3);
% y=a(1)+a(2)*U;