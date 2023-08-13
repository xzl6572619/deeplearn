

# research tushare

create table research.adjusted_preclose(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    preclose decimal(20,6) comment '前收盘价（分红调整后）',
    primary key (trddt, windcode)
);


drop table research.quote_ashareeod_tushare;
create table research.quote_ashareeod_tushare(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    opprc decimal(20,6) comment '开盘价',
    highprc decimal(20,6) comment '最高价',
    lowprc decimal(20,6) comment '最低价',
    clsprc decimal(20,6) comment '收盘价',
    avgprc decimal(20,6) comment '均价',
    preclose decimal(20,6) comment '前收盘价',
    pctchange decimal(12,8) comment '涨跌幅%',
    vol decimal(20,6) comment '成交量',
    amt decimal(20,6) comment '成交额',
    primary key(trddt,windcode)
);
select * from research.quote_ashareeod_tushare;


create table research.quote_daily_basic_tushare(
    trddt date not null,
    windcode varchar(20) not null,
    turnover_rate double,
    turnover_rate_f double,
    volume_ratio double,
    pe double,
    pe_ttm double,
    pb double,
    ps double,
    ps_ttm double,
    total_share double,
    float_share double,
    free_share double,
    total_mv double,
    circ_mv double,
    primary key(trddt, windcode)
);


create table research.quote_etfconstituent_wind(
    trddt date not null comment '交易日期',
    etf_code varchar(20) not null comment 'ETF万得代码',
    windcode varchar(20) not null comment '万得代码',
    qty int not null comment '数量',
    PRIMARY KEY (trddt, etf_code, windcode)
);


create table research.quote_etfconstituent_sse(
    trddt date not null comment '交易日期',
    etf_code varchar(20) not null comment 'ETF万得代码',
    windcode varchar(20) not null comment '万得代码',
    qty int not null comment '数量',
    r1 double comment '申购现金替代溢价比率',
    r2 double comment '赎回现金替代折价比率',
    flag int comment '现金替代标志',
    PRIMARY KEY (trddt, etf_code, windcode)
);


create table research.quote_etfprinfo_sse(
    trddt date not null comment '交易日期',
    etf_code varchar(20) not null comment 'ETF万得代码',
    creationredemptionunit int not null,
    maxcashratio double,
    publish int not null,
    creationredemption int not null,
    recordnum int not null,
    estimatecashcomponent double,
    cashcomponent double,
    navpercu double,
    nav double,
    PRIMARY KEY (trddt, etf_code)
)


-- 中证1000成份股列表 （权重为估算）
create table research.comp_csi1000_weight_est(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    weight decimal(12,8), -- 开盘价
    PRIMARY KEY (trddt, windcode)
);
-- 中证500成份股权重
create table research.comp_csi500_weight_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    weight decimal(12,8), -- 开盘价
    PRIMARY KEY (trddt, windcode)
);
-- 沪深300成份股权重
create table research.comp_csi300_weight_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    weight decimal(12,8), -- 开盘价
    PRIMARY KEY (trddt, windcode)
);
-- 上证50成份股权重
create table research.comp_csi050_weight_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    weight decimal(12,8), -- 开盘价
    PRIMARY KEY (trddt, windcode)
);


drop table research.quote_ashareeod_wind;
create table research.quote_ashareeod_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    opprc decimal(20,6) comment '开盘价',
    highprc decimal(20,6) comment '最高价',
    lowprc decimal(20,6) comment '最低价',
    clsprc decimal(20,6) comment '收盘价',
    avgprc decimal(20,6) comment '均价',
    adjftr decimal(20,6) comment '复权因子',
    preclose decimal(20,6) comment '前收盘价',
    pctchange decimal(12,8) comment '涨跌幅%',
    vol decimal(20,6) comment '成交量',
    amt decimal(20,6) comment '成交额',
    prclmtsts int, # 涨跌停状态 1涨停 -1跌停
    tradests int, # 交易状态 4正常交易 其他为退市、停牌或盘中停牌
    primary key (trddt,windcode)
);
select * from research.quote_ashareeod_wind;


drop table research.quote_ashare_limit_uqer;
create table research.quote_ashare_limit_uqer(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    limitupprice double comment '涨停价，无涨停限制时等于99999.999',
    limitdownprice double comment '跌停价，无限制时为最小单位0.01',
    uplimitreachedtimes int comment '达到涨停次数',
    downlimitreachedtimes int comment '达到跌停次数',
    primary key (trddt,windcode)
);
select * from research.quote_ashare_limit_uqer;




drop table research.quote_asharebod_stoplist_wind;
create table research.quote_asharebod_stoplist_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    primary key (trddt,windcode)
);
select * from research.quote_asharebod_stoplist_wind;


drop table research.quote_etfeod_wind;
create table research.quote_etfeod_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    opprc decimal(20,6) comment '开盘价',
    highprc decimal(20,6) comment '最高价',
    lowprc decimal(20,6) comment '最低价',
    clsprc decimal(20,6) comment '收盘价',
    avgprc decimal(20,6) comment '均价',
    adjftr decimal(20,6) comment '复权因子',
    preclose decimal(20,6) comment '前收盘价',
    pctchange decimal(12,8) comment '涨跌幅%',
    vol decimal(20,6) comment '成交量',
    amt decimal(20,6) comment '成交额',
    prclmtsts int, # 涨跌停状态 1涨停 -1跌停
    tradests int, # 交易状态 4正常交易 其他为退市、停牌或盘中停牌
    primary key (trddt,windcode)
);
select * from research.quote_etfeod_wind;


drop table research.quote_asharecpt_wind;
create table research.quote_asharecpt_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    total_share double null comment '总股本',
    float_share double null comment '流通股本',
    free_share double null comment '自由流通股本',
    total_mv double null comment '总市值',
    circ_mv double null comment '流通市值',
    free_mv double null comment '自由流通市值',
    primary key (trddt,windcode)
);
select * from research.quote_asharecpt_wind;


drop table research.quote_indexeod_tushare;
create table research.quote_indexeod_tushare(
    trddt date not null comment '交易日期', -- 交易日
    windcode varchar(20) not null comment '万得代码', -- 万得代码
    opprc decimal(20,6), -- 开盘价
    highprc decimal(20,6), -- 最高价
    lowprc decimal(20,6), -- 最低价
    clsprc decimal(20,6), -- 收盘价
    preclose decimal(20,6), -- 前收盘价
    pctchange decimal(12,8), -- 涨跌幅 单位是%
    vol decimal(20,6), -- 成交量 单位是股
    amt decimal(20,6),-- 成交额 单位是元
    primary key (trddt,windcode)
 )
select * from research.quote_indexeod_tushare;


drop table research.quote_indexeod_wind;
create table research.quote_indexeod_wind(
    trddt date not null comment '交易日期', -- 交易日
    windcode varchar(20) not null comment '万得代码', --万得代码
    opprc decimal(20,6), -- 开盘价
    highprc decimal(20,6), -- 最高价
    lowprc decimal(20,6), -- 最低价
    clsprc decimal(20,6), -- 收盘价
    avgprc decimal(20,6), -- 均价
    preclose decimal(20,6), -- 前收盘价
    pctchange decimal(12,8), -- 涨跌幅 单位是%
    vol decimal(20,6), -- 成交量 单位是股
    amt decimal(20,6),-- 成交额 单位是元
    primary key (trddt,windcode)
 )
select * from research.quote_indexeod_wind;


drop table research.quote_asharerisk_wind;
create table research.quote_asharerisk_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    st int not null, -- st
    asterisk int not null, -- *st
    warn int not null -- 退市整理
    primary key (trddt,windcode)
);
select * from research.quote_asharerisk_wind;


drop table research.quote_ashare_risk_wind;
create table research.quote_ashare_risk_wind(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    st_mark int not null comment '风险警示',
    delist_period int not null comment '退市整理',
    primary key (trddt,windcode)
);
select * from research.quote_ashare_risk_wind;


drop table research.quote_optioneod_tushare;
create table research.quote_optioneod_tushare(
    windcode varchar(20) not null comment '万得代码', # ts代码
    trddt date not null comment '交易日期', # 交易日期
    exchange varchar(10), # 交易市场
    presettle decimal(20,6), # 昨结算价
    preclose decimal(20,6), # 前收盘价
    opprc decimal(20,6), # 开盘价
    highprc decimal(20,6), # 最高价
    lowprc decimal(20,6), # 最低价
    clsprc decimal(20,6), # 收盘价
    settle decimal(20,6), # 结算价
    vol decimal(20,6), # 成交量(手)
    amt decimal(20,6), # 成交金额(万元)
    oi int, # 持仓量(手)
    primary key(trddt,windcode)
);
select * from research.quote_optioneod_tushare;


drop table research.quote_fundnav_tushare;
create table research.quote_fundnav_tushare(
    windcode varchar(20) not null comment '万得代码', # ts代码
    trddt date not null comment '交易日期', # 截止日期
    unit_nav double, # 单位净值
    accum_nav double, # 累计净值
    accum_div double, # 累计分红
    net_asset double, # 资产净值
    total_netasset double, # 合计资产净值
    adj_nav double, # 复权单位净值
    primary key(trddt,windcode)
);
select * from research.quote_fundnav_tushare;


drop table research.quote_hkse_top10_tushare;
create table research.quote_hkse_top10_tushare(
    windcode varchar(20) not null comment '万得代码', # ts代码
    trddt date comment not null comment '交易日期', # 截止日期
    market_type varchar(10), # 市场类型 2：港股通（沪） 4：港股通（深）
    amount double, # 累计成交金额（元）
    net_amount double, # 净买入金额（元）
    sh_amount double, # 沪市成交金额（元）
    sh_net_amount double, # 沪市净买入金额（元）
    sh_buy double, # 沪市买入金额（元）
    sh_sell double, # 沪市卖出金额
    sz_amount double, # 深市成交金额（元）
    sz_net_amount double, # 深市净买入金额（元）
    sz_buy double, # 深市买入金额（元）
    sz_sell double, # 深市卖出金额（元）
    primary key(trddt,windcode,market_type)
);
select * from research.quote_hkse_top10_tushare;


