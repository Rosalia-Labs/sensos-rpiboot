# sensos-rpiboot

Local `rpiboot` build for macOS without installing it into the OS.

## macOS local build

This repo builds `rpiboot` into a local `usbboot/` directory and leaves the binary there.

Install the missing build dependencies with MacPorts. `git` is only needed if you do not already have a usable `git` in `PATH`, and `pkgconf` is fine if it already provides `pkg-config`:

```bash
sudo port install libusb
```

Build locally:

```bash
./build-rpiboot.sh
```

Run it:

```bash
./usbboot/rpiboot
```

The script will:

- clone `raspberrypi/usbboot` into `./usbboot`
- update that checkout on later runs
- build `rpiboot` in place
- avoid `make install` or copying binaries into system paths

## Linux Docker option

The included [Dockerfile](/Users/keittth/Projects/sensos-rpiboot/Dockerfile) is still useful on Linux hosts where raw USB passthrough is available:

```bash
docker build -t sensos-rpiboot .
docker run --rm --privileged -v /dev/bus/usb:/dev/bus/usb sensos-rpiboot
```

This is not a good fit for Docker Desktop on macOS because direct USB passthrough is limited there.
