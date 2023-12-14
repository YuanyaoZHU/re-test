%Mooring Force Function
%code by ZHU-YY
%code date:2021/06/01

%information:
%F -- the 

function F=fun(Hf,Vf,w,L,E,A, x,z)
    if L-Vf/w>0    
    Cb=0.0001;
        F(1) = L - Vf/w + (Hf/w)*log(Vf/Hf + sqrt(1+(Vf/Hf)^2)) + Hf*L/E/A+Cb*w/2/E/A*(-(L-Vf/w)^2 + (L-Vf/w-Hf/Cb/w)*max(L-Vf/w-Hf/Cb/w,0)) -x;
    else
        F(1) = Hf/w*(log(Vf/Hf+sqrt(1+(Vf/Hf)^2))-log((Vf-w*L)/Hf + sqrt(1+((Vf-w*L)/Hf)^2)))+Hf*L/E/A-x;
    end

    F(2) = Hf/w*(sqrt(1+(Vf/Hf)^2)-sqrt(1+((Vf-w*L)/Hf)^2))+1/E/A*(Vf*L-w*(L^2)/2)-z;
    
end