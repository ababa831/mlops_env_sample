# 環境差分を生じさせないように，CPU・GPU環境用Dockerfileともに同じBase Imageを利用
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

MAINTAINER ababa831 <flvonlineconverter@gmail.com>

# 必要なpackageのインストール．
# nginx, ca-certificatesはSageMaker API用
# mecab, libmecab-dev, mecab-ipadic-utf8は，NLP系タスクで必須
# editor関係は任意で追加可
RUN apt-get update
RUN apt-get install -y \
    locales \
    curl \
    wget \
    git \
    sudo \
    unzip \ 
    python3-all-dev \
    python3-pip \
    python3-venv \
    nginx \
    ca-certificates \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    nano
RUN rm -rf /root/.cache

# 地域，言語等の設定
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Python関係の設定
RUN pip3 install --upgrade pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Poetry関係の設定
# 導入
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
ENV PATH $PATH:/root/.poetry/bin
# Poetry仮想環境ディレクトリを固定化（この場合，カレントディレクトリに仮想環境が作成される）
# APIで仮想環境先のPythonインタプリタを使うので，仮想環境パスがランダムに生成されないようにしたかった
RUN mkdir -p /root/.config/pypoetry/ \
    && touch /root/.config/pypoetry/config.toml \
    && poetry config settings.virtualenvs.create true \
    && poetry config settings.virtualenvs.in-project true \
    && poetry install

# SageMaker関係の設定