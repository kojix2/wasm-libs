# ==============================================================================
# Version Configuration
# ==============================================================================
# Centralized version management for all components.
# Override any variable with: make VAR=value
#
# Example:
#   make WASI_SDK_MAJOR=33 build-container
#   make BDWGC_VERSION=v8.2.12 libgc
# ==============================================================================

# Builder base image
ALPINE_VERSION ?= 3.24

# WASI SDK toolchain
WASI_SDK_MAJOR ?= 33
WASI_SDK_FULL ?= 33.0+m
WASI_TARGET ?= wasm32-wasip1
WASI_HOST ?= wasm32-wasi

# Library versions (Git tags)
BDWGC_VERSION ?= v8.2.12
PCRE2_VERSION ?= pcre2-10.47
