%--------------------------------------------------------------------------------------------------------------------------------------
%思路：枚举法，计算所有情况再删选
clc;
clear;
%---------------------------------------------------------- 敏感度测试 -----------------------------------------------------------------
%{
注   释：对浮式结构待优化参数进行梯度定义，生成所有可能的尺寸序列（计算时长5min左右）
结构可变参数7个：底部浮筒长度、宽度、高度，中心立柱直径、长度，倾斜外立柱倾角、直径
每个参数梯度变化，生成计算所有组合（2百万多个组合），对结果筛选
结果筛选条件（反选）：
1.|浮心-重心|>5
2.初稳性高：GML>3
3.极限静倾角：Max_incline>10
4.垂荡运动固有周期(s):Tn_33<20
5.纵摇运动固有周期(s):Tn_55<20
对筛选后的结果反向搜索对应的结构参数
%}

Con_Ptn_Length_array = 30:5:65;     %底部浮筒长度测试范围
Con_Ptn_edge_D_array = 10:2:24;     %底部浮筒宽度测试范围
Con_Ptn_edge_H_array = 4:1:11;       %底部浮筒高度测试范围
Con_CenCol_edgelen_array = 11:2:25;  %中心立柱直径测试范围
Con_CenCol_Length_array = 16:4:44;   %中心立柱长度测试范围
Con_SideCol_incline_array = 0:5:35; %外立柱倾角测试范围  35:5:70;
Con_SideCol_edgelen_array = 10:2:24; %外立柱直径测试范围

%Input_test_array = [1.0,2.0,3.0,4.0,5.0,6.0];  %横撑直径测试范围
%Input_test_array = [0.03,0.04,0.05,0.06];  %横撑厚度测试范围
%Input_test_array = [0.3,0.6,0.9,1.2,1.5,1.8,2.1];  %垂荡运动附加质量比率
%Input_test_array = [0.3,0.6,0.9,1.2,1.5,1.8,2.1];  %纵摇运动附加质量比率

