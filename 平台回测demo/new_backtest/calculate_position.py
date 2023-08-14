

def cal_new_position(calculate_table):
	sorted_table = calculate_table.sort_values(ascending=False)  # 对表按照score进行排序。
	sorted_table.loc[0,"weight"] = 0.01
	sorted_table.loc[sorted_table.loc[0,"weight"].cumsum()>1,"weight"] = 0  # 总比重不能大于1
	return sorted_table.loc[:,"weight"]

