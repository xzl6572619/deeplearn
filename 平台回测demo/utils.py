import datetime
import math

import numpy as np

import pandas as pd
from consts import _TRDDT_S2015, DAYS_IN_YEAR


def data2score(data, neg=True, ascending=True, axis=1, dummys=None):
    score = data.rank(axis=axis, method="first", ascending=ascending)
    if dummys is None:
        dummys = []
    if neg:
        score = score * 2 - 1
    for col in dummys:
        if col in data.columns:
            score[col] = data[col].copy()
    return pd.DataFrame(data=score, columns=data.columns, index=data.index)


def info_lag(data, n_lag):
    new_index = pd.Index([tradingdate(x, offset=n_lag) for x in data.index])
    out = data.copy()
    out.index = new_index
    return out.loc[~new_index.duplicated(keep='last')]


def tradingdate(date=None, offset=0, start=None, end=None, forward=False):
    # faster with _TRDDT_S2015 in memory
    if (start is not None):
        if isinstance(start, str):
            start = datetime.datetime.strptime(start, '%Y-%m-%d').date().toordinal()
        elif isinstance(start, datetime.date):
            start = start.toordinal()

        if end is None:
            end = datetime.date.today().toordinal()
        elif isinstance(end, str):
            end = datetime.datetime.strptime(end, '%Y-%m-%d').date().toordinal()
        elif isinstance(end, datetime.date):
            end = end.toordinal()

        return _get_dates(start, end)

    if date is None:
        date = datetime.date.today()
    elif isinstance(date, str):
        date = datetime.datetime.strptime(date, '%Y-%m-%d').date()

    ix, found = _bisearch(date.toordinal())
    if found:
        return _TRDDT_S2015[ix + offset]
    else:
        if forward:
            return _TRDDT_S2015[ix + offset]
        else:
            return _TRDDT_S2015[ix + offset - int(offset >= 0)]


def bisearch(ele, data):
    max_itr = 100
    count = 0
    end = len(data) - 1
    start = 0

    if data[-1] <= ele:
        start = end
    elif data[0] >= ele:
        end = start

    while end - start > 1:
        mid = (end + start) // 2
        count += 1

        if count > max_itr:
            break

        if data[mid] > ele:
            end = mid
        elif data[mid] < ele:
            start = mid
        else:
            start, end = mid, mid

    return (end, data[end] == ele)


def _bisearch(dtnum):
    ix_guess = int(round((dtnum - 735601) / 1.5)) - 10
    tpdates = list(_TRDDT_S2015[ix_guess: ix_guess + 20])
    (v1, v2) = bisearch(datetime.date.fromordinal(dtnum), tpdates)
    return v1 + ix_guess, v2


def _get_dates(startnum, endnum):
    s, s2 = _bisearch(startnum)
    # s = s1 + (not s2)
    e1, e2 = _bisearch(endnum)
    e = e1 + e2
    trddts = list(_TRDDT_S2015[s:e])
    return trddts


def curveanalysis(nav):
    rtn = np.diff(np.log(nav))
    avg_dt_diff = pd.Series(nav.index).apply(lambda x: x.toordinal()).diff().mean()
    if avg_dt_diff > 4:
        nperiods = 52
    else:
        nperiods = 250
    result = {}
    result['totalrtn'] = nav[-1] / nav[0] - 1
    number_of_years = (nav.index[-1].toordinal() - nav.index[0].toordinal()) / DAYS_IN_YEAR
    result['alzdrtn'] = (result['totalrtn'] + 1) ** (1 / number_of_years) - 1
    result['stdev'] = rtn.std()
    # result['vol'] = rtn.std() * np.sqrt(TRADE_DAYS_IN_YEAR)
    result['vol'] = rtn.std() * np.sqrt(nperiods)
    result['sharpe'] = result['alzdrtn'] / result['vol']
    result['maxdown'] = 1 - 1 / math.exp(maximum_drawdown(rtn))
    return result


def maximum_drawdown(data):
    min_all = 0
    sum_here = 0
    for x in data:
        sum_here += x
        if sum_here < min_all:
            min_all = sum_here
        elif sum_here >= 0:
            sum_here = 0
    return -min_all