drop table research.quote_hkszsh_top10_tushare;
create table research.quote_hkszsh_top10_tushare(
    windcode varchar(20) not null comment '万得代码', # ts代码
    trddt date comment not null comment '交易日期', # 截止日期
    market_type varchar(10), # 市场类型 2：港股通（沪） 4：港股通（深）
    amount double, # 累计成交金额（元）
    net_amount double, # 净买入金额（元）
    buy double, # 沪市买入金额（元）
    sell double, # 沪市卖出金额
    primary key(trddt,windcode)
);
select * from research.quote_hkszsh_top10_tushare;


drop table research.report_reperchase_tushare;
create table research.report_reperchase_tushare(
    windcode varchar(20) not null comment '万得代码', # ts代码
    trddt date not null comment '交易日期', # 截止日期
    end_date varchar(12), # 截止日期
    proc nvarchar(40) not null, # 进度
    exp_date varchar(12), # 过期日期
    vol double, # 回购数量
    amount double, # 回购金额
    high_limit double, # 回购最高价
    low_limit double, # 回购最低价
    primary key(trddt,windcode,proc)
);
select * from research.report_reperchase_tushare;


drop table research.report_holdertrade_tushare;
create table research.report_holdertrade_tushare(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    holder_name nvarchar(40), # 股东名称
    holder_type varchar(8), # 股东类型g高管p个人c公司
    in_de varchar(8), # 类型in增持de减持
    change_vol double, # 变动数量
    change_ratio double, # 占流通比例（%）
    after_share double, # 变动后持股
    after_ratio double, # 变动后占流通比例（%）
    avg_price double, # 平均价格
    total_share double, # 持股总数
    begin_date varchar(12), # 增减持开始日期
    close_date varchar(12), # 增减持结束日期
    primary key(trddt,windcode,holder_name,begin_date,in_de)
);
select * from research.report_holdertrade_tushare;


drop table research.report_holders_trade_plan_wind;
create table research.report_holders_trade_plan_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    firstpublishdate date not null comment '首次公告日期',
    latestpublishdate date not null comment '最新公告日期',
    process nvarchar(20) comment '方案进度',
    direction nvarchar(10) comment '变动方向',
    shareholdername nvarchar(100) comment '股东名称',
    shareholdertype nvarchar(20) comment '股东类型',
    shareholderidentify nvarchar(50) comment '股东身份',
    startdate date comment '变动起始日期',
    enddate date comment '变动截止日期',
    changeup double comment '拟变动数量上限',
    changeuppercent decimal(8,4) comment '拟变动数量上限占总股本比例(%)',
    changelimit double comment '拟变动数量下限',
    changelimitpercent decimal(8,4) comment '拟变动数量下限占总股本比例(%)',
    trademethod nvarchar(100) comment '交易方式',
    primary key(windcode,latestpublishdate,shareholdername,direction)
);
select * from research.report_holders_trade_plan_wind;


-- choice 2020年以前的数据来源于windapi
drop table research.report_holders_trade_plan_choice;
create table research.report_holders_trade_plan_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    firstpublishdate date not null comment '首次公告日期',
    latestpublishdate date not null comment '最新公告日期',
    process nvarchar(20) comment '方案进度',
    direction nvarchar(10) comment '变动方向',
    shareholdername nvarchar(200) comment '股东名称',
    shareholdertype nvarchar(100) comment '股东类型',
    startdate date comment '变动起始日期',
    enddate date comment '变动截止日期',
    changeup double comment '拟变动数量上限(万股)',
    changeuppercent decimal(8,4) comment '拟变动数量上限占总股本比例(%)',
    changelimit double comment '拟变动数量下限(万股)',
    changelimitpercent decimal(8,4) comment '拟变动数量下限占总股本比例(%)',
    trademethod nvarchar(100) comment '交易方式',
    no_condition nvarchar(10) comment '是否无条件',
    amtup double comment '拟投入金额上限(万元)',
    amtlimit double comment '拟投入金额下限(万元)',
    knock_price double comment '增减持触发价格',
    price_limit double comment '增减持价格上限',
    shares_before_trade double comment '增减持前持股',
    primary key(windcode,firstpublishdate,latestpublishdate,shareholdername,direction)
);
select * from research.report_holders_trade_plan_choice;


drop table research.quote_asharemargin_tushare;
create table research.quote_asharemargin_tushare(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    rzye double, # 融资余额(元)
    rqye double, # 融券余额(元)
    rzmre double, # 融资买入额(元)
    rqyl double, # 融券余量（手）
    rzche double, # 融资偿还额(元)
    rqchl double, # 融券偿还量(手)
    rqmcl double, # 融券卖出量(股,份,手)
    rzrqye double, # 融资融券余额(元)
    primary key(trddt,windcode)
);
select * from research.quote_asharemargin_tushare;


drop table research.quote_moneyflow_tushare;
create table research.quote_moneyflow_tushare(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    buy_sm_vol int, # 小单买入量（手）
    buy_sm_amount double, # 小单买入金额（万元）
    sell_sm_vol int, # 小单卖出量（手）
    sell_sm_amount double, # 小单卖出金额（万元）
    buy_md_vol int, # 中单买入量（手）
    buy_md_amount double, # 中单买入金额（万元）
    sell_md_vol int, # 中单卖出量（手）
    sell_md_amount double, # 中单卖出金额（万元）
    buy_lg_vol int, # 大单买入量（手）
    buy_lg_amount double, # 大单买入金额（万元）
    sell_lg_vol int, # 大单卖出量（手）
    sell_lg_amount double, # 大单卖出金额（万元）
    buy_elg_vol int, # 特大单买入量（手）
    buy_elg_amount double, # 特大单买入金额（万元）
    sell_elg_vol int, # 特大单卖出量（手）
    sell_elg_amount double, # 特大单卖出金额（万元）
    net_mf_vol int, # 净流入量（手）
    net_mf_amount double, # 净流入额（万元）
    primary key(trddt,windcode)
);
select * from research.quote_moneyflow_tushare;


drop table research.quote_hkholding_tushare;
create table research.quote_hkholding_tushare(
    trddt date not null comment '交易日期',
    code varchar(10) not null,
    windcode varchar(20),
    vol bigint, # 持股数量(股)
    ratio decimal(10,6), # 持股占比（%）
    primary key(trddt,code)
);
select * from research.quote_hkholding_tushare;


drop table research.quote_hkholding_wind;
create table research.quote_hkholding_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    vol bigint comment '持股数量',
    ratio decimal(10,6) comment '公布持股占比', 
    ratio_cal decimal(10,6) comment 'wind计算持股占比', 
    primary key(trddt, windcode)
);
select * from research.quote_hkholding_wind;


drop table research.quote_hkcf_corr_derived;
create table research.quote_hkcf_corr_derived(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    morn_corr double,
    aftn_corr double,
    day_corr double,
    primary key(trddt,windcode)
);
select * from research.quote_hkcf_corr_derived;


drop table research.info_trade_dates;
create table research.info_trade_dates(
    trddt date not null primary key comment '交易日期',
    ordinal int
);
select * from research.info_trade_dates;


drop table research.info_ashareinfo_tushare;
create table research.info_ashareinfo_tushare(
    windcode varchar(20) not null comment '万得代码',
    symbol nvarchar(30), # 股票代码
    compname nvarchar(30), # 股票名称
    area nvarchar(30), # 所在地域
    industry nvarchar(30), # 所属行业
    fullname nvarchar(200), # 股票全称
    enname varchar(200), # 英文全称
    market nvarchar(30), # 市场类型 （主板/中小板/创业板）
    exchange nvarchar(30), # 交易所代码
    curr_type nvarchar(30), # 交易货币
    list_status nvarchar(10), # 上市状态： l上市 d退市 p暂停上市
    list_date nvarchar(30), # 上市日期
    delist_date nvarchar(30), # 退市日期
    is_hs nvarchar(10), # 是否沪深港通标的，n否 h沪股通 s深股通
    primary key(windcode)
);
select * from research.info_ashareinfo_tushare;


drop table research.info_name_change_wind;
create table research.info_name_change_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    name_before nvarchar(30) not null comment '旧名',
    name_after nvarchar(30) not null comment '新名',
    primary key(trddt,windcode)
);
select * from research.info_name_change_wind;


create table research.info_stockindexinfo_wind(
    windcode varchar(20) not null comment '万得代码', # the windcode of the index
    name nvarchar(50) not null, # name of the index
    nameeng varchar(200) not null # name of the index in english
    primary key(windcode)
)

drop table research.info_asharediv_tushare;
create table research.info_asharediv_tushare(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    end_date varchar(10), # 分红年度
    ann_date varchar(10), # 预案公告日
    div_proc nvarchar(10), # 实施进度
    stk_div double, # 每股送转
    stk_bo_rate double, # 每股送股比例
    stk_co_rate double, # 每股转增比例
    cash_div double, # 每股分红（税后）
    cash_div_tax double, # 每股分红（税前）
    record_date varchar(10), # 股权登记日
    ex_date varchar(10), # 除权除息日
    pay_date varchar(10), # 派息日
    div_listdate varchar(10), # 红股上市日
    imp_ann_date varchar(10), # 实施公告日
    base_date varchar(10), # 基准日
    base_share double, # 基准股本（万）
    primary key(trddt,windcode)
);
select * from research.info_asharediv_tushare;


drop table research.sest_asharerating_all;
create table research.sest_asharerating_all(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100),
    report_date date not null,
    latest_rating nvarchar(20),
    source nvarchar(20),
    optime time not null,
    primary key(report_date, windcode, institute)
);
select * from research.sest_asharerating_all;