Con_Zong_array=[Con_Ptn_Length_array',Con_Ptn_edge_D_array',Con_Ptn_edge_H_array',Con_CenCol_edgelen_array',Con_CenCol_Length_array',Con_SideCol_incline_array',Con_SideCol_edgelen_array'];
n = 7;  %%%需优化尺寸参数个数
k = 8;  %%%单参数梯度数
Con_Zong_array = Con_Zong_array'
Con_Zong = zeros(n,k^n);
for i = 1:n
     Con_Zong(i,:) = reshape(repmat(Con_Zong_array(i,:),[k^(n-i),k^(i-1)]),1,k^n); 
end

Test_len = k^n;  
Out_put_GML1 = zeros(1,Test_len);
Out_put_GML2 = zeros(1,Test_len);
Out_put_GML  = zeros(1,Test_len);
Out_put_C55d  = zeros(1,Test_len);
Out_put_Max_incline  = zeros(1,Test_len);
Out_put_Tn_33  = zeros(1,Test_len);
Out_put_Tn_55  = zeros(1,Test_len);
Out_put_Mass  = zeros(1,Test_len);

for ct_i = 1:Test_len
%     fprintf('ct_i = %d \n',ct_i);
%--------------------------------------------------------------------------------------------------------------------------------------
%                                                   输入参数设置
% 不常改变的参数：
Md = 7825.0;  %-- 材料密度，kg/m3
Wd = 1025.0;  %-- 水密度，kg/m3
g = 9.81;     %--重力加速度
Draft = 18.0; %吃水,m 

% 已只条件的参数：
Rotor_mass = 230000;    %Rotor mass,kg
Rotor_centroid = [-7.07,0.0,119];%重心,m

Nacelle_mass = 446000;  %Nacelle mass,kg
Nacelle_centroid = [2.69,0.0,118.08];%重心,m

Tower_mass = 1257000;   %Tower mass,kg
Tower_centroid = [0,0.0,49.8];%重心,m


% ------------------ 待测试优化的参数 ------------------
%--- PART 1: 底部浮筒 Potoon --- 默认为矩形
Con_Ptn_Length = Con_Zong(1,ct_i); %浮筒长度，m
Con_Ptn_edge_D = Con_Zong(2,ct_i);  %截面宽度，m
Con_Ptn_edge_H = Con_Zong(3,ct_i);  %截面高度，m
Con_Ptn_th = 0.03;   %--- 厚度，m

%--- PART 2: 中心立柱CentreCol -------
CenCol_shape_flag = 1;  %--- 形状标记，1为圆柱；0为方形柱
Con_CenCol_edgelen = Con_Zong(4,ct_i); %边长或直径
Con_CenCol_Length = Con_Zong(5,ct_i);  %长度
Con_CenCol_th = 0.03;   %--- 厚度

%--- PART 3: 外立柱SideCol -------
SideCol_shape_flag = 1;  %--- 形状标记，1为圆柱；0为方形柱
Con_SideCol_edgelen = Con_Zong(7,ct_i); %边长或直径
Con_SideCol_incline = Con_Zong(6,ct_i); %-- 倾斜角度，deg   ============  Have been test =============
Con_SideCol_th = 0.03;   %--- 厚度

%--- PART 4: 横撑结构 Cross-brace ---
CrossB_shape_flag = 1;  %--- 形状标记，1为圆柱；0为方形柱  %+++++++++++++++++
Con_CrossB_edge_D = 2.0; %截面边长，默认为圆或等边四角形
Con_CrossB_th = 0.03;   %--- 厚度

%--- 附加质量比率 ----------
AddMass_11_ratio = 0.5;  %-纵荡运动附加质量比率  0.5
AddMass_33_ratio = 1.6/1.4;  %-垂荡运动附加质量比率 1.6/1.4 
Add_Inertia_55_ratio = 1.0; %-纵荡运动附加质量比率   1.0

%--------------------------------------------------------------------------------------------------------------------------------------
%                                               以下为计算主程序
%--------------------------------------------------------------------------------------------------------------------------------------
%                             三立柱（考虑斜柱）的主尺度、重力、浮力、压载设计
%--------------------------------------------------------------------------------------------------------------------------------------
%------ 风机参数 ---------
WT_mass = sum([Rotor_mass,Nacelle_mass,Tower_mass]);%--- 风机总重量,kg
%--- 重心坐标[x,y,z]，单位 m
WT_centroid = [0,0,0];
M_temp = [Rotor_mass,Nacelle_mass,Tower_mass]; %---主程序临时变量
%--- 求重心 ------
WT_centroid(1) = Func_centr(M_temp,[Rotor_centroid(1),Nacelle_centroid(1),Tower_centroid(1)]);
WT_centroid(2) = Func_centr(M_temp,[Rotor_centroid(2),Nacelle_centroid(2),Tower_centroid(2)]);
WT_centroid(3) = Func_centr(M_temp,[Rotor_centroid(3),Nacelle_centroid(3),Tower_centroid(3)]);
M_temp = 0.0; %---释放临时变量

%--------------- 形状与尺寸 ------------
%--- PART 1: 底部浮筒 Potoon ---
Ptn_Length = Con_Ptn_Length; %浮筒长度，m
Ptn_edge_D = Con_Ptn_edge_D; %截面宽度，m
Ptn_edge_H = Con_Ptn_edge_H;  %截面高度，m
Ptn_th = Con_Ptn_th;   %--- 厚度，m
Ptn_Num = 4;      %--- 该结构的个数 zhu:由3改为4

Ptn_area = 2.0*Ptn_Length*(Ptn_edge_D+Ptn_edge_H)+Ptn_edge_D*Ptn_edge_H;  %--- 表面积，m^2
Ptn_Smass = Ptn_area*Ptn_th*Md;   %--- 单个质量，kg
Ptn_Tmass = Ptn_Smass*Ptn_Num; %--- 所有的质量，kg************************************************
Ptn_centroid_Z = Ptn_edge_H/2.0; %---从龙骨基底算起的重心高度,局部坐标系，m
Ptn_centroid_Z_AD = Ptn_centroid_Z - Draft; %--从水线面算起的重心高度，全局坐标系，m
Ptn_buoy = Ptn_edge_D*Ptn_edge_H*Ptn_Length*Wd*Ptn_Num;   %-- 浮力，kg
Ptn_capacity = (Ptn_edge_D-2.0*Ptn_th)*(Ptn_edge_H-2.0*Ptn_th)*Ptn_Length*Wd*Ptn_Num;  %-- 压载容量，kg

%--- PART 2: 中心立柱CentreCol -------
CenCol_edgelen = Con_CenCol_edgelen; %边长或直径
CenCol_Length = Con_CenCol_Length;  %长度
CenCol_th = Con_CenCol_th;   %--- 厚度

if CenCol_shape_flag == 0    % 0为方柱，1为圆柱
    CenCol_area = 4.0*CenCol_edgelen*CenCol_Length + power(CenCol_edgelen,2);
    CenCol_buoy = power(CenCol_edgelen,2)*(Draft-Ptn_edge_H)*Wd;   %-- 浮力
    CenCol_capacity = power(CenCol_edgelen-2.0*CenCol_th,2)*(Draft-Ptn_edge_H)*Wd;  %-- 压载
else
    CenCol_area = pi*CenCol_edgelen*CenCol_Length + 0.25*pi*power(CenCol_edgelen,2);  %--- 表面积,周长乘以长度加上艉封板
    CenCol_buoy = pi*power(CenCol_edgelen,2)*0.25*(Draft-Ptn_edge_H)*Wd;   %-- 浮力
    CenCol_capacity = pi*power(CenCol_edgelen-2.0*CenCol_th,2)*0.25*(Draft-Ptn_edge_H)*Wd;  %-- 压载
end
CenCol_Tmass = CenCol_area*CenCol_th*Md; %--- 所有的质量************************************************
CenCol_centroid_Z = Ptn_edge_H + CenCol_Length/2.0; %--- 从龙骨基底算起的重心,局部坐标系,浮筒的高度基础上算上面结构的高度
CenCol_centroid_Z_AD = CenCol_centroid_Z - Draft; %--从水线面算起的重心，全局坐标系


%--- PART 3: 外立柱SideCol -------
SideCol_edgelen = Con_SideCol_edgelen; %边长或直径
SideCol_incline = Con_SideCol_incline; %-- 倾斜角度，deg
SideCol_Length = CenCol_Length/cos(SideCol_incline/180*pi);  %长度,斜柱的长度方向边长
SideCol_th = Con_SideCol_th;   %--- 厚度
SideCol_Num = 4;      %--- 该结构的个数，默认为三浮筒立柱，目前不可更改 zhu:由3改为4

if SideCol_shape_flag == 0    % 0为方柱，1为圆柱
    SideCol_area = 4.0*SideCol_edgelen*SideCol_Length + power(SideCol_edgelen,2);  %--- 表面积,周长乘以长度加上艉封板
    SideCol_buoy = power(SideCol_edgelen,2)*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;   %-- 浮力
    SideCol_capacity = power(SideCol_edgelen-2.0*SideCol_th,2)*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;  %-- 压载    
else
    SideCol_area = pi*SideCol_edgelen*SideCol_Length + 0.25*pi*power(SideCol_edgelen,2);  %--- 表面积,周长乘以长度加上艉封板
    SideCol_buoy = pi*power(SideCol_edgelen,2)*0.25*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;   %-- 浮力
    SideCol_capacity = pi*power(SideCol_edgelen-2.0*SideCol_th,2)*0.25*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;  %-- 压载
end
SideCol_Smass = SideCol_area*SideCol_th*Md;   %--- 单个质量
SideCol_Tmass = SideCol_Smass*SideCol_Num; %--- 所有的质量************************************************
SideCol_centroid_Z = Ptn_edge_H + SideCol_Length/2.0*cos(SideCol_incline/180*pi); %--- 从龙骨基底算起的重心,局部坐标系,浮筒的高度基础上算上面结构的高度
SideCol_centroid_Z_AD = SideCol_centroid_Z - Draft; %--从水线面算起的重心，全局坐标系

%--- PART 4: 横撑结构 Cross-brace ---
CrossB_Length = Ptn_Length + SideCol_Length*sin(SideCol_incline/180*pi)-SideCol_edgelen; %横撑长度
CrossB_edge_D = Con_CrossB_edge_D; %截面边长，默认为圆的直径或等边四角形的边长
CrossB_th = Con_CrossB_th;   %--- 厚度
CrossB_Num = 4;      %--- 该结构的个数，默认为三浮筒立柱，目前不可更改 zhu:由3改为4

if CrossB_shape_flag == 0
    CrossB_area = 4.0*CrossB_edge_D*CrossB_Length;  %--- 表面积,横撑两端与其他结构连接，没有封板
else
    CrossB_area = pi*CrossB_edge_D*CrossB_Length;  %--- 表面积,横撑两端与其他结构连接，没有封板
end
CrossB_Smass = CrossB_area*CrossB_th*Md;   %--- 单个质量
CrossB_Tmass = CrossB_Smass*CrossB_Num; %--- 所有的质量************************************************
CrossB_centroid_Z = Ptn_edge_H + CenCol_Length - CrossB_edge_D/2.0; %---从龙骨基底算起的重心,局部坐标系
CrossB_centroid_Z_AD = CrossB_centroid_Z - Draft; %--从水线面算起的重心，全局坐标系

%------------------ 质量 ---------------------------
%{
    风机：
        WT_mass  WT_centroid
    PART 1: 底部浮筒:
        Ptn_Tmass   Ptn_centroid_Z_AD
    PART 2: 中心立柱:
        CenCol_Tmass  CenCol_centroid_Z_AD
    PART 3: 外立柱:
        SideCol_Tmass  SideCol_centroid_Z_AD
    PART 4: 横撑结构:  
        CrossB_Tmass  CrossB_centroid_Z_AD
%}
%------ 平台 Pltfm ------
M_temp = [Ptn_Tmass,CenCol_Tmass,SideCol_Tmass,CrossB_Tmass]; %---主程序临时变量
Cor_temp = [Ptn_centroid_Z_AD,CenCol_centroid_Z_AD,SideCol_centroid_Z_AD,CrossB_centroid_Z_AD];
Pltfm_mass = sum(M_temp);
Pltfm_centroid = [0.0,0.0,0.0];
%--- 求重心 ------
Pltfm_centroid(3) = Func_centr(M_temp,Cor_temp);
M_temp = 0.0;
Cor_temp = 0.0;
%------ 整体 FOWT ------
FOWT_mass = WT_mass + Pltfm_mass;
FOWT_centroid = [0.0,0.0,0.0]; 
FOWT_centroid(1) = Func_centr([WT_mass,Pltfm_mass],[WT_centroid(1),Pltfm_centroid(1)]);
FOWT_centroid(3) = Func_centr([WT_mass,Pltfm_mass],[WT_centroid(3),Pltfm_centroid(3)]);

%------------------ 浮力计算 ---------------------------
%{
要求水线淹没浮筒，不考虑变截面情况
(结构排开水、全局坐标系重心、装载能力)
PART 1: 底部浮筒：
Ptn_buoy  Ptn_centroid_Z_AD  Ptn_capacity

PART 2: 中心立柱：
CenCol_buoy  CenCol_centroid_Z_AD  CenCol_capacity

PART 3: 外立柱：
SideCol_buoy  SideCol_centroid_Z_AD SideCol_capacity  

%}
%排开水重心
Ptn_Dis_Z = Ptn_centroid_Z_AD;
CenCol_Dis_Z = -0.5*(Draft-Ptn_edge_H);
SideCol_Dis_Z = -0.5*(Draft-Ptn_edge_H);
%结构总排开水质量和浮心
FOWT_Dis_mass = sum([Ptn_buoy,CenCol_buoy,SideCol_buoy]);
FOWT_Dis_centroid = [0.0,0.0,0.0];
FOWT_Dis_centroid(3) = Func_centr([Ptn_buoy,CenCol_buoy,SideCol_buoy],[Ptn_Dis_Z,CenCol_Dis_Z,SideCol_Dis_Z]);
FOWT_Dis_vol = FOWT_Dis_mass/Wd;

%------------------ 压载计算 ---------------------------
%只考虑水压，没考虑固定压载或其他压载物
Design_Dis_mass = FOWT_Dis_mass - FOWT_mass; %需要的压载质量
FOWT_capacity = sum([Ptn_capacity,CenCol_capacity,SideCol_capacity]); %总压载容量
FOWT_ballast = 0.0;
FOWT_ballast_centroid = [0.0,0.0,0.0];

if Design_Dis_mass <= Ptn_capacity  %需要的压载小于最底部的浮筒的容量，则只需要底部浮筒压载
    FOWT_ballast = Design_Dis_mass; %装得下
    FOWT_ballast_centroid(3) = Design_Dis_mass/Wd/(Ptn_edge_D*Ptn_Length)/2; %全部压载到浮筒，从底部算
        
elseif Design_Dis_mass <= FOWT_capacity %需要的压载大于最底部的浮筒的容量，则需要立柱参与压载
    Exc_ballast = Design_Dis_mass-Ptn_capacity; %浮筒装完之后，需要其他地方装载
    Exc_ballast_centroid = [0.0,0.0,0.0];
    %浮筒底部高+上部压载高度的中心(默认均匀装载)-吃水；其中上部横截面需要中心和外立柱的截面面积
    Exc_ballast_centroid(3) = (Ptn_edge_H+(Exc_ballast/Wd/(0.25*pi*power(SideCol_edgelen,2)*SideCol_Num+0.25*pi*power(CenCol_edgelen,2)))/2.0) - Draft;
    FOWT_ballast = Design_Dis_mass; %装得下
    FOWT_ballast_centroid(3) = Func_centr([Ptn_capacity,Exc_ballast],[Ptn_centroid_Z_AD,Exc_ballast_centroid(3)]);
    
else   %压载能力不够
    pause('压载能力不够！');
end

%------------------ 全局质量（含压载）重算计算 ---------------------------
%{
平台：
Pltfm_mass  Pltfm_centroid
压载：
FOWT_ballast FOWT_ballast_centroid
风机：
WT_mass  WT_centroid
%}
PltfmBallast_mass = Pltfm_mass + FOWT_ballast;
PltfmBallast_centroid = [0.0,0.0,0.0];
PltfmBallast_centroid(3) = Func_centr([Pltfm_mass,FOWT_ballast],[Pltfm_centroid(3),FOWT_ballast_centroid(3)]);

FOWTBallast_mass = PltfmBallast_mass + WT_mass;
FOWTBallast_centroid = [0.0,0.0,0.0];
FOWTBallast_centroid(1) = Func_centr([PltfmBallast_mass,WT_mass],[PltfmBallast_centroid(1),WT_centroid(1)]);
FOWTBallast_centroid(2) = Func_centr([PltfmBallast_mass,WT_mass],[PltfmBallast_centroid(2),WT_centroid(2)]);
FOWTBallast_centroid(3) = Func_centr([PltfmBallast_mass,WT_mass],[PltfmBallast_centroid(3),WT_centroid(3)]);
Deta_B_G = FOWT_Dis_centroid(3) - FOWTBallast_centroid(3);

%--------------------------------------------------------------------------------------------------------------------------------------
%                           极限静倾角、稳性、固有周期计算
%--------------------------------------------------------------------------------------------------------------------------------------
%{
交接数据
海水密度 Wd； 重力加速度 g =9.81;

PART 1: 底部浮筒：
已知：Ptn_Length
本节需求：

PART 2: 中心立柱：
已知：CenCol_edgelen（中心立柱直径）  
本节需求：CenCol_I_area(水线面截面惯性矩)

PART 3: 外立柱：
已知：SideCol_Num （外立柱数量）  SideCol_edgelen（外立柱直径）
本节需求：SideCol_Dist1（外立柱距离中心立柱的距离，第一种类型）   SideCol_Dist2（外立柱距离中心立柱的距离，第二种类型）   
SideCol_I_area(水线面截面惯性矩)

PART 4: 横撑结构：
已知：
本节需求：

总体：FOWT
已知：FOWT_Dis_vol（排开水体积） 
Deta_B_G（浮心-重心差） = FOWT_Dis_centroid(3) - FOWTBallast_centroid(3);
FOWT_Dis_centroid(3):浮心高；
FOWTBallast_centroid(3):重心高;
FOWT_I_area

本节需求：

GML(初稳性高) GML1(重心与浮心差贡献)   GML2（高度贡献）  

%}
%----------------------- 初稳性高GMl -----------------------
%重心与浮心高贡献的 GML1
GML1 = Deta_B_G;

%水线面贡献的 GML2
SideCol_Dist1 = Ptn_Length - SideCol_edgelen/2.0 + (Draft-Ptn_edge_H)*tan(SideCol_incline/180*pi); %-三立柱，一个位于轴线上
SideCol_Dist2 = SideCol_Dist1*cos(90/180*pi); %-三立柱，另外两个叉开  zhu:由SideCol_Dist1*cos(60/180*pi)改
SideCol_I_area1 = 0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist1,2)*2; %-水线面面积乘以到转轴的距离的平方 zhu:原来：0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist1,2)
SideCol_I_area2 = 0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist2,2)*2;
CenCol_I_area = pi*power(CenCol_edgelen,4)/64;  %-位于轴线上的圆的面积惯性矩
FOWT_I_area = sum([SideCol_I_area1,SideCol_I_area2,CenCol_I_area]);
GML2 = FOWT_I_area/FOWT_Dis_vol; 

