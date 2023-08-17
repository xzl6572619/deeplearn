import akshare as ak
import pandas as pd
import datetime
import numpy as np

pd.set_option("display.max_rows", None)
pd.set_option("display.width", 1000)

import sqlalchemy

pd.set_option("display.max_columns", None)

CONN_RESEARCH_readonly = sqlalchemy.create_engine(
    'mysql+pymysql://readonly:Only4$Reading@home.jinxiong.work:53306/research')
query = "select * from research.fs_fdmt_express_uqer where trddt>=2018 and windcode = '688126.SH'"
res = pd.read_sql_query(query, CONN_RESEARCH_readonly)
print(res)
