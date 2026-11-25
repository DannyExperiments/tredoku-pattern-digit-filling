# Claim scope and limitations

## Claimed

- Every tredoku pattern, as defined by Blackburn (2026), admits a filling by 1–9. Every diamond, and every nine-cell line along every run of length 3, contains each digit once.
- More generally (Theorem 3.1): for every q ≥ 2 and every finite set of non-overlapping lozenges subdivided q×q, there is a labelling by (ℤ/q)² that is complete on every tile and on every line along every run of exactly q tiles. Lines along shorter runs get distinct labels.

## Not claimed

- Nothing about tredoku *puzzles*: no claim about givens, unique solvability or difficulty. The question asks only for existence.
- "Straight line" is read as the line of sub-diamonds that crosses the run's shared edges, bending where the tiles change orientation, as in the puzzle. A strictly Euclidean reading would only remove constraints.
- No new technique. De Bruijn ribbons, Latin squares and design-key shifts are standard (paper, Remark 3.2).
- Formal verification covers only the logical core (Lean 4, `formalization/`). Lemma 2.3, that runs are disjoint paths, is a hypothesis in Lean.
- No peer review. The mathematical audits were performed by AI systems.
- Novelty is stated as "appears to be new after a documented search through 26 November 2026". The source gaps are listed in `STATUS.md`.
