FROM ruby:3.2

# 必要なライブラリのインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn

RUN apt-get update && apt-get install -y git

# 作業ディレクトリの設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

#COPY .git .git

# Gemのインストール
RUN bundle install

# ソースコードをコピー
COPY . .
