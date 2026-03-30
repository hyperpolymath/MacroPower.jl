# TEST-NEEDS: MacroPower.jl

## Current State

| Category | Count | Details |
|----------|-------|---------|
| **Source modules** | 1 | 78 lines |
| **Test files** | 1 | 95 lines, 37 @test/@testset |
| **Benchmarks** | 0 | None |

## What's Missing

- [ ] **Performance**: No benchmarks for macro expansion
- [ ] **Error handling**: No tests for invalid macro input

## FLAGGED ISSUES
- **37 tests for 1 module** -- adequate for a small package
- **Test lines > source lines** (95 > 78)

## Priority: P3 (LOW)

## FAKE-FUZZ ALERT

- `tests/fuzz/placeholder.txt` is a scorecard placeholder inherited from rsr-template-repo — it does NOT provide real fuzz testing
- Replace with an actual fuzz harness (see rsr-template-repo/tests/fuzz/README.adoc) or remove the file
- Priority: P2 — creates false impression of fuzz coverage
