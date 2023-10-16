
# 本番環境が18なので
FROM ubuntu:18.04

# packagesのインストール
RUN apt update -y && apt upgrade -y && \
	apt install -y sudo curl jq mysql-client-core-5.7 locales locales-all && \
	# az cmd
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# localeの設定
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV TZ=Asia/Tokyo   

# ユーザー追加
RUN useradd -ms /bin/bash ops && gpasswd -a ops sudo
# RUN echo "ops:${PASSWORD}" | chpasswd
RUN echo "ops:password" | chpasswd

# ファイル
WORKDIR /home/ops/tool
COPY ./tool/* ./
COPY ./.environment.local ./
COPY ./db.local.cnf ./

USER ops
