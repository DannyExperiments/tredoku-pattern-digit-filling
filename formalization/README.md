# Lean formalization (partial)

**Scope: a partial logical-core check.** The Lean files prove the parts of the argument that carry the geometry and the labelling. They take the run structure of a tredoku pattern as a hypothesis instead of deriving it from a pattern.

Toolchain: Lean 4.26.0, core library only, with no Mathlib (`lean-toolchain`). Replay: `sh formalization/verify.sh`. It rejects `sorry`, `admit`, `native_decide` and new axioms, builds the files in a clean directory, and checks that every audited declaration uses only the standard axioms `propext`, `Quot.sound` and `Classical.choice`.

## Formalized (`TredokuFilling.lean`)

- The triangular lattice, all three lozenge orientations, and the 3×3 subdivision in exact integer coordinates (scaled by 3).
- Lines are defined **geometrically**. Within each tile a line is a strip with a fixed index along the run direction. Strips in neighbouring tiles are joined when they share a boundary sub-segment, an unordered pair of lattice points. No index convention is assumed in the next tile.
- `along_eq_of_link` is Lemma 2.1 of the paper: the index is preserved across any shared edge. It covers all 27 combinations of direction and tile types, including bends.
- `exists_filling` is the conclusion of Theorem 3.1 for q = 3. Take any family of three-tile runs that are pairwise disjoint within each direction. Then the explicit labelling gives each tile nine distinct digits from 1 to 9, and gives nine distinct digits to every geometric line along every run.
- `bendLine` is a concrete bending run with a geometric line through it. It shows that the `Line` hypothesis can be satisfied.

## Not formalized

- Lemma 2.3: in a pattern, the runs of one direction are disjoint paths. This is a hypothesis of `exists_filling`.
- That each line has exactly nine cells. Together with injectivity this gives "each digit exactly once".
- The q×q generalization.

The separate `leanchecker` kernel replay used in other releases is not shipped with Lean 4.26.0. Here the check is a clean `lake build`, which the Lean kernel checks, plus the axiom audit.
