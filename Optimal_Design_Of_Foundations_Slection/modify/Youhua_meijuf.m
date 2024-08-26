%--------------------------------------------------------------------------------------------------------------------------------------
%˼·��ö�ٷ����������������ɾѡ
clc;
clear;
%---------------------------------------------------------- ���жȲ��� -----------------------------------------------------------------
%{
ע   �ͣ��Ը�ʽ�ṹ���Ż����������ݶȶ��壬�������п��ܵĳߴ����У�����ʱ��5min���ң�
�ṹ�ɱ����7�����ײ���Ͳ���ȡ���ȡ��߶ȣ���������ֱ�������ȣ���б��������ǡ�ֱ��
ÿ�������ݶȱ仯�����ɼ���������ϣ�2��������ϣ����Խ��ɸѡ
���ɸѡ��������ѡ����
1.|����-����|>5
2.�����Ըߣ�GML>3
3.���޾���ǣ�Max_incline>10
4.�����˶���������(s):Tn_33<20
5.��ҡ�˶���������(s):Tn_55<20
��ɸѡ��Ľ������������Ӧ�Ľṹ����
%}

Con_Ptn_Length_array = 30:5:65;     %�ײ���Ͳ���Ȳ��Է�Χ
Con_Ptn_edge_D_array = 10:2:24;     %�ײ���Ͳ��Ȳ��Է�Χ
Con_Ptn_edge_H_array = 4:1:11;       %�ײ���Ͳ�߶Ȳ��Է�Χ
Con_CenCol_edgelen_array = 11:2:25;  %��������ֱ�����Է�Χ
Con_CenCol_Length_array = 16:4:44;   %�����������Ȳ��Է�Χ
Con_SideCol_incline_array = 0:5:35; %��������ǲ��Է�Χ  35:5:70;
Con_SideCol_edgelen_array = 10:2:24; %������ֱ�����Է�Χ

%Input_test_array = [1.0,2.0,3.0,4.0,5.0,6.0];  %���ֱ�����Է�Χ
%Input_test_array = [0.03,0.04,0.05,0.06];  %��ź�Ȳ��Է�Χ
%Input_test_array = [0.3,0.6,0.9,1.2,1.5,1.8,2.1];  %�����˶�������������
%Input_test_array = [0.3,0.6,0.9,1.2,1.5,1.8,2.1];  %��ҡ�˶�������������

Con_Zong_array=[Con_Ptn_Length_array',Con_Ptn_edge_D_array',Con_Ptn_edge_H_array',Con_CenCol_edgelen_array',Con_CenCol_Length_array',Con_SideCol_incline_array',Con_SideCol_edgelen_array'];
n = 7;  %%%���Ż��ߴ��������
k = 8;  %%%�������ݶ���
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
%                                                   �����������
% �����ı�Ĳ�����
Md = 7825.0;  %-- �����ܶȣ�kg/m3
Wd = 1025.0;  %-- ˮ�ܶȣ�kg/m3
g = 9.81;     %--�������ٶ�
Draft = 18.0; %��ˮ,m 

% ��ֻ�����Ĳ�����
Rotor_mass = 230000;    %Rotor mass,kg
Rotor_centroid = [-7.07,0.0,119];%����,m

Nacelle_mass = 446000;  %Nacelle mass,kg
Nacelle_centroid = [2.69,0.0,118.08];%����,m

Tower_mass = 1257000;   %Tower mass,kg
Tower_centroid = [0,0.0,49.8];%����,m


% ------------------ �������Ż��Ĳ��� ------------------
%--- PART 1: �ײ���Ͳ Potoon --- Ĭ��Ϊ����
Con_Ptn_Length = Con_Zong(1,ct_i); %��Ͳ���ȣ�m
Con_Ptn_edge_D = Con_Zong(2,ct_i);  %�����ȣ�m
Con_Ptn_edge_H = Con_Zong(3,ct_i);  %����߶ȣ�m
Con_Ptn_th = 0.03;   %--- ��ȣ�m

%--- PART 2: ��������CentreCol -------
CenCol_shape_flag = 1;  %--- ��״��ǣ�1ΪԲ����0Ϊ������
Con_CenCol_edgelen = Con_Zong(4,ct_i); %�߳���ֱ��
Con_CenCol_Length = Con_Zong(5,ct_i);  %����
Con_CenCol_th = 0.03;   %--- ���

%--- PART 3: ������SideCol -------
SideCol_shape_flag = 1;  %--- ��״��ǣ�1ΪԲ����0Ϊ������
Con_SideCol_edgelen = Con_Zong(7,ct_i); %�߳���ֱ��
Con_SideCol_incline = Con_Zong(6,ct_i); %-- ��б�Ƕȣ�deg   ============  Have been test =============
Con_SideCol_th = 0.03;   %--- ���

%--- PART 4: ��Žṹ Cross-brace ---
CrossB_shape_flag = 1;  %--- ��״��ǣ�1ΪԲ����0Ϊ������  %+++++++++++++++++
Con_CrossB_edge_D = 2.0; %����߳���Ĭ��ΪԲ��ȱ��Ľ���
Con_CrossB_th = 0.03;   %--- ���

%--- ������������ ----------
AddMass_11_ratio = 0.5;  %-�ݵ��˶�������������  0.5
AddMass_33_ratio = 1.6/1.4;  %-�����˶������������� 1.6/1.4 
Add_Inertia_55_ratio = 1.0; %-�ݵ��˶�������������   1.0

%--------------------------------------------------------------------------------------------------------------------------------------
%                                               ����Ϊ����������
%--------------------------------------------------------------------------------------------------------------------------------------
%                             ������������б���������߶ȡ�������������ѹ�����
%--------------------------------------------------------------------------------------------------------------------------------------
%------ ������� ---------
WT_mass = sum([Rotor_mass,Nacelle_mass,Tower_mass]);%--- ���������,kg
%--- ��������[x,y,z]����λ m
WT_centroid = [0,0,0];
M_temp = [Rotor_mass,Nacelle_mass,Tower_mass]; %---��������ʱ����
%--- ������ ------
WT_centroid(1) = Func_centr(M_temp,[Rotor_centroid(1),Nacelle_centroid(1),Tower_centroid(1)]);
WT_centroid(2) = Func_centr(M_temp,[Rotor_centroid(2),Nacelle_centroid(2),Tower_centroid(2)]);
WT_centroid(3) = Func_centr(M_temp,[Rotor_centroid(3),Nacelle_centroid(3),Tower_centroid(3)]);
M_temp = 0.0; %---�ͷ���ʱ����

%--------------- ��״��ߴ� ------------
%--- PART 1: �ײ���Ͳ Potoon ---
Ptn_Length = Con_Ptn_Length; %��Ͳ���ȣ�m
Ptn_edge_D = Con_Ptn_edge_D; %�����ȣ�m
Ptn_edge_H = Con_Ptn_edge_H;  %����߶ȣ�m
Ptn_th = Con_Ptn_th;   %--- ��ȣ�m
Ptn_Num = 4;      %--- �ýṹ�ĸ��� zhu:��3��Ϊ4

Ptn_area = 2.0*Ptn_Length*(Ptn_edge_D+Ptn_edge_H)+Ptn_edge_D*Ptn_edge_H;  %--- �������m^2
Ptn_Smass = Ptn_area*Ptn_th*Md;   %--- ����������kg
Ptn_Tmass = Ptn_Smass*Ptn_Num; %--- ���е�������kg************************************************
Ptn_centroid_Z = Ptn_edge_H/2.0; %---�����ǻ�����������ĸ߶�,�ֲ�����ϵ��m
Ptn_centroid_Z_AD = Ptn_centroid_Z - Draft; %--��ˮ������������ĸ߶ȣ�ȫ������ϵ��m
Ptn_buoy = Ptn_edge_D*Ptn_edge_H*Ptn_Length*Wd*Ptn_Num;   %-- ������kg
Ptn_capacity = (Ptn_edge_D-2.0*Ptn_th)*(Ptn_edge_H-2.0*Ptn_th)*Ptn_Length*Wd*Ptn_Num;  %-- ѹ��������kg

%--- PART 2: ��������CentreCol -------
CenCol_edgelen = Con_CenCol_edgelen; %�߳���ֱ��
CenCol_Length = Con_CenCol_Length;  %����
CenCol_th = Con_CenCol_th;   %--- ���

if CenCol_shape_flag == 0    % 0Ϊ������1ΪԲ��
    CenCol_area = 4.0*CenCol_edgelen*CenCol_Length + power(CenCol_edgelen,2);
    CenCol_buoy = power(CenCol_edgelen,2)*(Draft-Ptn_edge_H)*Wd;   %-- ����
    CenCol_capacity = power(CenCol_edgelen-2.0*CenCol_th,2)*(Draft-Ptn_edge_H)*Wd;  %-- ѹ��
else
    CenCol_area = pi*CenCol_edgelen*CenCol_Length + 0.25*pi*power(CenCol_edgelen,2);  %--- �����,�ܳ����Գ��ȼ��������
    CenCol_buoy = pi*power(CenCol_edgelen,2)*0.25*(Draft-Ptn_edge_H)*Wd;   %-- ����
    CenCol_capacity = pi*power(CenCol_edgelen-2.0*CenCol_th,2)*0.25*(Draft-Ptn_edge_H)*Wd;  %-- ѹ��
end
CenCol_Tmass = CenCol_area*CenCol_th*Md; %--- ���е�����************************************************
CenCol_centroid_Z = Ptn_edge_H + CenCol_Length/2.0; %--- �����ǻ������������,�ֲ�����ϵ,��Ͳ�ĸ߶Ȼ�����������ṹ�ĸ߶�
CenCol_centroid_Z_AD = CenCol_centroid_Z - Draft; %--��ˮ������������ģ�ȫ������ϵ


%--- PART 3: ������SideCol -------
SideCol_edgelen = Con_SideCol_edgelen; %�߳���ֱ��
SideCol_incline = Con_SideCol_incline; %-- ��б�Ƕȣ�deg
SideCol_Length = CenCol_Length/cos(SideCol_incline/180*pi);  %����,б���ĳ��ȷ���߳�
SideCol_th = Con_SideCol_th;   %--- ���
SideCol_Num = 4;      %--- �ýṹ�ĸ�����Ĭ��Ϊ����Ͳ������Ŀǰ���ɸ��� zhu:��3��Ϊ4

if SideCol_shape_flag == 0    % 0Ϊ������1ΪԲ��
    SideCol_area = 4.0*SideCol_edgelen*SideCol_Length + power(SideCol_edgelen,2);  %--- �����,�ܳ����Գ��ȼ��������
    SideCol_buoy = power(SideCol_edgelen,2)*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;   %-- ����
    SideCol_capacity = power(SideCol_edgelen-2.0*SideCol_th,2)*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;  %-- ѹ��    
else
    SideCol_area = pi*SideCol_edgelen*SideCol_Length + 0.25*pi*power(SideCol_edgelen,2);  %--- �����,�ܳ����Գ��ȼ��������
    SideCol_buoy = pi*power(SideCol_edgelen,2)*0.25*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;   %-- ����
    SideCol_capacity = pi*power(SideCol_edgelen-2.0*SideCol_th,2)*0.25*(Draft-Ptn_edge_H)/cos(SideCol_incline/180*pi)*Wd*SideCol_Num;  %-- ѹ��
end
SideCol_Smass = SideCol_area*SideCol_th*Md;   %--- ��������
SideCol_Tmass = SideCol_Smass*SideCol_Num; %--- ���е�����************************************************
SideCol_centroid_Z = Ptn_edge_H + SideCol_Length/2.0*cos(SideCol_incline/180*pi); %--- �����ǻ������������,�ֲ�����ϵ,��Ͳ�ĸ߶Ȼ�����������ṹ�ĸ߶�
SideCol_centroid_Z_AD = SideCol_centroid_Z - Draft; %--��ˮ������������ģ�ȫ������ϵ

%--- PART 4: ��Žṹ Cross-brace ---
CrossB_Length = Ptn_Length + SideCol_Length*sin(SideCol_incline/180*pi)-SideCol_edgelen; %��ų���
CrossB_edge_D = Con_CrossB_edge_D; %����߳���Ĭ��ΪԲ��ֱ����ȱ��Ľ��εı߳�
CrossB_th = Con_CrossB_th;   %--- ���
CrossB_Num = 4;      %--- �ýṹ�ĸ�����Ĭ��Ϊ����Ͳ������Ŀǰ���ɸ��� zhu:��3��Ϊ4

if CrossB_shape_flag == 0
    CrossB_area = 4.0*CrossB_edge_D*CrossB_Length;  %--- �����,��������������ṹ���ӣ�û�з��
else
    CrossB_area = pi*CrossB_edge_D*CrossB_Length;  %--- �����,��������������ṹ���ӣ�û�з��
end
CrossB_Smass = CrossB_area*CrossB_th*Md;   %--- ��������
CrossB_Tmass = CrossB_Smass*CrossB_Num; %--- ���е�����************************************************
CrossB_centroid_Z = Ptn_edge_H + CenCol_Length - CrossB_edge_D/2.0; %---�����ǻ������������,�ֲ�����ϵ
CrossB_centroid_Z_AD = CrossB_centroid_Z - Draft; %--��ˮ������������ģ�ȫ������ϵ

%------------------ ���� ---------------------------
%{
    �����
        WT_mass  WT_centroid
    PART 1: �ײ���Ͳ:
        Ptn_Tmass   Ptn_centroid_Z_AD
    PART 2: ��������:
        CenCol_Tmass  CenCol_centroid_Z_AD
    PART 3: ������:
        SideCol_Tmass  SideCol_centroid_Z_AD
    PART 4: ��Žṹ:  
        CrossB_Tmass  CrossB_centroid_Z_AD
%}
%------ ƽ̨ Pltfm ------
M_temp = [Ptn_Tmass,CenCol_Tmass,SideCol_Tmass,CrossB_Tmass]; %---��������ʱ����
Cor_temp = [Ptn_centroid_Z_AD,CenCol_centroid_Z_AD,SideCol_centroid_Z_AD,CrossB_centroid_Z_AD];
Pltfm_mass = sum(M_temp);
Pltfm_centroid = [0.0,0.0,0.0];
%--- ������ ------
Pltfm_centroid(3) = Func_centr(M_temp,Cor_temp);
M_temp = 0.0;
Cor_temp = 0.0;
%------ ���� FOWT ------
FOWT_mass = WT_mass + Pltfm_mass;
FOWT_centroid = [0.0,0.0,0.0]; 
FOWT_centroid(1) = Func_centr([WT_mass,Pltfm_mass],[WT_centroid(1),Pltfm_centroid(1)]);
FOWT_centroid(3) = Func_centr([WT_mass,Pltfm_mass],[WT_centroid(3),Pltfm_centroid(3)]);

%------------------ �������� ---------------------------
%{
Ҫ��ˮ����û��Ͳ�������Ǳ�������
(�ṹ�ſ�ˮ��ȫ������ϵ���ġ�װ������)
PART 1: �ײ���Ͳ��
Ptn_buoy  Ptn_centroid_Z_AD  Ptn_capacity

PART 2: ����������
CenCol_buoy  CenCol_centroid_Z_AD  CenCol_capacity

PART 3: ��������
SideCol_buoy  SideCol_centroid_Z_AD SideCol_capacity  

%}
%�ſ�ˮ����
Ptn_Dis_Z = Ptn_centroid_Z_AD;
CenCol_Dis_Z = -0.5*(Draft-Ptn_edge_H);
SideCol_Dis_Z = -0.5*(Draft-Ptn_edge_H);
%�ṹ���ſ�ˮ�����͸���
FOWT_Dis_mass = sum([Ptn_buoy,CenCol_buoy,SideCol_buoy]);
FOWT_Dis_centroid = [0.0,0.0,0.0];
FOWT_Dis_centroid(3) = Func_centr([Ptn_buoy,CenCol_buoy,SideCol_buoy],[Ptn_Dis_Z,CenCol_Dis_Z,SideCol_Dis_Z]);
FOWT_Dis_vol = FOWT_Dis_mass/Wd;

%------------------ ѹ�ؼ��� ---------------------------
%ֻ����ˮѹ��û���ǹ̶�ѹ�ػ�����ѹ����
Design_Dis_mass = FOWT_Dis_mass - FOWT_mass; %��Ҫ��ѹ������
FOWT_capacity = sum([Ptn_capacity,CenCol_capacity,SideCol_capacity]); %��ѹ������
FOWT_ballast = 0.0;
FOWT_ballast_centroid = [0.0,0.0,0.0];

if Design_Dis_mass <= Ptn_capacity  %��Ҫ��ѹ��С����ײ��ĸ�Ͳ����������ֻ��Ҫ�ײ���Ͳѹ��
    FOWT_ballast = Design_Dis_mass; %װ����
    FOWT_ballast_centroid(3) = Design_Dis_mass/Wd/(Ptn_edge_D*Ptn_Length)/2; %ȫ��ѹ�ص���Ͳ���ӵײ���
        
elseif Design_Dis_mass <= FOWT_capacity %��Ҫ��ѹ�ش�����ײ��ĸ�Ͳ������������Ҫ��������ѹ��
    Exc_ballast = Design_Dis_mass-Ptn_capacity; %��Ͳװ��֮����Ҫ�����ط�װ��
    Exc_ballast_centroid = [0.0,0.0,0.0];
    %��Ͳ�ײ���+�ϲ�ѹ�ظ߶ȵ�����(Ĭ�Ͼ���װ��)-��ˮ�������ϲ��������Ҫ���ĺ��������Ľ������
    Exc_ballast_centroid(3) = (Ptn_edge_H+(Exc_ballast/Wd/(0.25*pi*power(SideCol_edgelen,2)*SideCol_Num+0.25*pi*power(CenCol_edgelen,2)))/2.0) - Draft;
    FOWT_ballast = Design_Dis_mass; %װ����
    FOWT_ballast_centroid(3) = Func_centr([Ptn_capacity,Exc_ballast],[Ptn_centroid_Z_AD,Exc_ballast_centroid(3)]);
    
else   %ѹ����������
    pause('ѹ������������');
end

%------------------ ȫ����������ѹ�أ�������� ---------------------------
%{
ƽ̨��
Pltfm_mass  Pltfm_centroid
ѹ�أ�
FOWT_ballast FOWT_ballast_centroid
�����
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
%                           ���޾���ǡ����ԡ��������ڼ���
%--------------------------------------------------------------------------------------------------------------------------------------
%{
��������
��ˮ�ܶ� Wd�� �������ٶ� g =9.81;

PART 1: �ײ���Ͳ��
��֪��Ptn_Length
��������

PART 2: ����������
��֪��CenCol_edgelen����������ֱ����  
��������CenCol_I_area(ˮ���������Ծ�)

PART 3: ��������
��֪��SideCol_Num ��������������  SideCol_edgelen��������ֱ����
��������SideCol_Dist1���������������������ľ��룬��һ�����ͣ�   SideCol_Dist2���������������������ľ��룬�ڶ������ͣ�   
SideCol_I_area(ˮ���������Ծ�)

PART 4: ��Žṹ��
��֪��
��������

���壺FOWT
��֪��FOWT_Dis_vol���ſ�ˮ����� 
Deta_B_G������-���Ĳ = FOWT_Dis_centroid(3) - FOWTBallast_centroid(3);
FOWT_Dis_centroid(3):���ĸߣ�
FOWTBallast_centroid(3):���ĸ�;
FOWT_I_area

��������

GML(�����Ը�) GML1(�����븡�Ĳ��)   GML2���߶ȹ��ף�  

%}
%----------------------- �����Ը�GMl -----------------------
%�����븡�ĸ߹��׵� GML1
GML1 = Deta_B_G;

%ˮ���湱�׵� GML2
SideCol_Dist1 = Ptn_Length - SideCol_edgelen/2.0 + (Draft-Ptn_edge_H)*tan(SideCol_incline/180*pi); %-��������һ��λ��������
SideCol_Dist2 = SideCol_Dist1*cos(90/180*pi); %-�����������������濪  zhu:��SideCol_Dist1*cos(60/180*pi)��
SideCol_I_area1 = 0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist1,2)*2; %-ˮ����������Ե�ת��ľ����ƽ�� zhu:ԭ����0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist1,2)
SideCol_I_area2 = 0.25*pi*power(SideCol_edgelen,2)*power(SideCol_Dist2,2)*2;
CenCol_I_area = pi*power(CenCol_edgelen,4)/64;  %-λ�������ϵ�Բ��������Ծ�
FOWT_I_area = sum([SideCol_I_area1,SideCol_I_area2,CenCol_I_area]);
GML2 = FOWT_I_area/FOWT_Dis_vol; 

