#!/usr/bin/env bash
# Download and extract WASI sysroot (libc + headers)
set -euo pipefail

url="https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_MAJOR}/wasi-sysroot-${WASI_SDK_FULL}.tar.gz"
curl -fsSL --retry 3 --retry-connrefused -o /tmp/wasi-sysroot.tar.gz "$url"

rm -rf wasi-sysroot
tar -xzf /tmp/wasi-sysroot.tar.gz

cp -r wasi-sysroot-${WASI_SDK_FULL}/include/* "$SYSROOT/include"
mkdir -p "$SYSROOT/lib/${WASI_TARGET}"
cp -r wasi-sysroot-${WASI_SDK_FULL}/lib/${WASI_TARGET}/* "$SYSROOT/lib/${WASI_TARGET}"
cp -r "$SYSROOT/lib/${WASI_TARGET}"/* "$SYSROOT/lib/wasm32-wasi"
