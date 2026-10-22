# Known Limitations / Limites Connues

This document describes known technical limitations, platform support constraints, and evaluation boundaries for AADSec v0.1.0.

Ce document décrit les limites techniques connues, les contraintes de plateformes et le cadre de la version d'évaluation d'AADSec v0.1.0.

---

## English (EN)

### 1. Operating System & Platform Support

- **macOS (Intel, macOS 15)**: tested.
- **Apple Silicon (darwin_arm64 binary)**: compiled, but execution has not been performed on macOS (G2-05).
- **Linux x86_64**: tested under WSL2 (Ubuntu 24.04) with Docker Desktop; native Linux tests in progress (CI).
- **Linux arm64 runner image**: provided; tool versions checked under emulation only; not tested natively.
- **Windows 11**: experimental; native folder scans work under the tested conditions.
  - `--image` scans on Windows are not supported (observed on Windows 11: exit code 3 "analysis incomplete", attempt 2 "scan interrupted").
  - Output directory on `/mnt/c` under WSL is not supported due to filesystem translation semantics; use paths under `/home` (W14).
  - When Docker is not installed or unreachable, the CLI message "Docker Desktop is not running" can be misleading (issue B-W05, scheduled for 0.1.1).
  - Interrupting `docker.exe` during an ongoing scan can leave an active container running (W18: terminates on its own after ~110 seconds on amd64; on emulated arm64, it may remain stuck at high CPU until terminated with `docker rm -f`).
  - The Windows executable is distributed without digital signature; a SmartScreen warning was observed during testing of alpha.1.

### 2. Evaluation Scope & Limits

- **Evaluation scan limit**: Usage is limited to 3 successful scans per machine via a local counter file (`beta-usage.json`). Dry runs and scans failing before execution do not decrement this quota.
- **Legal documentation**: The accompanying legal files (`LICENSE`, `SECURITY.md`, `THIRD_PARTY_NOTICES.md`) represent evaluation drafts, with finalized legal texts scheduled for release 0.1.1.

### 3. Scanner Findings & Vulnerability Database

- **Embedded Gitleaks binary findings**: 36 HIGH/CRITICAL findings (1 CRITICAL, 35 HIGH) detected during container runner audits stem from the upstream Gitleaks 8.30.1 binary itself (the latest upstream release available at build time). Upstream updates or remediation will follow in subsequent updates.
- **Trivy vulnerability database**: The host cache database (`~/Library/Caches/aadsec` on macOS) can be newer than the static database embedded in the runner image. The vulnerability database update date is displayed in `report.html` and recorded in `audit-metadata.json` (e.g. `2026-10-12`).

### 4. Integrity Checksums

- **SHA256SUMS scope**: The `SHA256SUMS` file covers the 12 compiled release binaries and archive files. It does not cover the CycloneDX SBOM or the installation scripts (`install.sh`, `install.ps1`).
- **Integrity checksums**: SHA-256 sums are cryptographic integrity digests for verification, not electronic signatures.

---

## Français (FR)

### 1. Systèmes d'exploitation et plateformes

- **macOS (Intel, macOS 15)** : testé.
- **Apple Silicon (binaire darwin_arm64)** : compilé, mais exécution non réalisée sous macOS (G2-05).
- **Linux x86_64** : testé sous WSL2 (Ubuntu 24.04) avec Docker Desktop ; tests Linux natifs en cours (CI).
- **Image Linux arm64** : fournie ; versions des outils contrôlées sous émulation seulement ; non testé en natif.
- **Windows 11** : expérimental ; scans natifs de dossiers opérationnels dans les conditions testées.
  - Les scans `--image` sous Windows ne sont pas pris en charge (constaté sous Windows 11 : code de sortie 3 « analysis incomplete », tentative 2 « scan interrupted »).
  - La sortie sur `/mnt/c` sous WSL n'est pas prise en charge ; utiliser un répertoire sous `/home` (W14).
  - Lorsque Docker est absent, le message « Docker Desktop is not running » est trompeur (anomalie B-W05, correction prévue en 0.1.1).
  - Interrompre `docker.exe` pendant un scan peut laisser un conteneur actif (W18 : s'arrête seul après ~110 s en amd64 ; bloqué à charge processeur élevée en arm64 émulé, nécessitant `docker rm -f`).
  - Le binaire Windows est distribué sans signature numérique ; un avertissement SmartScreen a été observé lors des tests d'alpha.1.

### 2. Cadre et limites de l'évaluation

- **Plafond d'évaluation** : L'usage est plafonné à 3 scans réussis par machine au moyen d'un compteur local (`beta-usage.json`). Les exécutions `--dry-run` et les échecs ne consomment pas ce quota.
- **Documents juridiques** : Les fichiers `LICENSE`, `SECURITY.md` et `THIRD_PARTY_NOTICES.md` constituent des versions d'évaluation, avec version finale prévue en 0.1.1.

### 3. Constats des scanners et base de vulnérabilités

- **Constats liés au binaire amont Gitleaks** : 36 constats HIGH/CRITICAL (1 CRITICAL, 35 HIGH) identifiés dans le conteneur runner proviennent du binaire amont Gitleaks 8.30.1 embarqué (dernière version amont disponible à la compilation). Le traitement interviendra après le lancement.
- **Base de vulnérabilités Trivy** : La base du cache hôte peut être plus récente que celle embarquée dans l'image. La date de mise à jour de la base est affichée dans `report.html` et enregistrée dans `audit-metadata.json` (ex. `2026-10-12`).

### 4. Empreintes cryptographiques

- **Périmètre de SHA256SUMS** : Le fichier `SHA256SUMS` couvre les 12 binaires et archives de distribution. Il ne couvre ni le SBOM CycloneDX, ni les scripts d'installation (`install.sh`, `install.ps1`).
- **Nature des sommes** : Les sommes SHA-256 constituent des empreintes d'intégrité cryptographique et non des signatures électroniques.
