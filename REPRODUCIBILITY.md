# Reproducibility
Nothing here is load-bearing; the proof is analytic.
- Geometric check: `python3 -I verification/src/geometric_check.py` → `lines checked 124101 length-3 runs 4027 all OK` (seeded, deterministic).
- Negative control: `python3 -I verification/src/geometric_check.py --negative-control` must print `FAILURE DETECTED`.
- Lean: in `formalization/lean`, `lean TredokuFilling.lean` (toolchain pinned in `lean-toolchain`, Lean 4.26.0, core only). Expected axiom report: `'exists_filling' depends on axioms: [propext, Classical.choice, Quot.sound]`.
- Paper: `cd paper && latexmk -pdf manuscript.tex`.
