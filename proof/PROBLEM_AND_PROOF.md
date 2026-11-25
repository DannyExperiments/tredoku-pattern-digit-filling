# Problem and proof

## Problem

Blackburn, *Tredoku patterns* (Electron. J. Combin. 33(3) (2026), #P3.58), concluding remarks, item 2. Divide each diamond of a tredoku pattern into a 3 × 3 grid of sub-diamonds. Can the sub-diamonds always be numbered from {1,…,9} so that every diamond, and every "straight line" of nine sub-diamonds that follows a run of length 3, contains each number exactly once? Blackburn conjectures yes.

A *run* is a maximal sequence of distinct tiles, where consecutive tiles share an edge and all of these shared edges are parallel. In a tredoku pattern every run has length 1 or 3.

## Proof

1. **Coordinates.** Give each of the three lattice directions a fixed orientation u₀, u₁, u₂. Every tile is T = P + [0,1]u_d + [0,1]u_e for a unique corner P. Its sub-diamond T(i,j) has index i along d and index j along e.
2. **Index preservation (Lemma 2.1).** Each of the two tiles on a shared edge parallel to u_d numbers the edge's three segments from the same endpoint, in the direction of u_d. So a line crossing the edge keeps its index i. This holds even when the line bends because the next tile has a different second direction.
3. **Runs are paths (Lemma 2.3).** Each edge is shared by at most two tiles. Crossing a tile between its two d-sides moves monotonically in the direction perpendicular to u_d, so the tiles of one direction form paths, never cycles, and each tile lies in exactly one run per direction.
4. **Labelling.** Attach the linear forms L₀ = x, L₁ = y, L₂ = x + y on (ℤ/3)² to the three directions. Give the tiles of each run distinct offsets o(T,d) ∈ {0,1,2}. Label T(i,j) by the unique (x,y) with L_d = i + o(T,d) and L_e = j + o(T,e), written as the digit 1 + 3x + y.
5. **Check.** Any two of the forms determine (x,y) (determinant ±1), so each tile receives all nine labels. A line along a d-run has a fixed index i. In the tile T_m it fills the whole fibre L_d = i + o(T_m,d). The three offsets are distinct, so the three fibres are disjoint and cover all nine labels.

The same argument works for q×q subdivisions and runs of length q, for every q ≥ 2. It uses only that the tiles do not overlap. See [`../paper/manuscript.pdf`](../paper/manuscript.pdf).
