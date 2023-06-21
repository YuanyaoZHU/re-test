该版本文件建于2021年4月22日，上一个版本中，已经将湍流风接入到系统中，这一版本将用于对各个模块的调整和整合！
对于风机个坐标位置的定义，通过阅读和整理AeroDyn中的代码，现整理思路如下：
首先需要知道两个公式，第一个公式是坐标转换公式，第二个是速度转换公式：
第一个公式为：
P_global = P_ref + P_local * RefOrientation
第二个公式为：
V_Global = V_ref + w_ref (X) P_local + V_local    其中V是Velocity的代称，W为角速度的代称，（X）为叉乘的意思

首先AeroDyn中已经在初始化时定义好了position(即节点的初始位置）、orientation(全局坐标系的旋转矩阵，就是局部坐标向量乘以旋转矩阵后，将转换到全局坐标系）和RefOrientation（这个是坐标原点或者参考点的旋转矩阵，在风机定义中，大部分节点可以以风机塔筒基座为原点，这时RefOrientation就是单位矩阵，但是某些节点利用参考点建模更加方便，如风机叶片上的点相对于叶片根部就相对方便去建立坐标系，这时RefOrientation就是叶片根部的旋转矩阵，当这些矩阵乘以这个RefOrientation时就可以还原到上一级坐标系中，#这里的上一级坐标系并非指的是全局，由于我们现在建立的是漂浮式风机，风机也会相对空间进行运动#）
在计算时，需要进行实时更改的主要有以下几个量
Orientation------------旋转矩阵
TranslationDisp--------位移
TranslationVel---------速度
已上各量均是相对于全局坐标系建立的

vesion:		test_alpha_v5版本
build date:	2021年4月27日
description:	用于对各种参数的验证及修改


