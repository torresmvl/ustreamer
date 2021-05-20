FROM alpine:3.12 as base-build

RUN apk --upgrade add --no-cache \
    git \
    alpine-sdk \
    libevent-dev \
    libjpeg-turbo-dev \
    libbsd-dev

# raspberrypi-dev \ libgpiod
RUN ARCH=$(uname -m); \
    if [[ "$ARCH" == "armv7l" || "aarch64" ]]; \
    then apk --upgrade add \
    raspberrypi-dev \
    libgpiod-dev; \
    else continue; \
    fi

WORKDIR /tmp
RUN git clone --depth=1 https://github.com/pikvm/ustreamer && cd ustreamer; \
    ARCH=$(uname -m); \
    if [[ "$ARCH" == "armv7l" || "aarch64" ]]; \
    then WITH_PTHREAD_NP=0 WITH_OMX=1 WITH_GPIO=1 make; \
    else WITH_PTHREAD_NP=0 make; \
    fi

FROM alpine:3.12 as pre-release

RUN apk --update add --no-cache \
    tini \
    libevent \
    libjpeg-turbo \
    libbsd

RUN ARCH=$(uname -m); \
    if [[ "$ARCH" == "armv7l" || "aarch64" ]]; \
    then apk --upgrade add \
    raspberrypi \
    libgpiod; \
    else continue; \
    fi

FROM scratch as release
ENV LD_LIBRARY_PATH=/opt/vc/lib
COPY --from=pre-release / /
COPY --from=base-build /tmp/ustreamer/ustreamer /usr/bin/ustreamer
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "/usr/bin/ustreamer" ]