drop table research.sest_asharerating_fr;
create table research.sest_asharerating_fr(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null,
    report_date date not null,
    num_rating int not null,
    source nvarchar(20),
    optime time not null,
    primary key(report_date, windcode, inst)
);
select * from research.sest_asharerating_fr;


drop table research.sest_asharerating_dc;
create table research.sest_asharerating_dc(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null,
    report_date date not null,
    num_rating int not null,
    source nvarchar(50),
    optime time not null,
    primary key(report_date, windcode, inst)
);
select * from research.sest_asharerating_dc;


drop table research.sest_asharerating_choice;
create table research.sest_asharerating_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    latest_rating nvarchar(20),
    prev_rating nvarchar(20),
    rating_change nvarchar(20),
    optime time not null,
    primary key(report_date, windcode, institute, analyst)
);
select * from research.sest_asharerating_choice;


CREATE TABLE `rpt_forecast_stk`  (
  `id` int(11) NOT NULL,
  `report_id` int(11) NULL DEFAULT NULL,
  `stock_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `stock_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `report_type` int(11) NULL DEFAULT NULL,
  `reliability` int(11) NULL DEFAULT NULL,
  `organ_id` int(11) NULL DEFAULT NULL,
  `organ_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `author_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_date` date NULL DEFAULT NULL,
  `report_year` int(11) NULL DEFAULT NULL,
  `report_quarter` int(11) NULL DEFAULT NULL,
  `forecast_or` double NULL DEFAULT NULL,
  `forecast_op` double NULL DEFAULT NULL,
  `forecast_tp` double NULL DEFAULT NULL,
  `forecast_np` double NULL DEFAULT NULL,
  `forecast_eps` double NULL DEFAULT NULL,
  `forecast_dps` double NULL DEFAULT NULL,
  `forecast_rd` double NULL DEFAULT NULL,
  `forecast_pe` double NULL DEFAULT NULL,
  `forecast_roe` double NULL DEFAULT NULL,
  `forecast_ev_ebitda` double NULL DEFAULT NULL,
  `organ_rating_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `organ_rating_content` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gg_rating_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gg_rating_content` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `target_price_ceiling` double NULL DEFAULT NULL,
  `target_price_floor` double NULL DEFAULT NULL,
  `current_price` double NULL DEFAULT NULL,
  `refered_capital` double NULL DEFAULT NULL,
  `is_capital_change` int(11) NULL DEFAULT NULL,
  `currency` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `settlement_date` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `language` int(11) NULL DEFAULT NULL,
  `attention` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `entrytime` datetime(0) NULL DEFAULT NULL,
  `updatetime` datetime(0) NULL DEFAULT NULL,
  `tmstamp` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_utsrpt_forecast_stk`(`tmstamp`) USING BTREE,
  INDEX `idx_rpt_forecast_stk_1`(`create_date`) USING BTREE,
  INDEX `idx_rpt_forecast_stk_2`(`entrytime`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;


CREATE TABLE research.rpt_forecast_gogoalapi(
    id int(11) NOT NULL COMMENT '流水号',
    time_year int(11) NOT NULL COMMENT '预测年度',
    origin_id int(11) NULL DEFAULT NULL COMMENT '原始id',
    stock_code varchar(20) NULL DEFAULT NULL COMMENT '证券代码',
    code_name varchar(20) NULL DEFAULT NULL COMMENT '证券名称',
    type_id int(11) NULL DEFAULT NULL COMMENT '报告分类id',
    org_name nvarchar(100) NULL DEFAULT NULL COMMENT '机构名称',
    author nvarchar(200) NULL DEFAULT NULL COMMENT '作者',
    author_id varchar(200) NULL DEFAULT NULL COMMENT '作者ID',
    score varchar(20) NULL DEFAULT NULL COMMENT '机构评级',
    organ_score varchar(20) NULL DEFAULT NULL COMMENT '机构原始评级',
    create_date date NULL DEFAULT NULL COMMENT '报告撰写日期',
    into_date date NULL DEFAULT NULL COMMENT '报告首次入库日期',
    text5 double NULL DEFAULT NULL COMMENT '目标价',
    price_current double NULL DEFAULT NULL COMMENT '报告参考价格',
    reliability int(11) NULL DEFAULT NULL COMMENT '可信度级别',
    change_type int(11) NULL DEFAULT NULL COMMENT '事件类型',
    change_name nvarchar(50) NULL DEFAULT NULL COMMENT '事件名称',
    quarter_num int(11) NULL DEFAULT NULL COMMENT '预测报表期',
    capital_current double NULL DEFAULT NULL COMMENT '报告参考股本',
    forecast_income double NULL DEFAULT NULL COMMENT '预期营业收入',
    forecast_profit double NULL DEFAULT NULL COMMENT '预期归属母公司净利润',
    forecast_income_share double NULL DEFAULT NULL COMMENT '预期每股收益',
    forecast_return_cash_share  double NULL DEFAULT NULL COMMENT '预期股息率',
    forecast_return_capital_share double NULL DEFAULT NULL COMMENT '预期净资产收益率',
    forecast_return double NULL DEFAULT NULL COMMENT '预期主营业务利润',
    r_tar1 double NULL DEFAULT NULL COMMENT '预期市盈率',
    r_tar2 double NULL DEFAULT NULL COMMENT '预期每股股息',
    r_tar3 double NULL DEFAULT NULL COMMENT 'EV/EBITDA',
    r_tar5 double NULL DEFAULT NULL COMMENT '预期利润总额',
    entrydate date NULL DEFAULT NULL COMMENT '最后更新日期',
    entrytime time NULL DEFAULT NULL COMMENT '最后更新时间',
    type_name nvarchar(50) NULL DEFAULT NULL COMMENT '报告分类名称',
    org_id int(11) NULL DEFAULT NULL COMMENT '机构ID',
    score_id int NULL DEFAULT NULL COMMENT 'Go-Goal评级ID',
    pro_org int NULL DEFAULT NULL COMMENT '*是否专业机构',
    pro_type int NULL DEFAULT NULL COMMENT '*专业机构类型',
    organ_score_id int NULL DEFAULT NULL COMMENT '机构原始评级ID',
    fileguid varchar(100) NULL DEFAULT NULL COMMENT '报告原文对应编码',
    title nvarchar(100) NULL DEFAULT NULL COMMENT '报告标题',
    update_time datetime NULL DEFAULT NULL COMMENT '最后更新时间',
    istrust_author int(11) NULL DEFAULT NULL COMMENT '是否最值得信赖分析师',
    primary key(id, time_year),
    INDEX `idx_rpt_forecast_stk_rptdt`(`create_date`) USING BTREE
);


drop table research.sest_asharerating_gogoal;
create table research.sest_asharerating_gogoal(
    report_id int not null comment '报告id',
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    latest_rating nvarchar(20),
    optime time not null,
    PRIMARY KEY (report_id)
);
select * from research.sest_asharerating_gogoal;


drop table research.fs_institute_holding_choice;
create table research.fs_institute_holding_choice(
    rpt_year int not null,
    quarter int not null,
    windcode varchar(20) not null comment '万得代码',
    fund_number int,
    fund_vol double,
    fund_ratio decimal(10,6),
    fund_amt double,
    astmgnt_number int,
    astmgnt_vol double,
    astmgnt_ratio decimal(10,6),
    astmgnt_amt double,
    insurance_number int,
    insurance_vol double,
    insurance_ratio decimal(10,6),
    insurance_amt double,
    social_number int,
    social_vol double,
    social_ratio decimal(10,6),
    social_amt double,
    qfii_number int,
    qfii_vol double,
    qfii_ratio decimal(10,6),
    qfii_amt double,
    other_number int,
    other_vol double,
    other_ratio decimal(10,6),
    other_amt double,
    primary key(rpt_year, quarter, windcode)
);
select * from research.fs_institute_holding_choice;


drop table research.quote_col_rep_exchg_choice;
create table research.quote_col_rep_exchg_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    col_trade_vol bigint,
    pch_trade_vol bigint,
    col_vol bigint,
    col_pct decimal(9,6),
    col_vol_float bigint,
    col_vol_limited bigint,
    primary key(trddt, windcode)
);
select * from research.quote_col_rep_exchg_choice;


drop table research.sest_asharerpt_hibor;
create table research.sest_asharerpt_hibor(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    latest_rating nvarchar(40),
    rating_change nvarchar(40),
    optime time not null,
    eps_fy0 double,
    eps_fy1 double,
    eps_fy2 double,
    pe_fy0 double,
    pe_fy1 double,
    pe_fy2 double,
    oper_revnue_fy0 double,
    oper_revnue_fy1 double,
    oper_revnue_fy2 double,
    oper_cost_fy0 double,
    oper_cost_fy1 double,
    oper_cost_fy2 double,
    oper_total_cost_fy0 double,
    oper_total_cost_fy1 double,
    oper_total_cost_fy2 double,
    oper_profit_fy0 double,
    oper_profit_fy1 double,
    oper_profit_fy2 double,
    total_profit_fy0 double,
    total_profit_fy1 double,
    total_profit_fy2 double,
    net_profit_fy0 double,
    net_profit_fy1 double,
    net_profit_fy2 double,
    sh_net_profit_fy0 double,
    sh_net_profit_fy1 double,
    sh_net_profit_fy2 double,
    roe_fy0 double,
    roe_fy1 double,
    roe_fy2 double,
    pb_fy0 double,
    pb_fy1 double,
    pb_fy2 double,
    ev_over_ebitda_fy0 double,
    ev_over_ebitda_fy1 double,
    ev_over_ebitda_fy2 double,
    oper_cfps_fy0 double,
    oper_cfps_fy1 double,
    oper_cfps_fy2 double,
    bps_fy0 double,
    bps_fy1 double,
    bps_fy2 double,
    debt_to_asset_fy0 double,
    debt_to_asset_fy1 double,
    debt_to_asset_fy2 double,
    total_asset_turnover_fy0 double,
    total_asset_turnover_fy1 double,
    total_asset_turnover_fy2 double,
    margin_fy0 double,
    margin_fy1 double,
    margin_fy2 double,
    net_margin_fy0 double,
    net_margin_fy1 double,
    net_margin_fy2 double,
    benchmark_year int,
    primary key(report_date, windcode, institute, analyst)
);
select * from research.sest_asharerpt_hibor;


drop table research.sest_asharerpt_choice;
create table research.sest_asharerpt_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    latest_rating nvarchar(40),
    prev_rating nvarchar(40),
    rating_change nvarchar(40),
    optime time not null,
    eps_fy0 double,
    eps_fy1 double,
    eps_fy2 double,
    eps_growth_fy0 double,
    eps_growth_fy1 double,
    eps_growth_fy2 double,
    pe_fy0 double,
    pe_fy1 double,
    pe_fy2 double,
    sh_net_profit_fy0 double,
    sh_net_profit_fy1 double,
    sh_net_profit_fy2 double,
    oper_revnue_fy0 double,
    oper_revnue_fy1 double,
    oper_revnue_fy2 double,
    benchmark_year int,
    primary key(report_date, windcode, institute, analyst)
);
select * from research.sest_asharerpt_choice;


