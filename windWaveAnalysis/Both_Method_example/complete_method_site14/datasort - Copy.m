%%
clc;
clear all;
close all;
%% import data, keep only Hs, Tp and wind speed U
%NB: 2004 & 2008 have 366 days, so they have 24 rows' more data
Data_Dir = 'D:\research\MARINA\WP2envdata\DataFromNKUA\RawWindWaveData\Site14Wave\Wave';
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
Tp = data(:,2); %peak period
