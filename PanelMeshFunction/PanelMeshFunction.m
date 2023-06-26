clc;
clear;
Elements = load('Element.txt');
Nodes = load('Node.txt');
Reduces = readmatrix('Reduce.txt');%在水流下游的网衣单元


Elements = sortrows(Elements,1); 

Number_Node = size(Nodes,1);
Number_Element = size(Elements,1);

Panels1 = zeros(Number_Node,20);

No_effective_element=0; %无效单元的数量

%------------------------------------------------------------%
%------------------------------------------------------------%
% Panels1的构成
% Panels1[1] ------------ Panel Number
% Panels1[2-5]----------- Panel包含的Node的编号
% Panels1[6-9]----------- Panel包含的Element的编号
% Panels1[10-13]--------- Panel的Node编号的重新排序
% Panels1[14-16]--------- Panel的方向向量
% Panels1[17-19]--------- Panel的中心点坐标
% Panels1[20]------------ 判断Panel单元是否在水流下游

% Nodes的构成
% Nodes[1] -------------- Nodes编号
% Nodes[2-4]------------- 节点坐标
% Nodes[5-8]------------- 与该节点相连的单元（0代表无单元）

% Elements的构成
% Elements[1] ----------- Elements的编号
% Elements[2-3]---------- 组成该单元的两个节点编号
% Elements[4-5]---------- 包含该单元的Panel单元编号
%------------------------------------------------------------%
%------------------------------------------------------------%

P1=zeros(4,1);%用于找到与节点相连的单元
P2=zeros(6,2);%用于对找到的单元进行分组
P3=zeros(2,1);%用于对承载单元中两个节点的号码
P4=zeros(2,1);%用于临时存放找到在分组中两个单元的另一个节点

P0=0;


for i=1:Number_Node
    k=0;
    for j = 1:Number_Element
       if(Elements(j,2)==Nodes(i,1) || Elements(j,3)==Nodes(i,1))
           k=k+1;
           P1(k)=Elements(j,1);
           Nodes(i,k+4)=Elements(j,1);
       end
    end
end

for i=1:Number_Node
    k=0;
    P1(:,1) = 0;
    P3(:,1) = 0;
    P4(:,1) = 0;
    for j = 1:Number_Element
       if(Elements(j,2)==Nodes(i,1) || Elements(j,3)==Nodes(i,1))
           k=k+1;
           P1(k)=Elements(j,1);
       end
    end
    effective_element=0;
    for j = 1:4
       if(P1(j)~=0)
          effective_element =effective_element+1; 
       end
    end
    if(effective_element <=1)
        No_effective_element = No_effective_element+1;
        not_effective_element(No_effective_element) = Nodes(i,1); 
        continue
    end
    P2(1,1) = P1(1);
    P2(1,2) = P1(2);
    P2(2,1) = P1(2);
    P2(2,2) = P1(3);
    P2(3,1) = P1(3);
    P2(3,2) = P1(4);
    P2(4,1) = P1(1);
    P2(4,2) = P1(4);
    P2(5,1) = P1(2);
    P2(5,2) = P1(4);
    P2(6,1) = P1(1);
    P2(6,2) = P1(3);
    
    for j =1:6
      for m = 1:2
        if (P2(j,m)~=0)
            PP = P2(j,m);
          P3(1) = Elements(P2(j,m),2);
          P3(2) = Elements(P2(j,m),3);
        end
        if(P3(1)==Nodes(i,1))
           P4(m) = P3(2);
        else
           P4(m) = P3(1);
        end
      end
      if P4(1)==P4(2)
         continue; 
      end
      for m =1:4
          for n =1:4
             if(Nodes(P4(1),n+4) == 0 || Nodes(P4(2),m+4) == 0)
                continue; 
             end
              
             if(Elements(Nodes(P4(1),n+4),2)==P4(1))
                other1 = 3;
             else
                other1 = 2;
             end
             if(Elements(Nodes(P4(2),m+4),2)==P4(2))
                other2 = 3;
             else
                other2 = 2;
             end
             if(Elements(Nodes(P4(1),n+4),other1)==Nodes(i,1))
                 continue;
             end
             if(Elements(Nodes(P4(1),n+4),other1) == Elements(Nodes(P4(2),m+4),other2))
                 if(Nodes(P4(1),n+4)~= P2(j,1) && Nodes(P4(1),n+4)~=P2(j,2))
                     if(Nodes(P4(2),m+4)~= P2(j,1) && Nodes(P4(2),m+4)~=P2(j,2))
                         P0=P0+1;
                         Panels1(P0,1) = P0;
                         Panels1(P0,2) = Nodes(i,1);
                         Panels1(P0,3) = P4(1);
                         Panels1(P0,4) = Elements(Nodes(P4(1),n+4),other1);
                         Panels1(P0,5) = P4(2);
                         Panels1(P0,6) = P2(j,1);
                         Panels1(P0,7) = P2(j,2);
                         Panels1(P0,8) = Nodes(P4(1),n+4);
                         Panels1(P0,9) = Nodes(P4(2),m+4);
                         P6 = Panels1(P0,2:5);
                         P7 = sort(P6);
                         Panels1(P0,10:13)=P7;
                     end
                 end
             end
          end
      end   
    end