drop table research.sest_asharerpt_choiceapi;
create table research.sest_asharerpt_choiceapi(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    predictyear int,
    researcher nvarchar(100),
    publishcode int,
    publishname nvarchar(50),
    report_date date not null,
    str_rating nvarchar(40),
    lastrating nvarchar(40),
    fangxiang nvarchar(40),
    dilutedeps double,
    dec_meigushouyi2 double,
    dec_meigushouyi3 double,
    dec_meigushouyi4 double,
    parentnetprofit double,
    dec_lirun2 double,
    dec_lirun3 double,
    dec_lirun4 double,
    totaloperatereve double,
    dec_shouru2 double,
    dec_shouru3 double,
    dec_shouru4 double,
    dec_zzl1 double,
    dec_zzl2 double,
    dec_zzl3 double,
    peg1 double,
    peg2 double,
    peg3 double,
    str_publishnamedc3 double,
    str_publishnamezjh double,
    optime time not null,
    primary key(report_date, windcode, publishcode)
);
select * from research.sest_asharerpt_choiceapi;


drop table research.sest_ashareeps_choice;
create table research.sest_ashareeps_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_choice;


drop table research.sest_ashareeps_hibor;
create table research.sest_ashareeps_hibor(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_hibor;


drop table research.sest_ashareeps_wind;
create table research.sest_ashareeps_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_wind;


drop table research.sest_ashareeps_wdf;
create table research.sest_ashareeps_wdf(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_wdf;


drop table research.sest_ashareeps_csmar;
create table research.sest_ashareeps_csmar(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_csmar;


drop table research.sest_ashareeps_gogoal;
create table research.sest_ashareeps_gogoal(
    id int not null comment 'GoGoal record ID',
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    oper_revnue double not null,
    eps_year int not null,
    primary key(id)
);
select * from research.sest_ashareeps_gogoal;


drop table research.sest_ashareeps_ifind;
create table research.sest_ashareeps_ifind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, eps_year)
);
select * from research.sest_ashareeps_ifind;


drop table research.sest_ashareeps_datayes;
create table research.sest_ashareeps_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, eps_year)
);
select * from research.sest_ashareeps_datayes;


drop table research.quote_l2pqcorr_datayes;
create table research.quote_l2pqcorr_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    corr double not null,
    cnt int not null,
    primary key(trddt, windcode)
);
select * from research.quote_l2pqcorr_datayes;


drop table research.quote_l2_amtads_datayes;
create table research.quote_l2_amtads_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    buy_stat double not null,
    sell_stat double not null,
    primary key(trddt, windcode)
);
select * from research.quote_l2_amtads_datayes;


drop table research.quote_l2_order_info_datayes;
create table research.quote_l2_order_info_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    buy_deal_cnt int,
    buy_avg_deal_amt int,
    buy_deal_amt double,
    buy_tot_order_amt double,
    buy_tot_order_cnt int,
    sell_deal_cnt int,
    sell_avg_deal_amt int,
    sell_deal_amt double,
    sell_tot_order_amt double,
    sell_tot_order_cnt int,
    buy_vld_order_avg_amt int,
    buy_vld_order_std int,
    buy_vld_order_cnt int,
    buy_vld_order_min int,
    buy_vld_order_q1 int,
    buy_vld_order_q2 int,
    buy_vld_order_q3 int,
    buy_vld_order_max int,
    sell_vld_order_cnt int,
    sell_vld_order_avg_amt int,
    sell_vld_order_std int,
    sell_vld_order_min int,
    sell_vld_order_q1 int,
    sell_vld_order_q2 int,
    sell_vld_order_q3 int,
    sell_vld_order_max int,
    buy_gini double,
    sell_gini double,
    primary key(trddt, windcode)
);
select * from research.quote_l2_order_info_datayes;


drop table research.quote_l2_fst_dgts_datayes;
create table research.quote_l2_fst_dgts_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    buy_bgw_1 int,
    buy_bgw_2 int,
    buy_bgw_3 int,
    buy_bgw_4 int,
    buy_bgw_5 int,
    buy_bgw_6 int,
    buy_bgw_7 int,
    buy_bgw_8 int,
    buy_bgw_9 int,
    sell_bgw_1 int,
    sell_bgw_2 int,
    sell_bgw_3 int,
    sell_bgw_4 int,
    sell_bgw_5 int,
    sell_bgw_6 int,
    sell_bgw_7 int,
    sell_bgw_8 int,
    sell_bgw_9 int,
    primary key(trddt, windcode)
);
select * from research.quote_l2_fst_dgts_datayes;


drop table research.quote_l2_qty_1stdgts_datayes;
create table research.quote_l2_qty_1stdgts_datayes(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    buy_bgw_1 int,
    buy_bgw_2 int,
    buy_bgw_3 int,
    buy_bgw_4 int,
    buy_bgw_5 int,
    buy_bgw_6 int,
    buy_bgw_7 int,
    buy_bgw_8 int,
    buy_bgw_9 int,
    sell_bgw_1 int,
    sell_bgw_2 int,
    sell_bgw_3 int,
    sell_bgw_4 int,
    sell_bgw_5 int,
    sell_bgw_6 int,
    sell_bgw_7 int,
    sell_bgw_8 int,
    sell_bgw_9 int,
    primary key(trddt, windcode)
);
select * from research.quote_l2_qty_1stdgts_datayes;


drop table research.sest_ashareeps_all;
create table research.sest_ashareeps_all(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    eps double not null,
    eps_year int not null,
    source nvarchar(20) not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareeps_all;


drop table research.sest_institution_dict;
create table research.sest_institution_dict(
    institute nvarchar(50) not null primary key,
    inst int not null
);
select * from research.sest_institution_dict;


drop table research.sest_ashareeps_fr;  -- first reported
create table research.sest_ashareeps_fr(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null comment '自定义机构编码',
    report_date date not null,
    eps double not null,
    eps_year int not null,
    optime time not null,
    source nvarchar(20) not null,
    primary key(report_date, windcode, inst, eps_year)
);
select * from research.sest_ashareeps_fr;


drop table research.sest_epschg_all;
create table research.sest_epschg_all(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null comment '自定义机构编码',
    eps_year int not null,
    report_date date not null,
    eps double not null,
    lst_eps double not null,
    lst_report_date date not null,
    optime time not null,
    source nvarchar(20) not null,
    primary key(report_date, windcode, inst, eps_year)
);
select * from research.sest_epschg_all;


drop table research.sest_fix_rpt_dt;  -- first reported
create table research.sest_fix_rpt_dt(
    windcode varchar(20) not null comment '万得代码',
    inst int not null comment '自定义机构编码',
    report_date date not null comment '原始报告日期',
    new_rpt_date date not null comment '合并报告日期',
    primary key(report_date, windcode, inst)
);
select * from research.sest_fix_rpt_dt;


drop table research.sest_ashareeps_dc;  -- double checked
create table research.sest_ashareeps_dc(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null comment '自定义机构编码',
    report_date date not null,
    eps double not null,
    eps_year int not null,
    optime time not null,
    source nvarchar(50) not null,
    primary key(report_date, windcode, inst, eps_year)
);
select * from research.sest_ashareeps_dc;


drop table research.sest_ashareeps_tmp;  -- 用于replace into的临时表
create table research.sest_ashareeps_tmp(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    inst int not null comment '自定义机构编码',
    report_date date not null,
    eps double not null,
    eps_year int not null,
    optime time not null,
    source nvarchar(50) not null,
    primary key(report_date, windcode, inst, eps_year)
);
select * from research.sest_ashareeps_tmp;


drop table research.sest_ashareor_hibor;
create table research.sest_ashareor_hibor(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    optime time not null,
    oper_revenue double not null,
    eps_year int not null,
    primary key(report_date, windcode, institute, analyst, eps_year)
);
select * from research.sest_ashareor_hibor;


drop table research.sest_eps_increase_wind;
create table research.sest_eps_increase_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    this_eps double comment '最新每股收益',
    this_npf double comment '最新净利润',
    this_rvn double comment '最新总收入',
    report_date date not null comment '最新报告日期',
    last_eps double comment '前次预测每股收益',
    last_npf double comment '前次预测净利润',
    last_rvn double comment '前次预测总收入',
    last_report_date date not null comment '前次报告日期',
    optime time not null comment '获取数据时间',
    primary key(trddt, windcode, institute, analyst)
);
select * from research.sest_eps_increase_wind;


drop table research.sest_eps_increase_choice;
create table research.sest_eps_increase_choice(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    this_eps double comment '最新每股收益',
    this_npf double comment '最新净利润',
    this_rvn double comment '最新总收入',
    report_date date not null comment '最新报告日期',
    last_eps double comment '前次预测每股收益',
    last_npf double comment '前次预测净利润',
    last_rvn double comment '前次预测总收入',
    last_report_date date not null comment '前次报告日期',
    optime time not null comment '获取数据时间',
    primary key(trddt, windcode, institute, analyst)
);
select * from research.sest_eps_increase_choice;


