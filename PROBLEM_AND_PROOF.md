# Problem and proof in brief
**Problem** (Blackburn 2026, concluding remarks, item 2). Divide each diamond of a tredoku pattern into a 3×3 grid. Can the sub-diamonds always be numbered 1–9 so that every diamond, and every nine-cell line following a run of three diamonds, contains each number once? Blackburn conjectures yes.

**Proof sketch.**
1. Orient the three lattice directions once and for all. The sub-diamond T(i,j) of a tile P + [0,1]u_d + [0,1]u_e has index i along d. A line crossing a shared d-edge keeps its index, because the position along a directed edge is the same from both sides (Lemma 2.1).
2. Each tile lies in exactly one run per direction, because runs are paths (Lemma 2.3).
3. Give the tiles of each run distinct offsets. Label T(i,j) by the (x,y) ∈ (ℤ/3)² with L_d = i + o(T,d) and L_e = j + o(T,e), where L_0 = x, L_1 = y, L_2 = x + y.
4. Each tile then gets all nine pairs. A line gets three disjoint fibres of L_d, which together are all nine pairs. Encode (x,y) as 1 + 3x + y.

Full details: `paper/manuscript.pdf`.
