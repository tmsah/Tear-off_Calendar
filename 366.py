# coding:UTF-8
import json
import csv

json_list = []
json_data = {}

# CSVファイルのロード
with open('./366daysWord.csv', 'r') as f:
    # list of dictの作成
    for line in csv.DictReader(f):
        json_list.append(line)

    json_data["datesInfo"] = json_list

with open('./DatesInfo.json', 'w') as f:
    # JSONへの書き込み
    json.dump(json_data, f, ensure_ascii=False)