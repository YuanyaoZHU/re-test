# 仓库介绍

本仓库用于储存工程仿真必备文件的储存，由于仿真结果文件一般比较大，所以仓库中仅包含了仿真必备的文件。

- Spar_5MW_FOWT_test 

  该文件夹用于对OC3项目中5MW浮式风机工程的仿真，其中包含所有的基础文件，从该文件夹中可以构建完整的仿真程序。

- statespace_replace_covolution

  该文件夹用于对状态空间法替代延迟函数计算的相关求解，具体内容请看文件夹中具体介绍。

- matlab_Figrue_Templete

  该文件夹用于储存matlab出图模板

- PanelMeshFunction

  该文件夹中包含的程序可以从abaqus的inp文件中提取的Node和Element文件构建Panel单元
<<<<<<< HEAD
=======
  目前新的PanelMeshFunction对Panel单元添加了第20列，用于判断该Panel单元是否为下游网衣模型，输入文件增加了Reduce.txt文件，该文件为abaqus的集合直接拿出来的，2023.6.26。
>>>>>>> 2c3ffecbddae317c14a75ba43c5dd727c0cd5584

- CircleNet

  该文件夹包含圆形网衣案例
<<<<<<< HEAD

- NREL_5MW_SPAR_FOWT_property

  该文件夹包含了NREL 5MW spar平台浮式风机的完整属性
=======
>>>>>>> 2c3ffecbddae317c14a75ba43c5dd727c0cd5584

- OC3_Spar_Retardation_Calculation

  该文件夹包含了生成RETARDATION.txt文件的代码，该文件用于计算COMMINS法中的卷积计算

- Turbsim_OC3_SPAR

  该文件夹包含了Turbsim生成风场文件的案例，其中有原始的OC3项目中的风场文件，也包含了Vhub=18m/s Iref = 0.167的风场生成输入文件
