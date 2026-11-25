# Status

- **Claim:** every tredoku pattern admits a digit filling (Blackburn, EJC 33(3) (2026) #P3.58, concluding remarks item 2), with a q×q generalization to all finite non-overlapping lozenge sets.
- **State:** private public-candidate. Not released; no DOI yet.
- **Mathematics:** three independent AI audits passed; no invalid step found. Not peer reviewed.
- **Computation:** corroborating only; replay with `python3 scripts/replay.py`.
- **Priority:** three literature lanes through 2026-11-26. Apparently new; the ingredients are standard. Remaining source gaps: Google Scholar, full-text arXiv search, zbMATH/MathSciNet, Preece's 2013 slides and Mindome's internal puzzle-generation method.
- **Formalization:** partial. The logical core is checked in Lean 4.26.0 (`formalization/`, core library, standard axioms only). The run structure of patterns is a hypothesis there.
