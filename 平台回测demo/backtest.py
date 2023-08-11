import bkt_engine
import utils
from aiqlib import get_data, get_trade_date
import time, datetime
import threading
import numpy as np
import pandas as pd
import math
pd.set_option('display.max_rows',20)
pd.set_option('display.max_columns',10)
pd.set_option('display.width',100)
pd.set_option('mode.chained_assignment',None)
pd.set_option('display.precision',2)
pd.set_option('display.float_format','{:,.2f}'.format)
import matplotlib
import matplotlib.pyplot as plt
import os


jsd = bkt_engine.AshareData()
jsbkt = bkt_engine.Backtest(jsd)
