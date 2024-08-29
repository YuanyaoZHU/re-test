import downloadstock as dt

'''
one = dt.readBatch('../stock_data/Table.xlsx', method=9, start='20160101')
one.action()

'''
two = dt.Analysis(dt.Account(dt.Stock('1002230')), 9)
two.money.to_csv('../analysis_result/money_one.csv', encoding='gb2312')
dt.Data_report(two.money, two.account.stock.code).save()

