# Mathematical audit (25 November 2026)

Three independent Claude instances audited the frozen proof note. Each saw only the frozen note and the original problem, not the other audits or the director's conclusions, and worked without internet access.

| Lane | Verdict | Confidence | Main checks |
|---|---|---|---|
| 1. Hostile line-by-line | PASS, no invalid step | 0.97 | Coordinates well defined for all three tile types, including the 120° corner; index preserved across bends (position along a directed edge is intrinsic); runs are paths; offsets independent; determinants ±1. Own exact simulation with lines built from shared sub-edges for q = 2…6: no failures |
| 2. Independent reconstruction | CORRECT | 0.97 | Solved the problem before reading the note and found the same construction in symmetric form (labels in {α ∈ (ℤ/q)³ : α₀+α₁+α₂ = 0}). 16,650 random patterns, no failures. q×q version and "connectivity unused" confirmed |
| 3. Scope, computation, formalization | PASS, statement exact | 0.97 | Candidate's own script checks only the algebra (not geometric). Independent geometric check: 400 random patterns (2,853 lines, 715 bent runs) and 330 genuine tredoku patterns with all four conditions verified (25,440 lines), no failures. Negative controls (per-tile corner convention, zero offsets, transposed indices) all rejected |

Editorial repairs adopted in the paper: a precise definition of a line (lines may bend); "exactly one run per direction" instead of "at most one"; determinants instead of "by subtraction"; an explicit statement that non-overlap is the only structural hypothesis used; the q×q statement restricted to runs of length exactly q.

These are AI audits, not peer review.
