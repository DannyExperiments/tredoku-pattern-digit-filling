# Reproducibility

Nothing here is load-bearing; the proof is analytic.

| What | Command | Expected |
|---|---|---|
| Integrity and privacy | `python3 -I scripts/verify_repository.py` | `OK: … hashed files, privacy scan clean` |
| Corroborating computation | `python3 -I scripts/replay.py` | `lines checked 124101 length-3 runs 4027 all OK`; negative control detected |
| Lean core | `sh formalization/verify.sh` (needs `elan`) | clean build; only the standard axioms `propext`, `Quot.sound` and `Classical.choice` |
| Paper | `cd paper && latexmk -pdf manuscript.tex` | 4 pages, no warnings |
| Explorer | unzip `visualization/tredoku-filling-explorer.zip`, open `index.html` | offline 3D figure |

Each of these also runs in GitHub Actions (badges in `README.md`).
