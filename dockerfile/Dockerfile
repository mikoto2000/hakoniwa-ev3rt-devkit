# 実行環境のビルド
FROM debian:buster-slim AS runtime-build-env

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "TOPPERS/箱庭 単体ロボット向けシミュレータ(https://toppers.github.io/hakoniwa/prototypes/single-robot/)の実行環境ビルド"

ARG athrill_build_root="/athrill"

RUN apt-get update \
    && apt-get -y install \
        git \
        build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir ${athrill_build_root} \
    && cd ${athrill_build_root} \
    && git clone --depth 1 https://github.com/toppers/athrill.git \
    && git clone --depth 1 https://github.com/toppers/athrill-target-v850e2m.git \
    && cd ${athrill_build_root}/athrill-target-v850e2m/build_linux \
    && make timer32=true clean \
    && make timer32=true \
    && cp /athrill/athrill/bin/linux/athrill2 /usr/local/bin/athrill2


# athrill-gcc
FROM debian:buster-slim AS athrill-gcc

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "TOPPERS/箱庭 athrill-gcc コピー元イメージ"

RUN apt-get update \
    && apt-get -y install \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/toppers/athrill-gcc-v850e2m/releases/download/v1.1/athrill-gcc-package.tar.gz \
    && tar xf athrill-gcc-package.tar.gz \
    && tar xf athrill-gcc-package/athrill-gcc.tar.gz -C / \
    && rm -rf athrill-gcc-package*


# EV3RT 開発環境
FROM debian:buster-slim AS ev3rt-sdk

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "TOPPERS/箱庭 単体ロボット向けシミュレータ(https://toppers.github.io/hakoniwa/prototypes/single-robot/)の EV3RT 開発環境"

RUN apt-get update \
    && apt-get -y install \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/toppers/ev3rt-athrill-v850e2m.git


# アプリケーションビルド・実行環境
FROM debian:buster-slim

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="1.0.0"
LABEL description "TOPPERS/箱庭 単体ロボット向けシミュレータ(https://toppers.github.io/hakoniwa/prototypes/single-robot/)のアプリケーションビルド環境"

RUN apt-get update \
    && apt-get -y install \
        ruby \
        make \
        dnsutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=runtime-build-env \
    /usr/local/bin/athrill2 \
    /usr/local/bin/athrill2

COPY --from=athrill-gcc \
    /usr/local/athrill-gcc \
    /usr/local/athrill-gcc

COPY --from=ev3rt-sdk \
    /ev3rt-athrill-v850e2m \
    /ev3rt-athrill-v850e2m

COPY --from=runtime-build-env \
    /athrill/athrill/apl/src/athrill-syscall.c \
    /athrill/apl/src/athrill-syscall.c

COPY --from=runtime-build-env \
    /athrill/athrill/apl/include/athrill_syscall.h \
    /athrill/apl/include/athrill_syscall.h

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

ENV PATH=/usr/local/athrill-gcc/bin/:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/athrill-gcc:/usr/local/athrill-gcc/lib:${LD_LIBRARY_PATH}
ENV RUBYOPT=-EUTF-8

