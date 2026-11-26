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
- `docker.sock` is **never** mounted; during scans, the CLI runs with `--pull=never` so nothing is pulled or uploaded implicitly.
- Only the **results** (`findings.json` schema `0.4`, `report.html`, `audit-metadata.json`) are written to your disk.
- If you later want human assistance, you can **voluntarily** share the results — never your source code. See [How sharing works](docs/SHARING.md).

### Why AADSec Exists

Built by a DevSecOps engineer tired of exposing proprietary repositories to third-party clouds and triaging hundreds of duplicate alerts across six separate tools.

**One command (`aadsec scan`). Local offline container execution (`--network none`). Deduplicated findings and AI patches proven by real re-scan (`aadsec-agent`).**

---

## What It Scans

| Domain | Engine | Scope & Notes |
|---|---|---|
| Secrets | **Gitleaks** | Secret detection with strict redaction; opt-in local `--history` scan |
| Dependencies (SCA) | **Trivy** | Filesystem dependency manifests and lockfiles, with structured upgrade plans |
| SAST (Multi-language) | **Opengrep** | Clean-room local SAST ruleset (LGPL-2.1) — no external rule registry |
| SAST (Go) | **gosec** | Offline Go SAST adapter with strict redaction and canonical CWE deduplication |
| SAST (Python) | **Bandit** | Offline Python SAST adapter with strict redaction and canonical CWE deduplication |
| IaC | **Checkov** | Terraform, Kubernetes, Dockerfile, CloudFormation, and GitHub Actions (`github_actions`) |
| Container Image | **Trivy** | Local Docker images (`--image`) or `docker save` archives (`--image-tar`) |

**Outputs (`findings.json` schema `0.4` & `report.html`):**
- `findings.json` schema `0.4`: deduplicated across scanners, prioritized `P0`–`P3`, and enriched offline with dated **CISA KEV** and **FIRST EPSS** exploitability feeds (with `14`-day and `30`-day freshness alerts).
- `report.html`: single self-contained file with zero external assets, Executive and Developer views, FR/EN parity (`--lang en|fr`), and browser print styling (`Cmd+P` / `Ctrl+P`).

**Not currently included:** SARIF export, scan-level CycloneDX SBOM export (planned for a future release), automated PDF binary export, or DAST.

---

## AADSec Verified Remediation Agent

While scanners only detect issues and generic AI assistants only *claim* a patch works, **AADSec Verified Remediation Agent** proves remediation by execution:

- **Local Desktop UI (`AADSec Local` via `aadsec-agent app`)**: launch `aadsec-agent app` (or the OS desktop icon installed automatically by `install.sh` via `aadsec-agent app --install-desktop`) to open a folder, run unlimited free local scans, export JSON/CSV/Markdown/HTML reports, review verified diffs, and apply or discard patches (`aadsec-agent discard`).
- **Explicit human consent & local redaction**: `step` and `scoped` are the consent modes on the default gateway (`metadata` is reserved for `--provider custom`); secrets are redacted locally and only a bounded `+/- 120`-line window plus import header (`lines 1..60`, `<= 20 KiB` under the `32 KiB` gateway bound) is transmitted upon approval, with SHA-256 audit logging (`ai-consent-log.json`).
- **Double scan in `--network none` isolation**: every proposed patch is applied in an isolated workspace and re-scanned inside the `--network none` runner container against the baseline.
- **7 honest statuses**: `NOT_DETECTED_AFTER_PATCH`, `STILL_DETECTED`, `NEW_FINDING_INTRODUCED`, `SUPPRESSED_NOT_FIXED`, `DESTRUCTIVE_CHANGE`, `PATCH_APPLY_ERROR`, and `SCAN_NON_COMPARABLE` — failures and regressions are surfaced explicitly.
- **Anti-Goodhart enforcement**: automatically detects and rejects fake fixes such as `#checkov:skip`, `nosec`, exclusion files (`.trivyignore`, `.gitleaksignore`, `.checkov.yaml`), commenting out active lines, or destructive resource deletion/replacement.
- **Atomic `apply` / `discard` / `undo` & `--defer-result-report`**: source files stay untouched by default; when using `--defer-result-report` (default in `aadsec-agent app`), billable credit reporting waits until you explicitly `apply` (`1 credit`) or `discard` (`aadsec-agent discard`, `0 credit`), and out-of-tree backups with `undo` restore exact prior state and permissions.
- **Secrets & dependencies verification**: offline `plan-rotation`, container-isolated `rotation-verify` (post-rotation Gitleaks double scan), and `dependency-verify` (post-upgrade Trivy double scan).
- **One-time activation & shell autocompletion**: activate your key interactively without terminal echo (`aadsec-agent activate`), via `AADSec Local` (`aadsec-agent app`), via `printf '%s\n' "$KEY" | aadsec-agent activate --stdin`, or pass `AADSEC_LICENSE_KEY` directly in CI/CD environments; built-in `completion <bash|zsh|fish|powershell>` support.
- **Offline (`0 credit`) vs. Online (`1 credit` on verified `Apply`)**: Scanning (`aadsec scan` / `AADSec Local` scan), exports, and Gitleaks secret fixes (`0 credit — local`) run **100% offline** with zero network transfers. `Fix with AADSec` (`1 credit`) queries AADSec's online verified recipes on `api.aadsec.xyz` first and falls back transparently to AI models when needed (Internet connection required, `<= 20 KiB` redacted excerpt under the `32 KiB` bound, zero code retention), then verifies every patch locally inside offline Docker (`--network none`).

