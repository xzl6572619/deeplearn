import datetime
import threading

import matplotlib.pyplot as plt
import numpy as np
import utils
import sqlalchemy

import pandas as pd

pd.set_option('display.max_rows', 5000)
pd.set_option('display.max_columns', 1000)
pd.set_option('display.width', 100)
pd.set_option('mode.chained_assignment', None)
pd.set_option('display.precision', 2)
pd.set_option('display.float_format', '{:,.2f}'.format)

NONE_PCT_LIST = ['sharpe', 'avg_evt_num']

# get data from read_only MYSQL
CONN_RESEARCH = sqlalchemy.create_engine('mysql+pymysql://readonly:Only4$Reading@home.jinxiong.work:53306/research')
d1 = datetime.date(2023, 3, 25)
d2 = datetime.date(2023, 4, 30)
query = "SELECT * from quote_ashareeod_wind where trddt>='{}' and trddt<='{}'".format(d1, d2)
data_sql = pd.read_sql_query(query, CONN_RESEARCH)
data = data_sql[
    ['trddt', 'windcode', 'clsprc', 'preclose', 'opprc', 'pctchange', 'vol', 'amt', "prclmtsts", 'tradests', 'avgprc']]
data.columns = ['trddt', 'windcode', 'close', 'preclose', 'open', 'pctchange', 'vol', 'amt', "udstatus", 'tradestatus',
                'avg']
print(data)
# 获取指数数据
import akshare as ak

'''
def get_ashare_info():
    info = get_data('secid')
    ashare = info['exchangeCD'].isin(['XSHG', 'XSHE']) & (info['assetClass'] == 'E') & (
        info['ticker'].apply(lambda x: x[0] in ['0', '3', '6']))
    ashare_info = info.loc[ashare]
    ashare_info['windcode'] = ashare_info['aiq_ticker'].apply(utils.getwindstockcode)
    return ashare_info
'''
'''
def get_mktequd_data(start_date, end_date=None):
    if end_date is None:
        tpdata = get_data('mktequd', start_date,
                          cols=['closePrice', 'preClosePrice', 'openPrice', 'marketValue', 'chgPct', 'turnoverVol',
                                'turnoverValue', 'isOpen', 'vwap'])
    else:
        tpdata = get_data('mktequd', start_date, end_date, cols=['closePrice', 'preClosePrice', 'openPrice',
                                                                 'marketValue', 'chgPct', 'turnoverVol',
                                                                 'turnoverValue', 'isOpen', 'vwap'])
    mktequd_data = tpdata[
        ['aiq_date', 'aiq_ticker', 'closePrice', 'preClosePrice', 'openPrice', 'marketValue', 'chgPct', 'turnoverVol',
         'turnoverValue', 'isOpen', 'vwap']]
    mktequd_data.columns = ['trddt', 'windcode', 'close', 'preclose', 'open', 'totalvalue', 'pctchange', 'vol', 'amt',
                            'tradestatus', 'avg']
    return mktequd_data
'''
'''
def get_mktlimit_data(start_date, end_date=None):
    if end_date is None:
        tpdata = get_data('mktlimit', start_date, cols=['limitUpPrice', 'limitDownPrice'])
    else:
        tpdata = get_data('mktlimit', start_date, end_date, cols=['limitUpPrice', 'limitDownPrice'])
    tpdata = tpdata[['aiq_date', 'aiq_ticker', 'limitUpPrice', 'limitDownPrice']]
    tpdata.columns = ['trddt', 'windcode', 'limitup', 'limitdown']
    return tpdata
'''


