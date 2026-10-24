# Beta guide

Thanks for trying AADSec in V1 (beta). This guide gets you from install to your
first report in ~15 minutes, and shows how to send useful feedback.

AADSec is a **local-first DevSecOps audit**: it orchestrates recognized
open-source scanners, prioritizes the results, and produces a readable report.
**Your code never leaves your machine.**

---

## What V1 (beta) does (and doesn't)

| Domain | Tool | In V1 (beta) |
|---|---|---|
| Secrets | Gitleaks | ✅ |
| Dependencies (SCA) | Trivy (filesystem) | ✅ |
| SAST | Semgrep (local ruleset) | ✅ |
| IaC (terraform, kubernetes, dockerfile, cloudformation) | Checkov | ✅ |
| Container image | Trivy (`--image`) | ✅ |

- **Outputs:** `findings.json` (normalized, prioritized P0–P3) + `report.html`
  (executive + developer views, self-contained).
- **Profiles delivered:** `quick` (fast feedback) and `standard` (recommended).
  A `deep` profile is a **future idea**, not shipped.
- **Roadmap (not yet delivered):** SARIF export, SBOM export from a scan (a
  CycloneDX SBOM of the runner image is provided in the release), PDF export,
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

- **Docker**, running (the scanners run inside a container). If Docker is not started, `aadsec doctor` and `aadsec scan` will detect it and provide the exact command to start it on your OS.
- **git**.
- **Platforms:** macOS (Intel, macOS 15): tested with 0.1.1. Apple Silicon (darwin_arm64): install and aadsec --version verified on a macOS arm64 runner (CI run 40054317431); scan not tested on Apple Silicon. Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1; `--image` and output on /mnt/c under WSL are not supported.

---

## Download & install

The current build is `v0.1.1` on the [**Releases**](https://github.com/aadieng100/aadsec-public/releases) page.
The installer downloads the matching binary and **verifies its checksum** before
installing — nothing is installed if the checksum fails.

```bash
# macOS/Linux — download the installer and checksums, read install.sh, then run it:
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.1.1/install.sh
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.1.1/SHA256SUMS
bash install.sh
aadsec --version

# Fetch the runner image once (AADSec never pulls it for you):
docker pull ghcr.io/aadieng100/aadsec-runner:0.1.1

# Verify everything is aligned:
aadsec doctor        # should show "Runner status: ✅ present … (matches CLI)"
```

> On Windows, download `install.ps1` from the same Releases page instead
> (experimental — see below).

Then scan your repo and open the report:

```bash
cd /path/to/your/repo
aadsec scan .
open security-output/report.html      # macOS — on Linux: xdg-open
```

Output is English by default; add `--lang fr` for French.

> Beta access is provided on a **limited, revocable, and non-transferable** basis
> — AADSec is proprietary software (see [PROPRIETARY.md](../PROPRIETARY.md)).

---

## Beta usage limit

The beta is capped at **3 successful scans per machine** so we can gather
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

## Uninstall completely

To remove AADSec and **all** its local state:

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip the confirmation
```

It deletes only AADSec-owned paths — the installed binary, the config directory
(including the beta counter), the scanner cache, and the `~/.aadsec` fallback.
Per-project `security-output/` folders and the Docker runner image are left
untouched — remove those yourself (`docker rmi ghcr.io/aadieng100/aadsec-runner:<version>`).

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
