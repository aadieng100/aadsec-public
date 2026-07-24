#!/usr/bin/env bash
#
# install.sh — install the AADSec CLI on macOS/Linux.
#
# It detects your OS/architecture, downloads the matching binary AND the
# SHA256SUMS file, VERIFIES the checksum before installing, then installs into
# a user-local directory (no sudo). If the checksum does not match, nothing is
# installed.
#
# This script is NOT meant to be run blindly via `curl | bash`. Download it,
# read it, optionally verify its own checksum, then run it:
#
#   curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v<ver>/install.sh
#   bash install.sh
#
# Configuration (env vars, all optional):
#   AADSEC_VERSION       version to install            (default: pinned below)
#   AADSEC_BASE_URL      base URL for the assets        (default: GitHub release)
#   AADSEC_INSTALL_DIR   install directory              (default: ~/.local/bin)
#
# The AADSec CLI never uploads your code and never pulls Docker images by
# itself. The container runner image is obtained separately (see the beta
# guide): docker pull ghcr.io/aadieng100/aadsec-runner:<version>.
set -eu

# ── Pinned default version (bump per release) ────────────────────────────────
DEFAULT_VERSION="0.1.0-alpha.1"

VERSION="${AADSEC_VERSION:-${1:-$DEFAULT_VERSION}}"
BASE_URL="${AADSEC_BASE_URL:-https://github.com/aadieng100/aadsec-public/releases/download/v${VERSION}}"
INSTALL_DIR="${AADSEC_INSTALL_DIR:-${HOME}/.local/bin}"

info()  { printf '%s\n' "$*"; }
warn()  { printf 'WARNING: %s\n' "$*" >&2; }
die()   { printf 'error: %s\n' "$*" >&2; exit 1; }

# ── Detect OS ────────────────────────────────────────────────────────────────
os_raw="$(uname -s)"
case "${os_raw}" in
	Darwin) os="darwin" ;;
	Linux)  os="linux" ;;
	*) die "unsupported OS '${os_raw}'. On Windows, use scripts/install.ps1 (PowerShell)." ;;
esac

# ── Detect architecture ──────────────────────────────────────────────────────
arch_raw="$(uname -m)"
case "${arch_raw}" in
	x86_64|amd64)   arch="amd64" ;;
	arm64|aarch64)  arch="arm64" ;;
	*) die "unsupported architecture '${arch_raw}'." ;;
esac

ASSET="aadsec_${VERSION}_${os}_${arch}"
info "→ Installing AADSec ${VERSION} for ${os}/${arch}"

# ── Downloader (curl or wget; supports file:// for local testing) ────────────
download() { # download <url> <dest>
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL "$1" -o "$2"
	elif command -v wget >/dev/null 2>&1; then
		wget -q "$1" -O "$2"
	else
		die "need 'curl' or 'wget' to download; please install one."
	fi
}

# ── Checksum tool ────────────────────────────────────────────────────────────
sha256_of() { # sha256_of <file> -> hash on stdout
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print $1}'
	elif command -v shasum >/dev/null 2>&1; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		die "need 'sha256sum' or 'shasum' to verify integrity."
	fi
}

# ── Work in a temp dir, always cleaned up ────────────────────────────────────
tmp="$(mktemp -d "${TMPDIR:-/tmp}/aadsec-install.XXXXXX")"
trap 'rm -rf "${tmp}"' EXIT

info "→ Downloading ${ASSET} and SHA256SUMS…"
download "${BASE_URL}/${ASSET}"     "${tmp}/${ASSET}"     || die "failed to download ${BASE_URL}/${ASSET}"
download "${BASE_URL}/SHA256SUMS"   "${tmp}/SHA256SUMS"   || die "failed to download ${BASE_URL}/SHA256SUMS"

# ── Verify checksum BEFORE installing ────────────────────────────────────────
expected="$(awk -v f="${ASSET}" '$2==f {print $1}' "${tmp}/SHA256SUMS" | head -n1)"
[ -n "${expected}" ] || die "no checksum entry for ${ASSET} in SHA256SUMS — refusing to install."

actual="$(sha256_of "${tmp}/${ASSET}")"

# Lower-case both for a case-insensitive compare.
expected_lc="$(printf '%s' "${expected}" | tr 'A-F' 'a-f')"
actual_lc="$(printf '%s' "${actual}" | tr 'A-F' 'a-f')"
if [ "${expected_lc}" != "${actual_lc}" ]; then
	die "checksum mismatch for ${ASSET}!
  expected: ${expected}
  actual:   ${actual}
Refusing to install a file that failed integrity verification."
fi
info "✓ Checksum verified (SHA256: ${actual})"

# ── Install (user-local, no sudo) ────────────────────────────────────────────
mkdir -p "${INSTALL_DIR}" || die "cannot create install dir ${INSTALL_DIR}"
dest="${INSTALL_DIR}/aadsec"
cp "${tmp}/${ASSET}" "${dest}"
chmod 755 "${dest}"
info "✓ Installed aadsec to ${dest}"

# ── PATH guidance (do not modify PATH automatically) ─────────────────────────
case ":${PATH}:" in
	*":${INSTALL_DIR}:"*) : ;;
	*)
		warn "${INSTALL_DIR} is not on your PATH."
		info "  Add it to your shell profile, e.g.:"
		info "    echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.profile && . ~/.profile"
		;;
esac

info ""
info "Done. Verify with:  aadsec --version   (expected: ${VERSION})"
info "Next: pull the runner image, then scan your repo — see docs/BETA.md."
