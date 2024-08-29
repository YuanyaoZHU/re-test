clc;
clear;
Sheet2 = xlsread('Table.xlsx');

[k,d,j]=  myKDJ(Sheet2, 9,3 ,3 ,3);
n=length(k);
%figure(1);
%plot(n-50:n,k(n-50:n)),hold on;
%plot(n-50:n,d(n-50:n)),hold on;
%plot(n-50:n,j(n-50:n)),hold off;

money=10000;
x=zeros(n,1);
y=zeros(n,1);
deal=zeros(n,1);
x(1)=0;
y(1)=0;
Number=zeros(n,1);
holdNumber=0;
accont=zeros(n,1);
balance=zeros(n,1);
allmoney=zeros(n,1);
m=300;
buyprice=0;
%%
for i=m:n
    x(i)=k(i)-j(i);
    if x(i)*x(i-1)<0 & d(i)<=20 & j(i)>k(i) & holdNumber==0  %Buying strategy
                
                 holdNumber=floor(money/(Sheet2(i,4)*100));
        
                 money=money-holdNumber*Sheet2(i,4)*100;
                 
                 buyprice=Sheet2(i,4);
                 
                 
       
    elseif x(i)*x(i-1)<0 &  k(i)>j(i) & holdNumber>0 & d(i)>80 %selling strategy
        
            %if holdNumber>0 
                %if d(i)>=80
                    money=money+holdNumber*Sheet2(i,4)*100;
                    holdNumber=0;
                    buyprice=0;
                %end
            %end
            
    elseif Sheet2(i,4)<0.97*buyprice & holdNumber>0  % stop loss line
            money=money+holdNumber*Sheet2(i,4)*100;
            holdNumber=0;
            buyprice=0;
            
    elseif Sheet2(i,4)>1.03*buyprice & holdNumber>0  % stop profit line
            money=money+holdNumber*Sheet2(i,4)*100;
            holdNumber=0;
            buyprice=0;        
    end
    
    balance(i)=money;
    Number(i)=holdNumber;
    accont(i)=Number(i)*Sheet2(i,4)*100;
    allmoney(i)=accont(i)+balance(i);
        
end
%{
figure('Name','allmoney')
plot(m:n,allmoney(m:n));
figure('Name','accont');
plot(m:n,accont(m:n));
figure('Name','balance');
plot(m:n,balance(m:n));
figure('Name','Number');
plot(m:n,Number(m:n));
%}
figure('Name','allmoney,accont,blance');
plot(m:n,allmoney(m:n)),hold on;
plot(m:n,accont(m:n)),hold off;
%%  MACD strategy
%figure('Name','MACD');
index=MACD(Sheet2(:,4));
%plot(m:n,index.dif(m:n)),hold on;
%plot(m:n,index.dea(m:n)),hold on;
%stem(m:n,index.macd(m:n)),hold off;
buy=0;
day=0;
top=0;
for i=m:n
    x(i)=index.dif(i)-index.dea(i);
    y(i)=k(i)-j(i);

    if x(i)*x(i-1)<0 &index.dif(i)>index.dea(i) & holdNumber==0  & index.dea(i)>0   %Buying strategy
                
                 holdNumber=floor(money/(Sheet2(i,4)*100));
        
                 money=money-holdNumber*Sheet2(i,4)*100;
                 
                 buyprice=Sheet2(i,4);
                 
                 top=Sheet2(i,4);
                 
                 
       
    elseif x(i)*x(i-1)<0 &  index.dif(i)>index.dea(i) & holdNumber>0 %selling strategy
        

            money=money+holdNumber*Sheet2(i,4)*100;
            holdNumber=0;
            buyprice=0;
            top=0;
    elseif Sheet2(i,4)<0.9*buyprice & holdNumber>0  % stop loss line
            money=money+holdNumber*Sheet2(i,4)*100;
            holdNumber=0;
            buyprice=0;  
             %x(i)=k(i)-j(i);
            top=0; 
    elseif  y(i)*y(i-1)<0 & d(i)<=20 & j(i)>k(i)
            buy=1;
            day=1;
            top=0;
    elseif  Sheet2(i,4)<top*0.99 & holdNumber>0 %stop profit
            money=money+holdNumber*Sheet2(i,4)*100;
            holdNumber=0;
            buyprice=0;              
            top=0;
             
    end
    if holdNumber>0 & Sheet2(i,4)>Sheet2(i-1,4)
       top=Sheet2(i,4); 
    end

    
    if day<=3 | day>=1
        day=day+1;
        buy=1;
    end
    if day>3 | day<1
        day=0;
        buy=0;
    end
    balance(i)=money;
    Number(i)=holdNumber;
    accont(i)=Number(i)*Sheet2(i,4)*100;
    allmoney(i)=accont(i)+balance(i);
        
end
figure('Name','allmoney,accont,blance2');
plot(m:n,allmoney(m:n)),hold on;
plot(m:n,accont(m:n)),hold off;

%%
RSI12=calc_RSI(Sheet2(:,4),12);
RSI6=calc_RSI(Sheet2(:,4),6);
figure('Name','RSI');
plot(5513:5613,RSI12(5513:5613)),hold on;
plot(5513:5613,RSI6(5521:5621)),hold on;
%% short time strategy
ma25=MA(Sheet2(:,4),25);
ma5= MA(Sheet2(:,4),5);
top=0;
holdDay=0;
for i=m:n
    
    m1=Sheet2(i-1,4)-ma25(i-1);
    m2=Sheet2(i,4)-ma25(i);
    dm=m1*m2;
    
    if holdNumber>0
       holdDay=holdDay+1; 
    end
    if dm<0 & m2>0 & Sheet2(i,7)<Sheet2(i-1,7) & Sheet2(i-1,7)<Sheet2(i-2,7)& holdNumber==0
         holdNumber=floor(money/(Sheet2(i,4)*100));
        
         money=money-holdNumber*Sheet2(i,4)*100;
                 
         buyprice=Sheet2(i,4);
                 
         top=Sheet2(i,4);
         
         holdDay=1;
         
         
    elseif Sheet2(i,4)<0.86*buyprice & holdNumber>0  % stop loss line
         money=money+holdNumber*Sheet2(i,4)*100;
         holdNumber=0;
         buyprice=0; 
         top=0;
         holdDay=0;
         
    elseif  Sheet2(i,4)<top*0.99 & holdNumber>0 %stop profit
         money=money+holdNumber*Sheet2(i,4)*100;
         holdNumber=0;
         buyprice=0;  
         top=0;
         holdDay=0;
         
    elseif holdDay>25 & holdNumber>0
         money=money+holdNumber*Sheet2(i,4)*100;
         holdNumber=0;
         buyprice=0;  
         top=0;
         holdDay=0;
        
    end
    if holdNumber>0 & Sheet2(i,4)>Sheet2(i-1,4)
       top=Sheet2(i,4); 
    end
    

        
    
    balance(i)=money;
    Number(i)=holdNumber;
    accont(i)=Number(i)*Sheet2(i,4)*100;
    allmoney(i)=accont(i)+balance(i);
    
    
end
figure('Name','short time');
plot(m:n,allmoney(m:n)),hold on;
plot(m:n,accont(m:n)),hold off;
figure('Name','MA25');
plot(m:n,ma25(m:n)),hold on;
plot(m:n,ma5(m:n)),hold on;
plot(m:n,Sheet2(m:n,4)),hold off;



