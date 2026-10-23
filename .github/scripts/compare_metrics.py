import json, hashlib, os, sys

findings_file = "security-output/findings.json"
meta_file = "security-output/audit-metadata.json"

if not os.path.isfile(findings_file):
    print(f"Error: {findings_file} not found")
    sys.exit(1)

with open(findings_file, "rb") as f:
    findings_bytes = f.read()
findings_sha = hashlib.sha256(findings_bytes).hexdigest()

with open(findings_file, "r", encoding="utf-8") as f:
    findings_data = json.load(f)

if "summary" not in findings_data:
    print("Erreur critique: cle 'summary' absente de findings.json")
    sys.exit(1)

meta_data = {}
if os.path.isfile(meta_file):
    with open(meta_file, "r", encoding="utf-8") as f:
        meta_data = json.load(f)

summary = findings_data.get("summary", {})
by_prio = summary.get("by_priority", {})
by_tool = summary.get("by_tool", {})

brut = summary.get("total_findings", 0)
dedup = summary.get("deduplicated_findings", 0)
p0 = by_prio.get("P0", 0)
p1 = by_prio.get("P1", 0)
p2 = by_prio.get("P2", 0)
p3 = by_prio.get("P3", 0)

gitleaks = by_tool.get("gitleaks", 0)
trivy = by_tool.get("trivy", 0)
semgrep = by_tool.get("semgrep", 0)
checkov = by_tool.get("checkov", 0)

# Lecture des totaux bruts par outil dans audit-metadata.json
raw_tools = {}
for cov in meta_data.get("coverage", []):
    cname = cov.get("name")
    if cname and "findings" in cov:
        raw_tools[cname] = cov.get("findings")

trivy_date = "non detectee"
for cov in meta_data.get("coverage", []):
    if cov.get("name") == "trivy":
        scope = cov.get("scope", "")
        if "vulnerability DB updated:" in scope:
            trivy_date = scope.split("vulnerability DB updated:")[-1].strip()
        else:
            trivy_date = scope

print("=== MESURES AUDIT AADSEC ===")
print(f"Total brut: {brut} (attendu: 101)")
if raw_tools:
    print(f"Bruts par outil: Gitleaks {raw_tools.get('gitleaks', 0)}, Trivy {raw_tools.get('trivy', 0)}, Semgrep {raw_tools.get('semgrep', 0)}, Checkov {raw_tools.get('checkov', 0)}")
print(f"Deduplique: {dedup} (attendu: 86)")
print(f"P0: {p0} (attendu: 2)")
print(f"P1: {p1} (attendu: 38)")
print(f"P2: {p2} (attendu: 38)")
print(f"P3: {p3} (attendu: 8)")
print(f"Gitleaks: {gitleaks} (attendu: 2)")
print(f"Trivy: {trivy} (attendu: 52)")
print(f"Semgrep: {semgrep} (attendu: 0)")
print(f"Checkov: {checkov} (attendu: 32)")
print(f"Date base Trivy: {trivy_date}")
print(f"SHA-256 findings.json: {findings_sha}")

checks = [
    ("Total brut", 101, brut),
    ("Deduplique", 86, dedup),
    ("P0", 2, p0),
    ("P1", 38, p1),
    ("P2", 38, p2),
    ("P3", 8, p3),
    ("Gitleaks", 2, gitleaks),
    ("Semgrep", 0, semgrep),
    ("Checkov", 32, checkov),
]

failed = False
rows = []
for label, expected, actual in checks:
    status = "CONFORME" if actual == expected else "ECART"
    if status != "CONFORME":
        failed = True
    rows.append(f"| {label} | {expected} | {actual} | {status} |")

if trivy == 52:
    trivy_status = "CONFORME"
else:
    trivy_status = f"ecart de base ({trivy_date})"
rows.append(f"| Trivy | 52 | {trivy} | {trivy_status} |")
rows.append(f"| Date base Trivy | - | {trivy_date} | INFO |")
rows.append(f"| SHA-256 findings.json | 6eb66457678f33e3066a58906cf360a595c3b97b45e86f0e1974a96e0d729455 (mesure Windows) | {findings_sha} | MESURE |")

summary_lines = [
    "## AADSec Smoke Test - Synthese des resultats",
    "",
    "| Metrique | Attendu | Obtenu | Statut |",
    "|:---|:---:|:---:|:---:|",
    *rows,
    ""
]
summary_text = "\n".join(summary_lines)

step_summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
if step_summary_path:
    with open(step_summary_path, "a", encoding="utf-8") as f:
        f.write(summary_text + "\n")

if failed:
    print("ECHEC: Un ou plusieurs controles stricts sont en ECART (hors divergence base Trivy).")
    sys.exit(1)