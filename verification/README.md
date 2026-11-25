# Verification (corroborating only)
- `src/geometric_check.py`: an independent lattice simulation. Lines are built from shared sub-edges, with no index convention assumed. Log: `logs/geometric_check.log`.
- `--negative-control` flips the index on one tile type; the check must detect it. Log: `logs/negative_control.log`.
