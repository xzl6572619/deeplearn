import datetime
import pandas as pd
from useful_function import get_yygg_data_base_year_month, get_yysj_data_base_year_month, stage_tier_func, get_roe_df, \
    trddt_range
import numpy as np
from tqdm import tqdm
import concurrent.futures
import warnings

warnings.filterwarnings("ignore")

today = datetime.date(2020, 3, 15)

# 获取ROE的dataframe格式的数据
roe = get_roe_df()


def calculate_day_timedistance(dt):
    mont = dt.month
    year = dt.year
    lastyear = dt.year - 1

    # 1根据日期的年份和月份来获取盈余数据：预约披露日期和盈余快报.
    yysj_df = get_yysj_data_base_year_month(year, mont)
    yjgg_df = get_yygg_data_base_year_month(year, mont)

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
    filter = latest_profit_data["净利润-同比增长"] > 20 | latest_profit_data["净利润-净利润"] > 10000000
    latest_profit_data_50 = latest_profit_data.loc[filter, :]

    # 按照距离预约报告期的时间长度进行期限阶段的划分。
    latest_profit_data_50.loc[:, "tier"] = latest_profit_data_50["time_distance"].apply(stage_tier_func)

    # 计算去年同期的ROE
    latest_profit_data_50.loc[:, "last_period"] = latest_profit_data_50.loc[:, "accounting_period"] - pd.DateOffset(
        years=1)
    latest_profit_data_50_plusroe = pd.merge(latest_profit_data_50, roe, left_on=["股票代码", "last_period"],
                                             right_on=["code", "period"], how="left")
    latest_profit_data_50_plusroe.loc[:, "roedf"] = latest_profit_data_50_plusroe.loc[:,
                                                    "净资产收益率"] - latest_profit_data_50_plusroe.loc[:,
                                                                "ROE"]  # 计算ROE的变动幅度

    # 对股票进行排名
    latest_profit_data_50_plusroe.sort_values(by=["tier", "净利润-同比增长", "净利润-净利润", "roedf"],
                                              ascending=[False, False, False, False], inplace=True)
    latest_profit_data_50_plusroe.loc[:, "rnk"] = range(len(latest_profit_data_50_plusroe))

    latest_profit_data_50_plusroe.to_csv(
        "csv_data/score_df_all/latest_profit_data_50_plusroe_{0:%Y%m%d}.csv".format(dt))
    # print(type(latest_profit_data_50_plusroe.loc[3, "净资产收益率"]), type(latest_profit_data_50_plusroe.loc[3, "ROE"]))
    return latest_profit_data_50_plusroe


if __name__ == "__main__":
    start = datetime.date(2020, 1, 1)
    end = datetime.date(2020, 12, 31)
    trddt_range = trddt_range(start, end)

    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        for date in tqdm(trddt_range.loc[:, "trddt"]):
            executor.submit(calculate_day_timedistance, date)


