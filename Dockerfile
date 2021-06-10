FROM debian:buster-slim AS builder

WORKDIR /usr/local/src
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    ca-certificates wget tar git \
    automake build-essential gcc flex bison libncurses-dev libreadline-dev libssh-dev
ARG BIRD_VERSION=2.0.8
RUN wget "https://bird.network.cz/download/bird-${BIRD_VERSION}.tar.gz"
RUN tar -xvf ./bird-2.0.8.tar.gz
WORKDIR "/usr/local/src/bird-${BIRD_VERSION}"
RUN ./configure --sysconfdir=/etc/bird --prefix=/usr/local --runstatedir=/run
RUN sed -E 's/^(git-label:=).*/\1/g' -i ./Makefile
RUN make
RUN make install DESTDIR=/tmp/bird2-install

FROM debian:buster-slim
COPY --from=builder /tmp/bird2-install/ /
RUN apt-get update \
    && apt-get install -y --no-install-recommends libssh-4 libreadline7 \
    && rm -rf /var/lib/apt/lists/*
CMD ["/usr/local/sbin/bird", "-f"]
