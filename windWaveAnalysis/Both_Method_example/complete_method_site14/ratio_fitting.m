function y=ratio_fitting(b,U)
% b(1)=0.0001;
% y=b(1)+b(2)*exp(b(3)*U);
y=-0.001+b(1)*exp(b(2)*U);
% y=b(1)+b(2)*U.^b(3);
% y=b(1)+b(2)*U.^b(3);