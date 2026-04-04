# ==============================================================================
# Version Configuration
# ==============================================================================
# Centralized version management for all components.
# Override any variable with: make VAR=value
#
# Example:
#   make WASI_SDK_MAJOR=30 build-container
#   make BDWGC_VERSION=v8.3.0 libgc
# ==============================================================================

# Builder base image
ALPINE_VERSION ?= 3.23

# WASI SDK toolchain
WASI_SDK_MAJOR ?= 30
WASI_SDK_FULL ?= $(WASI_SDK_MAJOR).0

# Library versions (Git tags)
BDWGC_VERSION ?= v8.2.10
PCRE2_VERSION ?= pcre2-10.47
