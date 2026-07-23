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
container images (Trivy). DAST, SARIF, SBOM, and PDF export are on the roadmap,
not delivered.

**Why is there a scan limit?**
The alpha caps successful scans per machine so we can collect feedback before
opening wider access. It's a local guardrail, not a license — see the
[beta guide](BETA.md).

**Can I get help fixing the findings?**
Yes. You can **voluntarily** share the results (never your code) with AADSec for
remediation help — see [How sharing works](SHARING.md).

**Which platforms are supported?**
macOS and Linux are tested. Windows (Docker Desktop + WSL2 backend) is
experimental and not yet validated end-to-end.

**What does "AADSec" stand for?**
Publicly: **Actionable Audit for DevSecOps**. The name also carries the initials
of its creator, Abdoul Aziz Dieng.
