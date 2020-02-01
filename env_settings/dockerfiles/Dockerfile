# 環境差分を生じさせないように，CPU・GPU環境用Dockerfileともに同じBase Imageを起点に本スクリプトを利用
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

MAINTAINER ababa831 <flvonlineconverter@gmail.com>

SHELL ["/bin/bash", "-c"]

# SageMaker APIはこのディレクトリをベースに動くので，予め作業ディレクトリとして設定
WORKDIR /opt/program

# TODO: GPU版コンテナ周りの設定
# NotImplemented

# 必要なpackageのインストール．
# wget, nginx, ca-certificatesはSageMaker API用
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

# Poetryの導入（Pythonパッケージ依存関係の自動解決用）
ARG dependencies="dependencies/cpu"
COPY ${dependencies}/pyproject.toml .
# COPY ${dependencies}/poetry.lock .
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
ENV PATH $PATH:/root/.poetry/bin
RUN mkdir  -p /root/.config/pypoetry/
RUN touch /root/.config/pypoetry/config.toml
RUN echo -e "virtualenvs.create = false\nvirtualenvs.in-project = false\nvirtualenvs.path = '/root/venvs'" > /root/.config/pypoetry/config.toml
RUN poetry install

# mecab-ipadic-NEologd（新語に強いMeCab辞書）の設定
# こちらもNLP系タスクでほぼ必須
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
RUN cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y -a
RUN rm -rf mecab-ipadic-neologd

# Neologdのユーザ辞書周りの設定
# リポジトリのenv_settings/dictionaries内の特定のcsvを適用．csvはdocker-compose.ymlで指定
ARG csv='sample_userdic.csv'
COPY dictionaries/${csv} /opt/program/.userdic.csv
RUN /usr/lib/mecab/mecab-dict-index -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd\
    -u /opt/program/.mda_userdic.csv -f utf-8 -t utf-8 /opt/program/.userdic.csv && \
    echo "userdic = /opt/program/.mda_userdic.csv" >> /etc/mecabrc

# Jupyterlabのパスワード設定 (デモ用password: aaaa)
RUN poetry run jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:32bdbb42ed45:5e0b1d1681e9eaf60ee8bd158921a90ac30705a3'" >> /root/.jupyter/jupyter_notebook_config.py

# SageMaker関係の設定．以下のENVを設定しないとAPIデプロイ時，利用時にコケる．（以下のリンクを参照）
# https://github.com/awslabs/amazon-sagemaker-examples/blob/master/advanced_functionality/scikit_bring_your_own/container/Dockerfile
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"
ENV PYTHONHASHSEED 1

# エントリポイントのコピー
ARG entrypoint='entrypoint.sh'
COPY ${entrypoint} /opt/program/entrypoint.sh
