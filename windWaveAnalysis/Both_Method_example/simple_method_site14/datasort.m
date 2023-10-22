%%
clc;
clear all;
close all;
%% import data, keep only Hs, Tp and wind speed U
%NB: 2004 & 2008 have 366 days, so they have 24 rows' more data
Data_Dir = 'E:\TiM_Programing\Both_Method_example\Site14Wave\Wave';
for i=1:1:10;
    if i<10;
        filename = ['200' num2str(i) '.txt'];
    else
        filename = ['20' num2str(i) '.txt'];
    end
    temp=importdata(fullfile(Data_Dir,filename)); % whole matrix
    temp1=temp.data(:,[1,3,8]); % keep only Hs, wp and U
    temp1(:,2)=1./temp1(:,2); % convert wp to Tp
    eval(['w' num2str(i) '= temp1;']); % Hs, Tp and U
end
data=[w1;w2;w3;w4;w5;w6;w7;w8;w9;w10]; % merge 10 years data into one matrix
[m,n] = size(data);
Hs = data(:,1); %significant wave height
Tp = data(:,2); %peak frequency
% U = data(:,3); %mean wind speed


Data_Dir2 = 'E:\TiM_Programing\Both_Method_example\Site14Wind\Wind';
for i=1:1:10;
    if i<10;
        filename2 = ['200' num2str(i) '.txt'];
    else
        filename2 = ['20' num2str(i) '.txt'];
    end
    temp_wind=importdata(fullfile(Data_Dir2,filename2)); % whole matrix
    temp1_wind=(temp_wind.data(:,1).^2+temp_wind.data(:,2).^2).^0.5; % keep only Hs, wp and U
    eval(['wind' num2str(i) '= temp1_wind;']); % Hs, Tp and U
end
wind=[wind1;wind2;wind3;wind4;wind5;wind6;wind7;wind8;wind9;wind10]; % merge 10 years data into one matrix
U = wind;


data = [U Hs Tp]; % data: U, Hs, Tp
%% Sort data based on wind speed U-Hs-Tp
data_U.data = sortrows(data,1);

delta_U1 = 1; %1 %2 wind speed bin size of 1m/send
Umin = round(min(U));
Umax = max(U)+0.1;
U_shift1 = 19;%19 %13
delta_U2 = 2;%2 %3
U_shift2 = 23;%23 %19
U_x1 = (Umin:delta_U1:U_shift1-delta_U1)'; % wind speed classes
U_xx1 = (Umin+delta_U1/2:delta_U1:U_shift1-delta_U1/2)';
U_x2 = (U_shift1:delta_U2:U_shift2)';
U_xx2 = (U_x2(1)+delta_U2/2:delta_U2:U_x2(end)-delta_U2/2)';
U_x = [U_x1;U_x2;Umax];
U_xx = [U_xx1;U_xx2;0.5*(U_shift2+Umax)];
n_U = length(U_xx);
delta_U = zeros(n_U,1);
for i=1:1:n_U
    delta_U(i) = U_x(i+1)-U_x(i);
end
count_U = zeros(n_U,1); % occurrences for each wind class
cumulative_U = zeros(n_U,1);

Hsmin = 0;
Hsmax = max(Hs)+0.1;
delta_Hs1 = 0.5; %0.5 %1 Hs bin size of 0.5m
Hs_shift1 = 7.5;% %7.5 %7when Hs<9, delta Hs=0.5
Hs_x1 = (Hsmin:delta_Hs1:Hs_shift1-delta_Hs1)'; % Hs classes
Hs_xx1 = (Hsmin+delta_Hs1/2:delta_Hs1:Hs_shift1-delta_Hs1/2)';
delta_Hs2 = 1.0; %1 %1.5 Hs bin size of 1.0m
Hs_shift2 = 9.5; %9.5 %8.5 when 9<Hs<11, delta Hs=1.0
Hs_x2 = (Hs_shift1:delta_Hs2:Hs_shift2)';
Hs_xx2 = (Hs_x2(1)+delta_Hs2/2:delta_Hs2:Hs_shift2-delta_Hs2/2)';
Hs_x = [Hs_x1;Hs_x2;Hsmax];
Hs_xx = [Hs_xx1;Hs_xx2;0.5*(Hs_x2(end)+Hsmax)];

% Hs_max2=13.5;
% Hs_x = (Hsmin:0.5:Hs_max2)';
% Hs_xx = (Hsmin+0.25:0.5:Hs_max2-0.25)';

n_Hs = length(Hs_xx); % number of Hs classes
delta_Hs = zeros(n_Hs,1);
for i=1:1:n_Hs
    delta_Hs(i) = Hs_x(i+1)-Hs_x(i);
end

Tp_min = 3;
Tp_max = 17;
delta_Tp = 1;
Tp_x = (Tp_min:delta_Tp:Tp_max)';
Tp_xx = (Tp_min+delta_Tp/2:delta_Tp:Tp_max-delta_Tp/2)'; % Tp vector
n_Tp = length(Tp_xx); % number of Tp classes

