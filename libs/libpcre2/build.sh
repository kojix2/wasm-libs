#!/usr/bin/env bash
# Build PCRE2 (Perl Compatible Regular Expressions v2) for WASM
set -euo pipefail

git clone --branch "${PCRE2_VERSION}" --depth 1 https://github.com/PCRE2Project/pcre2
cd pcre2

export CC="clang"
export CFLAGS="-target ${WASI_TARGET} --sysroot=${SYSROOT} -Os"

./autogen.sh

./configure \
  --host=${WASI_HOST} \
  --with-sysroot=${SYSROOT} \
  --disable-shared \
  --disable-pcre2grep-callout

make -j$(nproc) libpcre2-8.la

llvm-ranlib .libs/libpcre2-8.a

cp src/pcre2.h $SYSROOT/include
cp .libs/libpcre2-8.a $SYSROOT/lib/wasm32-wasi
