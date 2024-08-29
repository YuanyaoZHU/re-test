# encoding:utf-8

"""
@ProjectName:__init__.py
@Author:zhuyu
@File:downloadstock.py
@Date:2021/3/31
@Email:zhuyuanyao_only@163.com
"""
import pandas as pd
import baostock as bs
import numpy as np
import talib
import matplotlib.pyplot as plt
import math


class Stock:
    def __init__(self, code, start='2015-1-1', end=''):
        self.code = code
        self.start = start
        self.end = end
        self.df = self.get_daily()
        self.df = self.sort()

    def __str__(self):
        return "传入的股票代码为：%d" % self.code

    def get_daily(self):
        rs = bs.query_history_k_data_plus(self.code,
                                          "date,code,open,high,low,close,preclose,volume,amount,adjustflag,turn,tradestatus,pctChg,isST",
                                          start_date=self.start, end_date=self.end,
                                          frequency="d", adjustflag="2")
        print('query_history_k_data_plus respond error_code:' + rs.error_code)
        print('query_history_k_data_plus respond  error_msg:' + rs.error_msg)

        #### 打印结果集 ####
        data_list = []
        while (rs.error_code == '0') & rs.next():
            # 获取一条记录，将记录合并在一起
            data_list.append(rs.get_row_data())
        columns = ['日期', 'code', '开盘价', '最高价', '最低价', '收盘价', '前收盘价', 'volume', 'amount', 'adjustflag', 'turn',
                   'tradestatus', 'pctChg', 'isST']
        result = pd.DataFrame(data_list, columns=columns)
        result["开盘价"] = [0 if x == "" else float(x) for x in result["开盘价"]]
        result["收盘价"] = [0 if x == "" else float(x) for x in result["收盘价"]]
        result["最高价"] = [0 if x == "" else float(x) for x in result["最高价"]]
        result["最低价"] = [0 if x == "" else float(x) for x in result["最低价"]]
        return result

    def sort(self):
        self.df = self.df.set_index('日期')
        self.df = self.df.sort_index()
        return self.df


'''
Account类用于对各股账户的管理，其中函数包含了买股票和卖股票等方法
'''


