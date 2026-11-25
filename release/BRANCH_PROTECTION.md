# Branch-protection configuration

Protect the branch pattern `main` with a classic rule:

- require a pull request before merging;
- require status checks to pass, and branches to be up to date before merging;
- require conversation resolution and linear history;
- do not allow force pushes or deletions;
- apply the rule to administrators unless an explicit emergency exception is approved.

Required checks:

```text
Verify public candidate
Replay geometric check
Rebuild manuscript PDF
verify
```

(`verify` is the job of the partial Lean workflow.)
The rule is applied after the DOI metadata update, the last direct change to `main`.
