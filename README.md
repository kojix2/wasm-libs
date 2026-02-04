# wasm-libs

Build C/C++ libraries for WebAssembly WASI target.

## Usage

```bash
make all              # Build all libraries
make libc libgc       # Build specific libraries
make clean            # Remove build artifacts
```

Requires: Docker or Podman

## Libraries

| Library | Version |
| --- | --- |
| libc | WASI SDK 29 |
| libclang_rt | WASI SDK 29 |
| libgc | v8.2.10 |
| libpcre2 | 10.47 |

Output: `wasm32-wasi-sysroot/lib/wasm32-wasi/*.a`

## Version Updates

Edit `versions.mk`:
```makefile
WASI_SDK_MAJOR ?= 30
BDWGC_VERSION ?= v8.3.0
```

Or override:
```bash
make WASI_SDK_MAJOR=30 build-container
```

See `UPGRADE_NOTES.md` for upgrade procedures.
