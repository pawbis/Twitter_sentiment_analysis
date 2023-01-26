import json, requests, os

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
config_path = '//'.join([ROOT_DIR, 'config.json'])

with open(config_path) as config_file:
    config = json.load(config_file)
    config = config['token']

Value = config['value']

headers = {
    'Authorization' : f'Bearer {Value}',
}

query = 'from:elonmusk -is:retweet -is:reply -has:links'

query_params= {
    "query": query,
    "max_results": 10,
}

url = 'https://api.twitter.com/2/tweets/search/recent'

response = requests.get(url, headers=headers, params=query_params)
data = response.json()

path ='/twitter_api_folder/data.json'
with open(path, 'w') as f:
    json.dump(data, f)