%�����Ը�
GML= GML1 + GML2;

%----------------------- ��ҡ�նȡ����޾���� -----------------------
 %��ҡ�ն�(N*m/rad)
C55 = Wd*g*FOWT_Dis_vol*GML;  %������
C55d = Wd*g*FOWT_Dis_vol*GML/180*pi; %�Ƕ���
%����㸲����
My_wind = 204108360; %��������챵ķ���ص����أ�����ڸ���λ��
%My_wind = Hub_Thrust*(Height_hub - FOWT_Dis_centroid(3) )     %+++++++ ���Զ�����ͬ�������� +++++++++
Max_incline = My_wind/C55d;

%----------------------- �˶��������� -----------------------
% The 1st wave natural periods is during [5-20]s; To keep away from this range
%----- �����˶� -----
Aw_zz = 0.25*pi*(power(CenCol_edgelen,2)+power(SideCol_edgelen,2)*SideCol_Num);
AddMass_33 = FOWTBallast_mass*AddMass_33_ratio;
C33 = Wd*g*Aw_zz;
Tn_33 = 2.0*pi*sqrt((FOWTBallast_mass+AddMass_33)/C33);
Wn_33 = 2.0*pi/Tn_33;
%--- cancel effect���� -----
Zm = Ptn_centroid_Z_AD;
Wc = Wn_33/(sqrt(1.0-Wn_33*Wn_33*abs(Zm/g)));
Tc = 2.0*pi/Wc;

