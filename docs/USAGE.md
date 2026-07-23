# Usage guide

A short, practical guide to running AADSec. For install and the beta program,
see the [beta guide](BETA.md).

---

## The three commands you need

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
aadsec scan --profile quick .     # fast, lighter pass
aadsec scan --profile standard .  # recommended (default)
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

## Profiles

| Profile | When to use |
|---|---|
| `quick` | Fast feedback during development. |
| `standard` | Recommended — the default before a release. |

A `deep` profile is a **future idea**, not shipped yet. Don't rely on it.

---

## What you get

Every scan writes to `security-output/` (override with `--out`):

```
security-output/
  report.html          human-readable report (executive + developer views)
  findings.json        normalized, deduplicated, prioritized findings (P0–P3)
  audit-metadata.json  scan metadata (profile, tool versions, timestamps)
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
| `--profile` | `quick` \| `standard` (`standard`) | Scan intensity. |
| `--lang` | `en` \| `fr` (`en`) | Report and terminal language. |
| `--out` | path (`security-output`) | Output directory. |
| `--image` | image ref | Scan a **local** Docker image. |
| `--image-tar` | path | Scan a `docker save` archive. |
| `--dry-run` | — | Print the plan; launch no scanner. |

---

## After the scan

Two paths:

1. **Fix internally** — use the report's developer view (file, evidence, fix).
2. **Get help from AADSec** — voluntarily share the results (never your code).
   See [How sharing works](SHARING.md).
