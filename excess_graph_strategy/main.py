import datetime
import pandas as pd
from useful_function import get_yjgg_data_base_year_month, get_yysj_data_base_year_month, stage_tier_func, get_roe_data

today = datetime.date(2023, 3, 15)


def calculate_day_timedistance(dt):
    mont = dt.month
    year = dt.year
    lastyear = dt.year - 1

    # 1根据日期的年份和月份来获取盈余数据：预约披露日期和盈余快报.
    yysj_df = get_yysj_data_base_year_month(year, mont)
    yjgg_df = get_yjgg_data_base_year_month(year, mont)

    # 2将预约披露日期数据和业绩快报的数据合并在一起
    yysj_vs_yjgg = pd.merge(yysj_df, yjgg_df, on=["股票代码", "accounting_period"], how="inner")

    # 3获取当前日期距预约披露日期的时间长度
    yysj_vs_yjgg["trade_date"] = dt
    yysj_vs_yjgg["time_distance"] = yysj_vs_yjgg["首次预约时间"] - yysj_vs_yjgg["trade_date"]

    # 只选出在交易日之前发布公告的盈余公告。
    yysj_vs_yjgg = yysj_vs_yjgg[yysj_vs_yjgg["公告日期"] < yysj_vs_yjgg["trade_date"]]

    # 删掉没有利润增长记录的业绩快报
    yysj_vs_yjgg_with_profitdata = yysj_vs_yjgg.loc[yysj_vs_yjgg["净利润-同比增长"].notna(), :]

    latest_profit_period = yysj_vs_yjgg_with_profitdata.groupby("股票代码", as_index=False).agg(
        {"accounting_period": "max"})  # 获取最近的报告期数据
    latest_profit_data = pd.merge(latest_profit_period, yysj_vs_yjgg_with_profitdata, on=["股票代码", "accounting_period"],
                                  how="left")  # 取报告期最近的一期对应的记录

    # 找出增长率大于三成的数据。
    latest_profit_data_50 = latest_profit_data.loc[latest_profit_data["净利润-同比增长"] > 20, :]

    # 按照距离预约报告期的时间长度进行期限阶段的划分。
    latest_profit_data_50.loc[:, "tier"] = latest_profit_data_50["time_distance"].apply(stage_tier_func)

    # 计算去年同期的ROE
    latest_profit_data_50.loc[:, "last_period"] = latest_profit_data_50.loc[:, "accounting_period"] - pd.DateOffset(
        years=1)
    latest_profit_data_50.loc[:, "last_roe"] = latest_profit_data_50[["股票代码", "last_period"]].apply(
        lambda x: get_roe_data(x["股票代码"], x["last_period"]), axis=1)

    latest_profit_data_50.to_csv("latest_profit_data_50_{0:%m%d}.csv".format(dt))
    print(type(latest_profit_data_50.loc[3, "accounting_period"]))


# calculate_day_timedistance(today)
a = pd.read_csv(r"D:\git\learn\deeplearn\excess_graph_strategy\csv_data\roe_code_period.txt")
print(a)
