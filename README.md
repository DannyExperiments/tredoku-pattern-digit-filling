# Every tredoku pattern admits a digit filling

**Answer: yes.** Every tredoku pattern can be filled with the digits 1–9 so that each diamond, and each nine-cell line along each run of three diamonds, contains every digit exactly once. This proves Blackburn's conjecture.

## The problem
S. R. Blackburn, *Tredoku patterns*, Electron. J. Combin. **33**(3) (2026), #P3.58, [doi:10.37236/13659](https://doi.org/10.37236/13659) ([arXiv:2407.10752](https://arxiv.org/abs/2407.10752)), concluding remarks, item 2. Blackburn subdivides each diamond of a tredoku pattern into a 3×3 grid and asks whether there is always an assignment of 1,…,9 such that each diamond and each straight line of nine sub-diamonds following a run of length 3 contains every number exactly once. He conjectures yes.

## The result and the idea
Give each of the three lattice directions a fixed orientation. Then a sub-diamond's position along a run direction is the same on both sides of every shared edge, even where the line bends. Attach the linear forms `x`, `y`, `x+y` on (ℤ/3)² to the three directions, and give the three diamonds of each run distinct offsets. Label each sub-diamond by the unique pair whose two forms equal its two coordinates plus the offsets. Each diamond then gets all nine pairs, and each line gets three disjoint fibres of one form. The same construction works for q×q subdivisions for every q ≥ 2. It uses only that the diamonds do not overlap.

- Paper: [`paper/manuscript.pdf`](paper/manuscript.pdf) · source [`paper/manuscript.tex`](paper/manuscript.tex)
- Reproduce: [`REPRODUCIBILITY.md`](REPRODUCIBILITY.md)

[![verify](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/verify.yml/badge.svg)](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/verify.yml) [![pdf](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/pdf.yml/badge.svg)](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/pdf.yml) [![Partial logical-core Lean check](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/lean.yml/badge.svg)](https://github.com/DannyExperiments/tredoku-pattern-digit-filling/actions/workflows/lean.yml)

## Verification status
| Item | Status |
|---|---|
| Proof | Complete, analytic; does not rely on computation |
| Independent AI audits | Three independent model audits (hostile, reconstruction, scope/computation), all PASS; three literature lanes, no collision; not peer review |
| Computation | Corroborating only: geometric lattice simulation, plus a negative control |
| Lean | **Partial logical-core Lean check** (Lean 4.26.0, core library): crossing lemma + labelling correctness; run structure of tredoku patterns taken as hypothesis |
| Peer review | Not refereed |
| Novelty | See [`STATUS.md`](STATUS.md) |

## Citation
See [`CITATION.cff`](CITATION.cff) (added after authorship approval).
