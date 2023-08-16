import akshare as ak
import pandas as pd
import datetime
import numpy as np

pd.set_option("display.max_rows", None)
pd.set_option("display.max_columns", None)

pd.set_option("display.width", 1000)
import sqlalchemy

# 建立readonly数据库的连接


CONN_RESEARCH_readonly = sqlalchemy.create_engine(
    'mysql+pymysql://readonly:Only4$Reading@home.jinxiong.work:53306/research')

stock_yysj_em_df_1 = ak.stock_yysj_em(date="20230331")
stock_yysj_em_df_y = ak.stock_yysj_em(date="20221231")
print(stock_yysj_em_df_1, stock_yysj_em_df_y)
stock_yysj_em_df_y.rename(columns={"首次预约时间": "首次预约时间_y"}, inplace=True)
stock_yysj_em_df_1.rename(columns={"首次预约时间": "首次预约时间_1"}, inplace=True)

stock_yjbb_em_df = ak.stock_yjbb_em(date="20230331")
stock_yjkb_em_df_1 = ak.stock_yjkb_em(date="20230331")[["股票代码", "净利润-同比增长", "净利润-净利润", "公告日期"]]
stock_yjyg_em_df_1_all = ak.stock_yjyg_em(date="20230331")
stock_yjkb_em_df_y = ak.stock_yjkb_em(date="20221231")[["股票代码", "净利润-同比增长", "净利润-净利润", "公告日期"]]
stock_yjyg_em_df_y_all = ak.stock_yjyg_em(date="20221231")

stock_yjyg_em_df_1 = stock_yjyg_em_df_1_all[stock_yjyg_em_df_1_all["预测指标"] == "扣除非经常性损益后的净利润"][
    ["股票代码", "业绩变动幅度", "预测数值", "公告日期"]]
stock_yjyg_em_df_y = stock_yjyg_em_df_y_all[stock_yjyg_em_df_y_all["预测指标"] == "扣除非经常性损益后的净利润"][
    ["股票代码", "业绩变动幅度", "预测数值", "公告日期"]]

stock_yjkb_em_df_1.rename(columns={"净利润-同比增长": "利润增长", "净利润-净利润": "利润"}, inplace=True)
stock_yjyg_em_df_1.rename(columns={"业绩变动幅度": "利润增长", "预测数值": "利润"}, inplace=True)
stock_yjkb_em_df_y.rename(columns={"净利润-同比增长": "利润增长", "净利润-净利润": "利润"}, inplace=True)
stock_yjyg_em_df_y.rename(columns={"业绩变动幅度": "利润增长", "预测数值": "利润"}, inplace=True)

satisfied_stock_yjyg_1 = stock_yjyg_em_df_1[(stock_yjyg_em_df_1["利润增长"] > 50) & (stock_yjyg_em_df_1["利润"] > 10000000)]
satisfied_stock_yjyg_y = stock_yjyg_em_df_y[(stock_yjyg_em_df_y["利润增长"] > 50) & (stock_yjyg_em_df_y["利润"] > 10000000)]
satisfied_stock_yjkb_1 = stock_yjkb_em_df_1[(stock_yjkb_em_df_1["利润增长"] > 50) & (stock_yjkb_em_df_1["利润"] > 10000000)]
satisfied_stock_yjkb_y = stock_yjkb_em_df_y[(stock_yjkb_em_df_y["利润增长"] > 50) & (stock_yjkb_em_df_y["利润"] > 10000000)]

satisfied_1 = pd.concat([satisfied_stock_yjyg_1, satisfied_stock_yjkb_1], ignore_index=True)
satisfied_y = pd.concat([satisfied_stock_yjyg_y, satisfied_stock_yjkb_y], ignore_index=True)

satisfied_1.rename(columns={"公告日期": "公告日期_1"}, inplace=True)
satisfied_y.rename(columns={"公告日期": "公告日期_y"}, inplace=True)
print(satisfied_1, satisfied_y)


# 判断黄金，白银和青铜期的函数
def stage_tier_func(x):
    if x <= pd.Timedelta(days=0):
        return 1
    elif x <= pd.Timedelta(days=10):
        return 3
    elif x <= pd.Timedelta(days=20):
        return 2
    else:
        return 1


