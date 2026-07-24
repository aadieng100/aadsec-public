# AADSec — Actionable Audit for DevSecOps

> **AADSec** is a **local-first DevSecOps audit tool**. It orchestrates trusted
> open-source scanners over your codebase, prioritizes the results, and produces
> a report you can act on — **without uploading your source code**.

[![Status: Private beta](https://img.shields.io/badge/status-Private%20beta%20%E2%80%94%20not%20production%20ready-orange)]()
[![License: Proprietary](https://img.shields.io/badge/license-Proprietary%20%E2%80%94%20all%20rights%20reserved-red)](PROPRIETARY.md)

*AADSec is not a "magic scanner". It's an auditable orchestration and triage engine:
it runs recognized tools (Gitleaks, Trivy, Semgrep, Checkov), filters the noise,
prioritizes real risks, and hands you concrete fixes.*

> **Proprietary software — all rights reserved.** AADSec is **not** open source.
> See [Proprietary software](#proprietary-software) and [PROPRIETARY.md](PROPRIETARY.md).

---

## Positioning

**Local-first DevSecOps audit CLI for any project — SaaS, side projects, internal apps, or teams.
Runs trusted scanners (secrets, dependencies, SAST, IaC, containers) in one command, cuts through noisy logs and false positives, and delivers a prioritized report with concrete fixes — without sending your source code to the cloud.**

What AADSec does **not** do — and never claims:

- ❌ "Secure" / "safe" / "zero vulnerabilities" / "no risk"
- ❌ A complete automatic penetration test
- ❌ "Upload your repo to our cloud"
- ❌ Send your code to an AI/LLM without your consent

An automated audit **complements** a human security assessment — it does not
replace one.

---

## Why local-first

Teams hesitate to hand a Git repository to an unknown tool. AADSec is built the
other way around:

- The scan runs **on your machine or in your CI**.
- Your source is mounted **read-only** into an ephemeral container.
- Only the **results** (`findings.json`, `report.html`) are written to your disk.
- **Nothing is uploaded.** `docker.sock` is never mounted; no code is sent to an
  LLM without your explicit consent.

You own the output. If you later want help fixing it, you can **voluntarily**
share the results — never your code. See [How sharing works](docs/SHARING.md).

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

## Download & install

AADSec is distributed as a **private beta** from the
[**Releases**](../../releases) page (current build: `v0.1.0-alpha.1`). The
installer downloads the matching binary and **verifies its SHA-256** before
installing — nothing is installed if the checksum fails.

**macOS / Linux**

```bash
# 1) Download the installer (reading it before running is recommended)
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.1.0-alpha.1/install.sh

# 2) Run it — installs to ~/.local/bin, no sudo
bash install.sh
aadsec --version
```

**Windows** — ⚠️ experimental, not yet validated end-to-end. Requires Docker
Desktop with the **WSL2 backend**.

```powershell
Invoke-WebRequest -UseBasicParsing `
  -Uri https://github.com/aadieng100/aadsec-public/releases/download/v0.1.0-alpha.1/install.ps1 `
  -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
aadsec --version
```

Prefer not to use the script? The [Releases](../../releases) page also lists the
raw binaries, archives, `SHA256SUMS`, and a CycloneDX SBOM for manual installs.

**The scanner runner image (once).** The scan runs inside a container image you
fetch yourself — AADSec never pulls it for you:

```bash
docker pull ghcr.io/aadieng100/aadsec-runner:0.1.0-alpha.1
aadsec doctor      # verifies the CLI and runner image are aligned
```

> Beta access is **limited, revocable, and non-transferable** — see
> [Proprietary software](#proprietary-software).

---

## Use it

```bash
aadsec doctor                          # check Docker, Git, and the runner image
aadsec scan .                          # scan the current directory
open security-output/report.html       # macOS — on Linux: xdg-open
```

Common variations:

```bash
aadsec scan --profile quick .          # fast feedback
aadsec scan --profile standard .       # recommended (default)
aadsec scan --image myapp:audit        # scan a local Docker image you built
aadsec scan --image-tar ./myapp.tar    # scan a "docker save" archive
aadsec share                           # prepare an opt-in bundle to send to AADSec
```

Output is in **English by default**; add `--lang fr` for French. Full walkthrough:
[beta guide](docs/BETA.md) · [usage guide](docs/USAGE.md).

---

## After the scan: fix internally, or get help

Once you have your report, you have two paths:

1. **Fix internally.** Work the findings top-down (P0 → P3) and re-scan.
2. **Get remediation help from AADSec.** If you'd like a hand, you can
   *voluntarily* share the results (`findings.json`, `report.html`) — **never
   your source code**. AADSec then helps prioritize and fix. See
   [How sharing works](docs/SHARING.md) and [Contact](#contact).

---

## Uninstall

Remove AADSec and **all** of its local state in one step:

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip the confirmation
```

It deletes only AADSec-owned paths — the installed binary, the config directory
(including the beta counter), the scanner cache, and the `~/.aadsec` fallback.
Per-project scan outputs (`security-output/`) and the Docker runner image are
left untouched — remove those yourself.

---

## What it scans / what's not there yet

**Delivered (beta):**

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

## Status

**Private beta — not production ready.** AADSec is under active development.
Treat it as an additional layer, not a sole security gate. The beta is limited
to a small number of successful scans per machine so we can gather feedback
before opening wider access — details in the [beta guide](docs/BETA.md).

---

## Documentation

- [Usage guide](docs/USAGE.md) — commands, profiles, outputs
- [Beta guide](docs/BETA.md) — download, install, run, give feedback
- [How sharing works](docs/SHARING.md) — the opt-in, manual sharing model
- [FAQ](docs/FAQ.md) — trust, privacy, scope
- [Positioning](docs/POSITIONING.md) — offers, target market, brand meaning

---

## What "AADSec" means

Publicly, **AADSec = Actionable Audit for DevSecOps** (*Sec* = Security). The
name also carries the initials of its creator, **Abdoul Aziz Dieng**.

---

## Contact

- **Email:** [diengabdoulaziz110@gmail.com](mailto:diengabdoulaziz110@gmail.com)
- **LinkedIn:** [linkedin.com/in/aadieng](https://www.linkedin.com/in/aadieng/)
- **Book a 20-minute diagnostic:** reach out by email or LinkedIn.

---

## Proprietary software

**Proprietary software — all rights reserved.**
AADSec is proprietary software owned by Abdoul Aziz Dieng.
No right to use, copy, modify, distribute, sublicense, resell, or create
derivative works from AADSec is granted except with prior written permission
from the owner.
Any beta build or evaluation access is provided on a limited, revocable, and
non-transferable basis.

AADSec orchestrates third-party open-source scanners (Gitleaks, Trivy, Semgrep,
Checkov); those tools remain under their own respective licences — see
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). That does **not** make AADSec
open source. Full statement: [PROPRIETARY.md](PROPRIETARY.md).
