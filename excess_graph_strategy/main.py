import datetime
import pandas as pd
from useful_function import get_yjgg_data_base_year_month, get_yysj_data_base_year_month


today = datetime.date(2023, 5, 25)
mont = today.month
year = today.year

yysj_df = get_yysj_data_base_year_month(year, mont)
yjgg_df = get_yjgg_data_base_year_month(year, mont)

yysj_vs_yjgg = pd.merge(yysj_df, yjgg_df, on=["股票代码", "accounting_period"], how="inner")

yysj_vs_yjgg["trade_date"] = today
yysj_vs_yjgg["time_distance"] = yysj_vs_yjgg["首次预约时间"] - yysj_vs_yjgg["trade_date"]

yysj_vs_yjgg_with_profitdata = yysj_vs_yjgg.loc[yysj_vs_yjgg["净利润-同比增长"].notna(), :]  # 删掉没有利润增长记录的业绩快报
latest_profit_period = yysj_vs_yjgg_with_profitdata.groupby("股票代码", as_index=False).agg({"accounting_period": "max"})  # 获取最近的报告期数据
latest_profit_data = pd.merge(latest_profit_period, yysj_vs_yjgg_with_profitdata, on=["股票代码", "accounting_period"], how="left")  # 取报告期最近的一期对应的记录
latest_profit_data_50 = latest_profit_data.loc[latest_profit_data["净利润-同比增长"]>50,:]  # 找出增长率大于五成的数据。

latest_profit_data_50.to_csv("latest_profit_data_50_{0:%m%d}.csv".format(today))

print(latest_profit_data)
