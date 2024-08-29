%This is KDJ function


function [k,d,j] = myKDJ(sheet, N, M1, M2,nargin)
if( nargin == 3)
    N = 9;
    M1 = 3;
    M2 = 3;
end
hi=sheet(:,2);
lo=sheet(:,3);
cl=sheet(:,4);

a1 = zeros(size(cl));
k = a1;
d = a1;
j = a1; 
k(N) = 50; 
d(N) = 50; 
j(N) = 50; 
M =1; 
for n = N+1:length(cl)
    a2 = cl(n) - min(lo(n+1-N:n)); 
    a3 = max(hi(n+1-N:n)) - min(lo(n+1-N:n)); 
    a1(n) = a2 / a3 * 100; 
    rsv = a1(n); 
    k(n) = k(n-1) * (M1-1) / M1 + rsv * 1 / M1 ; 
    d(n) = d(n-1) * (M2-1) / M2 + k(n)/M2; 
    j(n) = 3 * k(n) - 2 * d(n); 
end