drop table research.sest_asharerpt_wind;
create table research.sest_asharerpt_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    eps_report_date date not null,
    latest_rating nvarchar(40),
    prev_rating nvarchar(40),
    rating_change nvarchar(40),
    optime time not null,
    eps_fy0 double,
    eps_fy1 double,
    eps_fy2 double,
    eps_fy3 double,
    eps_growth_fy1 double,
    eps_growth_fy2 double,
    eps_growth_fy3 double,
    pe_fy0 double,
    pe_fy1 double,
    pe_fy2 double,
    pe_fy3 double,
    peg_fy1 double,
    peg_fy2 double,
    peg_fy3 double,
    sh_net_profit_fy0 double,
    sh_net_profit_fy1 double,
    sh_net_profit_fy2 double,
    sh_net_profit_fy3 double,
    oper_revnue_fy0 double,
    oper_revnue_fy1 double,
    oper_revnue_fy2 double,
    oper_revnue_fy3 double,
    benchmark_year int,
    primary key(report_date, windcode, institute, analyst)
);
select * from research.sest_asharerpt_wind;


drop table research.sest_asharerpt_ifind;
create table research.sest_asharerpt_ifind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    report_date date not null,
    eps_report_date date not null,
    report_type nvarchar(100) not null,
    latest_rating nvarchar(40),
    abstract nvarchar(1000),
    optime time not null,
    eps_fy0 double,
    eps_fy1 double,
    eps_fy2 double,
    eps_fy3 double,
    sh_net_profit_fy0 double,
    sh_net_profit_fy1 double,
    sh_net_profit_fy2 double,
    sh_net_profit_fy3 double,
    oper_revnue_fy0 double,
    oper_revnue_fy1 double,
    oper_revnue_fy2 double,
    oper_revnue_fy3 double,
    benchmark_year int not null,
    primary key(report_date, windcode, institute, analyst, report_type)
);
select * from research.sest_asharerpt_ifind;


drop table research.sest_rptbasic_datayes;
create table research.sest_rptbasic_datayes(
    id int not null primary key,
    seccode varchar(20),
    secname nvarchar(20),
    title nvarchar(200),
    abstract nvarchar(1000),
    reporttype nvarchar(50),
    orgid int,
    author nvarchar(50),
    ratingid int,
    writedate date,
    publishdate date,
    reportid int,
    updatetime datetime,
    tarprice double,
    trddt date,
    optime time
);
select * from research.sest_rptbasic_datayes;


drop table research.sest_rptsentiment_datayes;
create table research.sest_rptsentiment_datayes(
    id int not null primary key,
    windcode varchar(20) not null comment '万得代码',
    institute nvarchar(50) not null,
    analyst nvarchar(100) not null,
    title nvarchar(200),
    report_date date not null,
    reporttype nvarchar(50),
    subreporttype nvarchar(50),
    rating nvarchar(20),
    sentiment double,
    trddt date,
    optime time
);
select * from research.sest_rptsentiment_datayes;


drop table research.sest_rptforecast_datayes;
create table research.sest_rptforecast_datayes(
    id int not null primary key,
    infostockid int not null,
    foreyear int,
    foretype int,
    foreincome double,
    foreprofit double,
    foreeps double,
    foreroe double,
    forepe double,
    forepb double,
    foreroa double,
    forebps double,
    foreebt double,
    forecapital double,
    foreevebitda double,
    forecps double,
    foreebitda double,
    foreoprofit double,
    foreoc double,
    foredps double,
    foreratio double,
    foreebit double,
    updatetime datetime,
    trddt date,
    optime time
);
select * from research.sest_rptforecast_datayes;


drop table research.sest_organinfo_datayes;
create table research.sest_organinfo_datayes(
    orgid int not null,
    srcorgname nvarchar(60) not null primary key,
    tgtorgname nvarchar(60),
    orgremark int,
    orgclass int
);
select * from research.sest_organinfo_datayes;


drop table research.factor_innerday_mtm;
create table research.factor_innerday_mtm(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    stm_pctchg double comment '成交最最大20%价格变动',
    ltm_pctchg double comment '成交量最小20%价格变动',
    vwa_pctchg double comment '量加权变动',
    rgk_ratio double comment '红绿比',
    trd_ratio double comment '趋势比',
    primary key(windcode, trddt)
);
select * from research.factor_innerday_mtm;


drop table research.quote_innerday_hhpamt;
create table research.quote_innerday_hhpamt(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    hhpamt_1000 double,
    hhpamt_1030 double,
    hhpamt_1100 double,
    hhpamt_1130 double,
    hhpamt_1330 double,
    hhpamt_1400 double,
    hhpamt_1430 double,
    hhpamt_1500 double,
    primary key(windcode, trddt)
);
select * from research.quote_innerday_hhpamt;


drop table research.factor_concensus_hibor;
create table research.factor_concensus_hibor(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    num_rps double,
    eps_fy0 double,
    eps_fy1 double,
    eps_fy2 double,
    oper_revnue_fy0 double,
    oper_revnue_fy1 double,
    oper_revnue_fy2 double,
    oper_cost_fy0 double,
    oper_cost_fy1 double,
    oper_cost_fy2 double,
    oper_profit_fy0 double,
    oper_profit_fy1 double,
    oper_profit_fy2 double,
    total_profit_fy0 double,
    total_profit_fy1 double,
    total_profit_fy2 double,
    net_profit_fy0 double,
    net_profit_fy1 double,
    net_profit_fy2 double,
    sh_net_profit_fy0 double,
    sh_net_profit_fy1 double,
    sh_net_profit_fy2 double,
    roe_fy0 double,
    roe_fy1 double,
    roe_fy2 double,
    margin_fy0 double,
    margin_fy1 double,
    margin_fy2 double,
    eps_growth_fy0 double,
    eps_growth_fy1 double,
    eps_growth_fy2 double,
    oper_revnue_growth_fy0 double,
    oper_revnue_growth_fy1 double,
    oper_revnue_growth_fy2 double,
    net_profit_growth_fy0 double,
    net_profit_growth_fy1 double,
    net_profit_growth_fy2 double,
    peg_1 double,
    peg_2 double,
    primary key(windcode, trddt)
);
select * from research.factor_concensus_hibor;

create table research.factor_concensus_uqer_raw(
    windcode varchar(20) not null comment '万得代码', #万德代码
    trddt date not null comment '交易日期', #交易日
    foreyear int not null,
    foretype int not null,
    conepstype int,
    coneps double,
    conprofittype int,
    conprofit double,
    conincometype int,
    conincome double,
    primary key(windcode, trddt, foreyear, foretype)
);
select * from factor_concensus_uqer_raw;

create table research.factor_concensus_fy0(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  net_profit decimal(20, 4) null, #净利润
  est_eps decimal(20, 4) null, #eps
  est_pe decimal(20, 4) null, #pe
  est_peg decimal(20, 4) null, #peg
  est_pb decimal(20, 4) null, #pb
  est_roe decimal(20, 4) null, #roe
  est_oper_revenue decimal(20, 4) null, #营业收入
  est_cfps decimal(20, 4) null, #每股现金流
  est_dps decimal(20, 4) null, #每股股利
  est_bps decimal(20, 4) null, #每股净资产
  est_ebit decimal(20, 4) null, #息税前利润
  est_ebitda decimal(20, 4) null, #息税折旧摊销前利润
  est_total_profit decimal(20, 4) null, #利润总额
  est_oper_profit decimal(20, 4) null, #营业利润
  est_oper_cost decimal(20, 4) null, #营业成本及附加
  benchmark_yr varchar(8) null, #基准年度
  est_baseshare decimal(30, 4) null, #预测基准股本综合值
  primary key(windcode, trddt)
);


# filesync合同于2020-11-27到期 后面的数据由api数据代替
create table research.factor_concensus_fy1(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  net_profit decimal(20, 4) null, #净利润
  est_eps decimal(20, 4) null, #eps
  est_pe decimal(20, 4) null, #pe
  est_peg decimal(20, 4) null, #peg
  est_pb decimal(20, 4) null, #pb
  est_roe decimal(20, 4) null, #roe
  est_oper_revenue decimal(20, 4) null, #营业收入
  est_cfps decimal(20, 4) null, #每股现金流
  est_dps decimal(20, 4) null, #每股股利
  est_bps decimal(20, 4) null, #每股净资产
  est_ebit decimal(20, 4) null, #息税前利润
  est_ebitda decimal(20, 4) null, #息税折旧摊销前利润
  est_total_profit decimal(20, 4) null, #利润总额
  est_oper_profit decimal(20, 4) null, #营业利润
  est_oper_cost decimal(20, 4) null, #营业成本及附加
  benchmark_yr varchar(8) null, #基准年度
  est_baseshare decimal(30, 4) null, #预测基准股本综合值
  primary key(windcode, trddt)
);


create table research.factor_concensus_gogoal_rolling(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  con_or_roll double null COMMENT '滚动一致预期营业收入',
  con_np_roll double null COMMENT '滚动一致预期净利润',
  con_eps_roll double null COMMENT '滚动一致预期每股收益',
  con_na_roll double null COMMENT '滚动一致预期净资产',
  con_pb_roll double null COMMENT '滚动一致预期市净率',
  con_ps_roll double null COMMENT '滚动一致预期市销率',
  con_pe_roll double null COMMENT '滚动一致预期市盈率',
  con_peg_roll double null COMMENT '滚动一致预期PEG',
  con_roe_roll double null COMMENT '滚动一致预期ROE',
  con_npcgrate_2y_roll double null COMMENT '滚动一致预期净利润两年复合增长率',
  con_or_yoy_roll double null COMMENT '滚动一致预期营业收入同比',
  con_np_yoy_roll double null COMMENT '滚动一致预期净利润同比',
  primary key(windcode, trddt)
);


