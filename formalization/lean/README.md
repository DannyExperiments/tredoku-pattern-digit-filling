# Lean formalization — Tredoku filling (logical core)

**Status: partial logical-core Lean check** (not a full formalization of Blackburn's question).

- Toolchain: Lean 4.26.0 (commit d8204c9fd894f91bbb2cdfec5912ec8196fd8562), core library only, no Mathlib.
- Build: `lean TredokuFilling.lean` — clean, no errors.
- No `sorry`, `admit`, `native_decide`, `unsafe` or `axiom` declarations.
- `#print axioms exists_filling` → `[propext, Classical.choice, Quot.sound]` (standard). `along_eq_of_link` → `[propext, Quot.sound]`.

## What is formalized
- The triangular lattice, all three lozenge orientations, the 3×3 subdivision in exact integer coordinates (scaled by 3).
- Lines along a run are defined **geometrically**: strips of fixed index along the run direction inside each tile, joined across tiles by equality of the shared boundary sub-segment (unordered pair of lattice points). No index convention in the next tile is assumed.
- `along_eq_of_link`: the strand index is preserved across any shared edge, for all 27 (direction, tile type, tile type) combinations — including bends where the neighbouring tile's other direction differs.
- `exists_filling`: for any list of three-tile runs that are pairwise disjoint within each direction, the explicit labelling (forms x, y, x+y over (ℤ/3)², run offsets, digit 1+3x+y) gives every tile nine distinct digits in 1..9 and every geometric line along every run nine distinct digits.
- `bendLine`: a concrete bending run with a geometric line (non-vacuity of the `Line` hypothesis).

## What is NOT formalized (taken as hypotheses / paper arguments)
- That in a tredoku pattern the length-3 runs of a fixed direction are pairwise disjoint and consist of three distinct tiles each having that direction (paper: each tile has two d-parallel edges, each shared with at most one tile by non-overlap, and d-chains cannot cycle).
- That a line has exactly nine cells (three strips of three cells in three distinct tiles), so nine distinct digits = every digit once.
- The q×q generalization.
