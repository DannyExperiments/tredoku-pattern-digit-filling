# Verification

The theorem is proved analytically. The computations here **corroborate** the proof; none of them is load-bearing.

- `src/geometric_check.py`: an independent simulation on the triangular lattice in exact integer coordinates. It generates random non-overlapping lozenge patterns (overlap is tested on the 18 small triangles of each tile) and finds runs from shared edges. It then builds lines **geometrically**, by crossing shared sub-edges with no index convention assumed in the next tile. Finally it applies the labelling and checks every tile and every line along runs of length 2 or 3. Seeded and deterministic. Expected output: `logs/geometric_check.log` (124,101 lines, 4,027 runs of length 3, no failures).
- `--negative-control` flips the index convention on one tile type. The check must detect the error: `logs/negative_control.log`.
- `tredoku_pattern_example.json` is the 12-tile tredoku pattern drawn in the explorer. All four tredoku conditions are checked, and all 21 of its lines contain 1–9.

Replay everything with `python3 scripts/replay.py`.

The independent model audits also ran their own geometric checks, including 330 genuine tredoku patterns and 25,440 lines; see `audits/public_safe_reports/MATHEMATICAL_AUDIT.md`.