create table research.factor_concensus_fy1_windapi(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  net_profit decimal(20, 4) null, #净利润
  est_eps decimal(20, 4) null, #eps
  est_roe decimal(20, 4) null, #roe
  est_oper_revenue decimal(20, 4) null, #营业收入
  est_cfps decimal(20, 4) null, #每股现金流
  est_dps decimal(20, 4) null, #每股股利
  est_bps decimal(20, 4) null, #每股净资产
  est_ebit decimal(20, 4) null, #息税前利润
  est_ebitda decimal(20, 4) null, #息税折旧摊销前利润
  est_total_profit decimal(20, 4) null, #利润总额
  est_oper_profit decimal(20, 4) null, #营业利润
  est_oper_cost decimal(20, 4) null, #营业成本及附加
  est_rating decimal(10, 4) null, #评级
  primary key(windcode, trddt)
);


create table research.factor_concensus_rolling_uqer(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  coneps double comment '一致预期eps',
  conincome double comment '一致预期营业总收入',
  conincome_cgr2y double, 
  # 1. 记预测日当年年度为FY1，下一年度为FY2，上一年度为FY0，两年前年度为FY-1；2. FY12营业总收入 = FY1一致预期营业总收入 * （m/365）+ FY2一致预期营业总收入 * (1-m/365)；3. FY-10营业总收入 = FY-1一致预期营业总收入 * （m/365）+ FY0一致预期营业总收入 * (1-m/365)；4. 指标 = sign(FY12营业总收入) * (sqrt(abs(FY12营业总收入 / FY-10营业总收入)) - 1) * 100；5. m为预测日当日距离年底的时间天数。
  conincome_chgpct1y double,
  # 1. 记预测日当日为T0，预测日往前一年为T-1Y(自然日)；若预测日往一年是非交易日，则取往前最新交易日；2. 指标 = (T0的CON_INCOME_FY12 - T-1Y的CON_INCOME_FY12) / abs(T-1Y的CON_INCOME_FY12) * 100；3. 当T-1Y的CON_INCOME_FY12为0或NULL时，指标为NULL。
  conincome_yoy double,
  # 1. 记预测日当年年度为FY1，下一年度为FY2，上一年度为FY0；2. FY12营业总收入 = FY1一致预期营业总收入 * （m/365）+ FY2一致预期营业总收入 * (1-m/365)；3. FY01营业总收入 = FY0一致预期营业总收入 * （m/365）+ FY1一致预期营业总收入 * (1-m/365)；4. 指标 = (FY12营业总收入- FY01营业总收入) / abs(FY01营业总收入) * 100；5. m为预测日当日距离年底的时间天数。
  conna double comment '一致预期净资产',
  conpb double comment '一致预期pb',
  conpe double comment '一致预期pe',
  conpeg1 double, # 指标 = CON_PE_FY12 / CON_PORFIT_FY12_YOY
  conpeg2 double, # 指标 = CON_PE_FY12 / CON_PROFIT_FY12_CGR2Y
  conprofit double comment '一致预期归母净利润',
  conprofit_cgr2y double, # 
  conprofit_chgpct1y double,
  conprofit_yoy double,
  conps double comment '一致预期ps市销率',
  conpsg1 double, # 指标 = CON_PS_FY12 / CON_INCOME_FY12_YOY
  conpsg2 double, # 指标 = CON_PS_FY12 / CON_INCOME_FY12_CGR2Y
  conroe double comment '一致预期ROE',
  primary key(windcode, trddt)
);


create table research.factor_avgest_rolling_uqer(
  # 3个月内分析师盈利预测报表的平均值，按自然年度的fy1 fy2做rolling
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  forebps double comment '每股净资产',
  forecapital double comment '股本',
  forecps double comment '每股现金流',
  foredps double comment '每股股利',
  foreebit double comment '息税前利润',
  foreebitda double comment '息税折旧摊销前利润',
  foreebt double comment '利润总额',
  foreeps double comment '每股收益',
  foreincome double comment '营业收入',
  foreoc double comment '营业成本',
  foreoprofit double comment '营业利润',
  forepb double comment '预测PB',
  forepe double comment '预测PE',
  foreprofit double comment '归母净利润',
  foreratio double comment '股息率',
  foreroa double comment '总资产收益率',
  foreroe double comment '净资产收益率',
  evebitda double comment '企业价值倍数',
  primary key(windcode, trddt)
);


create table research.factor_concensus_tar_windapi(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  target_price decimal(10, 4) null, #目标价
  primary key(windcode, trddt)
);


create table research.factor_fa_pit_windapi(
    windcode varchar(20) not null comment '万得代码', #万德代码
    trddt date not null comment '交易日期', #交易日
    fa_eps_basic double comment '基本每股收益',
    fa_eps_diluted double comment '稀释每股收益',
    fa_bps double comment '每股净资产',
    fa_grps double comment '每股营业总收入',
    fa_orps double comment '每股营业收入',
    fa_opps double comment '每股营业利润',
    fa_capsurpps double comment '每股资本公积',
    fa_spps double comment '每股盈余公积',
    fa_undistributedps double comment '每股未分配利润',
    fa_retainedps double comment '每股存留收益',
    fa_fcffps double comment '每股企业自由现金流量',
    fa_fcfeps double comment '每股股东自由现金流量',
    fa_cceps double comment '每股现金及现金等价物余额',
    fa_divcover_ttm double comment '股利保障倍数',
    fa_retainedearn_ttm double comment '留存盈余比率',
    fa_cfps_ttm double comment '每股现金流量净额',
    fa_ocfps_ttm double comment '每股经营活动产生的现金流量净额',
    fa_opps_ttm double comment '每股营业利润',
    fa_dps double comment '每股股利',
    fa_gr_ttm double comment '营业总收入',
    fa_gc_ttm double comment '营业总成本',
    fa_sellexpense_ttm double comment '销售费用',
    fa_adminexpense_ttm double comment '管理费用',
    fa_finaexpense_ttm double comment '财务费用',
    fa_perexpense_ttm double comment '期间费用',
    fa_interestexpense_ttm double comment '利息支出',
    fa_op_ttm double comment '营业利润',
    fa_nooperprofit_ttm double comment '营业外收支净额',
    fa_ebitunver_ttm double comment '息税前利润（反推法）',
    fa_tax_ttm double comment '所得税',
    fa_ebt_ttm double comment '利润总额',
    fa_profit_ttm double comment '净利润',
    fa_netprofit_ttm double comment '归母净利润',
    fa_deductprofit_ttm double comment '扣非后净利润',
    fa_ebit_ttm double comment 'EBIT',
    fa_ebitda_ttm double comment 'EBITDA',
    fa_salescash_ttm double comment '销售商品提供劳务收到的现金',
    fa_operactcashflow_ttm double comment '经营活动现金流量',
    fa_inveactcashflow_ttm double comment '投资活动现金流量',
    fa_finaactcashflow_ttm double comment '筹资活动现金流量',
    fa_cashflow_ttm double comment '现金净流量',
    fa_opertax_ttm double comment '营业税金及附加',
    primary key(windcode, trddt)
);


create table research.factor_concensus_yoy_windapi(
    windcode varchar(20) not null comment '万得代码', #万德代码
    trddt date not null comment '交易日期', #交易日
    yoynp double comment '归母净利润同比',
    primary key(windcode, trddt)
);


create table research.factor_cne5_datayes(
  windcode varchar(20) not null comment '万得代码', #万德代码
  trddt date not null comment '交易日期', #交易日
  beta decimal(10, 6) null, #
  momentum decimal(10, 6) null, #
  size decimal(10, 6) null, #
  earnyild decimal(10, 6) null, #
  resvol decimal(10, 6) null, #
  growth decimal(10, 6) null, #
  btop decimal(10, 6) null, #
  leverage decimal(10, 6) null, #
  liquidty decimal(10, 6) null, #
  sizenl decimal(10, 6) null, #
  primary key(windcode, trddt)
);
# 主键： trddt  windcode  
# 起始： 2019-11-27
# 更新时间：t+1 9:00


# 公司新闻指数统计表
create table research.factor_news_sentiment_datayes(
  windcode varchar(20) not null comment '万得代码', #万德代码
  newseffecdate date not null comment '新闻生效日期',
  clacdimtype int not null comment '1-盘中（新闻生效当天7点半-新闻生效当天15点）；2-隔夜（新闻生效前一天15点-新闻生效当天7点半）；3-当天（新闻生效当天0点-新闻生效当天24点）。', #
  newscount int comment '不是每家公司的关联的新闻数量，是当天过滤去重后有效的总的新闻的数量。', #
  heatindex double comment '计算公司当天的关联新闻指数，并对公司历史热度和全市场平均热度做平滑，再对所有公司做归一化后即是新闻热度值。', #
  sentindex double comment '计算公司当天的情感指数，考虑公司的关联新闻，关联度，新闻情感等因素。', #
  primary key(windcode, newseffecdate, clacdimtype)
);


drop table research.disclosure_title_cninfo;
create table research.disclosure_title_cninfo(
    report_date date not null, # 截止日期
    optime time not null,
    object_id int not null,
    rec_id varchar(30) not null,
    text_id varchar(30) not null,
    sec_code varchar(20) not null,
    sec_name nvarchar(20) not null,
    title nvarchar(100) not null, # 公告标题
    url varchar(100) not null, # 公告地址
    ext nvarchar(10), # 公告格式
    size double, # 公告大小 f006v
    info_category varchar(100), # 信息分类 f006v
    security_category_code varchar(20), # 证券类别编码 f007v
    security_category_name nvarchar(20), # 证券类别名称 f008v
    market_category_code varchar(20), # 证券市场编码 f009v
    market_category_name nvarchar(20), # 证券市场名称 f010v
    primary key(object_id)
);
select * from research.disclosure_title_cninfo;