class Account:
    def __init__(self, stock, investment=100000, stamp_duty=0.001, transfer_fee=0.0002, handling_fee=0.000487,
                 commision=0.003):
        self.stock = stock
        self.holdNumber = 0
        self.date = stock.df.index
        self.money = self.init_account(investment=investment, date=self.date)
        self.money_stock = self.init_money_stock(self.date)
        self.money_balance = investment
        self.number = self.init_money_stock(self.date)
        self.buy_price = self.init_money_stock(self.date)
        self.price = 0
        self.money1 = 0
        self.money_stock1 = 0
        self.stamp_duty = stamp_duty
        self.transfer_fee = transfer_fee
        self.handling_fee = handling_fee
        self.commision = commision
        self.fee = self.init_money_stock(self.date)
        self.fee1 = 0
        self.hold = False

    def __str__(self):
        return "目前处理的股票为:%s" % self.stock.code

    def init_account(self, investment, date):
        money1 = np.zeros(len(date)) + investment
        self.money = pd.DataFrame(data=money1, index=self.date, columns=[self.stock.code])
        return self.money

    def init_money_stock(self, date):
        money1 = np.zeros(len(date))
        p = pd.DataFrame(data=money1, index=self.date, columns=[self.stock.code])
        return p

    def buy(self, date):
        if self.holdNumber == 0 and self.money_balance > self.stock.df.loc[[date], ['收盘价']].values * 100 and \
                self.stock.df.loc[[date], ['收盘价']].values > 0:
            # print('买================================')
            self.hold = True
            self.money.at[[date], [self.stock.code]] = self.money_balance
            self.holdNumber = math.floor(
                self.money.loc[[date], [self.stock.code]].values / (self.stock.df.loc[[date], ['收盘价']].values * 100))
            self.money1 = self.money.loc[[date], [self.stock.code]].values
            self.price = self.stock.df.loc[[date], ['收盘价']].values
            self.buy_price.loc[date, self.stock.code] = self.price
            if self.price * 100 * self.holdNumber * self.commision < 5:
                commi = 5
            else:
                commi = self.price * 100 * self.holdNumber * self.commision
            self.fee1 = self.holdNumber * 100 * self.transfer_fee \
                        + self.price * 100 * self.holdNumber * self.handling_fee \
                        + commi
            self.fee.loc[date, self.stock.code] = self.fee1
            self.money_balance = self.money1 - self.price * 100 * self.holdNumber - self.fee1
            self.price = self.stock.df.loc[[date], ['收盘价']].values
        '''
            for i in range(p, L):
                self.number.iloc[i, 0] = math.floor(self.money.loc[[date], [self.stock.code]].values / (
                            self.stock.df.loc[[date], ['收盘价']].values * 100))
                self.money_stock.iloc[i, 0] = self.number.iloc[i, 0] * self.stock.df.iloc[i, q] * 100
                self.money_balance.iloc[i, 0] = self.money.loc[[date], [self.stock.code]].values - self.money_stock.loc[[date], [self.stock.code]].values
                self.money.iloc[i, 0] = self.money_stock.iloc[i, 0] + self.money_balance.iloc[i, 0]
        return self.money, self.money_stock, self.money_balance
        '''

    def sell(self, date):
        if self.holdNumber > 0 and self.stock.df.loc[[date], ['收盘价']].values > 0:
            # print('卖===================================')
            self.hold = False
            if self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.commision < 5:
                commi = 5
            else:
                commi = self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.commision
            self.fee1 = self.stock.df.loc[date, '收盘价'] * self.stamp_duty \
                        + self.holdNumber * 100 * self.transfer_fee \
                        + self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.handling_fee \
                        + commi
            self.money_balance = self.money_balance + self.holdNumber * self.stock.df.loc[[date], ['收盘价']].values * 100 \
                                 - self.fee1
            self.fee.loc[date, self.stock.code] = self.fee1
            self.money_stock.at[[date], [self.stock.code]] = 0
            self.holdNumber = 0
            self.money1 = 0
            self.price = 0

    def sell1(self, date):
        if self.holdNumber > 0 and self.stock.df.loc[[date], ['收盘价']].values > 0:
            # print('卖===================================')
            self.hold = False
            if self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.commision < 5:
                commi = 5
            else:
                commi = self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.commision
            self.fee1 = self.stock.df.loc[date, '收盘价'] * self.stamp_duty \
                        + self.holdNumber * 100 * self.transfer_fee \
                        + self.holdNumber * self.stock.df.loc[date, '收盘价'] * 100 * self.handling_fee \
                        + commi
            self.money_balance = self.money_balance + self.holdNumber * self.stock.df.loc[
                [date], ['收盘价']].values * 100 \
                                 - self.fee1
            self.fee.loc[date, self.stock.code] = self.fee1
            self.money_stock.at[[date], [self.stock.code]] = 0
            self.holdNumber = 0
            self.money1 = 0
            self.price = 0
            '''
            for i in range(p, L):
                self.money.iloc[i, 0] = self.money_stock.loc[[date], [self.stock.code]].values + self.money_balance.loc[
                    [date], [self.stock.code]].values
                self.money_balance.iloc[i, 0] = self.money.iloc[i, 0]
                self.money_stock.iloc[i, 0] = 0
                self.number.iloc[i, 0] = 0
            '''

    def monitor(self, date):
        p = self.number.index.get_loc(date)
        q = self.stock.df.columns.get_loc('收盘价')
        if self.holdNumber > 0:
            self.number.at[[date], [self.stock.code]] = self.holdNumber
            if self.stock.df.loc[[date], ['收盘价']].values <= 0:
                self.money_stock.iat[p, 0] = self.holdNumber * self.search_not_zero(date) * 100
            else:
                self.money_stock.iat[p, 0] = self.holdNumber * self.stock.df.iloc[p, q] * 100
            self.money.iloc[p, 0] = self.money_stock.iloc[p, 0] + self.money_balance
            self.money_stock1 = self.money_stock.iloc[p, 0]
        elif self.holdNumber == 0:
            self.money.at[[date], [self.stock.code]] = self.money_balance
            self.number.iloc[p, 0] = self.holdNumber
            self.money_stock.iloc[p, 0] = 0
        else:
            print('the hold number is smaller than 0, please check the code')

    def search_not_zero(self, date):
        price = self.stock.df.loc[[date], ['收盘价']].values
        p = self.stock.df.index.get_loc(date)
        q = self.stock.df.columns.get_loc('收盘价')
        while price <= 0:
            price = self.stock.df.iloc[p - 1, q]
            p = p - 1
        return price