def gen_port_by_score_with_vol_adj(trade, fw, sw, port_val, vol_lim, trade_lim, dec_wr, date):
    # gen_port_by_score_with_vol_adj: 根据trade中的信息生成一个组合：
    #   指定股票数量， 单个股票交易量按
    abspq = trade['udstatus'].abs()
    trade['no_sell'] = (trade['udstatus'] > 0) | (trade['tradestatus'] != 4)
    trade['no_buy'] = (abspq > 0) | (trade['tradestatus'] != 4)
    ignore = (trade['weight'] == 0) & trade['no_buy']
    trade.loc[ignore, 'score'] = -10000
    trade = trade.sort_values('score', ascending=False)
    trade['rank'] = np.arange(len(trade)) + 1
    # 计算市场允许的成交额上限
    trade['w_lim'] = trade['amt'] * vol_lim / port_val

    # 基础买入和卖出
    tpadj = dec_wr ** (trade['rank'] - 1)
    trade['tgt_pos'] = fw * tpadj
    bad = trade['tgt_pos'] < 0.001
    trade['tgt_pos'].loc[bad] = 0.001

    trade['tgt_trade'] = trade['tgt_pos'] - trade['weight']

    exceed = np.abs(trade['tgt_trade']) > trade['w_lim']
    trade.loc[exceed, 'tgt_trade'] = trade.loc[exceed, 'w_lim'] * np.sign(trade.loc[exceed, 'tgt_trade'])

    trade['tgt_pos'] = trade['weight'] + trade['tgt_trade']
    bad = trade['tgt_pos'].cumsum() > sw
    trade['tgt_pos'].loc[bad] = 0
    trade['tgt_trade'] = trade['tgt_pos'] - trade['weight']

    trade['w_buy'] = np.maximum(trade['tgt_trade'], 0)
    trade['w_sell'] = np.minimum(trade['tgt_trade'], 0)
    trade.to_csv(r"D:\py\平台回测demo\a_trade\trade_{}.csv".format(date))

    tpsell = trade['w_sell'] < 0
    trade.loc[tpsell, 'w_buy'] = 0

    trade.loc[trade['no_buy'], 'w_buy'] = 0  # 跌停或停牌不买
    trade.loc[trade['no_sell'], 'w_sell'] = 0  # 涨停或停牌不卖

    trade['cumu_sell'] = trade['w_sell'][::-1].cumsum()[::-1]
    trade.loc[trade['cumu_sell'] < -trade_lim, 'w_sell'] = 0  # 限制换手率trade_lim

    trade['cumu_buy'] = trade['w_buy'].cumsum()
    trade['cumu_sell'] = trade['w_sell'][::-1].cumsum()[::-1]
    trade['cumu_trade'] = trade['cumu_buy'] + trade['cumu_sell']

    trade['trade_diff'] = (trade['cumu_trade'] + trade['weight'].sum() - 1).round(6)

    trade['match'] = ((trade['trade_diff'] >= -1e-6) & (trade['trade_diff'] <= trade['w_buy'])) | (
            (trade['trade_diff'] <= 1e-6) & (trade['trade_diff'] >= trade['w_sell']))
    tpix = np.argmax(trade['match'])
    buy_tres = trade['cumu_buy'].iloc[tpix]

    trade.loc[trade['cumu_buy'] > buy_tres, 'w_buy'] = 0
    sell_tres = trade['cumu_sell'].iloc[tpix]
    trade.loc[trade['cumu_sell'] < sell_tres, 'w_sell'] = 0

    tpidx = trade.index[tpix]
    w_adj = trade.loc[tpidx, 'trade_diff']
    trade.loc[tpidx, 'w_buy'] = bool(trade.loc[tpidx, 'w_buy']) * (trade.loc[tpidx, 'w_buy'] - w_adj)
    trade.loc[tpidx, 'w_sell'] = bool(trade.loc[tpidx, 'w_sell']) * (trade.loc[tpidx, 'w_sell'] - w_adj)

    trade['new_pos'] = trade['weight'] + trade['w_buy'] + trade['w_sell']
    return trade


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


def fill_with_prev(info):
    if isinstance(info, pd.DataFrame):
        data = np.array(info)
    else:
        data = info.copy()

    prev_row = data[0]
    for irow in range(len(data)):
        this_row = data[irow]
        this_row_is_null = np.isnan(this_row)
        data[irow, this_row_is_null] = prev_row[this_row_is_null]
        prev_row = data[irow]

    if isinstance(info, pd.DataFrame):
        mean = pd.DataFrame(data=data, columns=info.columns, index=info.index)
        return mean
    else:
        return data


def gen_port_by_score_with_vol_adj_2(trade, fw, sw, port_val, vol_lim, trade_lim, dec_wr, date):
    not_trade = trade["tradestatus"] != 4
    ud = trade["udstatus"] != 0

    trade["new_pos"] = trade.loc[not_trade | ud, "weight"]

    trade.sort_values("score", ascending=False, inplace=True)
    trade["rank"] = np.arange(len(trade))+1
    trade.loc[~not_trade & ~ud, "new_pos"] = fw*dec_wr**trade["rank"]

    trade["trade_need_todo"] = trade["new_pos"] - trade["weight"]
    trade["cumpos"] = trade["new_pos"].cumsum()

    biggger_than_1 = trade["cumpos"]>1
    trade.loc[biggger_than_1, ["cumpos", "new_pos", "trade_need_todo"]] = 0

    return trade
