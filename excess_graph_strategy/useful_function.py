from datetime import date, datetime
import numpy as np
import akshare as ak
import pandas as pd
import sqlalchemy

pd.set_option("display.max_columns", None)
pd.set_option("display.width", 1000)
pd.set_option('display.unicode.ambiguous_as_wide', True)
pd.set_option('display.unicode.east_asian_width', True)


def calculte_statement_stage(year: int, month: int):  # 用来获取每年每个月份所采用的报告期：input:月份和年份；return：报告期
    month_stage_dic = {1: [date(year - 1, 9, 30), date(year - 1, 12, 31)],
                       2: [date(year - 1, 12, 31), date(year, 3, 31)],
                       3: [date(year - 1, 12, 31), date(year, 3, 31)],
                       4: [date(year - 1, 12, 31), date(year, 3, 31)],
                       5: [date(year, 3, 31), date(year, 6, 30)],
                       6: [date(year, 3, 31), date(year, 6, 30)],
                       7: [date(year, 3, 31), date(year, 6, 30)],
                       8: [date(year, 6, 30)],
                       9: [date(year, 6, 30), date(year, 9, 30)],
                       10: [date(year, 6, 30), date(year, 9, 30)],
                       11: [date(year, 9, 30), date(year, 12, 31)],
                       12: [date(year, 9, 30), date(year, 12, 31)]}
    statement_stage = month_stage_dic[month]
    return statement_stage


def get_yysj_data_base_year_month(year, month):
    statement_stage_list = calculte_statement_stage(year, month)
    df_list = []
    for statement_stage in statement_stage_list:
        df = ak.stock_yysj_em(date=datetime.strftime(statement_stage, "%Y%m%d"))
        df["accounting_period"] = statement_stage
        df_list.append(df)
    df_all = pd.concat(df_list, ignore_index=True)
    return df_all


def get_yygg_data_base_year_month(year, month):  # 获取业绩快报的数据，包括业绩快报的公告日期；所快报的报告期；股票代码；净利润；净利润增长率；净资产收益率。
    statement_stage_list = calculte_statement_stage(year, month)
    df_kb_list = []  # 业绩快报数据
    for statement_stage in statement_stage_list:
        df = ak.stock_yjkb_em(date=datetime.strftime(statement_stage, "%Y%m%d"))[
            ["股票代码", "净利润-同比增长", "净利润-净利润", "净资产收益率", "公告日期"]]
        df["accounting_period"] = statement_stage
        df_kb_list.append(df)
    df_kb_all = pd.concat(df_kb_list, ignore_index=True)

    df_yg_list = []  # 业绩预告数据
    for statement_stage in statement_stage_list:
        df = ak.stock_yjyg_em(date=datetime.strftime(statement_stage, "%Y%m%d"))
            # ]

        filter = df.loc[:, "预测指标"] == "归属于上市公司股东的净利润"
        df = df.loc[filter, ["股票代码", "业绩变动同比", "预测数值", "公告日期"]]
        df.insert(3, "净资产收益率", np.NAN)
        df["accounting_period"] = statement_stage
        df_yg_list.append(df)
    df_yg_all = pd.concat(df_yg_list, ignore_index=True)
    df_yg_all.columns = ["股票代码", "净利润-同比增长", "净利润-净利润", "净资产收益率", "公告日期"]

    df_all = pd.concat([df_kb_all, df_yg_all], ignore_index=True)
    return df_all


def getwindstockcode(numcode):
    if isinstance(numcode, str):
        if '.' in numcode:
            windcode = numcode
            return windcode
        else:
            if numcode[:6].isdigit():
                numstr = numcode[:6]
            elif numcode[-6:].isdigit():
                numstr = numcode[-6:]
            else:
                return np.nan
            numcode = int(numstr)
    fdgt = numcode // 100000
    if fdgt in [4, 8]:
        tail = 'BJ'
    elif numcode < 500000:
        tail = 'SZ'
    else:
        tail = 'SH'
    windcode = "{:06.0f}.{}".format(numcode, tail)
    return windcode


def stage_tier_func(x):
    if x <= pd.Timedelta(days=0):
        return 1
    elif x <= pd.Timedelta(days=10):
        return 3
    elif x <= pd.Timedelta(days=20):
        return 2
    else:
        return 1


# TODO :
def rebalancing_day(dt):  # 输入月份来获取该月调仓的日期设定，比如五六月份只在月初调仓，月中不变。
    m = dt.month
    d = dt.day

    not_reblc_month_list = [5, 6, 9, 11, 12]


def get_sue_data(code=None):
    stock_financial_abstract_df = ak.stock_financial_abstract(symbol=code)
    return stock_financial_abstract_df


def get_roe_df():
    # sim数据库
    CONN_sim = sqlalchemy.create_engine('mysql+pymysql://root:xld6572619@192.168.3.60:3307/bond')

    query = '''SELECT
                code,
                `日期` as period,
                max(`净资产收益率`) as ROE
            FROM
                stock_financial_abstract
            GROUP BY
                code,
                `日期`
                '''
    rROE = pd.read_sql_query(query, CONN_sim)
    rROE.loc[rROE.loc[:, "ROE"] == '--', "ROE"] = np.NAN
    rROE.loc[:, "period"] = pd.to_datetime(rROE.loc[:, "period"])

    rROE.loc[:, "ROE"] = rROE["ROE"].astype('float')  # 此时的数据就是最终要用的ROE数据
    return rROE


def trddt_range(start_date, end_date):
    CONN_sim = sqlalchemy.create_engine('mysql+pymysql://root:xld6572619@192.168.3.60:3307/bond')
    query = "select distinct trddt from bond.quote_ashareeod_wind where trddt>='{0:%Y%m%d}' and trddt<='{1:%Y%m%d}'".format(
        start_date, end_date)
    trddt_df = pd.read_sql_query(query, CONN_sim)
    return trddt_df


if __name__ == "__main__":
    # start = date(2020, 1, 1)
    # end = date(2020, 12, 31)
    # trddt_range = trddt_range(start, end)
    # print(trddt_range)
    data = get_roe_df()

    print(data.loc[data.loc[:, "code"] == "688295", :])
