# FAQ

Short answers to the questions we hear most.

---

**Does AADSec upload my code?**
No. The scan runs locally (or in your CI). Your source is mounted **read-only**
into an ephemeral container, and only the results are written to your disk.
Nothing is uploaded.

**Do you send my code to an AI / LLM?**
Not without your explicit consent. The local scanner (`aadsec`) never calls any AI/LLM API and has zero network imports. In `aadsec-agent` (CLI or `AADSec Local`), **Gitleaks secrets (`0 credit — local`) stay 100% offline** with zero network calls. For `Fix with AADSec` (`1 credit`), only a locally redacted `+/- 120`-line window plus import header (`lines 1..60`, `<= 20 KiB` under the `32 KiB` gateway bound) is sent after your explicit consent to `api.aadsec.xyz` (Internet connection required): AADSec evaluates its **online verified recipes first** and falls back transparently to AI models when needed (zero code retention on the gateway), before verifying the resulting patch locally inside offline Docker (`--network none`).

**Is this a scanner you built?**
No — AADSec is an **orchestrator**. It runs recognized open-source tools
(Gitleaks, Trivy, Opengrep, gosec, Bandit, Checkov), normalizes and deduplicates their output,
prioritizes real risks (P0–P3), and produces one readable report with concrete
fixes.

**Does a clean report mean my app is secure?**
No. A clean run means "nothing the configured scanners flagged" — it does **not**
prove the absence of vulnerabilities. AADSec never claims "secure", "safe", or "zero vulnerabilities".

**Does this replace a penetration test?**
No. It's an automated detection + triage layer that **complements** a human
security assessment. Many vulnerability classes (business logic, complex auth,
race conditions) are outside the scope of any automated tool.

**How is this different from just running the tools myself?**
The value is in the layer on top: normalization, deduplication across tools,
P0–P3 prioritization, business-impact framing, concrete fixes, and an optional
remediation follow-up.

**What does it actually scan today?**
Secrets (Gitleaks), dependencies/SCA (Trivy), SAST (Opengrep, gosec, Bandit), IaC (Checkov), and
container images (Trivy). DAST, SARIF export, SBOM export from a scan, and PDF
export are on the roadmap, not delivered.

**How do evaluation and licensing work?**
The local scanner CLI (`aadsec scan .`) and `AADSec Local` (`aadsec-agent app`) scan/export features are free and unlimited — no account, no license key, and no payment card required. Run a scan on your repository before purchasing to check engine and stack coverage; if a language or framework is missing or you need license support, email `support@aadsec.xyz` (general inquiries: `contact@aadsec.xyz`). For automated, container-verified remediation (`aadsec-agent`), non-expiring prepaid credit packs — **Starter (`$15`, `5` credits)**, **Developer (`$29`, `12` credits)**, and **Agency (`$49`, `30` credits on one shareable team key across multiple workstations)** — plus key-preserving top-ups (`+5` for `$9`, `+10` for `$16`, `+25` for `$35`) are available at [https://aadsec.xyz](https://aadsec.xyz) and activated locally via `aadsec-agent activate` or inside `aadsec-agent app` — see the [Quickstart guide](GUIDE.md). Only a verified fix accepted and applied deducts `1` credit (`0` credit on scan, export, failure, or `discard`).

**Can I run scans in an air-gapped or offline environment?**
Yes. You can scan projects with zero Internet connection using `aadsec scan --offline .`.
The runner container embeds a pre-packaged vulnerability database and local rulesets,
so no external network requests or database downloads are required.
During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report correspond to the database dated `2026-11-25` and may differ with a more recent database.

**Can I get help fixing the findings?**
Yes. You can **voluntarily** share the results (never your code) with AADSec for
remediation help — see [How sharing works](SHARING.md).

**Which platforms are supported?**
macOS (Intel, macOS 15): CLI and tests verified in 0.2.0 (full scan tested with 0.1.1). Apple Silicon (darwin_arm64, M1): CLI, native `linux/arm64` runner image, and offline demo scans tested on macOS 15 (M1) in 0.2.0 (CI install and `aadsec --version` also verified on a macOS arm64 runner, CI run 40054317431). Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1 or 0.2.0; `--image` and output on /mnt/c under WSL are not supported.

**What does "AADSec" stand for?**
Publicly: **Actionable Audit for DevSecOps**. The name also carries the initials
of its creator, Abdoul Aziz Dieng.
