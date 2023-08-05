function S1 = JONSWAP(omega,Hs,Tp)

    if Tp/sqrt(Hs)<=3.6
        gama = 5;
    elseif Tp/sqrt(Hs)>3.6 && Tp/sqrt(Hs)<=5
        gama = exp(5.75-1.15*Tp/sqrt(Hs));
    elseif Tp/sqrt(Hs)>5
        gama = 1;
    end

    if omega<=2*pi/Tp
        sigma = 0.07;
    elseif omega>=2*pi/Tp
        sigma = 0.09;
    end

    Div2pi=1.0/2.0/pi;
    C1 = 5.0/16.0*Hs^2*Tp;
    C2 = (omega*Tp/2/pi)^(-5);
    C3 = exp(-1.25*(omega*Tp/2/pi)^(-4));
    C4 = 1-0.287*log(gama);
    C5 = gama^exp(-0.5*((omega*Tp/2/pi-1)/sigma)^2);
    S1 = Div2pi*C1*C2*C3*C4*C5;

end