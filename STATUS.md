# Status

- **Claim:** every tredoku pattern admits a digit filling (Blackburn, EJC 33(3) (2026) #P3.58, concluding remarks item 2), with a q×q generalization to all finite non-overlapping lozenge sets.
- **State:** public. Version 1.0.0 released 2026-11-26 (tag `v1.0.0`, commit `a6342dc`). Version 1.0.1 (tag `v1.0.1`, commit `7acb8b9`) adds archive metadata only and is archived at Zenodo: version DOI 10.5281/zenodo.24544626, concept DOI 10.5281/zenodo.24544625.
- **Mathematics:** three independent AI audits passed; no invalid step found. Not peer reviewed.
- **Computation:** corroborating only; replay with `python3 scripts/replay.py`.
- **Priority:** three literature lanes through 2026-11-26. Apparently new; the ingredients are standard. Remaining source gaps: Google Scholar, full-text arXiv search, zbMATH/MathSciNet, Preece's 2013 slides and Mindome's internal puzzle-generation method.
- **Formalization:** partial. The logical core is checked in Lean 4.26.0 (`formalization/`, core library, standard axioms only). The run structure of patterns is a hypothesis there.
