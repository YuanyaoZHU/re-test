%Main Program
%code by Zhu-YY
%code date:2021/06/01
%code modified date:2023/12/7
%information: this mooring calculation file is copied from
%"E:\TiM_Programing\matlab tools\mooring". The program is used to calculate
% the variation of mooring fairlead tension with surge motion.
%
%----------------
clc;
clear;
g=9.81;
m = 177;
w = m*g*0.86955;%698.094;
L = 902.2;
E = 384243000;
D = 0.09;
A = 1;%pi*D^2/4;
d2r = pi/180;
r = 5.2;
Cb=0.0001;
ep=1E-6;
LineNum = 3;
SPAN = 853.87-5.2;

SpanAngle = [0*d2r,120*d2r, 240*d2r];
anchorCoord = zeros(3,2);
for i = 1:3
    anchorCoord(i,:) = [SPAN*cos(SpanAngle(i)), SPAN*sin(SpanAngle(i))];
end

LocationX = -40:1:40;
LocationY = zeros(length(LocationX),1);
Location = [LocationX' LocationY];


MooringForce = zeros(length(LocationX),3);
LineTensionH = zeros(length(LocationX),LineNum);
LineTensionV = zeros(length(LocationX),LineNum);
LineTension = zeros(length(LocationX),LineNum);
%%
for k = 1:length(LocationX)
    for i = 1:LineNum
        [x,z,relativeCoord] = LocalCoord(anchorCoord(i,:),Location(k,:),r,SpanAngle(i));
        [Hf,Vf] = CalcMooringForce(w,L,E,A,Cb,x,z,ep);
        tension(1) = Hf*relativeCoord(1)/x;
        tension(2) = Hf*relativeCoord(2)/x;
        LineTensionH(k,i) = Hf;
        LineTensionV(k,i) = Vf;
        LineTension(k,i) = sqrt(Hf^2+Vf^2);
        MooringForce(k,1) = tension(1) + MooringForce(k,1);
        MooringForce(k,2) = tension(2) + MooringForce(k,2);
        MooringForce(k,3) = Vf + MooringForce(k,3);
    end
    
end
f1 = figure;
f2 = figure;

figure(f1);
plot(LocationX,-MooringForce(:,1)/1000,"LineWidth",2.5,"Color","r");
hold on;
plot(LocationX,-MooringForce(:,3)/1000,"LineWidth",3.5,"Color","g");
hold off;
grid;

figure(f2);
set(gcf,'unit','normalized','position',[0.2,0.1,0.5,0.64]);
plot(LocationX,LineTension(:,1)/1000,"LineWidth",2.5,"Color","r");
hold on;
plot(LocationX,LineTension(:,2)/1000,"LineWidth",3.5,"Color","g");
plot(LocationX,LineTension(:,3)/1000,"LineWidth",1.5,"Color","m","LineStyle","--");
plot([-40,40],[8.167e+3,8.167e+3],"Color","k","LineStyle","--","LineWidth",3.0);
plot([-40,40],[6.439e+3,6.439e+3],"Color","b","LineStyle","--","LineWidth",3.0);
hold off;
xlabel("平台纵荡 [m]","FontSize",15);
ylabel("导缆拉力 [kN]","FontSize",15);
legend("1号锚链","2号锚链","3号锚链","破断张力","弹性极限张力","FontSize",15);
set(gca,"FontSize",15);
grid;
exportgraphics(gcf,"系泊张力随位移变化图.jpg","Resolution",600);
%x = (853.87-5.2);
%z = (320-70);





