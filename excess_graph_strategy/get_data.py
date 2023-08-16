import akshare as ak
import pandas as pd
import datetime
import numpy as np
pd.set_option("display.max_rows",None)
import sqlalchemy

CONN_RESEARCH_readonly = sqlalchemy.create_engine('mysql+pymysql://readonly:Only4$Reading@home.jinxiong.work:53306/research')
query = "select * from research.factor_fancy30_uqer where trddt>='20230401' and trddt<='20230430'"
factor_fancy30_uqer = pd.read_sql_query(query, CONN_RESEARCH_readonly)
print(factor_fancy30_uqer)
