%Jacobi matrix
%code by Zhu-YY
%code date:2021/06/01

%information:

function J=jacobi(Hf,Vf,w,L,E,A,Cb)
    %F1=(fun(Hf+ep,Vf,w,L,E,A, x,z)-fun(Hf,Vf,w,L,E,A, x,z))/ep;
    if L-Vf/w<=0
        J(1,1)=(log(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2)) - log((Vf - L*w)/Hf + ((Vf - L*w)^2/Hf^2 + 1)^(1/2)))/w + (Hf*(((Vf - L*w)/Hf^2 + (Vf - L*w)^2/(Hf^3*((Vf - L*w)^2/Hf^2 + 1)^(1/2)))/((Vf - L*w)/Hf + ((Vf - L*w)^2/Hf^2 + 1)^(1/2)) - (Vf/Hf^2 + Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2)))/(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2))))/w + L/(A*E);
        J(1,2)=-(Hf*((1/Hf + (2*Vf - 2*L*w)/(2*Hf^2*((Vf - L*w)^2/Hf^2 + 1)^(1/2)))/((Vf - L*w)/Hf + ((Vf - L*w)^2/Hf^2 + 1)^(1/2)) - (1/Hf + Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2)))/(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2))))/w;
        J(2,1)=((Vf^2/Hf^2 + 1)^(1/2) - ((Vf - L*w)^2/Hf^2 + 1)^(1/2))/w - (Hf*(Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2)) - (Vf - L*w)^2/(Hf^3*((Vf - L*w)^2/Hf^2 + 1)^(1/2))))/w;
        J(2,2)=L/(A*E) - (Hf*((2*Vf - 2*L*w)/(2*Hf^2*((Vf - L*w)^2/Hf^2 + 1)^(1/2)) - Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2))))/w;
    elseif L-Vf/w>0 && L-Vf/w-Hf/Cb/w>0
        J(1,1)=log(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2))/w + (Vf/w - L + Hf/(Cb*w))/(A*E) + L/(A*E) - (Hf*(Vf/Hf^2 + Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2))))/(w*(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2)));
        J(1,2)=(Hf*(1/Hf + Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2))))/(w*(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2))) - 1/w + (Cb*w*((2*(L - Vf/w))/w + (2*(Vf/w - L + Hf/(Cb*w)))/w))/(2*A*E);
        J(2,1)=((Vf^2/Hf^2 + 1)^(1/2) - ((Vf - L*w)^2/Hf^2 + 1)^(1/2))/w - (Hf*(Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2)) - (Vf - L*w)^2/(Hf^3*((Vf - L*w)^2/Hf^2 + 1)^(1/2))))/w;
        J(2,2)=L/(A*E) - (Hf*((2*Vf - 2*L*w)/(2*Hf^2*((Vf - L*w)^2/Hf^2 + 1)^(1/2)) - Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2))))/w;
    else
        J(1,1) = log(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2))/w + L/(A*E) - (Hf*(Vf/Hf^2 + Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2))))/(w*(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2)));
        J(1,2) = (Cb*(L - Vf/w))/(A*E) - 1/w + (Hf*(1/Hf + Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2))))/(w*(Vf/Hf + (Vf^2/Hf^2 + 1)^(1/2)));
        J(2,1)=((Vf^2/Hf^2 + 1)^(1/2) - ((Vf - L*w)^2/Hf^2 + 1)^(1/2))/w - (Hf*(Vf^2/(Hf^3*(Vf^2/Hf^2 + 1)^(1/2)) - (Vf - L*w)^2/(Hf^3*((Vf - L*w)^2/Hf^2 + 1)^(1/2))))/w;
        J(2,2)=L/(A*E) - (Hf*((2*Vf - 2*L*w)/(2*Hf^2*((Vf - L*w)^2/Hf^2 + 1)^(1/2)) - Vf/(Hf^2*(Vf^2/Hf^2 + 1)^(1/2))))/w;
    end
   % F2=(fun(Hf,Vf+ep,w,L,E,A, x,z)-fun(Hf,Vf,w,L,E,A, x,z))/ep;
   % J(1,1) = F1(1);
   % J(1,2) = F1(2);
   % J(2,1) = F2(1);
   % J(2,2) = F2(2);
end