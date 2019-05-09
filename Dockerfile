FROM debian:stretch as builder

WORKDIR /tor

COPY . .

RUN apt-get update && apt-get -y install autotools-dev \
    automake build-essential libevent-dev libssl-dev zlib1g zlib1g-dev \
    liblzma-dev 


RUN sh autogen.sh

RUN ./configure --disable-asciidoc --with-libevent-dir=/usr/local && make && make install

FROM debian:stretch-slim

COPY --from=builder /usr /usr

RUN groupadd tor && useradd -g tor -m -d /home/tor tor

USER tor

CMD [ "tor" ]