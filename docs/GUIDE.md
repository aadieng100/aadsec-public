# Quickstart guide

Welcome to AADSec. This guide gets you from install to your
first report in ~15 minutes, and shows how to send useful feedback.

AADSec is a **local-first DevSecOps audit**: it orchestrates recognized
open-source scanners, prioritizes the results, and produces a readable report.
**Your code never leaves your machine.**

---

## What AADSec scans (and doesn't)

| Domain | Tool | Included |
|---|---|---|
| Secrets | Gitleaks | ✅ |
| Dependencies (SCA) | Trivy (filesystem) | ✅ |
| SAST | Opengrep (local ruleset), gosec, Bandit | ✅ |
| IaC (terraform, kubernetes, dockerfile, cloudformation) | Checkov | ✅ |
| Container image | Trivy (`--image`) | ✅ |

- **Outputs:** `findings.json` (normalized, prioritized P0–P3) + `report.html`
  (executive + developer views, self-contained).
- **Roadmap (not yet delivered):** SARIF export, SBOM export from a scan (planned for a future release), PDF export, DAST/ZAP.

> AADSec **never** promises "zero vulnerabilities" or "secure". It's an automated
> detection + triage layer, and it **does not replace** a manual penetration test.

---

## Trust & privacy

- **Local-first:** the scan runs on your machine (or your CI). Your code is
  **never uploaded**.
- **No LLM processing** of your code without your explicit consent.
- The runner container is **ephemeral** (`--rm`), mounts your project
  **read-only**, and **never mounts `docker.sock`**.
- During scans, the `aadsec` CLI runs with `--pull=never` and never executes `docker pull` or `docker login` on its own (the installer `install.sh` / `install.ps1` can pull `ghcr.io/aadieng100/aadsec-runner:0.2.0` at install time unless `AADSEC_SKIP_IMAGE_PULL=1` is set).

---

## Prerequisites

- **Docker**, running (the scanners run inside a container). If Docker is not started, `aadsec doctor` and `aadsec scan` will detect it and provide the exact command to start it on your OS.
- **git**.
- **Platforms:** macOS (Intel, macOS 15): CLI and tests verified in 0.2.0 (full scan tested with 0.1.1). Apple Silicon (darwin_arm64, M1): CLI, native `linux/arm64` runner image, and offline demo scans tested on macOS 15 (M1) in 0.2.0 (CI install and `aadsec --version` also verified on a macOS arm64 runner, CI run 40054317431). Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1 or 0.2.0; `--image` and output on /mnt/c under WSL are not supported.

---

## Download & install

The current build is `v0.2.0` on the [**Releases**](https://github.com/aadieng100/aadsec-public/releases) page.
The installer checks `SHA256SUMS` in fail-closed mode before writing anything to disk and installs both **`aadsec` and `aadsec-agent`** into `~/.local/bin` (or `%LOCALAPPDATA%\aadsec` on Windows):

- **macOS / Linux (`install.sh`)**: automatically configures `PATH` and loads shell completions (`bash`, `zsh`, `fish`) via `~/.aadsec/completions/` (disable with `AADSEC_NO_MODIFY_PATH=1` / `AADSEC_NO_COMPLETION=1`).
- **Windows (`install.ps1`, experimental)**: updates `User Path` and generates PowerShell completion scripts in `%LOCALAPPDATA%\aadsec\completions\` (`aadsec.ps1` and `aadsec-agent.ps1`).
- **Runner image**: if Docker is running during installation, the installer verifies or pulls `ghcr.io/aadieng100/aadsec-runner:0.2.0` (disable with `AADSEC_SKIP_IMAGE_PULL=1` / `-SkipImagePull`).

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

**Windows (PowerShell — experimental)**

See [Known limitations](KNOWN_LIMITATIONS.md) for Windows platform constraints.

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

```bash
# If Docker was not running during install (or AADSEC_SKIP_IMAGE_PULL=1 was set), pull the runner image:
docker pull ghcr.io/aadieng100/aadsec-runner:0.2.0

# Verify everything is aligned:
aadsec doctor        # should show "Runner status: ✅ present … (matches CLI)"
```

Then scan your repo and open the report:

```bash
cd /path/to/your/repo
aadsec scan .
open security-output/report.html      # macOS — on Linux: xdg-open
```

Output is English by default; add `--lang fr` for French.

> AADSec is proprietary software — all rights reserved (see [PROPRIETARY.md](../PROPRIETARY.md) and https://aadsec.xyz/terms).

---

## Evaluation & licensing

- **Scanner CLI (`aadsec`)**: **free and unlimited local scanner** — no account, no license key, and no payment card required.
- **AADSec Remediation Agent (`aadsec-agent` — Standard)**: available at **[https://aadsec.xyz](https://aadsec.xyz)** (`$49/month` — `30` verified fixes/month, `120` attempts/month — or `$490/year` — `360` verified fixes/year pool, `120` attempts/month, 2 months free). Activate and run verified remediation locally:
  ```bash
  aadsec-agent activate
  aadsec-agent --findings security-output/findings.json --finding-rule <RULE_ID> --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
  aadsec-agent apply --out ./aadsec-ai-output --source .
  ```
- **Proprietary software**: all rights reserved — see [PROPRIETARY.md](../PROPRIETARY.md) and [https://aadsec.xyz/terms](https://aadsec.xyz/terms).

---

## (Optional) Share your findings with AADSec

If you'd like help fixing what the report surfaced, you can **voluntarily** send
the results — **never your source code**. `aadsec share` prepares a local bundle;
**nothing is uploaded**:

```bash
aadsec share          # bundles ./security-output into ./aadsec-share
```

The bundle contains only `findings.json`, `report.html`, `audit-metadata.json`, and `SHARE_README.txt`.
Details: [How sharing works](SHARING.md).

---

## Uninstall completely

To remove AADSec and **all** its local state:

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip the confirmation
```

It deletes only AADSec-owned paths — the installed `aadsec` binary, the companion `aadsec-agent` binary, the config directory, the `aadsec` and `aadsec-agent` caches, and `~/.aadsec` (including `~/.aadsec/completions/`). The `# >>> aadsec initialize >>>` block in shell configuration files remains harmless and can be removed manually if desired.
Per-project `security-output/` folders and the Docker runner image are left
untouched — remove those yourself (`docker rmi ghcr.io/aadieng100/aadsec-runner:0.2.0`).

---

## Send feedback

The most useful things to tell us:

1. OS + versions (`aadsec --version`, `aadsec doctor`).
2. Project type scanned (languages, IaC, rough size) — **without pasting
   sensitive code**.
3. What worked / broke (paste the exact error if it crashed).
4. **Useful** findings vs **false positives / noise** — triage quality matters
   most.
5. Is the report clear for a CTO? for a developer?
6. What you miss most (SARIF? SBOM? PDF? CI integration?).
