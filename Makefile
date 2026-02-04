# WebAssembly WASI Libraries Build System
include versions.mk

# Builder image versioning (rebuild when Dockerfile or versions change)
BUILDER_IMAGE_VERSION=$(shell cat Dockerfile versions.mk | sha256sum | cut -d ' ' -f1)
BUILDER_IMAGE_NAME=wasm-libs-builder-image

# Auto-detect container CLI (docker or podman)
CONTAINER_CLI ?= $(shell if command -v docker >/dev/null 2>&1; then echo docker; elif command -v podman >/dev/null 2>&1; then echo podman; else echo docker; fi)

# Podman-specific flags for SELinux and user namespace
MOUNT_FLAGS=--volume=$(PWD):/mnt
EXTRA_RUN_FLAGS=
ifeq ($(CONTAINER_CLI),podman)
MOUNT_FLAGS=--volume=$(PWD):/mnt:Z
EXTRA_RUN_FLAGS=--userns=keep-id
endif

# TTY detection for interactive flag
DOCKER_STDIN=$(shell test -t 0 && echo -i)
DOCKER_STDOUT=$(shell test -t 1 && echo -t)

# Containerized build environment
BUILD_ENV=$(CONTAINER_CLI) run --rm $(DOCKER_STDIN) $(DOCKER_STDOUT) $(EXTRA_RUN_FLAGS) $(MOUNT_FLAGS) --user=$(shell id -u):$(shell id -g) --workdir=/tmp \
	-e "SYSROOT=/mnt/wasm32-wasi-sysroot" \
	-e "WASI_SDK_MAJOR=$(WASI_SDK_MAJOR)" -e "WASI_SDK_FULL=$(WASI_SDK_FULL)" \
	-e "BDWGC_VERSION=$(BDWGC_VERSION)" -e "PCRE2_VERSION=$(PCRE2_VERSION)" \
	$(BUILDER_IMAGE_NAME)

all: libc libclang_rt libpcre2 libgc

build-container:
	@if [ "$$( $(CONTAINER_CLI) inspect $(BUILDER_IMAGE_NAME) --format '{{ index .Config.Labels "version"}}' 2>/dev/null || true)" != "$(BUILDER_IMAGE_VERSION)" ]; then \
		$(CONTAINER_CLI) build --pull -t $(BUILDER_IMAGE_NAME) \
			--build-arg BUILDER_IMAGE_VERSION=$(BUILDER_IMAGE_VERSION) \
			--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
			--build-arg WASI_SDK_MAJOR=$(WASI_SDK_MAJOR) \
			--build-arg WASI_SDK_FULL=$(WASI_SDK_FULL) \
			.; \
	fi

wasm32-wasi-sysroot:
	@mkdir -p wasm32-wasi-sysroot/lib/wasm32-wasi
	@mkdir -p wasm32-wasi-sysroot/include

clean:
	rm -rf wasm32-wasi-sysroot

tar: all
	tar -zcf wasm32-wasi-sysroot.tar.gz wasm32-wasi-sysroot
	cd wasm32-wasi-sysroot/lib/wasm32-wasi && tar -zcf ../../../wasm32-wasi-libs.tar.gz *

debug-cli:
	$(BUILD_ENV) bash

.PHONY: build-container clean all tar

include libs/*/Makefile
