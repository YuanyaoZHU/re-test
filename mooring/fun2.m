function F=fun2(Hf,Vf,w,L,E,A, x,z)
    Lb=L-Vf/w; 
    if Lb>0    
        Cb=0.0001;
        F(1) = Lb + (Hf/w)*log(Vf/Hf + sqrt(1+(Vf/Hf)^2))  -x + Cb*w/2/E/A*(-(L-Vf/w)^2 + (L-Vf/w-Hf/Cb/w)*max(L-Vf/w-Hf/Cb/w,0)) + Hf*L/E/A;
        %F(2) = (Hf/w)*(cosh((x-Lb)/Hf*w)-1)-z + (Vf^2)/(2*E*A*w);
        F(2) = (Hf/w)*(sqrt(1+(Vf/Hf)^2)-1)-z + (Vf^2)/(2*E*A*w);
        %F(3) = Cb*w/2/E/A*(-(L-Vf/w)^2 + (L-Vf/w-Hf/Cb/w)*max(L-Vf/w-Hf/Cb/w,0));
        %F(4) = Hf*L/E/A;
        %F(5) = (Vf^2)/(2*E*A*w);
        %F(2) = 1/w*(sqrt(Vf^2+Hf^2)-Hf)+w*(Vf/w)^2/(2*E*A)-z;
    else
        F(1) = Hf/w*(log(Vf/Hf+sqrt(1+(Vf/Hf)^2))-log((Vf-w*L)/Hf + sqrt(1+((Vf-w*L)/Hf)^2)))+Hf*L/E/A-x;
        F(2) = Hf/w*(sqrt(1+(Vf/Hf)^2)-sqrt(1+((Vf-w*L)/Hf)^2))+1/E/A*(Vf*L-w*(L^2)/2)-z;
    end
   
end