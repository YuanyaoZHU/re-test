import pandas as pd
 
#沪市前面加0，深市前面加1，比如0000001，是上证指数，1000001是中国平安
def get_daily(code,start='19901219',end=''):
    url_mod="http://quotes.money.163.com/service/chddata.html?code=%s&start=%s&end=%s"
    url=url_mod%(code,start,end)
    df=pd.read_csv(url, encoding = 'gb2312')
    return df
 
df=get_daily('0600703')     # 获取上证指数

df.to_csv("D:/documents/stock analysis/test.csv",encoding = 'gb2312')   
 
print(df)
