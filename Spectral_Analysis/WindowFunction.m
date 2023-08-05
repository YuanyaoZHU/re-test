%% Information
%   this function include two methods to smooth the spectrum
%   1. Hammming window
%   2. Hanning window
%   the second argument is set as 'Hammming' or 'Hanning' to select the
%   method

function [S1]=WindowFunction(P1,Method)
L=length(P1);
S1=zeros(1,L);
if  Method == ['Hamming']
    for i=1:L-2
        S1(i+1)=0.23*P1(i)+0.54*P1(i+1)+0.23*P1(i+2);
    end
    S1(1)=0.54*P1(1)+0.46*P1(2);
    S1(end)=0.46*P1(end-1)+0.54*P1(end);
elseif Method == ['Hanning']
    for i=1:L-2
        S1(i+1)=0.25*P1(i)+0.5*P1(i+1)+0.25*P1(i+2);
    end
    S1(1)=0.5*P1(1)+0.5*P1(2);
    S1(end)=0.5*P1(end-1)+0.5*P1(end);
else
    disp('wrong input');
    return;
end
