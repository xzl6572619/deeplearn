from new_backtest.ENGINIE import DATA
from new_backtest.ENGINIE import BACK_TEST
import pandas as pd
import sqlalchemy
import datetime

# get data from read_only MYSQL
CONN_RESEARCH = sqlalchemy.create_engine('mysql+pymysql://readonly:Only4$Reading@home.jinxiong.work:53306/research')
d1 = datetime.date(2023, 5, 20)
d2 = datetime.date(2023, 8, 1)
query = "SELECT * from quote_ashareeod_wind where trddt>='{}' and trddt<='{}'".format(d1, d2)
data_sql = pd.read_sql_query(query, CONN_RESEARCH)
data = data_sql[
    ['trddt', 'windcode', 'clsprc', 'preclose', 'opprc', 'pctchange', 'vol', 'amt', "prclmtsts", 'tradests', 'avgprc']]
data.columns = ['trddt', 'code', 'close', 'preclose', 'open', 'pctchange', 'vol', 'amt', "udstatus", 'tradestatus',
                'avg']

DATA_OBJ = DATA(data)
DATA_OBJ.get_score_data(DATA_OBJ.pctchange)

INS_TEST = BACK_TEST(DATA_OBJ)
INS_TEST.start_test(weight_of_topstock=0.05, weight_decreaseing_rate=0.95)

INS_TEST.net_value_change.to_csv("net_value_change.csv")
INS_TEST.turnover.to_csv("turnover.csv")
print(INS_TEST.net_value_change)
