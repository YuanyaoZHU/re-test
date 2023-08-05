%% Spectrum Analysis
%   Code by YY-ZHU
%   Modified on 6/3/2021
%% Defination
%   Three methods are included:
%   1. Self-Correlation Function (SCF) method
%   2. Fast Fourier Transform (FFT) method
%   3. Maximum Entropy Method (MEM)
%   The function for these three methods are named as:
%   1. Spectrum_Analysis_SCF
%   2. Spectrum_Analysis_FFT
%   3. Spectrum_Analysis_MEM
function [Spectrum,Frequency]=Spectrum_Analysis_FFT(b,Fs,Method)
  T = 1/Fs;             % Sampling period       
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
P1(1) = 0;
S2 = zeros(1,L/2+1);
for i=1:L/2+1
    S2(i)=(P1(i)^2)*T*L/4/pi;
    %S2(i)=1/(2*pi*L)*P1(i)^2;
end

for i=1:15
    
    S2=WindowFunction(S2,Method);
end
Frequency = Fs*(0:(L/2))/L;
Spectrum = S2;