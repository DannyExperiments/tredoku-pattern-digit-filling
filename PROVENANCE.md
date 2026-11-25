# Provenance

1. **Discovery (25 November 2026).** Working through a public open-problems catalog, an OpenAI model (GPT-6.2 Astra, in the ChatGPT desktop app) found the construction and wrote a short proof note and a control script. The raw note is kept in a private evidence repository.
2. **Freeze (25 November 2026).** The note was frozen with SHA-256 hashes before review.
3. **Independent computation.** `verification/src/geometric_check.py` was written by Claude without using the candidate's script, which checks only the algebra. The audit lanes wrote further independent geometric checks.
4. **Audits (25–26 November 2026).** Three mathematical audit lanes and three literature lanes ran as separate Claude instances that did not see each other's conclusions. Summaries are in `audits/public_safe_reports/`.
5. **Manuscript, Lean and repository (25–26 November 2026).** Claude prepared these from the frozen proof and the audit repairs. The mathematics was not changed.
