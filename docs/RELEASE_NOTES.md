# AADSec — release notes (template)

Copy this into each GitHub Release description and replace the `<…>` placeholders.
Keep the proprietary software notice at the top of every release.

---

## AADSec `<version>`

> **Proprietary software — all rights reserved.**
> Provided under the terms published at https://aadsec.xyz/terms.
> See [PROPRIETARY.md](https://github.com/aadieng100/aadsec-public/blob/main/PROPRIETARY.md). **AADSec is not open source.**

**Scope:** An automated audit + triage layer; it does **not** replace a
penetration test and never claims your code is "secure" or free of vulnerabilities.

### Platforms

macOS (Intel, macOS 15): CLI and tests verified in 0.2.0 (full scan tested with 0.1.1). Apple Silicon (darwin_arm64, M1): CLI, native `linux/arm64` runner image, and offline demo scans tested on macOS 15 (M1) in 0.2.0 (CI install and `aadsec --version` also verified on a macOS arm64 runner, CI run 40054317431). Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1 or 0.2.0; `--image` and output on /mnt/c under WSL are not supported.

### Assets in this release

- `install.sh` — macOS/Linux installer for `aadsec` and `aadsec-agent` (verifies SHA-256 checksums before installing, configures `PATH` and `bash`/`zsh`/`fish` completions)
- `install.ps1` — Windows PowerShell installer for `aadsec` and `aadsec-agent` (verifies SHA-256 checksums before installing, updates User `Path` and generates PowerShell completion scripts)
- `SHA256SUMS` — SHA-256 checksums for the 24 release binaries and archives (`6` raw binaries + `6` archives for `aadsec`, and `6` raw binaries + `6` archives for `aadsec-agent` across `darwin`/`linux`/`windows` × `amd64`/`arm64`; does not cover `install.sh` or `install.ps1`)
- platform binaries & archives: `aadsec_<version>_<os>_<arch>` and `aadsec-agent_<version>_<os>_<arch>` (`.exe` and `.zip` on Windows, raw binary and `.tar.gz` on macOS/Linux)

### Install

macOS / Linux — run the one-liner or download and inspect `install.sh` first:

```bash
# One-liner
curl -fsSL https://github.com/aadieng100/aadsec-public/releases/download/v<version>/install.sh | sh

# Or download and inspect first
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v<version>/install.sh
sh install.sh

aadsec --version
aadsec-agent --version
```

Windows (PowerShell — experimental):

```powershell
irm https://github.com/aadieng100/aadsec-public/releases/download/v<version>/install.ps1 | iex
```

If Docker was not running during install (or `AADSEC_SKIP_IMAGE_PULL=1` was set), pull the scanner runner image once (during scans, `aadsec` runs with `--pull=never`):

```bash
docker pull ghcr.io/aadieng100/aadsec-runner:<version>
aadsec doctor
```

### Use

```bash
aadsec-agent app                     # launch AADSec Local (Desktop UI; OS launcher installed by install.sh or --install-desktop)
aadsec scan .                        # or run the standalone CLI scanner
open security-output/report.html     # macOS — on Linux: xdg-open
```

Verified remediation uses prepaid non-expiring credit packs (`Starter $15` / `5` credits, `Developer $29` / `12` credits, `Agency $49` / `30` credits with one shareable key, plus key-preserving top-ups `+5/$9`, `+10/$16`, `+25/$35`) with `1 credit = 1 verified, accepted, and applied fix` (`0 credit` on scan, export, failure, or `aadsec-agent discard` / `--defer-result-report`).

### Uninstall

```bash
aadsec uninstall          # or: aadsec uninstall --yes
```

Removes all local AADSec state (`aadsec`, `aadsec-agent`, local config, caches for `aadsec` and `aadsec-agent`, and `~/.aadsec`). Per-project
`security-output/` and the runner image are left untouched.

### Known limitations

- Scanner CLI (`aadsec scan`): free and unlimited local scanner (no account, no license key, and no payment card required).
- Not yet delivered: SARIF export, SBOM export, PDF export, DAST (OWASP ZAP).
- Windows support is experimental (see above).
- Full list: [KNOWN_LIMITATIONS.md](https://github.com/aadieng100/aadsec-public/blob/main/docs/KNOWN_LIMITATIONS.md).

### Feedback wanted

Email **support@aadsec.xyz** (technical/license support & stack requests) or **contact@aadsec.xyz** (general inquiries), or reach out on
**[LinkedIn](https://www.linkedin.com/company/aadsec/)** with: OS + versions
(`aadsec --version`, `aadsec doctor`), project type (no sensitive code), useful
findings vs noise, report clarity (CTO vs developer), and what you miss most.

---

*Changelog for `<version>`:*

- `<summary of what changed in this build>`
