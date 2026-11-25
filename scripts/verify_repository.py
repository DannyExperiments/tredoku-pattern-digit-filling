"""Integrity and privacy checks for the public repository.

1. Every file listed in SHA256SUMS.txt exists and matches its hash, and every tracked file is listed.
2. No file contains local paths, account identifiers, tokens or private session references.
"""
import hashlib, re, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
errors = []

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

listed = {}
for line in (ROOT / "SHA256SUMS.txt").read_text().splitlines():
    h, name = line.split(None, 1); listed[name.lstrip("*").strip()] = h
for name, h in listed.items():
    p = ROOT / name
    if not p.is_file(): errors.append(f"missing: {name}")
    elif sha(p) != h: errors.append(f"hash mismatch: {name}")
try:
    tracked = subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True).split()
except Exception:
    tracked = [str(p.relative_to(ROOT)) for p in ROOT.rglob("*") if p.is_file() and ".git" not in p.parts]
exempt = {"SHA256SUMS.txt"}
for name in tracked:
    if name not in listed and name not in exempt: errors.append(f"not in SHA256SUMS.txt: {name}")

PATTERNS = {
    "local home path": r"/Users/[A-Za-z]|/home/[a-z]+/|C:\\\\Users",
    "private account name": r"daniel\s*cabezas|danielcabezas",
    "GitHub token": r"gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}",
    "API key": r"sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}",
    "private key": r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
    "private chat or session link": r"chatgpt\.com/|claude\.ai/(chat|code)|chat\.openai\.com",
    "Codex local state": r"\.codex/|rollout-20\d\d-",
    "session identifier": r"\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b",
    "email address": r"[A-Za-z0-9._%+-]+@(?!users\.noreply\.github\.com)[A-Za-z0-9.-]+\.(com|net|org|io|ai|co|th)\b",
    "seed phrase marker": r"(?i)seed phrase|mnemonic|private key:",
}
SKIP_SUFFIX = {".pdf", ".zip", ".gif", ".png"}
for name in tracked:
    p = ROOT / name
    if p.suffix in SKIP_SUFFIX or name == "scripts/verify_repository.py": continue
    text = p.read_text(errors="replace")
    for label, pat in PATTERNS.items():
        m = re.search(pat, text)
        if m: errors.append(f"{label} in {name}: {m.group(0)[:40]!r}")


if errors:
    print("\n".join(errors)); sys.exit(1)
print(f"OK: {len(listed)} hashed files, privacy scan clean")