class AshareData(object):
    _instance_lock = threading.Lock()
    known_data = {}

    def __init__(self):
        if not hasattr(self, '_inited'):
            self.known_data = {}
            #             udstatus
            data_start = 20180103  # 行情数据起始时间
            date_end = int(utils.tradingdate().strftime('%Y%m%d'))
            tpfs = 20170630  # 财务（eps）数据起始时间
            self.bench_num_codes = [16, 905, 906, 300, 852]  # 基准指数代码

            # -------------------begin of extracting data-------------------
            att_cols = ['trddt', 'windcode', 'close', 'preclose', 'open', 'pctchange', 'vol', 'amt', "udstatus",
                        'tradestatus', 'avg']
            mktequd_data = data
            mktequd_data["pctchange"] = mktequd_data["pctchange"]/100
            mktequd_data.drop_duplicates(['trddt', 'windcode'], keep='first', inplace=True)
            for col in att_cols:
                df = mktequd_data.pivot(index='trddt', columns='windcode', values=col)
                df.index = [datetime.datetime.strptime(str(x), '%Y-%m-%d').date() for x in df.index]
                df.columns = [utils.getwindstockcode(x) for x in df.columns]
                self.known_data[col] = df
            self.known_data["udstatus"].fillna(0,inplace=True)




            '''
            att_cols = ['limitup', 'limitdown']
            limit_data = get_mktlimit_data(data_start, date_end)
            limit_data.drop_duplicates(['trddt', 'windcode'], keep='first', inplace=True)
            for col in att_cols:
                df = limit_data.pivot(index='trddt', columns='windcode', values=col)
                df.index = [datetime.datetime.strptime(str(x), '%Y%m%d').date() for x in df.index]
                df.columns = [utils.getwindstockcode(x) for x in df.columns]
                self.known_data[col] = df
            '''

            '''
            tpdata = get_data('secst', data_start, date_end)
            tpdata['is_st'] = 1
            tpdata = tpdata[['aiq_date', 'aiq_ticker', 'is_st']]
            tpdata.columns = ['trddt', 'windcode', 'is_st']
            tpdata.drop_duplicates(['trddt', 'windcode'], keep='first', inplace=True)
            df = tpdata.pivot(index='trddt', columns='windcode', values='is_st').fillna(0)
            df.index = [datetime.datetime.strptime(str(x), '%Y%m%d').date() for x in df.index]
            df.columns = [utils.getwindstockcode(x) for x in df.columns]
            self.known_data['is_st'] = df
            '''

            '''
            tpdata = get_data('fdmtmaindataqpit', tpfs, date_end, cols=['publishDate', 'eps'])
            tpdata = tpdata[['publishDate', 'aiq_ticker', 'eps']]
            tpdata.columns = ['trddt', 'windcode', 'eps_sq']
            tpdata['trddt'] = tpdata['trddt'].apply(lambda x: datetime.datetime.strptime(str(x), '%Y%m%d').date())
            tpdata['trddt'] = tpdata['trddt'].apply(lambda x: utils.tradingdate(x, offset=1))
            tpdata.drop_duplicates(['trddt', 'windcode'], keep='first', inplace=True)
            df = tpdata.pivot(index='trddt', columns='windcode', values='eps_sq')
            df.columns = [utils.getwindstockcode(x) for x in df.columns]
            self.known_data['eps_sq'] = df
            '''

            # 获取指数数据
            '''
            tpdata = get_data('idxd', data_start, date_end, cols=['ticker', 'closeIndex', 'CHGPct'])
            good = tpdata['ticker'].apply(len) == 6
            tpdata = tpdata.loc[good]
            good = tpdata['ticker'].apply(lambda x: x.isdigit())
            tpdata = tpdata.loc[good]
            tpdata['numcode'] = tpdata['ticker'].astype(int)
            good = tpdata['numcode'].isin(self.bench_num_codes)
            tpdata = tpdata.loc[good]
            tpdata['trddt'] = tpdata['aiq_date'].apply(lambda x: datetime.datetime.strptime(str(x), '%Y%m%d').date())
            tpdata.sort_values(['ticker', 'trddt'], inplace=True)
            tpdata.set_index('trddt', inplace=True)
            '''

            bench_rtn = {}
            bench_close = {}
            for x in self.bench_num_codes:
                # 另外两种形式的键
                windcode = "{:06d}.SH".format(x)
                ticker = windcode[:6]

                # 获取指数的数据，并计算
                index_df = ak.stock_zh_index_daily_tx(symbol="sh{:06d}".format(x))
                index_df["date"] = pd.to_datetime(index_df["date"])
                index_df.set_index("date", inplace=True)
                index_df["preclose"] = index_df["close"].shift()
                index_df["CHGPct"] = (index_df["close"] - index_df["preclose"]) / index_df["preclose"]  # 计算指数的pct变化

                # 定义词典
                bench_rtn[windcode] = index_df['CHGPct']
                bench_rtn[x] = bench_rtn[windcode]
                bench_rtn[ticker] = bench_rtn[windcode]
                bench_close[windcode] = index_df['close']
                bench_close[x] = bench_close[windcode]
                bench_close[ticker] = bench_close[windcode]

            self.bench_rtn = bench_rtn
            self.bench_close = bench_close
            # ------------------- end of extracting data -------------------

            # self.ashare_info = get_ashare_info()
            s1 = set(self.close.columns)
            # s2 = set(self.ashare_info['windcode'])
            self.windcode = sorted(list(s1))

            self.trddt = list(self.close.index)

            self.prepare_derived_data()
            self._inited = True

    def __new__(cls, *args, **kwargs):
        if not hasattr(AshareData, "_instance"):
            with AshareData._instance_lock:
                if not hasattr(AshareData, "_instance"):
                    AshareData._instance = object.__new__(cls, *args, **kwargs)
        return AshareData._instance

    def __getattr__(self, item):
        if item in self.known_data:
            return self.known_data[item]
        else:
            raise AttributeError("Attribute '{}' for AshareData not defined.".format(item))

    def prepare_derived_data(self):
        for col in self.known_data:
            self.known_data[col] = self.reindex(self.known_data[col])
        # self.eps_sq = utils.fill_with_prev(self.eps_sq)
        self.tradestatus = self.tradestatus.fillna(0).astype(int)
        # self.udstatus = (self.close == self.limitup).astype(int) - (self.close == self.limitdown).astype(int)
        # self.udstatus在从数据库导入的数据里已经有了
        self.capscore = None
        self.listed_days = (~pd.isnull(self.close)).cumsum()

        # 获取指数成分股权重数据
        '''
        tpfs = int((self.close.index[0] - datetime.timedelta(days=90)).strftime('%Y%m%d'))
        idx_weight_data = get_data('midxcloseweight', tpfs, cols=['ticker', 'effDate', 'consTickerSymbol', 'weight'])
        idx_weight_data = idx_weight_data[['ticker', 'effDate', 'consTickerSymbol', 'weight']]
        idx_weight_data.columns = ['index_code', 'trddt', 'windcode', 'weight']
        idx_weight_data['weight'] = idx_weight_data['weight'] / 100
        bench_weight = {}
        for x in self.bench_num_codes:
            windcode = "{:06d}.SH".format(x)
            ticker = windcode[:6]

            tpw = idx_weight_data.loc[idx_weight_data['index_code'] == ticker].pivot(index='trddt', columns='windcode',
                                                                                     values='weight')
            tpw.index = [datetime.datetime.strptime(str(x), '%Y%m%d').date() for x in tpw.index]
            tpw.index = [utils.tradingdate(x, forward=True) for x in tpw.index]
            tpw.columns = [utils.getwindstockcode(x) for x in tpw.columns]
            bench_weight[windcode] = utils.fill_with_prev(self.reindex(tpw.fillna(0))).fillna(0)
            bench_weight[x] = bench_weight[windcode]
            bench_weight[ticker] = bench_weight[windcode]
        self.bench_weight = bench_weight
        '''

    def exclude_st(self, score, rtn=False):
        filt1 = self.is_st.reindex(index=score.index, columns=score.columns) > 0
        #         filt2 = self.is_delist.reindex(index=score.index, columns=score.columns) > 0
        if rtn:
            score = score.copy()
        #         score[filt1 | filt2] = -10
        score[filt1] = np.nan
        if rtn:
            return score

    def exclude_new_stock(self, score, ndays=125, rtn=False):
        filt = utils.info_lag(self.listed_days.reindex(index=score.index, columns=score.columns), 1) < ndays
        if rtn:
            score = score.copy()
        score[filt] = np.nan
        if rtn:
            return score

    def exclude_neg_eps(self, score, rtn=False):
        filt = utils.info_lag(self.eps_sq.reindex(index=score.index, columns=score.columns), 1) < 0
        if rtn:
            score = score.copy()
        score[filt] = np.nan
        if rtn:
            return score

    def exclude_neg_risk_new(self, score):
        self.exclude_new_stock(score)
        self.exclude_st(score)
        self.exclude_neg_eps(score)

    def reindex(self, data):
        return data.reindex(index=self.trddt, columns=self.windcode, fill_value=np.nan)

    def bench_filter(self, data, code):
        res = data.copy()
        filt = self.bench_weight[code] > 0
        res[~filt] = np.nan
        return res


