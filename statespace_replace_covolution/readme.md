# 文件夹介绍

- 本文件夹中所载程序用于对延迟函数的状态空间法替代方法进行计算，其中“S1.mat”至“S10.mat”文件为不同自由度对应的状态空间的参数矩阵，里面包含了A\B\C\D矩阵。

- 文件Spar.1为原始水动力文件，是从FAST的仿真案例中复制过来的。

- Spar.txt为修改过的读取文件

- Spar_Infinity.txt为无穷频率处的附加质量。

- StateSpaceProcess.m为输出"S1.mat"文件的程序文件，statespace_calculate.m为最早研究状态空间法时留下的文件，StateSpace.m为研究过程中留存的试验性文件。