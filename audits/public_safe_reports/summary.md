# Public-safe audit summaries (2026-11-25)

**Lane 1 (hostile).** No invalid step. Checked:
- the coordinates are well defined for all three tile types, including the tile type whose angle at the origin corner is 120°;
- the strand index is preserved across shared edges where the run bends, because the position along a directed lattice edge is intrinsic to that edge;
- each tile lies in exactly one run per direction, since runs are paths with a monotone transverse coordinate;
- the offsets are independent;
- the pairwise determinants of the forms x, y, x+y are ±1.

An exact-arithmetic simulation built lines from shared sub-edges: q = 2..6, thousands of full lines, no failures. Expository requests were incorporated into the manuscript.

**Lane 2 (reconstruction).** The auditor solved the problem before reading the note and found the same construction in symmetric form (labels in {α ∈ (ℤ/q)³ : α₀+α₁+α₂ = 0}). The q×q generalization holds, and the connectivity conditions are unused. A simulation over 16,650 random patterns found no failures.

**Lane 3 (scope, computation, formalization).** The statement is exact. The candidate's own control script checks only the algebra, so it is not a geometric check. The auditor's independent geometric check covered:
- 400 random patterns: 2,853 lines, 715 of them on bent runs;
- 330 genuine tredoku patterns, with all four conditions verified: 25,440 lines;
- 0 failures in both;
- negative controls: a per-tile corner convention, zero offsets and transposed indices are all rejected.

It also recommended stating that non-overlap is used, and that lines may bend by 60°.

## Literature and priority (2026-11-26)
- **Status:** the question is still stated as open in the published EJC version (Sept 2026). It was first asked in arXiv v1 (July 2024), with the conjecture added from v2 on. The only citing work, Ridout 2025, does not address fillings. Crossref and DataCite show no DOI claiming a solution.
- **Theorem search:** no identical or stronger result found under any of the alternative names searched (lozenge or rhombus Latin labellings, sudoku on polyhedra, gerechte designs, de Bruijn ribbons). Classification: apparently new.
- **Architecture:** the ingredients are standard: de Bruijn ribbons/worms, Latin squares as three orthogonal partitions, design-key constructions. The manuscript credits them in Remark 3.2.
