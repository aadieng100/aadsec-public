# AADSec — beta release notes (template)

Copy this into each GitHub Release description and replace the `<…>` placeholders.
Keep the proprietary/beta notice at the top of every release.

---

## AADSec `<version>` — private beta

> **Pre-release · private beta.** Proprietary software — all rights reserved.
> Provided for **evaluation only**, on a limited, revocable, and non-transferable
> basis. See [PROPRIETARY.md](../PROPRIETARY.md). **AADSec is not open source.**

**Status:** private beta — not production ready. An automated audit + triage
layer; it does **not** replace a penetration test and never claims your code is
"secure" or free of vulnerabilities.

### Platforms

- macOS (amd64, arm64) — tested
- Linux (amd64, arm64) — tested
- Windows (amd64, arm64) — **experimental**, not yet validated end-to-end
  (requires Docker Desktop with the WSL2 backend)

### Assets in this release

- `install.sh` — macOS/Linux installer (verifies SHA-256 before installing)
- `install.ps1` — Windows installer (verifies SHA-256 before installing)
- `SHA256SUMS` — checksums for every asset
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
- Not yet delivered: SARIF export, SBOM (CycloneDX), PDF export, DAST (OWASP ZAP),
  the `deep` profile.
- Windows support is experimental (see above).
- Full list: [LIMITATIONS](https://github.com/aadieng100/aadsec) in the product
  repository.

### Feedback wanted 🎯

Email **diengabdoulaziz110@gmail.com** or reach out on
**[LinkedIn](https://www.linkedin.com/in/aadieng/)** with: OS + versions
(`aadsec --version`, `aadsec doctor`), project type (no sensitive code), useful
findings vs noise, report clarity (CTO vs developer), and what you miss most.

---

*Changelog for `<version>`:*

- `<summary of what changed in this build>`
