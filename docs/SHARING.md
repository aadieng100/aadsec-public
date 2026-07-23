# How sharing works

AADSec's whole model is **local-first**: your source code stays in your
environment. Sharing exists only so you can get **remediation help** — and it is
built to never compromise that trust.

---

## The three rules

1. **Opt-in and explicit.** Nothing is ever shared automatically. You run a
   command, on purpose, when you decide to.
2. **Manual — nothing is uploaded.** AADSec prepares a local folder. *You* send
   it, through a channel you trust. AADSec never pulls your files.
3. **Results only — never your code.** The bundle contains findings and the
   report. It never contains your source code or the raw scanner outputs.

---

## What a share bundle contains

```bash
aadsec share          # bundles ./security-output into ./aadsec-share
```

| Included (safe to share) | Purpose |
|---|---|
| `findings.json` | Normalized, deduplicated, prioritized findings (P0–P3). |
| `report.html` | The human-readable report. |
| `audit-metadata.json` | Scan metadata (profile, tool versions, timestamps). |
| `SHARE_README.txt` | A note describing exactly what's inside. |

**Never included:**

- ❌ your source code
- ❌ the `raw/` scanner outputs (which may contain file paths / code context)
- ❌ secrets, environment files, or any other repository content

---

## What happens next

1. You review the bundle folder yourself.
2. You send it to your AADSec contact through a channel you trust
   (email, a shared drive, etc.).
3. AADSec helps you **prioritize and fix** — and, if useful, retests the
   critical/high findings after your changes.

---

## What AADSec will never ask for

- ❌ "Upload your repository."
- ❌ Automatic, silent transfer of anything.
- ❌ Access to your code to run the audit (the scan is local — it doesn't need
  your code to leave your machine).

If a workflow ever contradicts these, it isn't AADSec's sharing model.