%初稳性高
GML= GML1 + GML2;

%----------------------- 纵摇刚度、极限静倾角 -----------------------
 %纵摇刚度(N*m/rad)
C55 = Wd*g*FOWT_Dis_vol*GML;  %弧度制
C55d = Wd*g*FOWT_Dis_vol*GML/180*pi; %角度制
%最大倾覆力矩
My_wind = 204108360; %作用在轮毂的风荷载的力矩，相对于浮心位置
%My_wind = Hub_Thrust*(Height_hub - FOWT_Dis_centroid(3) )     %+++++++ 可以定量不同风倾力矩 +++++++++
Max_incline = My_wind/C55d;

%----------------------- 运动固有周期 -----------------------
% The 1st wave natural periods is during [5-20]s; To keep away from this range
%----- 垂向运动 -----
Aw_zz = 0.25*pi*(power(CenCol_edgelen,2)+power(SideCol_edgelen,2)*SideCol_Num);
AddMass_33 = FOWTBallast_mass*AddMass_33_ratio;
C33 = Wd*g*Aw_zz;
Tn_33 = 2.0*pi*sqrt((FOWTBallast_mass+AddMass_33)/C33);
Wn_33 = 2.0*pi/Tn_33;
%--- cancel effect周期 -----
Zm = Ptn_centroid_Z_AD;
Wc = Wn_33/(sqrt(1.0-Wn_33*Wn_33*abs(Zm/g)));
Tc = 2.0*pi/Wc;