for i=1:1:n_U
    m_U = length(data_U.data(:,1));
    count_U(i)=sum(U>=U_x(i)&U<U_x(i+1));%count the occurrences for each wind class
    cumulative_U(i)= sum(count_U(1:i));%cumulative occurences for each wind class
    cdf_U_m(i)=cumulative_U(i)/m_U;
    pdf_U_m(i) = count_U(i)/m_U/delta_U(i);
    temp1 = sortrows(data_U.data(cumulative_U(i)-count_U(i)+1:cumulative_U(i),:),2);
    eval(['data_U.U' num2str(i) '.data = temp1;']);
    eval(['m_Hs_U = length(data_U.U' num2str(i) '.data(:,2));']);
    for k=1:1:n_Hs
        eval(['count_Hs_U(i,k)=sum(data_U.U' num2str(i) '.data(:,2)>=Hs_x(k)&data_U.U' num2str(i) '.data(:,2)<Hs_x(k+1));']);
        cumulative_Hs_U(i,k)= sum(count_Hs_U(i,1:k));%cumulative occurences for each Hs class
        cdf_Hs_U_m(i,k) = cumulative_Hs_U(i,k)/m_Hs_U;%cumulative frequency for each Hs class
        pdf_Hs_U_m(i,k) = count_Hs_U(i,k)/m_Hs_U/delta_Hs(k); %Measured pdf of Hs for each U class
        eval(['temp1 = sortrows(data_U.U' num2str(i) '.data(cumulative_Hs_U(i,k)-count_Hs_U(i,k)+1:cumulative_Hs_U(i,k),:),3);']);
        eval(['data_U.U' num2str(i) '.Hs' num2str(k) '.data = temp1;']);
        eval(['m_Tp_Hs_U = length(data_U.U' num2str(i) '.Hs' num2str(k) '.data(:,3));']);
        for s=1:1:n_Tp
            eval(['data_U.U' num2str(i) '.count_Tp_Hs_U(k,s) = sum(data_U.U' num2str(i) '.Hs' num2str(k) '.data(:,3)>=Tp_x(s)&data_U.U' num2str(i) '.Hs' num2str(k) '.data(:,3)<Tp_x(s+1));']);
            eval(['data_U.U' num2str(i) '.cumulative_Tp_Hs_U (k,s) = sum(data_U.U' num2str(i) '.count_Tp_Hs_U(k,1:s));']);%cumulative occurences for each Hs class
            eval(['data_U.U' num2str(i) '.cdf_Tp_Hs_U_m(k,s) = data_U.U' num2str(i) '.cumulative_Tp_Hs_U(k,s)/m_Tp_Hs_U;']);%cumulative frequency for each Hs class
            eval(['data_U.U' num2str(i) '.pdf_Tp_Hs_U_m(k,s) = data_U.U' num2str(i) '.count_Tp_Hs_U(k,s)/m_Tp_Hs_U/delta_Hs(k);']); %Measured pdf of Hs for each U class
            eval(['temp1 = data_U.U' num2str(i) '.Hs' num2str(k) '.data(data_U.U' num2str(i) '.cumulative_Tp_Hs_U(k,s)-data_U.U' num2str(i) '.count_Tp_Hs_U(k,s)+1:data_U.U' num2str(i) '.cumulative_Tp_Hs_U(k,s),:);']);
            eval(['data_U.U' num2str(i) '.Hs' num2str(k) '.Tp' num2str(s) ' = temp1;']);
        end
    end
end

%% Sort Tp based on Hs, Hs-Tp
data_Hs.data = sortrows(data,2);
for i=1:1:n_Hs
    m_Hs = length(data_Hs.data(:,2));
    count_Hs(i)=sum(Hs>=Hs_x(i)&Hs<Hs_x(i+1));%count the occurrences for each wind class
    cumulative_Hs(i)= sum(count_Hs(1:i));%cumulative occurences for each wind class
    temp1 = sortrows(data_Hs.data(cumulative_Hs(i)-count_Hs(i)+1:cumulative_Hs(i),:),2);
    cdf_Hs_m(i)=cumulative_Hs(i)/m_Hs;
    pdf_Hs_m(i) = count_Hs(i)/m_Hs/delta_Hs(i);
    
    eval(['data_Hs.Hs' num2str(i) '.data = temp1;']);
    eval(['m_Tp_Hs = length(data_Hs.Hs' num2str(i) '.data(:,3));']);
    for k=1:1:n_Tp
        eval(['count_Tp_Hs(i,k)=sum(data_Hs.Hs' num2str(i) '.data(:,3)>=Tp_x(k)&data_Hs.Hs' num2str(i) '.data(:,3)<Tp_x(k+1));']);
        cumulative_Tp_Hs(i,k)= sum(count_Tp_Hs(i,1:k));%cumulative occurences for each Hs class
        cdf_Tp_Hs_m(i,k) = cumulative_Tp_Hs(i,k)/m_Tp_Hs;%cumulative frequency for each Hs class
        pdf_Tp_Hs_m(i,k) = count_Tp_Hs(i,k)/m_Tp_Hs/delta_Tp; %Measured pdf of Hs for each U class
        eval(['temp1 = sortrows(data_Hs.Hs' num2str(i) '.data(cumulative_Tp_Hs(i,k)-count_Tp_Hs(i,k)+1:cumulative_Tp_Hs(i,k),:),3);']);
        eval(['data_Hs.Hs' num2str(i) '.Tp' num2str(k) ' = temp1;']);
    end
    for m=1:1:n_U
        eval(['count_U_Hs(i,m)=sum(data_Hs.Hs' num2str(i) '.data(:,1)>=U_x(m)&data_Hs.Hs' num2str(i) '.data(:,1)<U_x(m+1));']);
        cumulative_U_Hs(i,m)= sum(count_U_Hs(i,1:m));%cumulative occurences for each Hs class
        eval(['temp = sortrows(data_Hs.Hs' num2str(i) '.data,1);']);
        temp1 = temp((cumulative_U_Hs(i,m)-count_U_Hs(i,m)+1:cumulative_U_Hs(i,m)),:);
        eval(['data_Hs.Hs' num2str(i) '.U' num2str(m) ' = temp1;']);
    end
end