### Plans & Availability

- **Scanner CLI (`aadsec`)**: **free and unlimited local scanner** — no account, no license key, and no payment card required. Run `aadsec scan .` (or use `aadsec-agent app`) before purchasing an agent credit pack to inspect coverage on your stack; missing a language or framework, or need license support? Write to [support@aadsec.xyz](mailto:support@aadsec.xyz) (general inquiries: [contact@aadsec.xyz](mailto:contact@aadsec.xyz)).
- **AADSec Remediation Agent (`aadsec-agent`) — Prepaid Non-Expiring Credit Packs**: exclusively prepaid packs with **no expiration** (no recurring subscription required):
  - **Starter (`$15`)**: `5` non-expiring credits (`30` attempts/month, individual key)
  - **Developer (`$29`)**: `12` non-expiring credits (`60` attempts/month, individual key)
  - **Agency (`$49`)**: `30` non-expiring credits (`120` attempts/month, **one shareable key** across multiple team workstations on a shared wallet)
  - **Key-preserving top-ups**: `+5` credits (`$9`), `+10` credits (`$16`), `+25` credits (`$35`) — credit your active wallet directly without changing your key.
  - **Accounting rule**: **`1 credit = 1 verified, accepted, and applied fix`** (`NOT_DETECTED_AFTER_PATCH` without regression, accepted and applied via `aadsec-agent apply` or `AADSec Local`). Scans, exports (JSON/CSV/Markdown/HTML), failed attempts, and `discard` (`aadsec-agent discard`) consume **`0 credit`**.
  - Covers all 6 engines (`checkov` including `github_actions`, `opengrep`, `gosec`, `bandit`, `trivy`, `gitleaks`, with secrets & SCA handled locally without external AI; automatic Trivy `DoubleScan` applies directly to `go.mod`, `requirements*.txt`, and `pom.xml`, while lockfile-backed ecosystems use local upgrade + `aadsec-agent dependency-verify`). (`--runner-image` defaults to `ghcr.io/aadieng100/aadsec-runner:0.2.0`, whose published image embeds the initial 26 Opengrep rules pending the next runner rebuild for the 20 new `B-07` rules and `github_actions` runner extension.)
- **Human Triage & Audit**: **on quote** (voluntary sharing of `findings.json` / `report.html`, never source code).

