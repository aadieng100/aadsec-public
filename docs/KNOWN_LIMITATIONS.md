# Known Limitations / Limites Connues

This document describes known technical limitations, platform support constraints, and evaluation boundaries for AADSec v0.2.0.

Ce document décrit les limites techniques connues, les contraintes de plateformes et le cadre de la version d'évaluation d'AADSec v0.2.0.

---

## English (EN)

### 1. Operating System & Platform Support

- **macOS (Intel, macOS 15)**: CLI and tests verified in 0.2.0; full scan tested with 0.1.1.
- **Apple Silicon (darwin_arm64, M1)**: CLI, native `linux/arm64` runner image, and offline demo scans tested on macOS 15 (M1) in 0.2.0 (CI install and `aadsec --version` also verified on a macOS arm64 runner, CI run 40054317431).
- **Linux x86_64**: tested under WSL2 (Ubuntu 24.04) with Docker Desktop and natively on GitHub Actions ubuntu-24.04 (CI runs 40054317431 and 40056271929).
- **Linux arm64**: CLI and runner image tested natively on GitHub Actions ubuntu-24.04-arm (CI runs 40054317431 and 40056271929).
- **Windows 11**: experimental; native folder scans passed in tests with 0.1.0 and were not repeated with 0.1.1 or 0.2.0; `--image` and output on /mnt/c under WSL are not supported.
  - `--image` scans on Windows are not supported (observed on Windows 11: exit code 3 "analysis incomplete", attempt 2 "scan interrupted").
  - Output directory on `/mnt/c` under WSL is not supported due to filesystem translation semantics; use paths under `/home`.
  - When Docker is not installed or unreachable, the CLI message "Docker Desktop is not running" can be misleading.
  - Interrupting `docker.exe` during an ongoing scan can leave an active container running (terminates on its own after ~110 seconds on amd64; on emulated arm64, it may remain stuck at high CPU until terminated with `docker rm -f`).
  - The Windows executable is distributed without digital signature; a SmartScreen warning was observed during testing of 0.1.0.

### 2. Evaluation Scope & Limits

- **Evaluation access**: The local scanner (`aadsec scan`) runs locally for free and without scan limits — no account, no license key, and no payment card required. Paid subscriptions apply only to the companion remediation agent (`aadsec-agent`).
- **Companion agent default runner image**: In the current `0.2.0` build, the `--runner-image` flag of `aadsec-agent` still defaults to the historical `ghcr.io/aadieng100/aadsec-runner:0.1.1` reference; when only `ghcr.io/aadieng100/aadsec-runner:0.2.0` is present locally, pass `--runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0` to `aadsec-agent` re-scan commands.
- **Legal documentation**: The `PROPRIETARY.md`, `SECURITY.md`, and `THIRD_PARTY_NOTICES.md` files bundled in 0.2.0 archives accompany the evaluation version; the terms published on https://aadsec.xyz/terms prevail.

### 3. Scanner Findings & Vulnerability Database

- **Embedded Gitleaks binary findings**: 36 HIGH/CRITICAL findings (1 CRITICAL, 35 HIGH) detected during container runner audits stem from the upstream Gitleaks 8.30.1 binary itself (the latest upstream release available at build time). Upstream updates or remediation will follow in subsequent updates.
- **Trivy vulnerability database**: the Trivy database embedded in the promoted 0.2.0 image is dated `2026-11-18`; the database used can differ from the one in the image, and its date appears in the report. During the first online scan, AADSec downloads Trivy's vulnerability database into its local cache (about 1.6 GB measured on macOS); `--offline` uses the database from the image or the cache. The number of Trivy findings depends on the database in use: the totals in the sample report (`90` deduplicated findings, including `54` Trivy) correspond to the database dated `2026-11-07` and may differ with a more recent database.

### 4. Integrity Checksums

- **SHA256SUMS scope**: The `SHA256SUMS` file covers the 24 compiled release binaries and archive files (12 for `aadsec` and 12 for `aadsec-agent`). It does not cover the installation scripts (`install.sh`, `install.ps1`).
- **Integrity checksums**: SHA-256 sums are cryptographic integrity digests for verification, not electronic signatures.

---

## Français (FR)

### 1. Systèmes d'exploitation et plateformes

