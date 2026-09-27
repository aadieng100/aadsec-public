# AADSec — Example reports

Public, anonymized AADSec audit reports. Open them in any browser — self-contained (no external assets, no network).

- 🌐 **[View live demo report (EN)](https://aadieng100.github.io/aadsec-public/examples/report-demo.html)** — source: [`report-demo.html`](report-demo.html)
- 🇫🇷 **[Voir le rapport de démo en direct (FR)](https://aadieng100.github.io/aadsec-public/examples/report-demo-fr.html)** — source: [`report-demo-fr.html`](report-demo-fr.html)

## What it is

It was produced by scanning an **intentionally vulnerable** demo project with the
four filesystem scanners AADSec orchestrates (Gitleaks, Trivy, Semgrep, Checkov).
It illustrates the report format:

- an **executive view** — risk decision, counts by priority (P0–P3), top risks;
- a **developer view** — file, evidence, business impact, and a concrete fix.

## Anonymization

The report contains **no real code, no secrets, and no local paths**:

- the demo project is synthetic and disposable;
- the scan runs inside a container, so the project path is the generic
  `/workspace` (the report shows *"local project"*);
- Gitleaks runs with `--redact`, so any secret evidence is redacted.

## Honest scope

This is an **automated audit + triage** layer, not a penetration test. AADSec
never claims "zero vulnerabilities" or "secure". Exact finding counts depend on
the scanners' databases at scan time and will vary between runs.

> ⚠️ The demo project is deliberately insecure — it exists only to demonstrate
> the report. Do not deploy or reuse it.
