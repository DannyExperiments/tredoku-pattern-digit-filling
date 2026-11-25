"""Build the six Version 1.0.0 release assets from the tracked files of this repository.

Usage: python3 scripts/build_release_assets.py OUTDIR
Writes NAME-v1.0.0.pdf, NAME-v1.0.0.tex, references.bib, CITATION.cff, SHA256SUMS.txt and
NAME-public-evidence-v1.0.0.zip (all tracked files except workflows, the internal evidence
bundle and the GIF, under a top-level folder NAME-v1.0.0/, with fixed timestamps).
"""
import shutil, subprocess, sys, zipfile
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
NAME = ROOT.name if (ROOT / ".git").exists() else sys.argv[2]
out = Path(sys.argv[1]); out.mkdir(parents=True, exist_ok=True)
name = sys.argv[2] if len(sys.argv) > 2 else NAME
shutil.copy(ROOT / "paper/manuscript.pdf", out / f"{name}-v1.0.0.pdf")
shutil.copy(ROOT / "paper/manuscript.tex", out / f"{name}-v1.0.0.tex")
for f in ["paper/references.bib", "CITATION.cff", "SHA256SUMS.txt"]:
    shutil.copy(ROOT / f, out / Path(f).name)
files = sorted(f for f in subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True).split()
               if not f.startswith(".github") and not f.startswith("release/EVIDENCE") and not f.endswith(".gif"))
with zipfile.ZipFile(out / f"{name}-public-evidence-v1.0.0.zip", "w", zipfile.ZIP_DEFLATED) as z:
    for f in files:
        zi = zipfile.ZipInfo(f"{name}-v1.0.0/{f}", date_time=(2026, 11, 26, 0, 0, 0))
        zi.external_attr = 0o644 << 16; zi.compress_type = zipfile.ZIP_DEFLATED
        z.writestr(zi, (ROOT / f).read_bytes())
print("\n".join(sorted(p.name for p in out.iterdir())))
