# Usage guide

A short, practical guide to running AADSec. For installation and setup,
see the [Quickstart guide](GUIDE.md).

---

## Desktop App (`AADSec Local`) & CLI Quickstart

Launch the local graphical interface (`AADSec Local` on `127.0.0.1`) or run the three core CLI commands:

```bash
aadsec-agent app                       # open AADSec Local (scan, export, inspect diffs, apply/discard)
aadsec-agent app --install-desktop     # install/refresh OS Desktop icon & launcher (done automatically by install.sh)
```

```bash
aadsec doctor        # check Docker, Git, and the scanner runner image
aadsec scan .        # scan the current directory
aadsec share         # (optional) prepare an opt-in bundle to send to AADSec
```

Open the report when the scan finishes:

```bash
open security-output/report.html      # macOS — on Linux: xdg-open
```

---

## Scanning

```bash
aadsec scan .                     # current directory
aadsec scan ./myrepo              # a specific directory
aadsec scan . --lang fr           # French report and terminal output
```

### Scanning a container image

Build the image yourself first — AADSec never builds or pulls your target image:

```bash
docker build -t myapp:audit .
aadsec scan --image myapp:audit --out security-output-image
```

Or scan a pre-exported archive (no running daemon needed at scan time):

```bash
docker save myapp:audit -o myapp.tar
aadsec scan --image-tar ./myapp.tar --out security-output-image
```

---

## What you get

Every scan writes to `security-output/` (override with `--out`):

```
security-output/
  report.html          human-readable report (executive + developer views)
  findings.json        normalized, deduplicated, prioritized findings (P0–P3)
  audit-metadata.json  scan metadata (runner version, scanner coverage, timestamps)
  raw/                 raw scanner outputs (kept local; never shared by AADSec)
```

### Priorities

| Priority | Meaning |
|---|---|
| **P0** | Critical, immediate risk (e.g. an exposed secret). |
| **P1** | High — fix before or shortly after release. |
| **P2** | Medium — plan it in. |
| **P3** | Hardening / improvement. |

Work findings top-down (P0 → P3), then re-scan to confirm your fixes.

---

## Useful flags

| Flag | Values (default) | Purpose |
|---|---|---|
| `--lang` | `en` \| `fr` (`en`) | Report and terminal language. |
| `--out` | path (`security-output`) | Output directory. |
| `--offline` | — | Air-gapped scan (no DB updates or network calls). |
| `--history` | — | Scan accessible local Git commit history for secrets. |
| `--timeout` | duration (`15m`) | Global scan timeout (default `15m`). |
| `--image` | image ref | Scan a **local** Docker image. |
| `--image-tar` | path | Scan a `docker save` archive. |
| `--dry-run` | — | Print the plan; launch no scanner. |

---

## Verified Remediation with aadsec-agent

The companion agent (`aadsec-agent`) reads `security-output/findings.json` and `security-output/audit-metadata.json` read-only and writes all remediation artifacts under `./aadsec-ai-output/`.

### Activation

Activate your license key interactively without terminal echo, via stdin pipe, or via environment variable in CI/CD (no disk write when using `AADSEC_LICENSE_KEY`):

```bash
aadsec-agent activate
# Or from a pipe:
printf '%s\n' "$KEY" | aadsec-agent activate --stdin
# Or in CI/CD (takes priority over stored credentials):
export AADSEC_LICENSE_KEY="aadsec_live_..."
```

### Local diagnostic (offline, 0 network calls)

```bash
aadsec-agent doctor --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
```

### Verified remediation loop & atomic apply / discard / undo

`aadsec-agent` supports all 6 scanner engines (`checkov` including `github_actions`, `opengrep`, `gosec`, `bandit`, `trivy`, and `gitleaks`, with `--runner-image` defaulting to `ghcr.io/aadieng100/aadsec-runner:0.2.0`). **Offline (`0 credit`)**: local scans and Gitleaks secrets (`0 credit — local`) run 100% offline without network calls. **Online via `api.aadsec.xyz` (`1 credit` on verified `Apply`)**: `Fix with AADSec` consults AADSec's online verified recipes on `api.aadsec.xyz` first and falls back transparently to AI models when needed (Internet connection required, zero code retention), before verifying the patch locally inside offline Docker (`--network none`). Run `aadsec scan .` (or use `aadsec-agent app`) for free beforehand to inspect coverage on your stack; if a technology is missing or you need license support, write to `support@aadsec.xyz` (general inquiries: `contact@aadsec.xyz`).

Specify `--finding-rule <RULE_ID>` or `--finding-id <ID>` (required). On the default gateway, `--consent` supports `step` (default) or `scoped` (`metadata` is reserved for `--provider custom`). Pass `--defer-result-report` to defer credit reporting until you explicitly run `apply` (`1 credit`) or `discard` (`0 credit`):

```bash
aadsec-agent --findings security-output/findings.json \
  --finding-rule CKV_AWS_20 \
  --consent step \
  --defer-result-report \
  --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
```

Apply a verified patch atomically to your workspace (`1 credit`, with an out-of-tree backup), discard a proposed patch (`0 credit`), or revert an applied patch with `undo`:

```bash
aadsec-agent apply --out ./aadsec-ai-output --source .
aadsec-agent discard --out ./aadsec-ai-output
aadsec-agent undo --out ./aadsec-ai-output --source .
```

### Secret rotation & verification

Generate a local offline rotation plan (`--all-secrets`, `--finding-id <id>`, or `--rule-id <rule_id>`) and verify post-rotation state via isolated Gitleaks double scan (`--consent auto|step|scope`):

```bash
aadsec-agent plan-rotation --findings security-output/findings.json --all-secrets
aadsec-agent rotation-verify --findings security-output/findings.json --source . --all-secrets \
  --consent auto --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
```

### Dependency upgrade verification

Verify dependency upgrades via isolated Trivy double scan (`--all-vulns`, `--finding-id <id>`, or `--rule-id <cve_or_ghsa_id>`, `--consent auto|step|scope`):

```bash
aadsec-agent dependency-verify --findings security-output/findings.json --source . --all-vulns \
  --consent auto --runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0
```

### Shell autocompletion

Both binaries generate completion scripts natively:

```bash
aadsec completion <bash|zsh|fish|powershell>
aadsec-agent completion <bash|zsh|fish|powershell>
```

---

## After the scan

Three paths:

1. **Fix manually** — use the report's developer view (file, evidence, fix).
2. **Run verified remediation (`aadsec-agent`)** — patch and verify in an isolated `--network none` container before applying.
3. **Get human help from AADSec** — voluntarily share the results (never your code).
   See [How sharing works](SHARING.md).

---

## Uninstall

To remove AADSec and all its local state (`aadsec`, the companion `aadsec-agent` binary, config directory, `aadsec` and `aadsec-agent` caches, and `~/.aadsec` including `~/.aadsec/completions/`):

```bash
aadsec uninstall          # lists what will be deleted, then asks to confirm
aadsec uninstall --yes    # skip the confirmation
```

The `# >>> aadsec initialize >>>` block in shell configuration files remains harmless and can be removed manually if desired. Per-project scan outputs (`security-output/`) and the Docker runner image are left untouched.
