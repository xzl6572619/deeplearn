import pandas as pd
import datetime
import numpy as np
import sqlalchemy

pd.set_option("display.max_rows", None)
pd.set_option("display.width", 1000)
pd.set_option("display.max_columns", None)


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
    rROE.astype({"ROE": "float"})  # 此时的数据就是最终要用的ROE数据
    return rROE
