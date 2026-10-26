# FAQ

Short answers to the questions we hear most.

---

**Does AADSec upload my code?**
No. The scan runs locally (or in your CI). Your source is mounted **read-only**
into an ephemeral container, and only the results are written to your disk.
Nothing is uploaded.

**Do you send my code to an AI / LLM?**
Not without your explicit consent. AADSec does not call any AI/LLM API on your
scanned project.

**Is this a scanner you built?**
No — AADSec is an **orchestrator**. It runs recognized open-source tools
(Gitleaks, Trivy, Semgrep, Checkov), normalizes and deduplicates their output,
prioritizes real risks (P0–P3), and produces one readable report with concrete
fixes.

**Does a clean report mean my app is secure?**
No. A clean run means "nothing the configured scanners flagged" — it is **not** a
guarantee. AADSec never claims "secure", "safe", or "zero vulnerabilities".

**Does this replace a penetration test?**
No. It's an automated detection + triage layer that **complements** a human
security assessment. Many vulnerability classes (business logic, complex auth,
race conditions) are outside the scope of any automated tool.

**How is this different from just running the tools myself?**
The value is in the layer on top: normalization, deduplication across tools,
P0–P3 prioritization, business-impact framing, concrete fixes, and an optional
remediation follow-up.

**What does it actually scan today?**
Secrets (Gitleaks), dependencies/SCA (Trivy), SAST (Semgrep), IaC (Checkov), and
container images (Trivy). DAST, SARIF export, SBOM export from a scan, and PDF
export are on the roadmap, not delivered (a CycloneDX SBOM of the runner image
is provided in the release).

**Why is there a scan limit?**
The evaluation version caps successful scans per machine so we can collect
feedback before opening wider access. It's a local guardrail, not a license — see
the [beta guide](BETA.md).

**Can I run scans in an air-gapped or offline environment?**
Yes. You can scan projects with zero Internet connection using `aadsec scan --offline .`.
The runner container embeds a pre-packaged vulnerability database and local rulesets,
so no external network requests or database downloads are required.
During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report correspond to the database dated 20 October 2026 and may differ with a more recent database.

**Can I get help fixing the findings?**
Yes. You can **voluntarily** share the results (never your code) with AADSec for
remediation help — see [How sharing works](SHARING.md).

**Which platforms are supported?**
macOS (Intel, macOS 15): tested with 0.1.1. Apple Silicon (darwin_arm64): install and aadsec --version verified on a macOS arm64 runner (CI run 40054317431); scan not tested on Apple Silicon. Linux x86_64: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929). Linux arm64: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929). Windows 11: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1; `--image` and output on /mnt/c under WSL are not supported.

**What does "AADSec" stand for?**
Publicly: **Actionable Audit for DevSecOps**. The name also carries the initials
of its creator, Abdoul Aziz Dieng.