drop table research.disclosure_ilegality_wind;
create table research.disclosure_ilegality_wind(
    windcode nvarchar(50) not null,
    trddt date not null comment '交易日期', # 公告日期
    breach_type nvarchar(60) not null, # 违规类型
    breach_subject nvarchar(20), # 违规主体
    penalty_object nvarchar(100) not null, # 处罚对象
    relation nvarchar(20),# 关系
    penalty_type nvarchar(30) not null, # 处分类型
    processor nvarchar(50) not null, # 处理人
    penalty_amount decimal(20,6), # 处罚金额
    primary key(windcode, trddt, breach_type, penalty_object, penalty_type, processor)
);
select * from research.disclosure_ilegality_wind;


drop table research.fs_institute_holding_wind;
create table research.fs_institute_holding_wind(
    trddt date not null comment '交易日期',
    windcode varchar(20) not null comment '万得代码',
    rpt_year int not null,
    quarter int not null,
    fund_number int,
    fund_vol double,
    fund_ratio decimal(10,6),
    fund_amt double,
    astmgnt_number int,
    astmgnt_vol double,
    astmgnt_ratio decimal(10,6),
    astmgnt_amt double,
    insurance_number int,
    insurance_vol double,
    insurance_ratio decimal(10,6),
    insurance_amt double,
    social_number int,
    social_vol double,
    social_ratio decimal(10,6),
    social_amt double,
    qfii_number int,
    qfii_vol double,
    qfii_ratio decimal(10,6),
    qfii_amt double,
    other_number int,
    other_vol double,
    other_ratio decimal(10,6),
    other_amt double,
    primary key(trddt, rpt_year, quarter, windcode)
);
select * from research.fs_institute_holding_wind;


drop table research.disclosure_irmeeting_wind;
create table research.disclosure_irmeeting_wind(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '交易日期', # 公告日期
    meeting_date date not null, # 会议日期
    meeting_type nvarchar(20) not null,
    total_num int,
    media_gov_num int,
    inst_num int,
    listed_related_num int,
    others_num int
    # primary key(windcode, meeting_date, meeting_type)
);
select * from research.disclosure_irmeeting_wind;


drop table research.disclosure_irmeeting_choice;
create table research.disclosure_irmeeting_choice(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '交易日期', # 公告日期
    meeting_date date not null, # 会议日期
    total_num int,
    primary key(windcode, meeting_date)
);
select * from research.disclosure_irmeeting_choice;


drop table research.report_limit2free_wind;
create table research.report_limit2free_wind(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '交易日期', # 解禁日期
    shares double not null,
    type nvarchar(100) not null,
    primary key(windcode, trddt)
);
select * from research.report_limit2free_wind;


drop table research.disclosure_central_holding_choice;
create table research.disclosure_central_holding_choice(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '交易日期', # 获取到该信息的交易日期
    report_date date not null, # 公告日期
    hld_date date not null, # 持仓截至日期
    holder nvarchar(50) not null,
    hld_qty double,
    hld_pct decimal(10,6),
    primary key(windcode, hld_date, holder)
);
select * from research.disclosure_central_holding_choice;


drop table research.disclosure_profit_express_choice;
create table research.disclosure_profit_express_choice(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '交易日期', # 获取到该信息的交易日期
    report_date date not null, # 公告日期
    rpt_year int not null, # 公告年份
    quarter int not null, # 公告季度
    net_profit_parent double,
    net_profit_parent_lyr double,
    net_profit_parent_growth double,
    oper_revnue double,
    oper_revnue_lyr double,
    oper_revnue_growth double,
    oper_profit double,
    oper_profit_lyr double,
    oper_profit_growth double,
    total_profit double,
    total_profit_lyr double,
    total_profit_growth double,
    eps double,
    eps_lyr double,
    eps_growth double,
    roe double,
    roe_lyr double,
    roe_growth double,
    total_asset double,
    total_asset_lyr double,
    total_asset_growth double,
    net_asset double,
    net_asset_lyr double,
    net_asset_growth double,
    primary key(windcode, trddt, rpt_year, quarter)
);
select * from research.disclosure_profit_express_choice;


drop table research.fs_eps_ifind;
create table research.fs_eps_ifind(
    windcode varchar(20) not null comment '万得代码',
    findt date not null comment '报告期',
    basic_eps double not null comment '基本eps',
    trddt date not null comment '获取到该信息的日期',
    optime time not null comment '获取到该信息的时间',
    primary key(windcode, findt)
);
select * from research.fs_eps_ifind;


drop table research.fs_fdmt_idctr_ps_uqer;
create table research.fs_fdmt_idctr_ps_uqer(
    windcode varchar(20) not null comment '万得代码',
    findt date not null comment '报告期',
    trddt date not null comment '获取到该信息的日期',
    eps double comment '每股收益(期末摊薄,元/股)',
    basiceps double comment '基本每股收益',
    dilutedeps double comment '稀释每股收益',
    nassetps double comment '每股净资产(元/股)',
    trevps double comment '每股营业总收入(元/股)',
    revps double comment '每股营业收入(元/股)',
    opps double comment '每股营业利润(元/股)',
    ebitps double comment '每股息税前利润(元/股)',
    creserps double comment '每股资本公积(元/股)',
    sreserps double comment '每股盈余公积(元/股)',
    reserps double comment '每股公积金(元/股)',
    reps double comment '每股未分配利润(元/股)',
    treps double comment '每股留存收益(元/股)',
    ncfoperaps double comment '每股经营活动产生的现金流量净额(元/股)',
    ncincashps double comment '每股现金流量净额(元/股)',
    fcffps double comment '每股企业自由现金流量(元/股)',
    fcfeps double comment '每股股东自由现金流量(元/股)',
    primary key(windcode, findt)
);
select * from research.fs_fdmt_idctr_ps_uqer;


drop table research.fs_fdmt_promo_uqer;
create table research.fs_fdmt_promo_uqer(
    windcode varchar(20) not null comment '万得代码',
    findt date not null comment '报告期',
    trddt date not null comment '获取到该信息的日期',
    revchgrll double comment '收入增减幅度下限(%)',
    revchgrupl double comment '收入增减幅度上限(%)',
    exprevll double comment '预期收入下限',
    exprevupl double comment '预期收入上限',
    nincomechgrll double comment '净利润增减幅度下限(%)',
    nincomechgrupl double comment '净利润增减幅度上限(%)',
    expnincomell double comment '预期净利润下限',
    expnincomeupl double comment '预期净利润上限',
    nincapchgrll double comment '归属于母公司所有者的净利润增减幅度下限(%)',
    nincapchgrupl double comment '归属于母公司所有者的净利润增减幅度上限(%)',
    expnincapll double comment '预期归属于母公司所有者的净利润下限',
    expnincapupl double comment '预期归属于母公司所有者的净利润上限',
    expepsll double comment '预期每股收益下限',
    expepsupl double comment '预期每股收益上限',
    updatetime datetime comment '更新时间',
    actpubtime datetime comment '公告发布时间',
    primary key(windcode, findt)
);
select * from research.fs_fdmt_promo_uqer;


drop table research.fs_fdmt_express_uqer;
create table research.fs_fdmt_express_uqer(
    windcode varchar(20) not null comment '万得代码',
    findt date not null comment '报告期',
    trddt date not null comment '获取到该信息的日期',
    publishdate date comment '发布日期',
    actpubtime datetime comment '实际发布时间',
    reporttype varchar(6) comment '报告类型。Q1，S1，Q3，CQ3-累计1-9月，A-年',
    revenue double comment '营业收入',
    primeoperrev double comment '主营业务收入',
    grossprofit double comment '主营业务利润',
    operateprofit double comment '营业利润',
    tprofit double comment '利润总额',
    nincomeattrp double comment '归属于母公司所有者的净利润',
    nincomecut double comment '扣除非经常性损益后净利润',
    ncfopera double comment '经营活动现金流量净额',
    basiceps double comment '基本每股收益(元/股)',
    epsw double comment '加权平均每股收益(元/股)',
    epscut double comment '扣除非经常损益后的基本每股收益(元/股)',
    epscutw double comment '扣除非经常损益后的加权每股收益(元/股)',
    roe double comment '全面摊薄净资产收益率(%)',
    roew double comment '加权平均净资产收益率(%)',
    roecut double comment '扣除非经常性损益的全面摊薄净资产收益率(%)',
    roecutw double comment '扣除非经常性损益后的加权平均净资产收益率(%)',
    ncfoperaps double comment '每股经营活动现金流量净额(元/股)',
    tassets double comment '总资产',
    tequityattrp double comment '归属于母公司所有者权益合计',
    paidincapital double comment '股本',
    nassetps double comment '每股净资产(元)',
    primary key(windcode, findt)
);
select * from research.fs_fdmt_express_uqer;


drop table research.info_pub_events_uqer;
create table research.info_pub_events_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    eventid int not null comment '事件ID',
    sourceid varchar(20) not null comment '事件对应原始表的ID，若没有则为空。',
    eventname nvarchar(50) comment '事件名称',
    eventdate date comment '事件实际发生日期。',
    publishdate date comment '事件对外发布日期。',
    intodate datetime comment '事件记录到数据库时间。',
    eventvalue double comment '描述事件发生的程度。',
    enddate date comment '事件对应的财报报告期，若没有则为空。',
    primary key(windcode, eventid, sourceid, publishdate)
);
select * from research.info_pub_events_uqer;


