import datetime
import pandas as pd
from useful_function import get_yjgg_data_base_year_month, get_yysj_data_base_year_month


today = datetime.date(2023, 3, 5)
mont = today.month
year = today.year

yysj_df = get_yysj_data_base_year_month(year, mont)
yjgg_df = get_yjgg_data_base_year_month(year, mont)

yysj_vs_yjgg = pd.merge(yysj_df, yjgg_df, on=["股票代码", "accounting_period"], how="outer")
yysj_vs_yjgg.to_csv("yysj_vs_yjgg.csv")
print(yysj_vs_yjgg)
