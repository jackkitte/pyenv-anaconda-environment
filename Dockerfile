FROM jackkitte/development-environment-japanese
LABEL maintainer="tamash"

WORKDIR /home/tamash

# Neologism dictionary のインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /home/tamash/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y

# pyenv のインストール
RUN git clone git://github.com/yyuu/pyenv.git ${HOME}/.pyenv
RUN git clone https://github.com/yyuu/pyenv-pip-rehash.git ${HOME}/.pyenv/plugins/pyenv-pip-rehash
ENV PYENV_ROOT ${HOME}/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
RUN echo 'eval "$(pyenv init -)"' >> .zshrc

# anaconda のインストール
ENV ANACONDA_VER 5.2.0
ENV LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$PYENV_ROOT/versions/anaconda3-$ANACONDA_VER/lib
RUN pyenv install anaconda3-$ANACONDA_VER
RUN pyenv global anaconda3-$ANACONDA_VER
ENV PATH $PYENV_ROOT/versions/anaconda3-$ANACONDA_VER/bin:$PATH

# ライブラリのアップデート
RUN conda update -y conda
RUN pip install --upgrade pip
RUN pip install mecab-python3
RUN pip install ptvsd==3.0.0
RUN conda install -c conda-forge gensim
RUN conda install -c conda-forge wordcloud
RUN conda install -c conda-forge pygrib=2.0.2
RUN conda install -c conda-forge jpeg

# workディレクトリへzshでattach
WORKDIR /home/tamash/work
ENTRYPOINT [ "/bin/zsh" ]
