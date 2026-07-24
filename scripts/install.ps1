<#
.SYNOPSIS
  Install the AADSec CLI on Windows (PowerShell).

.DESCRIPTION
  Detects your architecture, downloads the matching aadsec_<ver>_windows_<arch>.exe
  AND the SHA256SUMS file, VERIFIES the SHA-256 checksum BEFORE installing, then
  installs into a user-local directory (no admin rights). If the checksum does
  not match, nothing is installed.

  Do NOT run this blindly (e.g. `irm ... | iex`). Download it, read it, then run:

      Invoke-WebRequest -UseBasicParsing `
        -Uri https://github.com/aadieng100/aadsec-public/releases/download/v<ver>/install.ps1 `
        -OutFile install.ps1
      powershell -ExecutionPolicy Bypass -File .\install.ps1

  The AADSec CLI never uploads your code and never pulls Docker images by
  itself. Obtain the container runner image separately (see docs/BETA.md):
      docker pull ghcr.io/aadieng100/aadsec-runner:<version>

.PARAMETER Version
  Version to install. Default: env AADSEC_VERSION, else the pinned default.

.PARAMETER BaseUrl
  Base URL (or local path / file:// URI for testing) hosting the assets.
  Default: env AADSEC_BASE_URL, else the GitHub release for the version.

.PARAMETER InstallDir
  Install directory. Default: env AADSEC_INSTALL_DIR, else %LOCALAPPDATA%\aadsec.
#>
[CmdletBinding()]
param(
    [string]$Version    = $env:AADSEC_VERSION,
    [string]$BaseUrl    = $env:AADSEC_BASE_URL,
    [string]$InstallDir = $env:AADSEC_INSTALL_DIR
)

$ErrorActionPreference = 'Stop'

# ── Pinned default version (bump per release) ────────────────────────────────
$DefaultVersion = '0.1.0-alpha.1'

if ([string]::IsNullOrWhiteSpace($Version))    { $Version = $DefaultVersion }
if ([string]::IsNullOrWhiteSpace($BaseUrl))    { $BaseUrl = "https://github.com/aadieng100/aadsec-public/releases/download/v$Version" }
if ([string]::IsNullOrWhiteSpace($InstallDir)) { $InstallDir = Join-Path $env:LOCALAPPDATA 'aadsec' }

# ── Detect architecture ──────────────────────────────────────────────────────
$archRaw = $env:PROCESSOR_ARCHITECTURE
switch ($archRaw) {
    'AMD64' { $arch = 'amd64' }
    'ARM64' { $arch = 'arm64' }
    default { throw "Unsupported architecture '$archRaw'." }
}

$asset = "aadsec_${Version}_windows_${arch}.exe"
Write-Host "-> Installing AADSec $Version for windows/$arch"

# ── Fetch helper: remote (http/https) or local (path / file://) ──────────────
function Get-Asset {
    param([string]$Name, [string]$Dest)
    if ($BaseUrl -match '^https?://') {
        $uri = "$BaseUrl/$Name"
        Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $Dest
    }
    else {
        $localBase = $BaseUrl -replace '^file:/{2,3}', ''
        $src = Join-Path $localBase $Name
        if (-not (Test-Path -LiteralPath $src)) { throw "Local source not found: $src" }
        Copy-Item -LiteralPath $src -Destination $Dest -Force
    }
}

# ── Work in a temp dir, always cleaned up ────────────────────────────────────
$tmp = Join-Path $env:TEMP ("aadsec-install-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
try {
    Write-Host "-> Downloading $asset and SHA256SUMS..."
    $assetPath = Join-Path $tmp $asset
    $sumsPath  = Join-Path $tmp 'SHA256SUMS'
    Get-Asset -Name $asset        -Dest $assetPath
    Get-Asset -Name 'SHA256SUMS'  -Dest $sumsPath

    # ── Verify checksum BEFORE installing ────────────────────────────────────
    $expected = $null
    foreach ($line in Get-Content -LiteralPath $sumsPath) {
        $parts = $line -split '\s+', 2
        if ($parts.Count -eq 2 -and $parts[1].Trim() -ieq $asset) {
            $expected = $parts[0].Trim()
            break
        }
    }
    if ([string]::IsNullOrWhiteSpace($expected)) {
        throw "No checksum entry for $asset in SHA256SUMS - refusing to install."
    }

    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $assetPath).Hash
    if ($actual -ine $expected) {
        throw "Checksum mismatch for ${asset}!`n  expected: $expected`n  actual:   $actual`nRefusing to install a file that failed integrity verification."
    }
    Write-Host "OK  Checksum verified (SHA256: $($actual.ToLower()))"

    # ── Install (user-local, no admin) ───────────────────────────────────────
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    $dest = Join-Path $InstallDir 'aadsec.exe'
    Copy-Item -LiteralPath $assetPath -Destination $dest -Force
    Write-Host "OK  Installed aadsec to $dest"

    # ── PATH guidance (do not modify PATH automatically) ─────────────────────
    $onPath = ($env:PATH -split ';') -contains $InstallDir
    if (-not $onPath) {
        Write-Warning "$InstallDir is not on your PATH."
        Write-Host "    Add it for your user with:"
        Write-Host "      setx PATH `"$InstallDir;`$env:PATH`""
        Write-Host "    then open a new terminal."
    }

    Write-Host ""
    Write-Host "Done. Verify with:  aadsec --version   (expected: $Version)"
    Write-Host "Next: ensure Docker Desktop (WSL2 backend) is running, pull the runner"
    Write-Host "image, then scan your repo - see docs/BETA.md."
}
finally {
    if (Test-Path -LiteralPath $tmp) { Remove-Item -Recurse -Force -LiteralPath $tmp }
}
