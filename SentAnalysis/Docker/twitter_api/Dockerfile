FROM ubuntu:latest

WORKDIR /twitter_api

COPY req.txt .
COPY app.py .

RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3-pip \
    && apt-get install -y python3

RUN pip3 install -r req.txt
ENTRYPOINT ["python3","app.py"]
