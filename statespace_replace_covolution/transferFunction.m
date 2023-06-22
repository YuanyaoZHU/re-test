%%
function [Hs] = transferFunction(s,a,b)
l = length(s);
la = length(a);
lb = length(b);
for i = 1:l
    ap = 0;
    bp = 0;
    for p = 1:la
        ap = ap+a(p)*s(i)^(la-p+1);
    end
    for p = 1:lb
        bp = bp+b(p)*s(i)^(lb-p+1);
    end
    Hs(i) = ap/bp;
end
%{    
    Hs(i) = (...
            a(1)*s(i)^10)/...
            (b(1)*s(i)^6+ b(2)*s(i)^5+b(3)*s(i)^4+b(4)*s(i)^3+b(5)*s(i)^2+b(6)*s(i)+b(7)...
            );
%}

%a(1)*s(i)^5+a(2)*s(i)^4+a(3)*s(i)^3+a(4)*s(i)^2+a(5)*s(i)+a(6))