'''
readBatch程序主要用于对股票信息的批量化处理，其中内部函数action用于批量化验证策略的执行方式
'''


class readBatch:
    def __init__(self, path, method=1, start='19901219', end=''):
        self.path = path
        self.df_excel = self.read_table()
        self.stock_ID = self.rerange_stockID()
        self.df = pd.DataFrame()
        self.df2 = pd.DataFrame()
        self.df3 = pd.DataFrame()
        self.df4 = pd.DataFrame()
        self.method = method
        self.start = start
        self.end = end

    def __str__(self):
        print('本软件用于批量处理')

    def read_table(self):
        self.df_excel = pd.read_excel(self.path, sheet_name='Table')
        return self.df_excel

    def rerange_stockID(self):
        stock_ID = self.df_excel['代码']
        self.stock_ID = self.df_excel['代码']
        for inx, x in enumerate(stock_ID):
            p = x[2:]
            q = x[0:2]
            if q[1] == 'H':
                self.stock_ID.iat[inx] = "sh." + p
            elif q[1] == 'Z':
                self.stock_ID.iat[inx] = "sz." + p
        return self.stock_ID

    def action(self):
        for i in self.stock_ID:
            stock = Stock(i, self.start, self.end)
            account = Account(stock)
            print(account)
            analysis = Analysis(account, self.method)
            self.df[stock.code] = analysis.money[stock.code]
            one = Data_report(analysis.money, stock.code)
            self.df2[stock.code] = one.profit[stock.code]
            self.df3[stock.code] = analysis.fee[stock.code]
            self.df4[stock.code] = analysis.buy_price[stock.code]
        self.df['average'] = self.df.mean(1)
        self.df.to_csv("../analysis_result/money_batch.csv", encoding='gb2312')
        self.df2.to_csv("../analysis_result/profit_percent_batch.csv", encoding='gb2312')
        self.df3.to_csv("../analysis_result/fee_batch.csv", encoding='gb2312')
        self.df4.to_csv("../analysis_result/buy_price_batch.csv", encoding='gb2312')
        plt.plot(self.df.index, self.df['average'])
        plt.show()


'''
Analysis类用于对策略的封装，其中目前method1为根据MACD买入卖出信号进行的策略分析，其他策略的验证可后续展开
'''


