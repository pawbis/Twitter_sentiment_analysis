import json
import pandas as pd


path = '/twitter_api_folder/results.json'
f = open(path)

data = json.load(f)
data = data['data']
df = pd.DataFrame.from_dict(data)
print(df)
