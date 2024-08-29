clear;
clc;
b=load('southFlight.txt');
Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period
%L = 250;
L = length(b);             % Length of signal
if mod(L,2)~=0
    a=b(1:end-1);
    L=L-1;
else
    a=b;
end

Y = fft(a);
P2 = abs(Y/L);  % 2-sides spectrum
P1 = P2(1:L/2+1); % fetch half of P2
P1(2:end-1) = 2*P1(2:end-1); 
f = Fs*(0:(L/2))/L;  
plot(f(1:100),P1(1:100)); 
