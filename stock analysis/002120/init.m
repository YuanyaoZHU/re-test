function info=init(RMB)
    clc;
    clear;
    Sheet2 = xlsread('Table.xlsx');
    n=length(Sheet2(:,1));
    info.money=RMB;
    info.Number=zeros(n,1);
    info.holdNumber=0;
    info.accont=zeros(n,1);
    info.balance=zeros(n,1);
    info.allmoney=zeros(n,1);
    info.m=300;
    info.buyprice=0;
end