stock_pool_dic = {}
for date in pd.date_range("20230401", "20230430"):
    stock_pool_1 = satisfied_1[satisfied_1["公告日期_1"] <= date.date()][["股票代码", "公告日期_1"]].groupby("股票代码").agg(
        {"公告日期_1": max})
    stock_pool_y = satisfied_y[satisfied_y["公告日期_y"] <= date.date()][["股票代码", "公告日期_y"]].groupby("股票代码").agg(
        {"公告日期_y": max})
    stock_pool_april = pd.merge(stock_pool_y, stock_pool_1, how="outer", on="股票代码")

    # 加入一季度和去年全年度的预约披露日期数据
    stock_pool_april_yysj_y = pd.merge(stock_pool_april, stock_yysj_em_df_y[["股票代码", "首次预约时间_y"]], how="left",
                                       on="股票代码")
    stock_pool_april_yysj = pd.merge(stock_pool_april_yysj_y, stock_yysj_em_df_1[["股票代码", "首次预约时间_1"]], how="left",
                                     on="股票代码")

    # 计算距离预约披露日期的天数
    stock_pool_april_yysj["距离天数_y"] = stock_pool_april_yysj["首次预约时间_y"] - date.date()
    stock_pool_april_yysj["距离天数_1"] = stock_pool_april_yysj["首次预约时间_1"] - date.date()

    # 添加需要的距离天数
    not_nan_1 = stock_pool_april_yysj[stock_pool_april_yysj["公告日期_1"].isna() == 0]
    nan_1 = stock_pool_april_yysj[stock_pool_april_yysj["公告日期_1"].isna()]

    # 对两个不同的DF创建列 距离天数  和 报告期采用，但是数据来源不一样。
    not_nan_1["距离天数"] = not_nan_1["距离天数_1"]
    not_nan_1["报告期采用"] = datetime.date(2023, 3, 31)
    nan_1["距离天数"] = nan_1["距离天数_y"]
    nan_1["报告期采用"] = datetime.date(2022, 12, 31)
    pool = pd.concat([not_nan_1, nan_1], ignore_index=True)

    # 以距离天数为依据添加阶段列tier
    pool["tier"] = pool["距离天数"].map(stage_tier_func)
    pool.insert(0, "trddt", date.date())

    # 将df写入到股票池字典中，键为日期date.date()
    stock_pool_dic[date.date()] = pool

# 检查四月一日生成的股票池，四月月初，三季度的盈余报告大部分还没有出来，所以就无法根据一季度的盈余报告来选择股票池，或者说只有一小部分的三季度盈余报告出来了，并且是符合条件的。
# 如果 **公告日期_1** 是 **Nan**，那么就运用 **首次预约时间_y** 和 **今天**的日期的距离天数来判断为**距离天数_y**；否则就运用 **首次预约时间_1** 和 **今天**的日期的距离天数来判断为**距离天数_1**，进而来判断该股票处于的时间阶段，是否处于黄金期，白银期或者青铜期。
d = 0
pool_of_all_april = stock_pool_dic[list(stock_pool_dic.keys())[0]]
for value in stock_pool_dic.values():
    if d == 0:
        d += 1
        continue
    else:
        pool_of_all_april = pd.concat([pool_of_all_april, value], ignore_index=True)
        d += 1

print(pool_of_all_april.tail(2000))


def calculate_SUE(x):
    month = x.trddt.month
    code_str = x.股票代码
    stock_financial_abstract_df = ak.stock_financial_abstract(symbol=code_str)
    a = stock_financial_abstract_df.iloc[3, 2:].reset_index().rename(columns={"index": "报告期", 3: "净利润"})
    a["报告期"] = pd.to_datetime(a["报告期"])
    using_df = a[a.loc[:, "报告期"].dt.month == month].iloc[:10]
    avg = using_df["净利润"].mean()
    std = np.std(using_df["净利润"])
    return (using_df.iloc[0, 1] - avg) / std


def calculate_deltaroeq(month, code_str):
    stock_financial_abstract_df = ak.stock_financial_abstract(symbol=code_str)
    a = stock_financial_abstract_df.iloc[11, 2:].reset_index().rename(columns={"index": "报告期", 11: "ROE"})
    a["报告期"] = pd.to_datetime(a["报告期"])
    using_df = a[a.loc[:, "报告期"].dt.month == month].iloc[:2]
    return using_df.iloc[0, 1] - using_df.iloc[1, 1]


def calculate_AOG(code_str, date):
    # 计算股票的跳空jump
    next_day = ak.stock_zh_a_hist(symbol=code_str, period="daily",
                                  start_date='{:%Y%m%d}'.format(date + pd.Timedelta(days=1)),
                                  end_date='{:%Y%m%d}'.format(date + pd.Timedelta(days=10)), adjust="")
    last_day = ak.stock_zh_a_hist(symbol=code_str, period="daily",
                                  start_date='{:%Y%m%d}'.format(date - pd.Timedelta(days=2)),
                                  end_date='{:%Y%m%d}'.format(date), adjust="")
    jump = next_day.loc[0, "开盘"] / last_day.loc[len(last_day) - 1, "收盘"]

    # 计算中证500的跳空zz500_jump
    zz500_next_day = ak.stock_zh_index_daily_em(symbol="sh000905",
                                                start_date='{:%Y%m%d}'.format(date + pd.Timedelta(days=1)),
                                                end_date='{:%Y%m%d}'.format(date + pd.Timedelta(days=10)))
    zz500_last_day = ak.stock_zh_index_daily_em(symbol="sh000905",
                                                start_date='{:%Y%m%d}'.format(date - pd.Timedelta(days=2)),
                                                end_date='{:%Y%m%d}'.format(date))
    zz500_jump = zz500_next_day.loc[0, "open"] / zz500_last_day.loc[len(zz500_last_day) - 1, "close"]

    # 对两者进行求差获得AOG
    aog = jump - zz500_jump
    return aog


# 计算分析师一致预期净利润调整幅度，从readonly数据库导入。

query = "select * from research.factor_avgest_rolling_uqer where trddt='20230411'"
factor_avgest_rolling_uqer = pd.read_sql_query(query, CONN_RESEARCH_readonly)





stage_pivot = pool_of_all_april.pivot(index="trddt", columns="股票代码", values="tier")
columns = [getwindstockcode(x) for x in stage_pivot.columns]
stage_pivot.fillna(0, inplace=True)
stage_pivot.columns = columns
stage_pivot.to_csv("score.csv")
print(columns, stage_pivot)
