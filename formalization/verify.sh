#!/bin/sh
set -eu
cd "$(dirname "$0")"
python3 - <<'PY'
from pathlib import Path
import re
for path in [Path("TredokuFilling.lean"), Path("Audit.lean")]:
    source = path.read_text()
    if re.search(r"\b(sorry|admit|unsafe|native_decide|implemented_by|extern)\b|^\s*(axiom|constant)\b", source, re.M):
        raise SystemExit("Prohibited Lean declaration or tactic in " + str(path))
print("No prohibited declarations.")
PY
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
cp TredokuFilling.lean Audit.lean lakefile.toml lake-manifest.json lean-toolchain "$build_dir/"
cd "$build_dir"
lake env lean --version
lake build
lake env lean Audit.lean > audit.log
cat audit.log
python3 - <<'PY'
from pathlib import Path
import re
decls = re.findall(r"^#print axioms ([\w.]+)$", Path("Audit.lean").read_text(), re.M)
results = {}
for line in Path("audit.log").read_text().splitlines():
    empty = re.fullmatch(r"'([\w.]+)' does not depend on any axioms", line)
    some = re.fullmatch(r"'([\w.]+)' depends on axioms: \[(.*)\]", line)
    if empty:
        results[empty[1]] = set()
    elif some:
        results[some[1]] = set(some[2].split(", "))
    else:
        raise SystemExit("Unexpected audit output: " + line)
if set(results) != set(decls):
    raise SystemExit("An audited declaration was missing")
allowed = {"propext", "Quot.sound", "Classical.choice"}
for name, axioms in results.items():
    if not axioms <= allowed:
        raise SystemExit("Unexpected axioms for " + name + ": " + str(axioms))
print(f"Checked axiom dependencies for all {len(results)} declarations: only standard axioms.")
PY
