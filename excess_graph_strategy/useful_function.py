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
            ["股票代码", "净利润-同比增长", "净利润-净利润", "公告日期"]]
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


if __name__ == "__main__":
    year = 2023
    month = 4
    res_df = get_yjgg_data_base_year_month(year, month)
    res_df.to_csv("{0:}{1:}.csv".format(year, month))
    print(res_df)