class Backtest():
    _instance_lock = threading.Lock()

    def __init__(self, data_obj):
        if not hasattr(self, '_inited'):
            self.data = data_obj
            self.windcode = self.data.windcode
            self.adjpq = {}
            self.adjpq['close'] = self.data.udstatus
            for prc in ['avg', 'open']:
                tppq = self.data.udstatus.fillna(0)
                tppq[self.data.close != self.data.open] = 0
                self.adjpq[prc] = tppq
            self._inited = True

    def __new__(cls, data_obj, *args, **kwargs):
        if not hasattr(Backtest, "_instance"):
            with Backtest._instance_lock:
                if not hasattr(Backtest, "_instance"):
                    Backtest._instance = object.__new__(cls, *args, **kwargs)
        return Backtest._instance

    def bkt_port(self, pos=None, score=None, fw=0.01, sw=1.2, fee_rate=0.0008,
                 bench='000905.SH', dealprice='close', event_num=None, plot=True,
                 neg_alpha=False, short_cost=0.0003, port_val=1e7,
                 vol_lim=0.05, trade_lim=0.55, dec_wr=1):
        # pos 传入一个目标持仓df 与score参数互斥
        # score 传入一个目标持仓df 与pos参数互斥
        # fw score模式下个股持仓的基准权重，0.01指分数最高的股票分配1%目标权重
        # sw score模式下卖出股票的阈值权重，如fw为0.01 sw为1.2，则代表除分数最高的前120个股票外，其余股票目标持仓变为0
        # fee_rate单边手续费率，万三+印花税对应数值应为(0.0003*2+0.001)/2=0.0008
        # bench基准指数代码，可接受'000905', '000905.SH', 905三种类型
        # dealprice计算当日成家价格选用的价格，默认为close, 可选avg和open。不建议使用open
        # event_num 不重要，忽略这个参数
        # plot画图开关 bool类型
        # neg_alpha 测试负超额开关，由于费用计算方式不同所以逻辑不同，负超额回测时，fee_rate应该设置为负数。
        # short_cost 融券单日成本
        # port_val 组合总市值，用于计算个股成交额占比是否超标。
        # vol_lim 用于控制个股交易额占该个股总成交额的占比，默认0.05。如果个股成交额限制无法满足交易，则由排名靠后的其他股票补充
        # trade_lim 单次交易换手率限制（单边），超过限制部分的交易会被忽略
        # dec_wr score模式下权重衰减系数，默认为1。如果设置为0.9，fw为0.1的情况下：分数最高个股目标权重为0.1第二名为0.09，第三名为0.08以此类推。



        rtns = self.data.pctchange.copy()
        rtns.to_csv("rtns.csv")
        pos_out = pd.DataFrame(np.zeros(rtns.shape), index=rtns.index, columns=rtns.columns)

        start_dt = score.index[0]


        rtn_before_trade = rtns
        rtn_after_trade = pd.Series(np.zeros(len(rtns.index)), index=rtns.index)


        temp_pos = pd.Series(data=np.zeros(len(rtns.columns)), index=rtns.columns)
        fee = pd.Series(np.zeros(len(rtns.index)), index=rtns.index)
        daily_rtn = pd.Series(np.zeros(len(rtns.index)), index=rtns.index)
        turnover = pd.Series(np.zeros(len(rtns.index)), index=rtns.index)
        for date in rtns.index[6:]:

            if date < start_dt:
                continue

            if score is None:
                trade_today = date in pos.index
            else:
                trade_today = date in score.index

            pos_rtn = (temp_pos * rtns.loc[date]).sum()
            trade_rtn = 0

            if trade_today:
                # pos adjusted by rtns
                # orig_pos = temp_pos.copy()
                temp_pos = temp_pos * (1 + rtns.loc[date])
                temp_pos = temp_pos / temp_pos.sum()


                # 此处if结构需要想办法优化。
                if score is None:
                    this_pos = pos.loc[date]
                else:
                    this_pos, _pos_cal = self.get_pos_on_score_new(temp_pos, score, date,
                                                                   fw, sw, port_val,
                                                                   vol_lim, trade_lim, dealprice, dec_wr)

                print("this_pos", this_pos)


                diff = this_pos - temp_pos
                '''
                temp_sell = diff < 0
                temp_buy = diff > 0
                tradable = (self.data.tradestatus.loc[date] == 4) & (self.adjpq[dealprice].loc[date] == 0)
                unfilled_buy = diff[~tradable & temp_buy].sum()
                unfilled_sell = diff[~tradable & temp_sell].sum()
                if abs(unfilled_sell) > abs(unfilled_buy):
                    to_buy = diff[tradable & temp_buy].sum()

                    adjr = (abs(unfilled_sell) - abs(unfilled_buy)) / to_buy
                    diff[tradable & temp_buy] = (1 - adjr) * diff[tradable & temp_buy]

                diff[~tradable] = 0
                fee.loc[date] = np.abs(diff).sum() * fee_rate
                trade_rtn = (diff * rtn_after_trade.loc[date]).sum()
                temp_pos += diff
                '''
                temp_pos = this_pos

                turnover.loc[date] = np.abs(diff).sum()
            else:
                # no trade
                temp_pos = temp_pos * (1 + rtns.loc[date])
                temp_pos = temp_pos / temp_pos.sum()

            pos_out.loc[date] = temp_pos
            daily_rtn.loc[date] = pos_rtn + trade_rtn - fee.loc[date]
            port_val = port_val * (1 + daily_rtn.loc[date])

        daily_rtn[:start_dt] = 0
        daily_rtn.to_csv("daily_return.csv")
        if neg_alpha:
            daily_rtn[start_dt:] = daily_rtn[start_dt:] + short_cost

        nav = (1 + daily_rtn).cumprod()
        if bench is None:
            alpha_nav = None
            bench_nav = None
        else:
            bench_rtn = self.data.bench_rtn[bench].copy()
            daily_alpha = daily_rtn - bench_rtn
            daily_alpha[:start_dt] = 0
            bench_rtn = bench_rtn.loc[start_dt:]
            bench_rtn.iloc[0] = 0
            bench_nav = (1 + bench_rtn).cumprod()  # starts from pos
            # alpha_nav = (1 + daily_alpha).cumprod()

        # bkt returns
        cap_dist = (pos_out * self.data.capscore).sum(axis=1)
        cap_dist = cap_dist.loc[start_dt:]
        nav_out = nav.loc[start_dt:]
        pos_out = pos_out.loc[start_dt:]

        alpha_nav = nav_out / bench_nav
        alpha_out = alpha_nav.loc[start_dt:]

        nhold = (pos_out > 0).sum(axis=1)

        # plot
        if plot:
            fig, axis = plt.subplots(2, 2)
            nav_out.plot(ax=axis[0, 0])
            if bench is not None:
                bench_nav.plot(ax=axis[0, 0])
            cap_dist.plot(ax=axis[0, 1])
            alpha_out.plot(ax=axis[1, 0])
            nhold.plot(ax=axis[1, 1])

            axis[0, 0].set_title("nav")
            axis[0, 0].legend(['port', 'benchmark'])
            axis[0, 1].set_title("cap dist")
            axis[1, 0].set_title("alpha nav")
            axis[1, 1].set_title("number of stocks")
            if event_num is not None:
                event_num = event_num.loc[start_dt:]
                event_num.plot(ax=axis[1, 1], drawstyle='steps-post')
                axis[1, 1].set_title("number of stocks and events")
                axis[1, 1].legend(['stocks', 'events'])
                # for bar and line together see
                # https://stackoverflow.com/questions/38810009/matplotlib-plot-bar-and-line-charts-together
        else:
            fig = None

        # cal risk-return indicators and store them in variable "results"
        result = utils.curveanalysis(alpha_out)
        result['turnover'] = turnover.loc[start_dt:].mean()
        if event_num is not None:
            result['avg_evt_num'] = event_num.mean()
        result['aot'] = result['alzdrtn'] / result['turnover'] / 250
        print('')
        for key, val in result.items():
            if key in NONE_PCT_LIST:
                print("{:>20s}: {:.4f}".format(key, val))
            else:
                print("{:>20s}: {:.2%}".format(key, val))

        print((alpha_out.pct_change().iloc[-5:].round(4) * 10000).astype(int))
        result['fig'] = fig

        return (nav_out, pos_out, alpha_out, result)

    def get_pos_on_score_new(self, lst_pos, score, date, fw, sw, port_val, vol_lim, trade_lim, dealprice, dec_wr):
        if np.all(pd.isnull(score.loc[date])):
            return lst_pos, None
        else:
            yst = utils.tradingdate(date, offset=-1)
            tpud = self.adjpq[dealprice].loc[date]
            tpts = self.data.tradestatus.loc[date]
            tpamt = self.data.amt.loc[yst]
            trade = pd.concat([lst_pos, score.loc[date], tpud, tpts, tpamt], axis=1, sort=False)
            trade.columns = ['weight', 'score', 'udstatus', 'tradestatus', 'amt']

            trade = utils.gen_port_by_score_with_vol_adj_2(trade, fw, sw, port_val, vol_lim, trade_lim, dec_wr, date)
            trade['new_pos'] = trade['new_pos'].fillna(0)
            trade.to_csv(r"D:\py\平台回测demo\trade_new_pos\trade_newpos{}.csv".format(date))
            return trade['new_pos'], trade