%----- 纵摇/横摇运动 -----
PltfmBallast_Inertia = PltfmBallast_mass*power(PltfmBallast_centroid(3)-FOWTBallast_centroid(3),2);
WT_Inertia = WT_mass*power(WT_centroid(3)-FOWTBallast_centroid(3),2);
FOWTBallast_Inertia = PltfmBallast_Inertia + WT_Inertia;
Inertia_radius = sqrt(FOWTBallast_Inertia/FOWTBallast_mass);
Add_Inertia = FOWTBallast_Inertia*Add_Inertia_55_ratio;
Tn_55 = 2.0*pi*sqrt((FOWTBallast_Inertia+Add_Inertia)/C55);

%----- 纵荡/横荡运动 -----
Tn_11 = 160.0;
AddMass_11 = FOWTBallast_mass*AddMass_11_ratio;
C11 = (AddMass_11+FOWTBallast_mass)*4.0*pi*pi/power(Tn_11,2);

%--------------------------------------------------------------------------------------------------------------------------------------
%                                             关心的输出变量
%{
浮体质量与质心：
无压载：Pltfm_mass    Pltfm_centroid
含压载：PltfmBallast_mass   PltfmBallast_centroid

浮式风机排开水质量、体积和浮心： FOWT_Dis_mass  FOWT_Dis_vol  FOWT_Dis_centroid
压载质量与质心：FOWT_ballast    FOWT_ballast_centroid

浮式风机的质量与质心：
无压载：FOWT_mass  FOWT_centroid
含压载：FOWTBallast_mass   FOWTBallast_centroid

%----------重要的参数-------------
浮心-重心： Deta_B_G = GML1 
水线面贡献的稳性：GML2
初稳性高：GML
纵摇刚度(N.m/deg)：C55d
极限静倾角：Max_incline
垂荡运动固有周期(s):Tn_33
纵摇运动固有周期(s):Tn_55
%}
%------------------------------------------------------------------------------------
Out_put_GML1(ct_i) = GML1;
Out_put_GML2(ct_i) = GML2;
Out_put_GML(ct_i)  = GML;
Out_put_C55d(ct_i)  = C55d;
Out_put_Max_incline(ct_i)  = Max_incline;
Out_put_Tn_33(ct_i)  = Tn_33;
Out_put_Tn_55(ct_i)  = Tn_55;
Out_put_Mass(ct_i) = Pltfm_mass/1000;

