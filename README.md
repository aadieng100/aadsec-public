# AADSec — Actionable Audit for DevSecOps

[![License: Proprietary](https://img.shields.io/badge/license-Proprietary%20%E2%80%94%20all%20rights%20reserved-red)](PROPRIETARY.md)

**Detect locally. Fix with AI. Prove nothing broke.**

AADSec orchestrates trusted open-source scanners inside an isolated local container, deduplicates and prioritizes findings (`P0`–`P3`), enriches vulnerabilities offline with dated CISA KEV and FIRST EPSS exploitability feeds, and writes a self-contained report on your disk — **without ever uploading your source code**.

Paired with the **AADSec Verified Remediation Agent** (`aadsec-agent`), every AI-proposed fix is re-scanned inside an isolated `--network none` container before delivery so you have verifiable proof of what changed and what did not break.

> **Proprietary software — all rights reserved.** AADSec is **not** open source.
> See [Proprietary software](#proprietary-software) and [PROPRIETARY.md](PROPRIETARY.md).

---

## What AADSec Is Not

An automated audit **complements** a human security assessment — it does not replace one. AADSec never claims:

- "Safe", "free of vulnerabilities", or a complete automated penetration test
- Uploading your repository to a cloud service
- Sending source code to an AI/LLM without your explicit consent

---

## Why Local-First

Teams hesitate to hand a Git repository to an external SaaS tool. AADSec is built the other way around:

- The scan runs **on your machine or in your CI**.
- Your source is mounted **read-only** (`:ro`) into an ephemeral, hardened container (`--cap-drop=ALL`, `--security-opt no-new-privileges`, `--pull=never`, non-root UID `10001`).
- `docker.sock` is **never** mounted; nothing is pulled or uploaded implicitly.
- Only the **results** (`findings.json` schema `0.4`, `report.html`, `audit-metadata.json`) are written to your disk.
- If you later want human assistance, you can **voluntarily** share the results — never your source code. See [How sharing works](docs/SHARING.md).

---

## What It Scans

| Domain | Engine | Scope & Notes |
|---|---|---|
| Secrets | **Gitleaks** | Secret detection with strict redaction; opt-in local `--history` scan |
| Dependencies (SCA) | **Trivy** | Filesystem dependency manifests and lockfiles, with structured upgrade plans |
| SAST (Multi-language) | **Opengrep** | Clean-room local SAST ruleset (LGPL-2.1) — no external rule registry |
| SAST (Go) | **gosec** | Offline Go SAST adapter with strict redaction and canonical CWE deduplication |
| SAST (Python) | **Bandit** | Offline Python SAST adapter with strict redaction and canonical CWE deduplication |
| IaC | **Checkov** | Terraform, Kubernetes, Dockerfile, and CloudFormation |
| Container Image | **Trivy** | Local Docker images (`--image`) or `docker save` archives (`--image-tar`) |

**Profiles:** `quick` (fast feedback) and `standard` (recommended default).

**Outputs (`findings.json` schema `0.4` & `report.html`):**
- `findings.json` schema `0.4`: deduplicated across scanners, prioritized `P0`–`P3`, and enriched offline with dated **CISA KEV** and **FIRST EPSS** exploitability feeds (with `14`-day and `30`-day freshness alerts).
- `report.html`: single self-contained file with zero external assets, Executive and Developer views, FR/EN parity (`--lang en|fr`), and browser print styling (`Cmd+P` / `Ctrl+P`).

**Not currently included:** SARIF export, scan-level CycloneDX SBOM export (a CycloneDX SBOM of the runner image itself is provided in releases), automated PDF binary export, DAST, or a `deep` profile.

---

## AADSec Verified Remediation Agent

While scanners only detect issues and generic AI assistants only *claim* a patch works, **AADSec Verified Remediation Agent** proves remediation by execution:

- **Explicit human consent & local redaction**: three consent modes (`step`, `scoped`, `metadata`); secrets are redacted locally and only a bounded `+/- 15`-line context window is transmitted upon approval, with SHA-256 audit logging (`ai-consent-log.json`).
- **Double scan in `--network none` isolation**: every proposed patch is applied in an isolated workspace and re-scanned inside the `--network none` runner container against the baseline.
- **7 honest statuses**: `NOT_DETECTED_AFTER_PATCH`, `STILL_DETECTED`, `NEW_FINDING_INTRODUCED`, `SUPPRESSED_NOT_FIXED`, `DESTRUCTIVE_CHANGE`, `PATCH_APPLY_ERROR`, and `SCAN_NON_COMPARABLE` — failures and regressions are surfaced explicitly.
- **Anti-Goodhart enforcement**: automatically detects and rejects fake fixes such as `#checkov:skip`, `nosec`, exclusion files (`.trivyignore`, `.gitleaksignore`, `.checkov.yaml`), commenting out active lines, or destructive resource deletion/replacement.
- **Atomic `apply` / `undo`**: source files stay untouched by default; when applied explicitly, out-of-tree backups and `undo` restore exact prior state and permissions.
- **Secrets & dependencies verification**: offline `plan-rotation`, container-isolated `rotation-verify` (post-rotation Gitleaks double scan), and `dependency-verify` (post-upgrade Trivy double scan).
- **Offline license verification**: the CLI verifies the license locally for offline and closed environments.

### Plans & Availability

- **Scanner CLI**: **free local scanner trial** — no account or payment card required.
- **Agent V1 Key**: **`$49/month`** or **`$490/year`** (2 months free), including **30 verified fixes/month** (**360/year pool**).
- **Human Triage & Audit**: **on quote** (voluntary sharing of `findings.json` / `report.html`, never source code).

Learn more and obtain a key at **[https://aadsec.xyz](https://aadsec.xyz)**.

---

## Example Report

Inspect a **public, anonymized** report generated on a deliberately vulnerable demo repository (English and French):
- **[View live demo report (EN)](https://aadieng100.github.io/aadsec-public/examples/report-demo.html)** — source: [`examples/report-demo.html`](examples/report-demo.html)
- **[Voir le rapport de démo en français (FR)](https://aadieng100.github.io/aadsec-public/examples/report-demo-fr.html)** — source: [`examples/report-demo-fr.html`](examples/report-demo-fr.html)

Origin and anonymization details: [examples/README.md](examples/README.md).

In the reference demo scan (Trivy vulnerability database dated **20 October 2026**), the report displays **86 deduplicated findings** (including **52 Trivy** and **32 Checkov** findings). Counts depend on the vulnerability database version in use:

> During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report correspond to the database dated 20 October 2026 and may differ with a more recent database.
>
> Lors du premier scan en ligne, AADSec télécharge la base de vulnérabilités de Trivy dans son cache local (environ 1,6 Go mesurés sur macOS) ; `--offline` utilise celle de l'image ou celle du cache. Le nombre de constats Trivy dépend de la base utilisée : les totaux de l'exemple de rapport correspondent à la base du 20 octobre 2026 et peuvent différer avec une base plus récente.

---

## Download & Install

Releases and checksums are published on the [**Releases**](https://github.com/aadieng100/aadsec-public/releases) page (current build: `v0.1.1`). The installer downloads the matching binary and **verifies its SHA-256** before installing — nothing is installed if the checksum check fails.

### Prerequisites

- **Docker**: running (scanners execute inside an isolated container).
  - **Linux**: your user account must have permission to access the Docker daemon socket (membership in the `docker` group with a refreshed session).
  - **Windows**: Docker Desktop with the **WSL2 backend**.
- **Git**: installed and on `PATH`.

### Installation

**macOS / Linux**

```bash
# 1) Download the installer (reading it before running is recommended)
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.1.1/install.sh

# 2) Run it — installs to ~/.local/bin (or $AADSEC_INSTALL_DIR), no sudo
bash install.sh
aadsec --version
```

If `~/.local/bin` is not in your `PATH`, add it to your shell profile:
- For **zsh** (macOS default):
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
  ```
- For **bash**:
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
  ```

**Windows** (experimental)

```powershell
Invoke-WebRequest -UseBasicParsing `
  -Uri https://github.com/aadieng100/aadsec-public/releases/download/v0.1.1/install.ps1 `
  -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
aadsec --version
```

For manual installation, the [Releases](https://github.com/aadieng100/aadsec-public/releases) page provides the raw binaries, archives, `SHA256SUMS` (covering the 12 distribution binaries and archives), and a CycloneDX SBOM of the runner image.

**Pull the scanner runner image (once):**

```bash
docker pull ghcr.io/aadieng100/aadsec-runner:0.1.1
aadsec doctor      # verifies the CLI and runner image are aligned
```

---

## Usage

```bash
aadsec doctor                          # check Docker, Git, and the runner image
aadsec scan .                          # scan the current directory
open security-output/report.html       # macOS — on Linux: xdg-open
```

Common options:

```bash
aadsec scan --profile quick .          # fast feedback
aadsec scan --profile standard .       # recommended (default)
aadsec scan --offline .                # air-gapped / offline scan (--network none)
aadsec scan --image myapp:audit        # scan a local Docker image you built
aadsec scan --image-tar ./myapp.tar    # scan a "docker save" archive
aadsec share                           # prepare an opt-in bundle of results
```

Output is in **English by default**; add `--lang fr` for French. See the [Usage guide](docs/USAGE.md).

---

## Uninstall

Remove AADSec and its local state (binary, config directory, scanner cache, and `~/.aadsec` fallback):

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip confirmation
```

Per-project scan outputs (`security-output/`) and the Docker runner image (`docker rmi ghcr.io/aadieng100/aadsec-runner:0.1.1`) are left untouched.

---

## Documentation

- [Quickstart guide](docs/GUIDE.md) — installation, prerequisites, and first scan
- [Usage guide](docs/USAGE.md) — commands, profiles, outputs
- [How sharing works](docs/SHARING.md) — the opt-in, manual sharing model
- [FAQ](docs/FAQ.md) — trust, privacy, scope
- [Known limitations](docs/KNOWN_LIMITATIONS.md) — technical constraints and platform scope

---

## What "AADSec" Means

**AADSec** stands for **Actionable Audit for DevSecOps** (*Sec* = Security), while also carrying the initials of its creator, **Abdoul Aziz Dieng**.

---

## Contact

- **Website:** [https://aadsec.xyz](https://aadsec.xyz)
- **Email:** [contact@aadsec.xyz](mailto:contact@aadsec.xyz)
- **LinkedIn:** [linkedin.com/company/aadsec](https://www.linkedin.com/company/aadsec/)

---

## Proprietary Software

**Proprietary software — all rights reserved.**
© 2026 Abdoul Aziz Dieng, exploitant l'entreprise individuelle DIENG TECH ET SERVICES.
No right to use, copy, modify, distribute, sublicense, resell, or create derivative works from AADSec is granted except with prior written permission from the owner. Evaluation and commercial terms are published at [https://aadsec.xyz/terms](https://aadsec.xyz/terms).

AADSec orchestrates third-party open-source scanners (Gitleaks under MIT, Trivy under Apache-2.0, Opengrep under LGPL-2.1, Checkov under Apache-2.0, gosec under Apache-2.0, Bandit under Apache-2.0); those tools remain under their own respective licenses — see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). That does **not** make AADSec open source. Full statement: [PROPRIETARY.md](PROPRIETARY.md).