Learn more and obtain a key at **[https://aadsec.xyz](https://aadsec.xyz)**.

---

## Example Report

Inspect a **public, anonymized** report generated on a deliberately vulnerable demo repository (English and French):
- **[View live demo report (EN)](https://aadieng100.github.io/aadsec-public/examples/report-demo.html)** — source: [`examples/report-demo.html`](examples/report-demo.html)
- **[Voir le rapport de démo en français (FR)](https://aadieng100.github.io/aadsec-public/examples/report-demo-fr.html)** — source: [`examples/report-demo-fr.html`](examples/report-demo-fr.html)

Origin and anonymization details: [examples/README.md](examples/README.md).

In the reference demo scan (Trivy / KEV / EPSS databases dated **2026-11-25**), the report displays **90 deduplicated findings** (`105` before deduplication: **54 Trivy**, **32 Checkov**, **2 Gitleaks**, **2 Opengrep**; `gosec` and `Bandit` report `not_applicable` as the demo repository contains no `.go` or `.py` files). Counts depend on the vulnerability database version in use:

> During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report correspond to the database dated `2026-11-25` and may differ with a more recent database.
>
> Lors du premier scan en ligne, AADSec télécharge la base de vulnérabilités de Trivy dans son cache local (environ 1,6 Go mesurés sur macOS) ; `--offline` utilise celle de l'image ou celle du cache. Le nombre de constats Trivy dépend de la base utilisée : les totaux de l'exemple de rapport correspondent à la base du `2026-11-25` et peuvent différer avec une base plus récente.

---

## Download & Install

Releases and checksums are published on the [**Releases**](https://github.com/aadieng100/aadsec-public/releases) page (current build: `v0.2.0`). The installer checks `SHA256SUMS` in fail-closed mode before writing anything to disk and installs both **`aadsec` and `aadsec-agent`** into `~/.local/bin` (or `%LOCALAPPDATA%\aadsec` on Windows):

- **macOS / Linux (`install.sh`)**: automatically updates `PATH` and loads shell autocompletion (`bash`, `zsh`, `fish`) via `~/.aadsec/completions/` (can be disabled via `AADSEC_NO_MODIFY_PATH=1` / `AADSEC_NO_COMPLETION=1`).
- **Windows (`install.ps1`, experimental)**: automatically updates `User Path` and generates PowerShell completion scripts in `%LOCALAPPDATA%\aadsec\completions\` (`aadsec.ps1` and `aadsec-agent.ps1`).
- **Runner image**: if Docker is running during installation, the installer verifies or pulls `ghcr.io/aadieng100/aadsec-runner:0.2.0` (can be disabled via `AADSEC_SKIP_IMAGE_PULL=1` / `-SkipImagePull`).

### Prerequisites

- **Docker**: running (scanners execute inside an isolated container).
  - **Linux**: your user account must have permission to access the Docker daemon socket (membership in the `docker` group with a refreshed session).
  - **Windows**: Docker Desktop with the **WSL2 backend**.
- **Git**: installed and on `PATH`.

### Installation

**macOS / Linux**

```bash
# Option A — One-liner install (installs aadsec + aadsec-agent, configures PATH & completions)
curl -fsSL https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.sh | sh

# Option B — Download and inspect first
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.sh
sh install.sh

aadsec --version
aadsec-agent --version
```

**Windows** (experimental)

```powershell
# Option A — One-liner install
irm https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.ps1 | iex

# Option B — Download and inspect first
Invoke-WebRequest -UseBasicParsing `
  -Uri https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.ps1 `
  -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1

aadsec --version
aadsec-agent --version
```

For manual installation, the [Releases](https://github.com/aadieng100/aadsec-public/releases) page provides the raw binaries, archives, and `SHA256SUMS` (covering the 24 distribution binaries and archives: 12 for `aadsec` and 12 for `aadsec-agent`; it does not cover `install.sh` or `install.ps1`).

**Pull the scanner runner image (if Docker was not running during install or `AADSEC_SKIP_IMAGE_PULL=1` was set):**

```bash
docker pull ghcr.io/aadieng100/aadsec-runner:0.2.0
aadsec doctor      # verifies the CLI and runner image are aligned
```

---

## Usage

**Graphical interface (`AADSec Local`) & CLI quickstart:**

```bash
aadsec-agent app                       # launch AADSec Local (runs locally on 127.0.0.1)
aadsec-agent app --install-desktop     # install/refresh OS Desktop icon & launcher
aadsec doctor                          # check Docker, Git, and the runner image
aadsec scan .                          # scan the current directory
open security-output/report.html       # macOS — on Linux: xdg-open
```

Common options:

```bash
aadsec scan --offline .                # air-gapped / offline scan (--network none)
aadsec scan --image myapp:audit        # scan a local Docker image you built
aadsec scan --image-tar ./myapp.tar    # scan a "docker save" archive
aadsec share                           # prepare an opt-in bundle of results
aadsec completion <bash|zsh|fish|powershell>  # generate shell completion script
```

Verified remediation (`aadsec-agent`):

```bash
aadsec-agent activate                                        # interactive license key activation (no echo)
aadsec-agent doctor --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
aadsec-agent --findings security-output/findings.json \
  --finding-rule CKV_AWS_20 \
  --defer-result-report \
  --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0      # verified IaC remediation loop (deferred credit deduction)
aadsec-agent apply --out ./aadsec-ai-output --source .       # atomically apply a verified patch (1 credit)
aadsec-agent discard --out ./aadsec-ai-output                # discard a proposed patch (0 credit)
aadsec-agent undo --out ./aadsec-ai-output --source .        # revert an applied patch from backup
aadsec-agent plan-rotation --findings security-output/findings.json --all-secrets
aadsec-agent rotation-verify --findings security-output/findings.json --source . --all-secrets \
  --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
aadsec-agent dependency-verify --findings security-output/findings.json --source . --all-vulns \
  --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
aadsec-agent completion <bash|zsh|fish|powershell>           # generate shell completion script
```

Output is in **English by default**; add `--lang fr` for French. See the [Usage guide](docs/USAGE.md).

---

## Uninstall

Remove AADSec and its local state (`aadsec`, the companion `aadsec-agent` binary in the same directory, the config directory, the `aadsec` and `aadsec-agent` caches, and `~/.aadsec` including `~/.aadsec/completions/`):

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip confirmation
```

The `# >>> aadsec initialize >>>` block in shell configuration files remains harmless and can be removed manually if desired. Per-project scan outputs (`security-output/`) and the Docker runner image (`docker rmi ghcr.io/aadieng100/aadsec-runner:0.2.0`) are left untouched.

---

## Documentation

- [Quickstart guide](docs/GUIDE.md) — installation, prerequisites, and first scan
- [Usage guide](docs/USAGE.md) — commands, flags, outputs
- [How sharing works](docs/SHARING.md) — the opt-in, manual sharing model
- [FAQ](docs/FAQ.md) — trust, privacy, scope
- [Known limitations](docs/KNOWN_LIMITATIONS.md) — technical constraints and platform scope

---

## What "AADSec" Means

**AADSec** stands for **Actionable Audit for DevSecOps** (*Sec* = Security), while also carrying the initials of its creator, **Abdoul Aziz Dieng**.

---

## Contact

- **Website:** [https://aadsec.xyz](https://aadsec.xyz)
- **Support, licenses & stack requests:** [support@aadsec.xyz](mailto:support@aadsec.xyz)
- **General contact & security reports:** [contact@aadsec.xyz](mailto:contact@aadsec.xyz)
- **LinkedIn:** [linkedin.com/company/aadsec](https://www.linkedin.com/company/aadsec/)

---

## Proprietary Software

**Proprietary software — all rights reserved.**
© 2026 Abdoul Aziz Dieng, exploitant l'entreprise individuelle DIENG TECH ET SERVICES.
No right to use, copy, modify, distribute, sublicense, resell, or create derivative works from AADSec is granted except with prior written permission from the owner. Evaluation and commercial terms are published at [https://aadsec.xyz/terms](https://aadsec.xyz/terms).

AADSec orchestrates third-party open-source scanners (Gitleaks under MIT, Trivy under Apache-2.0, Opengrep under LGPL-2.1, Checkov under Apache-2.0, gosec under Apache-2.0, Bandit under Apache-2.0); those tools remain under their own respective licenses — see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). That does **not** make AADSec open source. Full statement: [PROPRIETARY.md](PROPRIETARY.md).
