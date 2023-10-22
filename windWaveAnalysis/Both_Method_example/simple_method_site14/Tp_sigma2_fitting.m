function y=Tp_sigma2_fitting(b,Hs)
% b(1)=0.0000;
y=0.001+b(1)*exp(b(2)*Hs);
% y=b(1)+b(2)*Hs.^(b(3));
% y=b(1)+b(2)*x+b(3)*U.^b(4);