# 文件夹介绍
本文件夹可用于对系泊系统的初步设计，Process.m文件为计算和出图文件，是从mainProgram.m文件修改而来。而mainProgram.m文件是从原来文件夹中获得的，原来文件夹地址为：E:\TiM_Programing\matlab tools

在本计算软件中存在两个计算方法，jacobi.m和fun.m是一套，它是通过直接对锚链的非线性方程进行求偏导得到的，而jacobi2.m和fun2.m则是通过上一项减后一项然后除以步长来求偏导，可见前一种方法运算速度更快，收敛性更好。所以在Process.m中直接采用的是第一种，而第二种算法还保存在mainProgram.m中。

