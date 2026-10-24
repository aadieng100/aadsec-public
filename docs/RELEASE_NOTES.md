> **Notice (FR) :** v0.1.0-alpha.1 est remplacée par v0.1.0. L'image alpha.1 peut terminer un scan sans erreur avec 0 constat Checkov (échec silencieux de Checkov lors des tests) : ne l'utilisez pas.
>
> **Notice (EN):** v0.1.0-alpha.1 is replaced by v0.1.0. The alpha.1 image can finish a scan without error with 0 Checkov findings (silent Checkov failure observed during testing): do not use it.

# AADSec — beta release notes (template)

Copy this into each GitHub Release description and replace the `<…>` placeholders.
Keep the proprietary/beta notice at the top of every release.

---

## AADSec `<version>` — private beta

> **Pre-release · private beta.** Proprietary software — all rights reserved.
> Provided for **evaluation only**, on a limited, revocable, and non-transferable
> basis. See [PROPRIETARY.md](https://github.com/aadieng100/aadsec-public/blob/main/PROPRIETARY.md). **AADSec is not open source.**

**Status:** private beta — not production ready. An automated audit + triage
layer; it does **not** replace a penetration test and never claims your code is
"secure" or free of vulnerabilities.

### Platforms

macOS (Intel, macOS 15): tested with 0.1.1. Apple Silicon (darwin_arm64): install and aadsec --version verified on a macOS arm64 runner (CI run 40054317431); scan not tested on Apple Silicon. Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1; `--image` and output on /mnt/c under WSL are not supported.

### Assets in this release

- `install.sh` — macOS/Linux installer (verifies SHA-256 before installing)
- `install.ps1` — Windows installer (verifies SHA-256 before installing)
- `SHA256SUMS` — SHA-256 checksums for the 12 binaries and archives (does not cover the SBOM or the installer scripts)
- platform binaries: `aadsec_<version>_<os>_<arch>` (`.exe` on Windows)

### Install

macOS / Linux — download `install.sh` + `SHA256SUMS`, read the script, then:

```bash
bash install.sh
aadsec --version
```

Fetch the scanner runner image once (AADSec never pulls it for you):

```bash
docker pull ghcr.io/aadieng100/aadsec-runner:<version>
aadsec doctor
```

### Use

```bash
aadsec scan .
open security-output/report.html      # macOS — on Linux: xdg-open
```

### Uninstall

```bash
aadsec uninstall          # or: aadsec uninstall --yes
```

Removes all local AADSec state (binary, config, beta counter, cache). Per-project
`security-output/` and the runner image are left untouched.

### Known limitations

- Beta cap: **3 successful scans per machine** (feedback gate; not a licence).
- Not yet delivered: SARIF export, SBOM export from a scan (a CycloneDX SBOM of
  the runner image is provided in the release), PDF export, DAST (OWASP ZAP),
  the `deep` profile.
- Windows support is experimental (see above).
- Full list: [KNOWN_LIMITATIONS.md](https://github.com/aadieng100/aadsec-public/blob/main/docs/KNOWN_LIMITATIONS.md).

### Feedback wanted

Email **contact@aadsec.xyz** or reach out on
**[LinkedIn](https://www.linkedin.com/in/aadieng/)** with: OS + versions
(`aadsec --version`, `aadsec doctor`), project type (no sensitive code), useful
findings vs noise, report clarity (CTO vs developer), and what you miss most.

---

*Changelog for `<version>`:*

- `<summary of what changed in this build>`
