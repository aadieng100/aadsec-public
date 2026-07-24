# Positioning & content kit

This page is the source of truth for how AADSec is described publicly. It doubles
as a content kit for a future landing page — the section blocks below map onto a
one-page marketing site.

---

## Brand meaning

**AADSec — Actionable Audit for DevSecOps** (*Sec* = Security).

The name also carries the initials of its creator, **Abdoul Aziz Dieng**. The
public expansion emphasizes the product's differentiator: results are
**actionable** (prioritized, with concrete fixes), delivered as a productized
**audit**, across the **DevSecOps** surface.

---

## One-line positioning

> Local-first DevSecOps audit CLI for any project — SaaS, side projects, internal apps, or teams. Runs trusted scanners (secrets, dependencies, SAST, IaC, containers) in one command, cuts through noisy logs and false positives, and delivers a prioritized report with concrete fixes — without sending your source code to the cloud.

---

## Message discipline

**Sell this:**

- "Your code can stay in your environment."
- "I orchestrate recognized, open-source tools."
- "I prioritize real risks and filter the noise."
- "You get concrete fixes and a retest."
- "Goal: ship to production with less risk."

**Never say this:**

- "My scanner finds every vulnerability."
- "Upload your repo to my app."
- "Fully automatic penetration test."
- "Secure / safe / zero vulnerabilities / no risk."
- "AI that analyzes all your code."

---

## Target market

| Audience | Pain | Message |
|---|---|---|
| Startups about to launch an app/API | Fear of shipping obvious vulnerabilities. | "Security audit before launch." |
| SMBs with no security team | No time or in-house AppSec skills. | "A simple, actionable, affordable DevSecOps layer." |
| Web agencies / dev shops | Need to reassure their own clients before delivery. | "Add a security option to your deliverables." |
| AWS / GitHub / Terraform teams | Over-permissive IAM, secrets, images, pipelines. | "AppSec + Cloud/IaC review aligned to your stack." |
| Founders building with AI | Code shipped fast, lightly reviewed. | "Security check before commercialization." |

---

## Offer structure

Productized packs, not hourly billing. Pricing is **indicative and adapted per
client, country, and scope** — quoted on request.

| Pack | What it covers | Purpose |
|---|---|---|
| **Snapshot** | Short diagnostic, limited scan, quick call. | Lead magnet — not the real product. |
| **Starter Repo** | 1 repo: secrets, SCA, SAST + short report + readout. | Easy first pack to sell. |
| **Launch Security Audit** | 1 app/API: secrets, SCA, SAST, IaC, container + report + retest. | Main pack before going live. |
| **AWS + AppSec Review** | App + Terraform/AWS/IAM/CI-CD + executive report + remediation plan. | Premium pack. |
| **Continuous DevSecOps** | Recurring scan, triage, recurring report, light support. | Recurring revenue after an initial audit. |

> Honest scope: an automated audit is not a full manual penetration test, and
> AADSec never promises "zero vulnerabilities".

---

## Landing page blocks

Drop-in copy for a one-page site.

**Hero**
DevSecOps audit before you ship — code, dependencies, secrets, cloud/IaC and
container images. Local-first. *CTA: Book a 20-minute diagnostic.*

**Problem**
Teams ship fast, but basic vulnerabilities reach production — exposed secrets,
vulnerable dependencies, over-permissive IaC.

**Solution**
Automated scan + human triage + concrete fixes + retest. Recognized tools,
orchestrated and prioritized into one report you can act on.

**Trust**
Your code stays with you. Local/CI scan. No repo upload by default. No code sent
to an LLM without consent. Bundle only the results if you want help.

**Proof**
A downloadable [example report](../examples/report-demo.html) on a deliberately
vulnerable demo project.

**Offers**
Starter Repo · Launch Security Audit · AWS + AppSec Review.

**CTA**
Book a free 20-minute diagnostic.

---

## Content ideas to publish

- A 2–3 min video: vulnerable repo → scan → report → fixes.
- A public example report on a deliberately vulnerable app.
- "5 security mistakes I see before a production launch on AWS."
- "Why I don't ask for your repo to run an automated audit."
- An anonymized mini case study after the first audit.
