import threading
import pandas as pd
import numpy as np


# 二维pivot数据以时间为columns， 以股票为index.

class DATA:
    _instance_lock = threading.Lock()
    

    def __new__(cls, *args, **kwargs):
        if not hasattr(DATA, "_instance"):
            with DATA._instance_lock:
                if not hasattr(DATA, "_instance"):
                    DATA._instance = object.__new__(cls, *args, **kwargs)
        return DATA._instance
    
    # 传入的source数据必须要结构化，columns日期"trddt"；代码为"code"。
    def __init__(self, source):

        if not hasattr(self, '_inited'):
            self.known_data = {'close': None, 'preclose': None, 'open': None, 'pctchange': None, 'vol': None, 'amt': None, "udstatus": None,
                        'tradestatus': None, 'avg': None}
            for data_name in self.known_data:
                pivot_table = source.pivot(index="code", columns="trddt", values=data_name)
                self.known_data[data_name] = pivot_table
            self._inited = True
        
        
    # 为了避免定义属性环节过于冗杂，故使用__getattr__方法。
    def __getattribute__(self, __name):
        if __name in self.known_data:
            return self.known_data[__name]
        else:
            raise AttributeError(f"Attribute '{__name}' for AshareData not defined.")
        
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
                    BACK_TEST._instance = object.__new__(cls, *args, **kwargs)
        return BACK_TEST._instance
    
    # 初始化从DATA类中获取数据，作为我进行回测的资源，这是获取原材料
    # 然后再进一步构建工程线，去加工获得的原材料，即BACK_TEST类里面的method(方法)
    def __init__(self, data_object):
        if not hasattr(self, '_inited'):
            self.data = data_object
            self._inited = True

            # 初始化账户数据等，作为计量策略表现的依据
            self.TOTAL_position = pd.DataFrame(np.zeros(self.data.close.shape),
                                               index=self.data.close.index, columns=self.data.close.columns)
            self.position_DAILY_return = pd.Series(data=np.zeros(len(self.data.close.columns)), index=self.data.close.columns)
    # 开始回测的过程


    def start_test(self, number_of_stock, weight_of_one_stock=0.01):

        for date in self.data.close.columns:





        
        

