function [Hf,Vf] = CalcMooringForce2(w,L,E,A,x,z,ep)

    if x==0
        lamta0=1000000;
    elseif sqrt(x^2+z^2)>=L
        lamta0=0.2;
    else
        lamta0 = sqrt(3*((L^2-z^2)/x^2-1));
    end
    %Hf=736939.764;
    %Vf=535728.146;
    Hf=abs(w*x/2/lamta0);
    Vf=w/2*(z/tanh(lamta0)+L);
    for i = 0:10000
        J=jacobi2(Hf,Vf,w,L,E,A,x,z,ep);
        Inv_J=inv(J);
        F=fun2(Hf,Vf,w,L,E,A, x,z);
        f1=F(1);
        f2=F(2);
        %f3=F(3);
        %f4=F(4);
        %f5=F(5);
        Hf1 = Hf-(Inv_J(1,1)*f1+Inv_J(1,2)*f2);
        Vf1 = Vf-(Inv_J(2,1)*f1+Inv_J(2,2)*f2);
        delta1 = abs(Hf1-Hf);
        delta2 = abs(Vf1-Vf);
        if delta1<=ep && delta2<=ep
            Hf;
            Vf;
            break
        end
        Hf=Hf1;
        Vf=Vf1;
    end
end