ct_i = ct_i + 1;

end


%------------------------------------------------------------------------------------
%---确定优化限制条件，删去不符合条件的数据
%---Out_put_SX
%------------------------------------------------------------------------------------
Out_put_Zong = [Out_put_GML1',Out_put_GML2',Out_put_GML',Out_put_C55d',Out_put_Max_incline',Out_put_Tn_33',Out_put_Tn_55',Out_put_Mass'];
Out_put_SX = [Out_put_GML1',Out_put_GML2',Out_put_GML',Out_put_C55d',Out_put_Max_incline',Out_put_Tn_33',Out_put_Tn_55',Out_put_Mass'];
Out_put_SX( abs(Out_put_SX(:,1))>5 | abs(Out_put_SX(:,5))>10 | Out_put_SX(:,3)>3 | Out_put_SX(:,6)>5 & Out_put_SX(:,6)<20 | Out_put_SX(:,7)<18,:) = [];
ZUIYOU_shu=find(ismember(Out_put_Zong, Out_put_SX,'rows')) ;   %搜索筛选出的数据所在的行数
save('ZUIYOU_shu.txt','ZUIYOU_shu','-ASCII'); 
save('Out_put_SX.txt','Out_put_SX','-ASCII'); 
% xlswrite('Out_put_SX.xlsx',Out_put_SX);

%----找出对应的浮体尺寸参数（如果筛选之后的数据过多会导致计算时间过长）
lie_shu = length(ZUIYOU_shu(:));
YOUHUA_canshu = zeros(7,lie_shu)
for  i = 1:lie_shu
YOUHUA_canshu(:,i) = Con_Zong(:,ZUIYOU_shu(i))
end
xlswrite('YOUHUA_canshu.xlsx',YOUHUA_canshu');
%----

hmb=msgbox('运算完毕','消息对话框','warn');
