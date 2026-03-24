FROM debian:bookworm-slim AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        libusb-1.0-0-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone --depth 1 https://github.com/raspberrypi/usbboot.git .

WORKDIR /src

RUN make \
    && install -m 0755 rpiboot /usr/local/bin/rpiboot

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/rpiboot /usr/local/bin/rpiboot

ENTRYPOINT ["rpiboot"]
CMD ["-h"]
