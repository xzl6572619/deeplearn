def cal_new_position(calculate_table, weight_of_topstock=0.01, weight_decreaseing_rate=0.95):
    sorted_table = calculate_table.sort_values(by="score", ascending=False)  # 对表按照score进行排序。
    sorted_table.loc[:, "rank"] = range(len(sorted_table))

    sorted_table.loc[:, "weight"] = weight_of_topstock * weight_decreaseing_rate ** sorted_table.loc[:, "rank"]
    sorted_table.loc[sorted_table.loc[:, "weight"].cumsum() > 1, "weight"] = 0  # 总比重不能大于1

    return sorted_table


def cal_daily_positiondiff(calculate_table):

    calculate_table.loc[:, "position_diff"] = calculate_table.loc[:, "weight"] - calculate_table.loc[:,
                                                                                 "present_position"]
    return calculate_table.loc[:, "position_diff"]
