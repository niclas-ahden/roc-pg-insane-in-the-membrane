# roc-pg compiler performance

These measurements were taken on a 10-core Apple Silicon Mac with 32 GiB RAM. Native dev-cache reuse is fast, including after app-only runtime edits. Default optimized LLVM builds remain expensive, particularly for the example with twenty distinct query/result-row combinations.

## Revisions

- Compiler: [`roc-lang/roc`, `shared-native-cache-contract`, `839d32a335d4273f9ffdf972e9bf2d668cce7b9c`](https://github.com/roc-lang/roc/commit/839d32a335d4273f9ffdf972e9bf2d668cce7b9c).
- ReleaseFast unstripped compiler binary SHA-256: `b93d0b0527fa0d2e6e40606f5a5ae386a8f823a47837c58b1a829783c568dd9c`.
- roc-pg: the parser refactor in [`368dd113201ecdc70973a3ea298f3d5d7552182e`](https://github.com/niclas-ahden/roc-pg-insane-in-the-membrane/commit/368dd113201ecdc70973a3ea298f3d5d7552182e), with the platform pins published alongside this report and the redundant `OsStr` exposure removed from `small`. This PR also removes the same redundant exposure from the other affected entrypoints.
- Platforms: query/prepared use `roc-lang/basic-cli` 0.24.0; webserver uses `roc-lang/basic-webserver` 0.17.0; small uses `niclas-ahden/basic-cli` 0.28.0. Other entrypoints retain their platform owners and use the updated release pins.

The compiler binary's embedded version still reports the earlier `1ed2` label. The source revision and binary hash above identify the measured compiler; the label alone does not.

The benchmark used hash-verified source copies, not mutable application files. The original raw `small` import was incompatible with basic-cli 0.28.0; its separately recorded compatible input removes `exposing [OsStr]`. Package/schema/SQL sources were not changed.

## Protocol

Commands ran sequentially with the default Roc thread count. Dependencies were prefetched outside measurements. Each primary group used two cache-disabled runs, one unmeasured cache-enabled warmup of the same operation, and two measured warm runs. Cold means `--no-cache`, not an empty filesystem cache or a first cache-enabled publication.

Wall time and peak RSS came from macOS `/usr/bin/time -l`; RSS bytes were divided by `1024^3` for GiB. Cells show means of two per-process measurements. Ranges are in [results.json](results.json). Two samples on a shared machine are not a confidence interval.

All 98 ordinary benchmark commands and six supplemental diagnostics succeeded. Package tests ran; database applications were compiled, not executed. Profiles and timing diagnostics are excluded from means.

## Primary matrix

Each cell is **seconds / peak GiB**. Builds use the default optimized LLVM backend, not `--opt=dev`. Warm checks/builds in this table have no native dev seed.

| Target | Check cold | Check warm | LLVM build cold | LLVM build warm |
|---|---:|---:|---:|---:|
| `package/main.roc` | 11.895 / 4.055 | 6.220 / 3.930 | — | — |
| `examples/query.roc` | 11.630 / 4.091 | 6.385 / 4.063 | 34.000 / 8.007 | 11.420 / 4.282 |
| `examples/prepared.roc` | 11.495 / 4.099 | 6.310 / 3.956 | 35.260 / 8.048 | 12.275 / 4.272 |
| `examples/webserver.roc` | 11.635 / 4.115 | 6.325 / 4.025 | 35.370 / 8.462 | 12.455 / 4.270 |
| `examples/small/main.roc` | 17.120 / 5.507 | 12.465 / 5.232 | 119.005 / 8.494 | 93.140 / 7.329 |

`roc test package/main.roc`: cold **9.925 s / 4.209 GiB**, warm **7.075 s / 4.577 GiB**.

Earlier baseline LLVM measurements were approximately 34.5/11.9 seconds cold/warm for query and 121.4/93.2 seconds for small. These final results are in the same performance regime; small differences do not establish a speedup or regression.

## Native dev-populated cache

For each target, two cache-disabled dev builds were followed by a cache-enabled dev seed, then two unchanged dev builds, two checks, and two LLVM builds using the same isolated cache. These are different cache histories from the primary matrix.

| Workflow | Query seconds / GiB | Small seconds / GiB |
|---|---:|---:|
| Cold dev | 9.245 / 4.214 | 14.875 / 5.848 |
| Unchanged dev after dev seed | 0.355 / 0.725 | 0.395 / 0.754 |
| Check after dev seed | 0.325 / 0.698 | 0.330 / 0.712 |
| LLVM after dev seed | 11.375 / 4.276 | 92.320 / 7.017 |

Unmeasured cache-enabled dev seeds took 16.69 seconds for query and 20.47 seconds for small. Seed publication is not included in the unchanged-build means.

## Real runtime app-only edits

Separate application copies were dev-seeded, then edited twice, with each edit followed by a measured dev build and check. After a separate LLVM seed, two more edits were each followed by an LLVM build. Package, schema, and SQL were unchanged.

The edits changed query's `"Connected!"` stdout message and small's `"usage: small <database url>"` message by adding distinct numbered suffixes. These are observable runtime changes, not comments. They do not measure SQL/schema/result-type changes.

| Workflow after edit | Query seconds / GiB | Small seconds / GiB |
|---|---:|---:|
| Dev build | 0.450 / 0.761 | 1.745 / 1.351 |
| Check after dev | 0.325 / 0.698 | 0.330 / 0.727 |
| LLVM build | 11.790 / 4.208 | 93.625 / 7.630 |

Native cache reuse survives this class of app changes. LLVM's remaining optimized-application cost does not disappear.

## Reproduce the cache histories

Build the compiler revision above in ReleaseFast, using `zig build -j2 roc -Doptimize=ReleaseFast`. From this repository, point `ROC` to that binary and use a fresh absolute cache directory:

```sh
ROC=/absolute/path/to/roc
mkdir -p local/performance-reproduction
export ROC_CACHE_DIR="$PWD/local/performance-reproduction/cache"

# Cache-disabled dev, then a cache-enabled seed, then unchanged native reuse.
"$ROC" build --no-cache --opt=dev examples/small/main.roc \
    --output="$PWD/local/performance-reproduction/small"
"$ROC" build --opt=dev examples/small/main.roc \
    --output="$PWD/local/performance-reproduction/small"
"$ROC" build --opt=dev examples/small/main.roc \
    --output="$PWD/local/performance-reproduction/small"
"$ROC" check examples/small/main.roc

# The same dev-populated cache does not eliminate optimized LLVM work.
"$ROC" build examples/small/main.roc \
    --output="$PWD/local/performance-reproduction/small-llvm"
```

For primary check-only/LLVM-only measurements, use a separate fresh cache and the two-cold/one-warmup/two-warm sequence without a dev seed. Repeat with query, prepared, webserver, and package checks/tests. Use `/usr/bin/time -l` on macOS to collect wall time and RSS. Do not execute database applications as part of this compilation benchmark.

## Phase diagnostics

Single separate `--timings` runs, in seconds. Missing execution timings are not assumed zero.

| Phase | Small cold LLVM | Small warm LLVM | Small cold dev |
|---|---:|---:|---:|
| Frontend/type checking | 2.586 | 0.447 | 2.583 |
| Shared preparation + compile-time evaluation | 36.442 | 15.004 | 11.797 |
| Shared Monotype specialization | 8.554 | 7.040 | 8.261 |
| Shared intermediate-code generation | 4.881 | 0.975 | 0.343 |
| Shared ownership/reference-count processing | 15.827 | 3.421 | 0.556 |
| Actual compile-time execution | 0.153 | — | 0.140 |
| Application specialization/passes | 5.843 | 2.209 | 0.392 |
| LLVM IR generation | 0.267 | 0.260 | — |
| LLVM optimization + object emission | 77.566 | 74.137 | — |
| Linking | 0.030 | 0.023 | 0.029 |

Subrows of shared preparation are included in its total and must not be added to it again. Warm small LLVM's diagnostic elapsed 92.16 seconds, with approximately 80% in LLVM optimization/emission. Actual cold compile-time execution is only 153 milliseconds: the aggregate shared stage is not SQL parser execution time.

Warm native diagnostics recorded 85 early object hits for query and 81 for small, versus zero early object hits for LLVM. Shared body contexts fell from roughly 188,000 to 16,600 for query dev and 268,000 to 17,200 for small dev. Warm LLVM still had approximately 165,000 and 213,000 contexts respectively.

## LLVM profile and structural control

A ten-second macOS sampling window during small's LLVM optimization recorded 6,857 main-thread samples. SROA (scalar replacement of aggregates) accounted for 3,618 inclusive samples (52.8%), including 2,802 samples (40.9%) in its memory-to-register promotion branch. The latter is a subset, not an additional percentage. These describe one window, not the entire phase; they motivate investigating aggregate/local-memory and control-flow shape, not disabling optimizations.

An artificial control kept twenty separately named query functions and call sites but replaced all query annotations and SQL with the first query's row and SQL. Schema/package were unchanged. This changes application semantics and is not a workaround recommendation.

| Warm diagnostic | Original distinct queries/rows | Repeated query/row control |
|---|---:|---:|
| Total wall time | 92.16 s | 25.26 s |
| Shared preparation | 15.004 s | 13.705 s |
| Application specialization | 2.209 s | 0.762 s |
| LLVM optimize + emit | 74.137 s | 10.400 s |

This associates the high optimized cost with query/row specialization and resulting runtime code, not schema size alone. SQL and row annotations both changed, so it does not isolate row types as the sole cause.

Pack byte read/write totals were unavailable, not zero. The final accumulated cache contained 132 `.rpk` files totaling 193,868,344 bytes; this is storage inventory after all workflows, not I/O attribution.

See [the improvement analysis](improvement-analysis.md) for the recommended next steps. Large raw outputs, caches, compiler binaries, and historical machine-specific harnesses remain local and are not included here.
