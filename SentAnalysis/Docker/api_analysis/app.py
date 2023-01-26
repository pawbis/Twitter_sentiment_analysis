import pandas as pd
import re,emoji,json
from transformers import pipeline

path = '/twitter_api_folder/data.json'
f = open(path)

data = json.load(f)
data = data['data']
df = pd.DataFrame.from_dict(data)

def remove_emojis(data):
    emoj = re.compile("["
        u"\U0001F600-\U0001F64F"  # emoticons
        u"\U0001F300-\U0001F5FF"  # symbols & pictographs
        u"\U0001F680-\U0001F6FF"  # transport & map symbols
        u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
        u"\U00002500-\U00002BEF"  # chinese char
        u"\U00002702-\U000027B0"
        u"\U00002702-\U000027B0"
        u"\U000024C2-\U0001F251"
        u"\U0001f926-\U0001f937"
        u"\U00010000-\U0010ffff"
        u"\u2640-\u2642" 
        u"\u2600-\u2B55"
        u"\u200d"
        u"\u23cf"
        u"\u23e9"
        u"\u231a"
        u"\ufe0f"  # dingbats
        u"\u3030"
                      "]+", re.UNICODE)
    return re.sub(emoj, '', data)

def cleanTweet(tweet):
    if 'RT' in tweet[:3]:
        tweet = tweet.replace('RT','')
    tweet = remove_emojis(tweet)
    tweet = tweet.replace(':','')
    tweet = re.sub("@[A-Za-z0-9]+","",tweet) #Remove @ sign
    tweet = re.sub(r"(?:\@|http?\://|https?\://|www)\S+", "", tweet) #Remove http links
    tweet = re.sub(r"(?:\@|http?\://|https?\://|www)\S+", "", tweet) #Remove http links
    tweet = " ".join(tweet.split())
    tweet = ''.join(c for c in tweet if c not in emoji.UNICODE_EMOJI) #Remove Emojis
    tweet = tweet.replace("#", "").replace("_", " ") #Remove hashtag sign but keep the text
    return tweet

def cleanDf(columnName):
    cleanList = []
    for tweet in df[columnName]:
        clean_tweet = cleanTweet(tweet)
        cleanList.append(clean_tweet)
    df[columnName] = cleanList
cleanDf('text')

sentiment_pipeline = pipeline(model='finiteautomata/bertweet-base-sentiment-analysis')

def sentiment():
    label = []
    score = []
    for i in df['text']:
        label.append(sentiment_pipeline(i)[0]['label'])
        score.append(sentiment_pipeline(i)[0]['score'])
    df['Sentiment label'] = label
    df['Sentiment Score'] = score

sentiment()

df = df.drop(['id', 'edit_history_tweet_ids'], axis = 1)
df.to_json('/twitter_api_folder/results.json')