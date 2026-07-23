# Beta guide

Thanks for trying AADSec in alpha 🙏. This guide gets you from install to your
first report in ~15 minutes, and shows how to send useful feedback.

AADSec is a **local-first DevSecOps audit**: it orchestrates recognized
open-source scanners, prioritizes the results, and produces a readable report.
**Your code never leaves your machine.**

---

## What the alpha does (and doesn't)

| Domain | Tool | In the alpha |
|---|---|---|
| Secrets | Gitleaks | ✅ |
| Dependencies (SCA) | Trivy (filesystem) | ✅ |
| SAST | Semgrep (local ruleset) | ✅ |
| IaC (Terraform / K8s) | Checkov | ✅ |
| Container image | Trivy (`--image`) | ✅ |

- **Outputs:** `findings.json` (normalized, prioritized P0–P3) + `report.html`
  (executive + developer views, self-contained).
- **Profiles delivered:** `quick` (fast feedback) and `standard` (recommended).
  A `deep` profile is a **future idea**, not shipped.
- **Roadmap (not yet delivered):** SARIF export, SBOM (CycloneDX), PDF export,
  DAST/ZAP, the `deep` profile.

> AADSec **never** promises "zero vulnerabilities" or "secure". It's an automated
> detection + triage layer, and it **does not replace** a manual penetration test.

---

## Trust & privacy

- **Local-first:** the scan runs on your machine (or your CI). Your code is
  **never uploaded**.
- **No LLM processing** of your code without your explicit consent.
- The runner container is **ephemeral** (`--rm`), mounts your project
  **read-only**, and **never mounts `docker.sock`**.
- AADSec never runs `docker pull` / `docker login` on its own — you fetch the
  runner image yourself.

---

## Prerequisites

- **Docker**, running (the scanners run inside a container).
- **git**.
- **Windows:** Docker Desktop with the **WSL2 backend** enabled. Windows support
  is **experimental** and not yet validated end-to-end — macOS and Linux are the
  tested platforms.

---

## Install & run

Installation, the pinned version, and the runner image live in the **product
repository's releases**. Once installed:

```bash
# 1) Verify your environment
aadsec doctor        # should show "Runner status: ✅ present … (matches CLI)"

# 2) Scan your repo
cd /path/to/your/repo
aadsec scan .

# 3) Open the report
open security-output/report.html      # macOS — on Linux: xdg-open
```

Output is English by default; add `--lang fr` for French.

---

## Beta usage limit

The alpha is capped at **3 successful scans per machine** so we can gather
feedback before opening wider access.

- Only **successful** scans count. `--dry-run` never counts and is never blocked.
- After each scan you'll see `🧪 Beta: N/3 successful scans used — M remaining.`
- When the limit is reached, `aadsec scan` stops and points you to AADSec for
  extended access — reach out with your feedback.

This is an honest, **local** guardrail — not a tamper-proof license. It's a plain
JSON file under your OS config directory, and it resets on ephemeral CI runners.

---

## (Optional) Share your findings with AADSec

If you'd like help fixing what the report surfaced, you can **voluntarily** send
the results — **never your source code**. `aadsec share` prepares a local bundle;
**nothing is uploaded**:

```bash
aadsec share          # bundles ./security-output into ./aadsec-share
```

The bundle contains only `findings.json`, `report.html`, and `audit-metadata.json`.
Details: [How sharing works](SHARING.md).

---

## Send feedback 🎯

The most useful things to tell us:

1. OS + versions (`aadsec --version`, `aadsec doctor`).
2. Project type scanned (languages, IaC, rough size) — **without pasting
   sensitive code**.
3. What worked / broke (paste the exact error if it crashed).
4. **Useful** findings vs **false positives / noise** — triage quality matters
   most.
5. Is the report clear for a CTO? for a developer?
6. What you miss most (SARIF? SBOM? PDF? CI integration?).

Your feedback directly shapes the roadmap. Thank you 🚀
