import threading
import pandas as pd
import numpy as np
from tqdm import trange
from new_backtest.calculation import *


# 二维pivot数据以时间为columns， 以股票为index.

class DATA(object):
    _instance_lock = threading.Lock()
    known_data = {}

    def __new__(cls, *args, **kwargs):
        if not hasattr(DATA, "_instance"):
            with DATA._instance_lock:
                if not hasattr(DATA, "_instance"):
                    DATA._instance = object.__new__(cls)
        return DATA._instance

    # 传入的source数据必须要结构化，columns日期"trddt"；代码为"code"。
    def __init__(self, source):

        if not hasattr(self, '_inited'):
            self._inited = True
            self.known_data = {'close': None, 'preclose': None, 'open': None, 'pctchange': None, 'vol': None,
                               'amt': None, "udstatus": None,
                               'tradestatus': None, 'avg': None}
            for data_name in self.known_data:
                pivot_table = source.pivot(index="code", columns="trddt", values=data_name)
                self.known_data[data_name] = pivot_table

    # 为了避免定义属性环节过于冗杂，故使用__getattr__方法。
    def __getattr__(self, attr_name):
        if attr_name in self.known_data:
            return self.known_data[attr_name]
        else:
            raise AttributeError("Attribute '{}' for AshareData not defined.".format(attr_name))

    # 获取打分数据，在这之前要将分数数据结构化
    def get_score_data(self, score):
        # 首先获取数据框架frame，以让其与其他价格数据等对应
        self.score_frame = pd.DataFrame(columns=self.close.columns, index=self.close.index)
        self.score_frame.update(score)


class BACK_TEST:
    _instance_lock = threading.Lock()

    def __new__(cls, *args, **kwargs):
        if not hasattr(BACK_TEST, "_instance"):
            with BACK_TEST._instance_lock:
                if not hasattr(BACK_TEST, "_instance"):
                    BACK_TEST._instance = object.__new__(cls)
        return BACK_TEST._instance

    # 初始化从DATA类中获取数据，作为我进行回测的资源，这是获取原材料
    # 然后再进一步构建工程线，去加工获得的原材料，即BACK_TEST类里面的method(方法)
    def __init__(self, data_object):
        if not hasattr(self, '_inited'):
            self.data = data_object

            # 初始化账户数据等，作为计量策略表现的依据
            self.TOTAL_position = pd.DataFrame(np.zeros(self.data.close.shape),
                                               index=self.data.close.index, columns=self.data.close.columns)
            self.position_DAILY_return = pd.Series(data=np.zeros(len(self.data.close.columns)),
                                                   index=self.data.close.columns)
            self._inited = True
            self.net_value_change = None
            self.turnover = pd.DataFrame(np.zeros(self.data.close.shape),
                                         index=self.data.close.index, columns=self.data.close.columns)

    def start_test(self, number_of_stock=100, weight_of_topstock=0.01, weight_decreaseing_rate=0.95,
                   principle=1000000):  # 开始回测的过程
        length = len(self.data.close.columns)

        for i in trange(1, length):
            calculate_table = pd.concat([self.TOTAL_position.loc[:, self.data.close.columns[i - 1]],
                                         self.data.score_frame.loc[:, self.data.close.columns[i - 1]]], axis=1)
            # calculate_table.to_csv("calculate_table_{}.csv".format(i))
            calculate_table.columns = ["present_position", "score"]



            new_position = cal_new_position(calculate_table, weight_of_topstock,
                                            weight_decreaseing_rate).loc[:, "weight"]  # 根据score进行排名并分配权重
            # new_position.to_csv("new_position_{}.csv".format(i))
            self.TOTAL_position.loc[:, self.data.close.columns[i]].update(new_position)  # 对TOTAL_position进行更新

        stock_position_change = (self.data.pctchange / 100) * self.TOTAL_position  # 计算每只股票贡献的增长率
        totalposition_change = stock_position_change.sum().T  # 将所有股票贡献的成长率加总，获得position的增长率
        self.net_value_change = (1 + totalposition_change).cumprod() * principle  # 计算本金的变动情况