end

Panels2 = sortrows(Panels1,[10 11 12 13]);

Panels3 = Panels2(1:4:end,:);
% 中心点位置
Position = [0 0 0];
for i=1:size(Panels3,1)
    for j =1:3
        Position(j) = mean(Nodes(Panels3(i,2:4),j+1));
        Panels3(i,j+16) = Position(j);
    end
end

% 法向向量
Panels4 = Panels3;
for i = 1:size(Panels3,1)
  e13 = Nodes(Panels3(i,4),2:4)-Nodes(Panels3(i,2),2:4);
  e24 = Nodes(Panels3(i,5),2:4)-Nodes(Panels3(i,3),2:4);
  Normal_origin = cross(e24,e13);
  Normal = Normal_origin/norm(Normal_origin);
  %Normal = normalize(cross(e24,e13));
  OA = Panels3(i,17:19);
  sigma = acos(dot(Normal,OA)/(norm(Normal)*norm(OA)));
  SIGMA = sigma/pi*180;
  Panels3(i,14:16) = Normal;
  Panels4(i,14:16) = Normal;
  
  if(SIGMA>90)
     Panels4(i,3) = Panels3(i,5);
     Panels4(i,5) = Panels3(i,3);
     Panels4(i,14:16) = -Normal;
  end
  
end
for i=1:size(Panels4,1)
   Panels4(i,1)=i; 
end

%%
for i=1:size(Elements,1)
    k=4;
    for j=1:size(Panels4,1)
       if (Panels4(j,6)==Elements(i,1)||Panels4(j,7)==Elements(i,1)|| Panels4(j,8)==Elements(i,1)||Panels4(j,9)==Elements(i,1))
          Elements(i,k)=Panels4(j,1);
          k=k+1;
       end
    end
end

%% 本步骤更新了Panels4第20列数据，用于判断该Panels单元是否为下游单元
[m,n] = size(Reduces);
for i = 1:m
    for j = 1:n
        if(not(isnan(Reduces(i,j))))        
            if(Elements(Reduces(i,j),4)~=0)
                Panels4(Elements(Reduces(i,j),4),20) = 1;
            end
            if(Elements(Reduces(i,j),5)~=0)
                Panels4(Elements(Reduces(i,j),5),20) = 1;
            end
        end
    end
end

%% 输出
%save Panels.txt -ascii Panels4
%save Elements.txt -ascii Elements
fid=fopen('.\Panels.txt','wt');%写入文件路径
matrix=Panels4;                       %input_matrix为待输出矩阵
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
end
fclose(fid);

fid=fopen('.\Elements.txt','wt');%写入文件路径
matrix=Elements;                       %input_matrix为待输出矩阵
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
end
fclose(fid);
Nodes1(:,:) = Nodes(:,1:8);
fid=fopen('.\Nodes.txt','wt');%写入文件路径
matrix=Nodes1;                       %input_matrix为待输出矩阵
[m,n]=size(matrix);
 for i=1:1:m
   for j=1:1:n
      if j==n
        fprintf(fid,'%g\n',matrix(i,j));
     else
       fprintf(fid,'%g\t',matrix(i,j));
      end
   end
end
fclose(fid);



