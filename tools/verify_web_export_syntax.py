"""Validate exported JavaScript and repair one unused GameMaker runner stub.

Runtime 2026.0.0.23 can strip the parameter list from the duplicate, unused
compile_if_weak_ref stub during obfuscation. Only the empty, unreferenced stub
immediately following compile_if_used is eligible. Game code is not rewritten.
"""
from pathlib import Path
import re
import subprocess
import sys

bundle = Path(sys.argv[1]).resolve()
source = bundle.read_text(encoding="utf-8")
pattern = re.compile(r"(function compile_if_used\(\)\{\}function )([A-Za-z_$][\w$]*)(\{\})")
matches = list(pattern.finditer(source))
if matches:
    if len(matches) != 1:
        raise RuntimeError("Unexpected runner stub count; export left untouched")
    match = matches[0]
    name = match[2]
    if len(re.findall(r"(?<![\w$])" + re.escape(name) + r"(?![\w$])", source)) != 1:
        raise RuntimeError("Runner stub is referenced; export left untouched")
    repaired = source[:match.start()] + match[1] + name + "()" + match[3] + source[match.end():]
    candidate = bundle.with_suffix(".syntax-check.js")
    candidate.write_text(repaired, encoding="utf-8")
    try:
        subprocess.run(["node", "--check", str(candidate)], check=True)
        bundle.write_text(repaired, encoding="utf-8")
    finally:
        candidate.unlink(missing_ok=True)
    print("WEB_RUNNER_STUB_REPAIRED: unused empty function parameter list restored")
subprocess.run(["node", "--check", str(bundle)], check=True)
print("WEB_EXPORT_SYNTAX_PASS")
