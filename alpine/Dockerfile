FROM alpine:3.12 as base-build

RUN apk --upgrade add --no-cache \
  git \
  alpine-sdk \
  libevent-dev \
  libjpeg-turbo-dev \
  libbsd-dev

RUN ARCH=$(uname -m); \
  case "$ARCH" in \
  aarch64) apk add raspberrypi-dev libgpiod-dev ;; \
  armv7) apk add raspberrypi-dev libgpiod-dev ;; \
  *) echo "Skipping raspberry dependencies" ;; \
  esac;

WORKDIR /tmp
RUN git clone --depth=1 https://github.com/pikvm/ustreamer && cd ustreamer; \
  ARCH=$(uname -m); \
  case "$ARCH" in \
  x86_64) WITH_PTHREAD_NP=0 make ;; \
  *) WITH_PTHREAD_NP=0 WITH_OMX=1 WITH_GPIO=1 make ;; \
  esac;

FROM alpine:3.12 as pre-release

RUN apk --update add --no-cache \
  tini \
  libevent \
  libjpeg-turbo \
  libbsd

RUN ARCH=$(uname -m); \
  case "$ARCH" in \
  aarch64) apk add raspberrypi libgpiod ;; \
  armv7) apk add raspberrypi libgpiod ;; \
  *) echo "Skipping raspberry dependencies" ;; \
  esac;

FROM scratch as release
ENV LD_LIBRARY_PATH=/opt/vc/lib
COPY --from=pre-release / /
COPY --from=base-build /tmp/ustreamer/ustreamer /usr/bin/ustreamer
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/usr/bin/ustreamer" ]
