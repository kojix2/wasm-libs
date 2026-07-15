# WASI SDK WebAssembly Builder Image
# Note: Version values are passed via --build-arg from Makefile (sourced from versions.mk)
ARG ALPINE_VERSION=3.24
FROM alpine:${ALPINE_VERSION}

ARG BUILDER_IMAGE_VERSION
LABEL version=${BUILDER_IMAGE_VERSION}

ARG WASI_SDK_MAJOR
ARG WASI_SDK_FULL

RUN apk add --no-cache \
  autoconf \
  automake \
  bash \
  binutils \
  ca-certificates \
  clang \
  curl \
  git \
  libtool \
  lld \
  llvm \
  make

# Install WASI SDK libclang_rt builtins into clang resource directory
RUN set -euo pipefail; \
  url="https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_MAJOR}/libclang_rt-${WASI_SDK_FULL}.tar.gz"; \
  curl -fsSL --retry 3 --retry-connrefused -o /tmp/builtins.tar.gz "$url"; \
  tar -xzf /tmp/builtins.tar.gz -C /tmp; \
  clang_resource_dir="$(clang -print-resource-dir)"; \
  mkdir -p "$clang_resource_dir/lib/wasi"; \
  mkdir -p "$clang_resource_dir/lib/wasm32-unknown-wasi"; \
  mkdir -p "$clang_resource_dir/lib/wasm32-unknown-wasip1"; \
  cp "/tmp/libclang_rt-${WASI_SDK_FULL}/wasm32-unknown-wasi/libclang_rt.builtins.a" \
     "$clang_resource_dir/lib/wasi/libclang_rt.builtins-wasm32.a"; \
  cp "/tmp/libclang_rt-${WASI_SDK_FULL}/wasm32-unknown-wasi/libclang_rt.builtins.a" \
     "$clang_resource_dir/lib/wasm32-unknown-wasi/libclang_rt.builtins.a"; \
  cp "/tmp/libclang_rt-${WASI_SDK_FULL}/wasm32-unknown-wasi/libclang_rt.builtins.a" \
     "$clang_resource_dir/lib/wasm32-unknown-wasip1/libclang_rt.builtins.a"; \
  rm -rf /tmp/libclang_rt-${WASI_SDK_FULL} /tmp/builtins.tar.gz