%----- ��ҡ/��ҡ�˶� -----
PltfmBallast_Inertia = PltfmBallast_mass*power(PltfmBallast_centroid(3)-FOWTBallast_centroid(3),2);
WT_Inertia = WT_mass*power(WT_centroid(3)-FOWTBallast_centroid(3),2);
FOWTBallast_Inertia = PltfmBallast_Inertia + WT_Inertia;
Inertia_radius = sqrt(FOWTBallast_Inertia/FOWTBallast_mass);
Add_Inertia = FOWTBallast_Inertia*Add_Inertia_55_ratio;
Tn_55 = 2.0*pi*sqrt((FOWTBallast_Inertia+Add_Inertia)/C55);

%----- �ݵ�/�ᵴ�˶� -----
Tn_11 = 160.0;
AddMass_11 = FOWTBallast_mass*AddMass_11_ratio;
C11 = (AddMass_11+FOWTBallast_mass)*4.0*pi*pi/power(Tn_11,2);

%--------------------------------------------------------------------------------------------------------------------------------------
%                                             ���ĵ��������
%{
�������������ģ�
��ѹ�أ�Pltfm_mass    Pltfm_centroid
��ѹ�أ�PltfmBallast_mass   PltfmBallast_centroid

��ʽ����ſ�ˮ����������͸��ģ� FOWT_Dis_mass  FOWT_Dis_vol  FOWT_Dis_centroid
ѹ�����������ģ�FOWT_ballast    FOWT_ballast_centroid

��ʽ��������������ģ�
��ѹ�أ�FOWT_mass  FOWT_centroid
��ѹ�أ�FOWTBallast_mass   FOWTBallast_centroid

%----------��Ҫ�Ĳ���-------------
����-���ģ� Deta_B_G = GML1 
ˮ���湱�׵����ԣ�GML2
�����Ըߣ�GML
��ҡ�ն�(N.m/deg)��C55d
���޾���ǣ�Max_incline
�����˶���������(s):Tn_33
��ҡ�˶���������(s):Tn_55
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
%---ȷ���Ż�����������ɾȥ����������������
%---Out_put_SX
%------------------------------------------------------------------------------------
Out_put_Zong = [Out_put_GML1',Out_put_GML2',Out_put_GML',Out_put_C55d',Out_put_Max_incline',Out_put_Tn_33',Out_put_Tn_55',Out_put_Mass'];
Out_put_SX = [Out_put_GML1',Out_put_GML2',Out_put_GML',Out_put_C55d',Out_put_Max_incline',Out_put_Tn_33',Out_put_Tn_55',Out_put_Mass'];
Out_put_SX( abs(Out_put_SX(:,1))>5 | abs(Out_put_SX(:,5))>10 | Out_put_SX(:,3)>3 | Out_put_SX(:,6)>5 & Out_put_SX(:,6)<20 | Out_put_SX(:,7)<18,:) = [];
ZUIYOU_shu=find(ismember(Out_put_Zong, Out_put_SX,'rows')) ;   %����ɸѡ�����������ڵ�����
save('ZUIYOU_shu.txt','ZUIYOU_shu','-ASCII'); 
save('Out_put_SX.txt','Out_put_SX','-ASCII'); 
% xlswrite('Out_put_SX.xlsx',Out_put_SX);

%----�ҳ���Ӧ�ĸ���ߴ���������ɸѡ֮������ݹ���ᵼ�¼���ʱ�������
lie_shu = length(ZUIYOU_shu(:));
YOUHUA_canshu = zeros(7,lie_shu)
for  i = 1:lie_shu
YOUHUA_canshu(:,i) = Con_Zong(:,ZUIYOU_shu(i))
end
xlswrite('YOUHUA_canshu.xlsx',YOUHUA_canshu');
%----

hmb=msgbox('�������','��Ϣ�Ի���','warn');
