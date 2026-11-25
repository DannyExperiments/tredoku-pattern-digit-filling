"""Replay the corroborating computation for the tredoku filling theorem.

Usage: python3 scripts/replay.py
Runs the independent geometric check and its negative control, then checks the
labelling on the example tredoku pattern used in the 3D explorer. Exits non-zero on any failure.
The theorem itself is proved analytically; none of this is load-bearing.
"""
import json, subprocess, sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "verification" / "src" / "geometric_check.py"
def run(args):
    r = subprocess.run([sys.executable, "-I", str(SRC)] + args, capture_output=True, text=True)
    return r.returncode, r.stdout.strip()
code, out = run([])
print(out)
if code != 0 or "all OK" not in out: sys.exit("FAIL: geometric check")
code, out = run(["--negative-control"])
print("negative control:", out)
if code != 0 or "FAILURE DETECTED" not in out: sys.exit("FAIL: negative control was not detected")
expected = (ROOT / "verification" / "logs" / "geometric_check.log").read_text().strip()
got = run([])[1]
if got != expected: sys.exit("FAIL: output differs from verification/logs/geometric_check.log")
print("OK: geometric check reproduces the logged output; negative control detected")