create table research.factor_fancy30_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    aisude double comment 'AI未预期归母净利润差值',
    sude double comment '未预期季度归母净利润差值',
    lpnpq double comment '净利润提纯',
    npqyoy double comment '季度归母净利润同比',
    roeqyoyd double comment '季度净资产收益率同比差值',
    rrocq double comment '营业能力改善',
    dtop double comment '股息率TTM',
    aietopz180 double comment 'AI预测市盈率倒数180天标准化',
    etopq double comment '季度市盈率倒数',
    detopq double comment '季度归母净利润同比差值市值比',
    bcvp05m20d double comment '收盘成交量占比',
    upp01m20d double comment '高频上行波动率',
    voll01m20d double comment '大成交量下波动率',
    udsl double comment '上下影线',
    taentropy double comment '成交额占比熵',
    ashareholderz double comment '股东数据时序标准分',
    condape60 double comment '一致预期PE60日变化率',
    astprofituppct double comment '分析师净利润上涨比例',
    gsa double comment '月度券商金股推荐机构数',
    hkholdratioall double comment '北向资金持股比例',
    hkholdratiob double comment '北向券商类资金持股比例',
    hkholdvolchgb120 double comment '北向券商类资金120日持股数变化',
    fundt10count double comment '重仓基金个数',
    naiveweightchgasym double comment '基金重仓股变化不对称和',
    preportdiff double comment '定期财报预披露日变化',
    aidanp60 double comment 'AI归母净利润60日变化',
    aidape60 double comment 'AI市盈率60日变化',
    sumexclpatent1y double comment '过去1年发明专利独权专利总数',
    astrptsentiw double comment '研报情感得分加权求和',
    astrptsentiz730 double comment '研报情感730日标准化',
    primary key(windcode, trddt)
);
select * from research.factor_fancy30_uqer;


create table research.factor_hkratiob_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    hkholdratioall double comment '北向资金持股比例',
    hkholdratiob double comment '北向券商类资金持股比例',
    hkholdvolchgb120 double comment '北向券商类资金120日持股数变化',
    primary key(windcode, trddt)
);
select * from research.factor_hkratiob_uqer;


create table research.factor_hk_ratio_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    hkholdratioall double comment '北向资金持股比例',
    hkholdratiob double comment '北向券商类资金持股比例',
    primary key(windcode, trddt)
);
select * from research.factor_fancy30_uqer;


create table research.quote_hktopfihold_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    vol double,
    ratio double,
    primary key(windcode, trddt)
);
select * from research.quote_hktopfihold_uqer;


create table research.quote_hk_fi_hold_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    shcid varchar(30) not null comment '交易商代码',
    vol double,
    ratio double,
    primary key(windcode, trddt, shcid)
);
select * from research.quote_hk_fi_hold_uqer;


create table research.quote_margin_info_uqer(
    windcode varchar(20) not null comment '万得代码',
    trddt date not null comment '获取到该信息的日期',
    finval double comment'本日融资余额',
    finbuyval double comment'本日融资买入额',
    finrefundval double comment'本日融资偿还额',
    secvol double comment'本日融券余量',
    secsellvol double comment'本日融券卖出量',
    secrefundvol double comment'本日融券偿还量',
    secval double comment'本日融券余量金额',
    tradeval double comment'本日融资融券余额',
    primary key(windcode, trddt)
);
select * from research.quote_margin_info_uqer;



drop table research.fs_promo_cninfoweb;
create table research.fs_promo_cninfoweb(
    windcode varchar(20) not null comment '万得代码',
    findt date not null comment '报告期',
    report_date date not null comment '网站显示的日期',
    trddt date not null comment '获取到该信息的日期',
    change_type nvarchar(50) comment '变动类型',
    content nvarchar(200) comment '内容',
    reason nvarchar(500) comment '原因',
    npchgub double comment '变动上限',
    npchglb double comment '变动下限',
    primary key(windcode, findt)
);
select * from research.fs_promo_cninfoweb;


drop table research.info_ind_sw_wind;
create table research.info_ind_sw_wind(
    windcode varchar(20) not null comment '万得代码',
    numcode int not null,
    name nvarchar(40) not null,
    level int not null, 
    primary key(level, numcode)
);
select * from research.info_ind_sw_wind;


drop table research.ind_sw_eom_wind;
create table research.ind_sw_eom_wind(
    trddt date not null,
    windcode varchar(20) not null comment '万得代码',
    sw_level1 int,
    sw_level2 int,
    primary key(trddt, windcode)
);
select * from research.ind_sw_eom_wind;


drop table research.quote_ashare_delist_wind;
create table research.quote_ashare_delist_wind(
    trddt date not null,
    windcode varchar(20) not null comment '万得代码',
    delist_warning int not null,
    primary key(trddt, windcode)
);
select * from research.quote_ashare_delist_wind;


drop table research.quote_beta_eom_120;
create table research.quote_beta_eom_120(
    trddt date not null,
    windcode varchar(20) not null comment '万得代码',
    beta double,
    primary key(trddt, windcode)
);
select * from research.quote_beta_eom_120;


drop table research.quote_beta_eow_120;
create table research.quote_beta_eow_120(
    trddt date not null,
    windcode varchar(20) not null comment '万得代码',
    beta double,
    primary key(trddt, windcode)
);
select * from research.quote_beta_eow_120;


drop table research.info_portinfo_meishi_jc;
create table research.info_portinfo_meishi_jc(
    port_id varchar(50) not null primary key,
    port_name nvarchar(50),
    create_time datetime,
    author nvarchar(30),
    institute nvarchar(50),
    authorized int,
    industry nvarchar(30),
    primary key(trddt, windcode)
);
select * from research.info_portinfo_meishi_jc;


drop table research.info_portchg_meishi_jc;
create table research.info_portchg_meishi_jc(
    id int not null primary key,
    windcode varchar(20) not null comment '万得代码',
    trddt date not null,
    optime time not null,
    remark nvarchar(100),
    side int,
    updatetime datetime,
    author_id int,
    author nvarchar(30),
    inst_id int,
    institute nvarchar(30),
    old_pos double,
    new_pos double
);
select * from research.info_portchg_meishi_jc;


drop table research.info_portchg_meishi_xy;
create table research.info_portchg_meishi_xy(
    id int not null primary key,
    combName varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci not null,
    stockID varchar(20) not null comment '万得代码',
    adjDate date not null,
    updateTime datetime,
    analyst nvarchar(30),
    institute nvarchar(50),
    old_pos int,
    new_pos int,
    adjType nvarchar(20),
    direction nvarchar(10)
);
select * from research.info_portchg_meishi_xy;


-- --------------- CSMAR ------------------
drop table research.rpt_forecast_detail_csmar;
create table research.rpt_forecast_detail_csmar(
    stkcd int comment '证券代码 - 交易所发布的证券代码',
    rptdt date comment '报告公布日 - 盈利预测指标公布的时间以yyyy-mm-dd列示，部分缺少在相应位置上以00表示，如2001年12月某日表示为2001-12-00',
    fenddt date not null comment '预测终止日 - 指分析师预测的盈利指标到期日以yyyy-mm-dd列示，部分缺少在相应位置上以00表示，如2001年12月某日表示为2001-12-00',
    ananmid varchar(200) comment '分析师id - 国泰安内部编制',
    ananm nvarchar(200) comment '分析师姓名 - 做出盈利预测的分析师姓名，若有多名分析师，则依次列出',
    reportid int not null comment '研究报告id - 国泰安内部编制',
    institutionid double comment '证券公司id - 国泰安内部编制',
    brokern nvarchar(100) comment '证券公司名称 - 提供上市公司研究报告的研究机构名称',
    feps double comment '每股收益 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fpe double comment '市盈率 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fnetpro double comment '净利润 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    febit double comment '息税前收入 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    febitda double comment '扣除息、税、折旧及摊销前收入 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fturnover double comment '主营业务收入 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fcfps double comment '每股经营现金流 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fbps double comment '每股净资产 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    froa double comment '总资产收益率 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    froe double comment '净资产收益率 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    fpb double comment '市净率 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    ftotalassetsturnover double comment '总资产周转率 - 机构或分析师所提供的上市公司研究报告中披露的相应指标值',
    primary key(reportid, fenddt)
);
select * from research.rpt_forecast_detail_csmar;




-- --------------- zyyx ------------------


-- --------------- 期货信息 ------------------

drop table research.info_futureinfo_tushare;
create table research.info_futureinfo_tushare(
    windcode varchar(20) not null comment '万得代码',
    ts_code varchar(20) not null comment 'tushare代码',
    symbol varchar(20) not null comment '交易代码',
    exchange varchar(20) not null comment '交易所代码',
    name nvarchar(30) not null comment '合约名称',
    fut_code varchar(10) not null comment '品种代码',
    multiplier int comment '合约乘数',
    trade_unit nvarchar(10) not null comment '计量单位',
    per_unit double not null comment '交易单位',
    quote_unit nvarchar(50) not null comment '报价单位',
    quote_unit_desc nvarchar(50) not null comment '最小报价单位',
    d_mode_desc nvarchar(50) not null comment '交割方式',
    list_date date not null comment '上市日期',
    delist_date date not null comment '最后交易日',
    d_month varchar(10) not null comment '交割月份',
    last_ddate date not null comment '最后交割日',
    primary key(ts_code)
);
select * from research.info_futureinfo_tushare;


drop table research.quote_futureeod_tushare;
create table research.quote_futureeod_tushare(
    trddt date not null comment '交易日期', # 交易日
    windcode varchar(20) not null comment '万得代码', #万得代码
    opprc decimal(20,6) comment '开盘价',
    highprc decimal(20,6) comment '最高价',
    lowprc decimal(20,6) comment '最低价',
    clsprc decimal(20,6) comment '收盘价',
    avgprc decimal(20,6) comment '均价',
    settle decimal(20,6) comment '结算价',
    preclose decimal(20,6) comment '前收盘价',
    presettle decimal(20,6) comment '前结算价',
    pctchange decimal(12,8) comment '涨跌幅%',
    vol decimal(20,6) comment '成交量',
    amt decimal(20,6) comment '成交额',
    oi int comment '持仓量',
    oi_chg int comment '持仓量变化',
    primary key (trddt,windcode)
);
select * from research.quote_futureeod_tushare;