- **macOS (Intel, macOS 15)** : CLI et tests vérifiés en 0.2.0 ; scan complet testé avec la 0.1.1.
- **Apple Silicon (darwin_arm64, M1)** : CLI, image runner native `linux/arm64` et scans démo hors ligne testés sur macOS 15 (M1) en 0.2.0 (installation CI et `aadsec --version` également vérifiés sur un runner macOS arm64, run CI 40054317431).
- **Linux x86_64** : testé sous WSL2 (Ubuntu 24.04) avec Docker Desktop et en natif sur GitHub Actions ubuntu-24.04 (runs CI 40054317431 et 40056271929).
- **Linux arm64** : CLI et image du runner testés en natif sur GitHub Actions ubuntu-24.04-arm (runs CI 40054317431 et 40056271929).
- **Windows 11** : expérimental ; scans de dossiers réussis lors des tests avec la 0.1.0, non répétés avec la 0.1.1 ni la 0.2.0 ; `--image` et sortie sur /mnt/c sous WSL non pris en charge.
  - Les scans `--image` sous Windows ne sont pas pris en charge (constaté sous Windows 11 : code de sortie 3 « analysis incomplete », tentative 2 « scan interrupted »).
  - La sortie sur `/mnt/c` sous WSL n'est pas prise en charge ; utiliser un répertoire sous `/home`.
  - Lorsque Docker est absent, le message « Docker Desktop is not running » est trompeur.
  - Interrompre `docker.exe` pendant un scan peut laisser un conteneur actif (s'arrête seul après ~110 s en amd64 ; bloqué à charge processeur élevée en arm64 émulé, nécessitant `docker rm -f`).
  - Le binaire Windows est distribué sans signature numérique ; un avertissement SmartScreen a été observé lors des tests de 0.1.0.

### 2. Cadre et limites de l'évaluation

- **Accès d'évaluation** : Le scanner local (`aadsec scan`) s'exécute localement gratuitement et sans limite de scans, sans compte, sans clé de licence ni carte bancaire. L'abonnement payant concerne uniquement l'agent compagnon de remédiation (`aadsec-agent`).
- **Image par défaut de l'agent compagnon** : Dans la build `0.2.0` actuelle, le drapeau `--runner-image` d'`aadsec-agent` conserve par défaut la référence historique `ghcr.io/aadieng100/aadsec-runner:0.1.1` ; lorsque seule l'image `ghcr.io/aadieng100/aadsec-runner:0.2.0` est présente localement, passez `--runner-image ghcr.io/aadieng100/aadsec-runner:0.2.0` aux commandes de re-scan d'`aadsec-agent`.
- **Documents juridiques** : Les fichiers `PROPRIETARY.md`, `SECURITY.md` et `THIRD_PARTY_NOTICES.md` embarqués dans les archives 0.2.0 accompagnent la version d'évaluation ; les conditions publiées sur https://aadsec.xyz/terms prévalent.

### 3. Constats des scanners et base de vulnérabilités

- **Constats liés au binaire amont Gitleaks** : 36 constats HIGH/CRITICAL (1 CRITICAL, 35 HIGH) identifiés dans le conteneur runner proviennent du binaire amont Gitleaks 8.30.1 embarqué (dernière version amont disponible à la compilation) et seront traités lors d'une mise à jour ultérieure de l'image.
- **Base de vulnérabilités Trivy** : la base Trivy embarquée dans l'image 0.2.0 promue date du `2026-11-18` ; la base utilisée peut différer de celle de l'image, et sa date figure dans le rapport. Lors du premier scan en ligne, AADSec télécharge la base de vulnérabilités de Trivy dans son cache local (environ 1,6 Go mesurés sur macOS) ; `--offline` utilise celle de l'image ou celle du cache. Le nombre de constats Trivy dépend de la base utilisée : les totaux de l'exemple de rapport (`90` constats dédupliqués, dont `54` Trivy) correspondent à la base du `2026-11-07` et peuvent différer avec une base plus récente.

### 4. Empreintes cryptographiques

- **Périmètre de SHA256SUMS** : Le fichier `SHA256SUMS` couvre les 24 binaires et archives de distribution (12 pour `aadsec` et 12 pour `aadsec-agent`). Il ne couvre pas les scripts d'installation (`install.sh`, `install.ps1`).
- **Nature des sommes** : Les sommes SHA-256 constituent des empreintes d'intégrité cryptographique et non des signatures électroniques.
