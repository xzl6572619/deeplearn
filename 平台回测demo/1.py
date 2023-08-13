import time, datetime
import threading

from imp import reload
import numpy as np
import pandas as pd
import math

pd.set_option('display.max_rows', 20)
pd.set_option('display.max_columns', 10)
pd.set_option('display.width', 100)
pd.set_option('mode.chained_assignment', None)
pd.set_option('display.precision', 2)
pd.set_option('display.float_format', '{:,.2f}'.format)

import matplotlib
import matplotlib.pyplot as plt

import os

import utils
import bkt_engine

matplotlib.rcParams['figure.figsize'] = (20, 11.25)

score = pd.read_csv(r"D:\py\平台回测demo\score.csv")
print(score)
score["trddt"] = pd.to_datetime(score["trddt"])
score.index = score["trddt"]



jsd = bkt_engine.AshareData()
jsbkt = bkt_engine.Backtest(jsd)

frame = pd.DataFrame(np.zeros((len(jsd.close.index), len(jsd.close.columns))), index=jsd.close.index, columns=jsd.close.columns)
frame.update(score)
frame.to_csv("frame.csv")
score = utils.data2score(frame, ascending=False)
score.to_csv("score_frame.csv")


jsd.capscore = score

tpscore = utils.info_lag(1-jsd.capscore, 1)  # 按市值大小计算出score，小市值分数高
tpscore.to_csv("tpscore.csv")
bkt_start = datetime.date(2023, 4, 3)
(nav, pos_out, alpha_nav, result) = jsbkt.bkt_port(score=tpscore.loc[bkt_start:], fw=0.01, sw=1.05, dealprice='close', vol_lim=0.05, trade_lim=0.35, port_val=10e8, dec_wr=1, bench='000905.SH')