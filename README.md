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
| libc | WASI SDK 33 |
| libclang_rt | WASI SDK 33 |
| libgc | v8.2.12 |
| libpcre2 | 10.47 |

Output: `wasm32-wasi-sysroot/lib/wasm32-wasi/*.a`

## Version Updates

Edit `versions.mk`:
```makefile
ALPINE_VERSION ?= 3.24
WASI_SDK_MAJOR ?= 33
WASI_SDK_FULL ?= 33.0+m
WASI_TARGET ?= wasm32-wasip1
WASI_HOST ?= wasm32-wasi
BDWGC_VERSION ?= v8.2.12
PCRE2_VERSION ?= pcre2-10.47
```

Or override:
```bash
make WASI_SDK_MAJOR=33 build-container
```

Quick upgrade check:
```bash
make clean all
make tar
```

See `UPGRADE_NOTES.md` for upgrade procedures.

### Minimal Maintenance Policy

- Keep regular version updates in `versions.mk` only.
- Keep workflow changes in `.github/workflows/release.yml` only.
- Change `libs/*/build.sh` only when upstream changes break builds.

## Release

Push a `v*` tag to run `.github/workflows/release.yml` and publish a GitHub Release.
GitHub Actions versions are maintained by Dependabot.
