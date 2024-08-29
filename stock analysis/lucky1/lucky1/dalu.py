# encoding:utf-8

"""
@ProjectName:PythonWorkFile
@Author:zhuyu
@File:dalu.py
@Date:2021/3/23
@Email:zhuyuanyao_only@163.com
"""
import numpy.fft as fft
import numpy as np


class fft_solo:
    def __init__(self, data):
        self.data = data
        self.result = self.fft()

    def __str__(self):
        return '本方法用于计算快速傅里叶变换后的股票情况！'
'''
    def fft(self):
        data = fft.fft(self.data)
        self.result = 
        return self.result
'''