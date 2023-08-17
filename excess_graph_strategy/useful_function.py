from datetime import date, datetime
import numpy as np
import akshare as ak
import pandas as pd

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


def get_yjgg_data_base_year_month(year, month):  # 获取业绩快报的数据，包括业绩快报的公告日期；所快报的报告期；股票代码；净利润；净利润增长率。
    statement_stage_list = calculte_statement_stage(year, month)
    df_list = []
    for statement_stage in statement_stage_list:
        df = ak.stock_yjkb_em(date=datetime.strftime(statement_stage, "%Y%m%d"))[
            ["股票代码", "净利润-同比增长", "净利润-净利润", "净资产收益率", "公告日期"]]
        df["accounting_period"] = statement_stage
        df_list.append(df)
    df_all = pd.concat(df_list, ignore_index=True)
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


def get_roe_data(code, act_prd):  # 该函数输入股票代码和报告期，获得该股票在相关报告期的ROE数据。
    act_prd_str = datetime.strftime(act_prd, "%Y%m%d")
    stock_financial_abstract_df = ak.stock_financial_abstract(symbol=code)
    roe = stock_financial_abstract_df.loc[11, act_prd_str]
    return roe


if __name__ == "__main__":
    d = get_sue_data("600004")
    d.to_csv("stock_financial_abstract_600004.csv")
    print(d.columns[5], type(d.columns[5]))
