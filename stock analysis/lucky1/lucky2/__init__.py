# encoding:utf-8

"""
@ProjectName:PythonWorkFile
@Author:zhuyu
@File:__init__.py.py
@Date:2021/3/31
@Email:zhuyuanyao_only@163.com
"""
import baostock as bs
import downloadstock as dt
import pandas as pd

'''
#### 登陆系统 ####
lg = bs.login()
# 显示登陆返回信息
print('login respond error_code:'+lg.error_code)
print('login respond  error_msg:'+lg.error_msg)

two = dt.Analysis(dt.Account(dt.Stock('sh.512880')), 9)
two.money.to_csv('../analysis_result/money_one1.csv', encoding='gb2312')
dt.Data_report(two.money, two.account.stock.code).save()

#### 登出系统 ####
bs.logout()
'''
lg = bs.login()
# 显示登陆返回信息
print('login respond error_code:'+lg.error_code)
print('login respond  error_msg:'+lg.error_msg)

one = dt.readBatch('../stock_data/Table.xlsx', method=11, start='2014-01-01')
one.action()

bs.logout()

