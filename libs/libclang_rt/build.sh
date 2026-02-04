#!/usr/bin/env bash
# Copy compiler-rt builtins from WASI SDK installation
set -euo pipefail

clang_resource_dir="$(clang -print-resource-dir)"
cp "$clang_resource_dir/lib/wasi/libclang_rt.builtins-wasm32.a" "$SYSROOT/lib/wasm32-wasi/"
