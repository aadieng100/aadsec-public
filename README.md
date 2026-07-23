# AADSec — Actionable Audit for DevSecOps

> **AADSec** is a **local-first DevSecOps audit tool**. It orchestrates trusted
> open-source scanners over your codebase, prioritizes the results, and produces
> a report you can act on — **without uploading your source code**.

[![Status: Alpha](https://img.shields.io/badge/status-Alpha%20%E2%80%94%20not%20production%20ready-orange)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

*AADSec is not a "magic scanner". It's a thin, auditable orchestration + triage
layer: it runs recognized tools (Gitleaks, Trivy, Semgrep, Checkov), filters the
noise, prioritizes real risks, and hands you concrete fixes.*

---

## Positioning

**Automated DevSecOps audit for startups and SMBs — secrets, dependencies (SCA),
SAST, IaC and container images. Your code stays in your environment. You get a
prioritized report with impact, evidence, and concrete fixes.**

What AADSec does **not** do — and never claims:

- ❌ "Secure" / "safe" / "zero vulnerabilities" / "no risk"
- ❌ A complete automatic penetration test
- ❌ "Upload your repo to our cloud"
- ❌ Send your code to an AI/LLM without your consent

An automated audit **complements** a human security assessment — it does not
replace one.

---

## Why local-first (the trust angle)

Teams hesitate to hand a Git repository to an unknown tool. AADSec is built the
other way around:

- The scan runs **on your machine or in your CI**.
- Your source is mounted **read-only** into an ephemeral container.
- Only the **results** (`findings.json`, `report.html`) are written to your disk.
- **Nothing is uploaded.** `docker.sock` is never mounted; no code is sent to an
  LLM without your explicit consent.

You own the output. If you later want help fixing it, you can **voluntarily**
share the results — never your code. See
[How sharing works](docs/SHARING.md).

---

## Quick start

```bash
# 1) Check your environment (Docker + the scanner runner image)
aadsec doctor

# 2) Scan the current directory
aadsec scan .

# 3) Open the report
open security-output/report.html      # macOS — on Linux: xdg-open
```

Common variations:

```bash
aadsec scan --profile quick .         # fast feedback
aadsec scan --profile standard .      # recommended (default)
aadsec scan --image myapp:audit       # scan a local Docker image you built
aadsec scan --image-tar ./myapp.tar   # scan a "docker save" archive
```

Output is in **English by default**; add `--lang fr` for French.

> Installation, the runner image, and the full walkthrough live in the
> **product repository** and the [beta guide](docs/BETA.md).

---

## Example report

See a **public, anonymized** report generated on a deliberately vulnerable demo
project: **[examples/report-demo.html](examples/report-demo.html)** (open it in
any browser — it's self-contained, no network). Origin and anonymization details:
[examples/README.md](examples/README.md).

The report has two views:

- an **executive view** — risk decision, counts by priority (P0–P3), top risks;
- a **developer view** — file, evidence, business impact, and a concrete fix.

---

## What it scans / what's not there yet

**Delivered (alpha):**

| Domain | Tool |
|---|---|
| Secrets | Gitleaks |
| Dependencies (SCA) | Trivy — filesystem |
| SAST | Semgrep — local ruleset |
| IaC (Terraform / Kubernetes) | Checkov |
| Container image | Trivy — `--image` / `--image-tar` |

**Profiles:** `quick` (fast feedback) and `standard` (recommended).

**Roadmap — not yet delivered** (don't rely on these): SARIF export, SBOM
(CycloneDX), automatic PDF export, DAST (OWASP ZAP), a `deep` profile.

---

## After the scan: fix internally, or get help

Once you have your report, you have two paths:

1. **Fix internally.** Work the findings top-down (P0 → P3) and re-scan.
2. **Get remediation help from AADSec.** If you'd like a hand, you can
   *voluntarily* share the results (`findings.json`, `report.html`) — **never
   your source code**. AADSec then helps prioritize and fix. See
   [How sharing works](docs/SHARING.md) and [Contact](#contact).

---

## Status

**Alpha — not production ready.** AADSec is under active development. Treat it as
an additional layer, not a sole security gate. The alpha is also limited to a
small number of successful scans per machine so we can gather feedback before
opening wider access — details in the [beta guide](docs/BETA.md).

---

## Documentation

- [Usage guide](docs/USAGE.md) — commands, profiles, outputs
- [Beta guide](docs/BETA.md) — install, run, give feedback
- [How sharing works](docs/SHARING.md) — the opt-in, manual sharing model
- [FAQ](docs/FAQ.md) — trust, privacy, scope
- [Positioning](docs/POSITIONING.md) — offers, target market, brand meaning

---

## What "AADSec" means

Publicly, **AADSec = Actionable Audit for DevSecOps** (*Sec* = Security). The
name also carries the initials of its creator, **Abdoul Aziz Dieng**.

---

## Contact

> Fill these in before publishing (see the placeholders below).

- **Book a 20-minute diagnostic:** _add your booking link (e.g. Calendly)_
- **Email:** _add your contact email_
- **LinkedIn:** _add your profile_

---

## Licence

MIT — see [LICENSE](LICENSE). AADSec orchestrates open-source tools that keep
their own licences: Gitleaks (MIT), Trivy (Apache-2.0), Semgrep CE (LGPL-2.1),
Checkov (Apache-2.0).