class Analysis:
    def __init__(self, account, method=1):
        self.account = account
        self.method = method
        self.money = self.account.money
        self.fee = self.account.fee
        self.buy_price = self.account.buy_price
        self.account.stock.df['MA150'] = self.account.stock.df['收盘价'].rolling(150, min_periods=150).mean()
        self.account.stock.df['MA120'] = self.account.stock.df['收盘价'].rolling(120, min_periods=120).mean()
        self.account.stock.df['MA60'] = self.account.stock.df['收盘价'].rolling(60, min_periods=60).mean()
        self.account.stock.df['MA30'] = self.account.stock.df['收盘价'].rolling(30, min_periods=30).mean()
        self.account.stock.df['MA20'] = self.account.stock.df['收盘价'].rolling(20, min_periods=20).mean()
        self.account.stock.df['MA10'] = self.account.stock.df['收盘价'].rolling(10, min_periods=10).mean()
        self.account.stock.df['MA5'] = self.account.stock.df['收盘价'].rolling(5, min_periods=5).mean()
        if self.method == 1:
            self.method1()
        elif self.method == 2:
            self.method2()
        elif self.method == 3:
            self.method3()
        elif self.method == 4:
            self.method4()
        elif self.method == 5:
            self.method5()
        elif self.method == 6:
            self.method6()
        elif self.method == 7:
            self.method7()
        elif self.method == 8:
            self.method8()
        elif self.method == 9:
            self.method9()
        elif self.method == 10:
            self.method10()
        elif self.method == 11:
            self.method11()

    def method1(self):
        self.account.stock.df['MACD'], self.account.stock.df['MACDsignal'], self.account.stock.df[
            'MACDhist'] = talib.MACD(self.account.stock.df['收盘价'])
        for i in self.account.stock.df.index:
            p = self.account.stock.df.index.get_loc(i)
            pre = i if p == 0 else self.account.stock.df.index[p - 1]
            t1 = self.account.stock.df.loc[[i], ['MACDhist']].values
            t2 = self.account.stock.df.loc[[pre], ['MACDhist']].values
            if t1 > 0 and t2 < 0:
                self.account.buy(i)
            elif t1 < 0 and t2 > 0:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    def method2(self):
        self.account.stock.df['bool_upper'], self.account.stock.df['bool_middle'], self.account.stock.df[
            'bool_lower'] = talib.BBANDS(self.account.stock.df['收盘价'])
        for i in self.account.stock.df.index:
            t1 = self.account.stock.df.loc[[i], ['bool_upper']].values
            t2 = self.account.stock.df.loc[[i], ['bool_lower']].values
            if self.account.stock.df.loc[[i], ['最低价']].values < t2:
                self.account.buy(i)
            elif self.account.stock.df.loc[[i], ['最高价']].values > t2:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    # 策略：以MACD买卖信号为标准，辅助以3%回撤止损
    def method3(self):
        self.account.stock.df['MACD'], self.account.stock.df['MACDsignal'], self.account.stock.df[
            'MACDhist'] = talib.MACD(self.account.stock.df['收盘价'])
        top = 0
        for i in self.account.stock.df.index:
            p = self.account.stock.df.index.get_loc(i)
            pre = i if p == 0 else self.account.stock.df.index[p - 1]
            t1 = self.account.stock.df.loc[[i], ['MACDhist']].values
            t2 = self.account.stock.df.loc[[pre], ['MACDhist']].values
            t3 = self.account.stock.df.loc[[i], ['收盘价']].values
            t4 = self.account.stock.df.loc[[i], ['MACD']].values
            top = t3 if t3 > top else top
            if t1 > 0 and t2 < 0 and t4 > 0:
                self.account.buy(i)
                top = t3
            elif t1 < 0 and t2 > 0:
                self.account.sell(i)
            elif t3 < 0.97 * top:
                self.account.sell(i)
                top = 0
            self.account.monitor(i)
        return self.account

    # 在上涨市的星期四以收盘价买入，在星期一卖出
    def method4(self):
        self.account.stock.df['日期'] = self.account.stock.df.index
        self.account.stock.df['日期'] = pd.to_datetime(self.account.stock.df['日期'], format='%Y-%m-%d')
        self.account.stock.df['星期'] = self.account.stock.df['日期'].dt.dayofweek
        self.account.stock.df['星期'] += 1
        # 插入均线计算以及判断上涨市和下跌市
        self.account.stock.df.loc[(self.account.stock.df['收盘价'] > self.account.stock.df['收盘价'].rolling(20,
                                                                                                       min_periods=1).mean()), '上涨市_mean'] = True
        self.account.stock.df['上涨市_mean'].fillna(value=False, inplace=True)
        # 选择上涨市还是下跌市
        for i in self.account.stock.df.index:
            if self.account.stock.df.loc[i, '上涨市_mean'] and self.account.stock.df.loc[i, '星期'] == 4:
                self.account.buy(i)
            elif self.account.stock.df.loc[i, ['上涨市_mean']].values and self.account.stock.df.loc[i, '星期'] == 1:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    def method5(self):
        self.account.stock.df['日期'] = self.account.stock.df.index
        self.account.stock.df['日期'] = pd.to_datetime(self.account.stock.df['日期'], format='%Y-%m-%d')
        self.account.stock.df['星期'] = self.account.stock.df['日期'].dt.dayofweek
        self.account.stock.df['星期'] += 1
        # 插入均线计算以及判断上涨市和下跌市
        self.account.stock.df.loc[(self.account.stock.df['收盘价'] > self.account.stock.df['收盘价'].rolling(20,
                                                                                                       min_periods=1).mean()), '上涨市_mean'] = True
        self.account.stock.df['上涨市_mean'].fillna(value=False, inplace=True)
        # 选择上涨市还是下跌市
        for i in self.account.stock.df.index:
            if self.account.stock.df.loc[i, '星期'] == 4:
                self.account.buy(i)
            elif self.account.stock.df.loc[i, '星期'] == 1:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    # 采用赚三个点就跑指标交易规则
    def method6(self):
        self.account.stock.df['Var1'] = (2 * self.account.stock.df['收盘价'] + self.account.stock.df['最高价']
                                         + self.account.stock.df['最低价']) / 4
        self.account.stock.df['Var2'] = self.account.stock.df['最低价'].rolling(34, min_periods=1).min()
        self.account.stock.df['Var3'] = self.account.stock.df['最高价'].rolling(34, min_periods=1).max()
        self.account.stock.df['xx'] = talib.EMA((self.account.stock.df['Var1'] - self.account.stock.df['Var2']) / \
                                                (self.account.stock.df['Var3'] - self.account.stock.df['Var2']) * 100,
                                                13)
        self.account.stock.df['yy'] = talib.EMA(
            0.667 * self.account.stock.df['xx'].shift(1) + 0.333 * self.account.stock.df['xx'], 2)
        top = 0
        for p, i in enumerate(self.account.stock.df.index):
            q = self.account.stock.df.columns.get_loc('xx')
            qq = self.account.stock.df.columns.get_loc('yy')
            dm1 = self.account.stock.df.loc[i, 'xx'] - self.account.stock.df.loc[i, 'yy']
            dm2 = self.account.stock.df.iloc[p - 1, q] - self.account.stock.df.iloc[p - 1, qq]
            t3 = self.account.stock.df.loc[[i], ['收盘价']].values
            top = t3 if t3 > top else top
            if dm1 * dm2 < 0 and self.account.stock.df.loc[i, 'xx'] < 20:
                self.account.buy(i)
            elif dm1 * dm2 < 0 and self.account.stock.df.loc[i, 'xx'] > 80:
                self.account.sell(i)
            elif t3 < 0.95 * top:
                self.account.sell(i)
            elif self.account.price * 1.03 < t3:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    # 以macd信号为买入信号，并且保证买入位置为MACDhist值大于2倍标准差时，卖出跟method3一致
    def method7(self):
        self.account.stock.df['MACD'], self.account.stock.df['MACDsignal'], self.account.stock.df[
            'MACDhist'] = talib.MACD(self.account.stock.df['收盘价'])
        std = self.account.stock.df['MACD'].describe()['std']
        min = self.account.stock.df['MACD'].describe()['min']
        print('std = ', std)
        print('min = ', min)
        top = 0
        holdDay = 0
        for i in self.account.stock.df.index:
            p = self.account.stock.df.index.get_loc(i)
            pre = i if p == 0 else self.account.stock.df.index[p - 1]
            t1 = self.account.stock.df.loc[[i], ['MACDhist']].values
            t2 = self.account.stock.df.loc[[pre], ['MACDhist']].values
            t3 = self.account.stock.df.loc[[i], ['收盘价']].values
            t4 = self.account.stock.df.loc[[i], ['MACD']].values

            top = t3 if t3 > top else top
            if t1 > 0 and t2 < 0 and t4 < -std:
                self.account.buy(i)
                top = t3
            elif t1 < 0 and t2 > 0:
                self.account.sell(i)
            elif t3 < 0.8 * top:
                self.account.sell(i)
                top = 0
            elif t3 > 1.03 * self.account.price:
                self.account.sell(i)
            elif holdDay >= 3:
                self.account.sell(i)
            self.account.monitor(i)
            if self.account.holdNumber > 0:
                holdDay += 1
            else:
                holdDay = 0
        return self.account

    # 区间震荡交易法, 当确认连续3天收盘价大于5日均线，并且价格回落到之前的最低价格时，进行购买；盈利7%后卖出；止损位为下跌5%
    def method8(self):
        low = 100000
        low2 = 100000
        buy = False
        self.account.stock.df['MA5'] = self.account.stock.df['收盘价'].rolling(5, min_periods=1).mean()
        self.account.stock.df['MA120'] = self.account.stock.df['收盘价'].rolling(120, min_periods=1).mean()
        day3 = 0
        for i in self.account.stock.df.index:
            close = self.account.stock.df.loc[i, '收盘价']
            low_est = self.account.stock.df.loc[i, '最低价']
            if close < self.account.stock.df.loc[i, 'MA5'] and low_est != 0 and low2 > low_est:
                low2 = low_est
            if self.account.stock.df.loc[i, '收盘价'] > self.account.stock.df.loc[i, 'MA5']:
                day3 += 1
            else:
                day3 = 0
            if close > self.account.stock.df.loc[i, 'MA5'] and day3 >= 9:  # 收盘价连续3天大于5日均线，确认形成反弹
                buy = True
                low = low2
                low2 = 100000
            if buy and 1.01 * low > low_est and close > self.account.stock.df.loc[i, 'MA120']:
                self.account.buy(i)
            elif self.account.stock.df.loc[i, '最高价'] < self.account.stock.df.loc[i, 'MA5'] and self.account.hold:
                self.account.sell(i)
                if self.account.hold:
                    buy = False
            elif self.account.price * 0.97 > self.account.stock.df.loc[i, '最低价'] and self.account.hold:
                self.account.sell(i)
                if self.account.hold:
                    buy = False
            self.account.monitor(i)
        return self.account

    def method9(self):  # 该指数盈利在40%
        self.account.stock.df['dm10'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA10']
        self.account.stock.df['dm20'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA20']
        self.account.stock.df['dm60'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA60']
        self.account.stock.df.loc[
            (self.account.stock.df['dm60'] * self.account.stock.df['dm60'].shift(1) < 0), '5_60cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['dm20'] * self.account.stock.df['dm20'].shift(1) < 0), '5_20cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['dm10'] * self.account.stock.df['dm10'].shift(1) < 0), '5_10cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['MA60'] - self.account.stock.df['MA60'].shift(1) > 0), '牛市'] = True
        self.account.stock.df['牛市'].fillna(value=False, inplace=True)
        for i in self.account.stock.df.index:
            close = self.account.stock.df.loc[i, '收盘价']
            MA150 = self.account.stock.df.loc[i, 'MA150']
            MA120 = self.account.stock.df.loc[i, 'MA120']
            MA60 = self.account.stock.df.loc[i, 'MA60']
            MA30 = self.account.stock.df.loc[i, 'MA30']
            MA20 = self.account.stock.df.loc[i, 'MA20']
            MA10 = self.account.stock.df.loc[i, 'MA10']
            MA5 = self.account.stock.df.loc[i, 'MA5']
            if not self.account.hold and close > MA60:
                self.account.buy(i)
            elif self.account.hold and close < MA60:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    def method10(self):
        self.account.stock.df['dm10'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA10']
        self.account.stock.df['dm20'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA20']
        self.account.stock.df['dm60'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA60']
        self.account.stock.df.loc[
            (self.account.stock.df['dm60'] * self.account.stock.df['dm60'].shift(1) < 0), '5_60cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['dm20'] * self.account.stock.df['dm20'].shift(1) < 0), '5_20cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['dm10'] * self.account.stock.df['dm10'].shift(1) < 0), '5_10cross'] = True
        self.account.stock.df.loc[
            (self.account.stock.df['MA120'] - self.account.stock.df['MA120'].shift(1) > 0), '牛市'] = True
        self.account.stock.df['牛市'].fillna(value=False, inplace=True)
        for i in self.account.stock.df.index:
            close = self.account.stock.df.loc[i, '收盘价']
            MA150 = self.account.stock.df.loc[i, 'MA150']
            MA120 = self.account.stock.df.loc[i, 'MA120']
            MA60 = self.account.stock.df.loc[i, 'MA60']
            MA30 = self.account.stock.df.loc[i, 'MA30']
            MA20 = self.account.stock.df.loc[i, 'MA20']
            MA10 = self.account.stock.df.loc[i, 'MA10']
            MA5 = self.account.stock.df.loc[i, 'MA5']
            if not self.account.hold and close > MA60 and self.account.stock.df.loc[i, '牛市']:
                self.account.buy(i)
            elif self.account.hold and close < MA60:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    def method11(self):
        self.account.stock.df['dm60'] = self.account.stock.df['收盘价'] - self.account.stock.df['MA60']
        self.account.stock.df.loc[
            (self.account.stock.df['dm60'] > self.account.stock.df['dm60'].shift(1)), 'buy_signal'] = True
        self.account.stock.df['buy_signal'].fillna(value=False, inplace=True)
        for i in self.account.stock.df.index:
            close = self.account.stock.df.loc[i, '收盘价']
            MA60 = self.account.stock.df.loc[i, 'MA60']
            if not self.account.hold and close > MA60 and self.account.stock.df.loc[i, 'buy_signal']:
                self.account.buy(i)
            elif self.account.hold and not self.account.stock.df.loc[i, 'buy_signal']:
                self.account.sell(i)
            self.account.monitor(i)
        return self.account

    def method12(self):
        self.account.stock.df['']




class Data_report:
    def __init__(self, money, code):
        self.money = money
        self.code = code
        self.profit = pd.DataFrame(columns=[self.code], index=self.money.index)
        self.profit = self.profit_percent()
        self.columns_name = self.money.columns

    def profit_percent(self):
        p = self.money.columns[0]
        q = self.money.columns.get_loc(p)
        for inx, i in enumerate(self.money.index):
            pre = i if inx == 0 else self.money.index[inx - 1]
            # print(self.money.loc[[i],[self.code]].values)
            if inx == 0:
                self.profit.iat[inx, 0] = 0
            elif inx > 0:
                if self.money.iloc[inx, q] == 0:
                    # print('money ==0, ',self.money.iloc[inx, q])
                    self.profit.iat[inx, 0] = 0
                else:
                    # print('money /=0, ',self.money.iloc[inx, q])
                    self.profit.iloc[inx, 0] = (self.money.loc[i, self.code] - self.money.loc[pre, self.code]) * 100 / \
                                               self.money.loc[i, self.code]
        return self.profit

    def save(self):
        self.profit.to_csv("../analysis_result/profit_percent_one.csv", encoding='gb2312')


'''
one.number.to_csv("D:/documents/stock analysis/number.csv", encoding='gb2312')
one.money.to_csv("D:/documents/stock analysis/money.csv", encoding='gb2312')
plt.plot(range(len(one.money.index)), one.money[one.stock.code])
plt.show()

#Stock1 = Stock('0600703')  # 获取上证指数
#stock1.df.to_csv("D:/documents/stock analysis/test.csv", encoding='gb2312')
#account1 = account(stock1)
#print(account1.money)

'''
