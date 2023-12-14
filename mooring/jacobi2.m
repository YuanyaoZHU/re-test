function J=jacobi2(Hf,Vf,w,L,E,A,x,z,ep)
ep=ep*0.01;
F1=(fun2(Hf+ep,Vf,w,L,E,A, x,z)-fun2(Hf,Vf,w,L,E,A, x,z))/ep;
F2=(fun2(Hf,Vf+ep,w,L,E,A, x,z)-fun2(Hf,Vf,w,L,E,A, x,z))/ep;
    J(1,1) = F1(1);
    J(1,2) = F2(1);
    J(2,1) = F1(2);
    J(2,2) = F2(2);
end