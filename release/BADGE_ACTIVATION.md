# Badge activation record

The workflow badges report runs on public `main`. At the Version 1.0.1 commit `7acb8b9` all workflows passed: runs 45713418994 (verify), 45713419257 (replay), 45713419210 (PDF), 45713419155 (Lean). The Lean badge is labelled "Partial Lean verification" because only the logical core (the crossing lemma and the labelling) is kernel checked; the run structure of patterns is a hypothesis there.

The DOI badge uses the version DOI 10.5281/zenodo.24544626 because it cites the exact archived Version 1.0.1. The concept DOI is linked in the README citation section. The DOI badge was added only after both DOIs resolved and the archived file matched the GitHub source archive of tag `v1.0.1` (see `DOI_DEPOSIT.md`).

Before this update was committed, the DOI badge image was fetched from Zenodo without credentials. It returned HTTP 200 and shows the version DOI. The workflow badge states are taken from the runs listed above.
