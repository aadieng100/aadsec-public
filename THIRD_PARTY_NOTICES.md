# Third-Party Notices

AADSec orchestrates third-party open-source security tools that run inside its
Docker runner image. This file lists those tools, their licenses, and the
conditions under which AADSec uses them.

> **Note:** This file is informational. It should be reviewed by a legal
> advisor before any commercial distribution of AADSec. AADSec does not claim
> ownership of any third-party tool listed below.

---

## 1. Gitleaks

| Field       | Value |
|-------------|-------|
| **Project** | [https://github.com/gitleaks/gitleaks](https://github.com/gitleaks/gitleaks) |
| **License** | MIT |
| **License URL** | [https://github.com/gitleaks/gitleaks/blob/master/LICENSE](https://github.com/gitleaks/gitleaks/blob/master/LICENSE) |
| **Version (V1)** | 8.30.1 |
| **Usage** | External CLI binary executed inside the AADSec runner container to detect secrets in filesystem files. |
| **AADSec constraints** | `--no-git` (filesystem only, no Git history in V1), `--redact` (secrets are redacted in output), custom allowlist config written to `/tmp` at runtime. |

---

## 2. Trivy

| Field       | Value |
|-------------|-------|
| **Project** | [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy) |
| **License** | Apache-2.0 |
| **License URL** | [https://github.com/aquasecurity/trivy/blob/main/LICENSE](https://github.com/aquasecurity/trivy/blob/main/LICENSE) |
| **Version (V1)** | 0.72.0 |
| **Usage** | External CLI binary executed inside the AADSec runner container for Software Composition Analysis (SCA) — vulnerability detection in project dependencies. |
| **AADSec constraints** | `--scanners vuln` only (no secrets, no SBOM, no license scanning, no image scan in V1). Cache stored in a persistent host directory (`~/.aadsec/cache/trivy`), never in `/workspace`. Vulnerability database is downloaded from the Trivy distribution CDN during the first scan. |

---

## 3. Semgrep Community Edition (CE)

| Field       | Value |
|-------------|-------|
| **Project** | [https://github.com/semgrep/semgrep](https://github.com/semgrep/semgrep) |
| **License** | LGPL-2.1 (Semgrep CE engine — `osemgrep`) |
| **License URL** | [https://github.com/semgrep/semgrep/blob/develop/LICENSE](https://github.com/semgrep/semgrep/blob/develop/LICENSE) |
| **Version (V1)** | 1.80.0 |
| **Usage** | External CLI binary executed inside the AADSec runner container for Static Application Security Testing (SAST). |
| **AADSec constraints** | **Local rules only.** AADSec uses a custom embedded ruleset (`rules/semgrep/`) only. No Semgrep Registry, no `p/default`, no `--config auto`. `--metrics off` disables all telemetry. No Semgrep login, no Semgrep token, no Semgrep Pro, no Semgrep AppSec Platform. No code is sent to semgrep.dev. |

> ⚠️ Semgrep Pro features and Semgrep Registry rules have separate commercial
> licenses. AADSec V1 does not use them. Before enabling any Registry rules or
> Pro features, consult the Semgrep licensing terms.

---

## 4. Checkov

| Field       | Value |
|-------------|-------|
| **Project** | [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov) |
| **License** | Apache-2.0 |
| **License URL** | [https://github.com/bridgecrewio/checkov/blob/main/LICENSE](https://github.com/bridgecrewio/checkov/blob/main/LICENSE) |
| **Version (V1)** | 3.2.0 |
| **Usage** | External CLI binary executed inside the AADSec runner container for Infrastructure-as-Code (IaC) misconfiguration detection. |
| **AADSec constraints** | `--skip-download` (no external policy downloads). No `BC_API_KEY`, no `PRISMA_API_ID`, no `PRISMA_API_SECRET` (explicitly cleared). No upload to Bridgecrew / Prisma Cloud. No cloud runtime scanning (AWS/Azure/GCP). No autofix. Checkov is skipped cleanly if no IaC files are detected in the scanned project. |

---

## Release note

A future release of AADSec will include the full text of each third-party
license directly inside the runner Docker image at `/opt/aadsec/LICENSES/`.

---

*This file was last updated for AADSec V1 (alpha).*
