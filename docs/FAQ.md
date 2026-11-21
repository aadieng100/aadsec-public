# FAQ

Short answers to the questions we hear most.

---

**Does AADSec upload my code?**
No. The scan runs locally (or in your CI). Your source is mounted **read-only**
into an ephemeral container, and only the results are written to your disk.
Nothing is uploaded.

**Do you send my code to an AI / LLM?**
Not without your explicit consent. The local scanner (`aadsec`) never calls any AI/LLM API. With the companion agent (`aadsec-agent`), secrets and dependency upgrades are handled locally without AI; for IaC remediation (Terraform, Dockerfile, Kubernetes, and CloudFormation), only a locally redacted `+/- 15`-line snippet is sent after your explicit consent, with strict non-retention on the gateway.

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
The local scanner CLI (`aadsec scan`) is free and unlimited — no account, no license key, and no payment card required. For automated, container-verified remediation (`aadsec-agent`), Standard subscriptions (`$49/month` or `$490/year`) are available at [https://aadsec.xyz](https://aadsec.xyz) and activated locally via `aadsec-agent activate` — see the [Quickstart guide](GUIDE.md).

**Can I run scans in an air-gapped or offline environment?**
Yes. You can scan projects with zero Internet connection using `aadsec scan --offline .`.
The runner container embeds a pre-packaged vulnerability database and local rulesets,
so no external network requests or database downloads are required.
During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report correspond to the database dated `2026-11-07` and may differ with a more recent database.

**Can I get help fixing the findings?**
Yes. You can **voluntarily** share the results (never your code) with AADSec for
remediation help — see [How sharing works](SHARING.md).

**Which platforms are supported?**
macOS (Intel, macOS 15): CLI and tests verified in 0.2.0 (full scan tested with 0.1.1). Apple Silicon (darwin_arm64, M1): CLI, native `linux/arm64` runner image, and offline demo scans tested on macOS 15 (M1) in 0.2.0 (CI install and `aadsec --version` also verified on a macOS arm64 runner, CI run 40054317431). Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1 or 0.2.0; `--image` and output on /mnt/c under WSL are not supported.

**What does "AADSec" stand for?**
Publicly: **Actionable Audit for DevSecOps**. The name also carries the initials
of its creator, Abdoul Aziz Dieng.
