FROM debian:buster as base-build

RUN apt update && apt install -y -qq \
    git \
    build-essential \
    libevent-dev \
    libjpeg-dev \
    libbsd-dev

WORKDIR /tmp
RUN git clone --depth=1 https://github.com/pikvm/ustreamer && cd ustreamer \
    && make 

FROM debian:buster as pre-release
RUN apt update && apt install -y -qq --no-install-recommends \
    libevent-2.1-6 \
    libevent-pthreads-2.1-6 \
    libjpeg62-turbo \
    libbsd0 \
    dumb-init \
    v4l-utils \
    && rm -rf /var/lib/apt/lists/*

FROM scratch as release
COPY --from=pre-release / /
COPY --from=base-build /tmp/ustreamer/ustreamer /usr/bin/ustreamer
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/usr/bin/ustreamer" ]