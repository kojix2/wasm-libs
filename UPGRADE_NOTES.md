# Upgrade Notes

This repository favors minimal maintenance overhead:

- Update versions in `versions.mk`.
- Keep CI changes in `.github/workflows/release.yml`.
- Touch `libs/*/build.sh` only when upstream changes break builds.

## Standard Upgrade Checklist

1. Update one or more versions in `versions.mk`.
2. Check upstream tag/release notes for each changed dependency.
3. Run `make clean all`.
4. Verify key outputs exist:
   - `wasm32-wasi-sysroot/lib/wasm32-wasi/libc.a`
   - `wasm32-wasi-sysroot/lib/wasm32-wasi/libclang_rt.builtins-wasm32.a`
   - `wasm32-wasi-sysroot/lib/wasm32-wasi/libpcre2-8.a`
   - `wasm32-wasi-sysroot/lib/wasm32-wasi/libgc.a`
5. Run `make tar`.
6. If build failed in libgc and `BDWGC_VERSION` is not `v8.2.x`, review the WASI gcconfig patch section in `libs/libgc/build.sh`.
7. Commit only intended update files (usually `versions.mk`, optionally docs/CI).

## Rollback

- Revert only `versions.mk` to the previous known-good values and rebuild.
