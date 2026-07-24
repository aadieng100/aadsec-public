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

## Download & install

The current build is `v0.1.0-alpha.1` on the [**Releases**](../../releases) page.
The installer downloads the matching binary and **verifies its checksum** before
installing — nothing is installed if the checksum fails.

```bash
# macOS/Linux — download the installer (read it first is recommended), then run it:
curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.1.0-alpha.1/install.sh
bash install.sh
aadsec --version

# Fetch the runner image once (AADSec never pulls it for you):
docker pull ghcr.io/aadieng100/aadsec-runner:0.1.0-alpha.1

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
