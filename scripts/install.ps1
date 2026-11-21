<#
.SYNOPSIS
  Install AADSec and aadsec-agent on Windows (PowerShell).

.DESCRIPTION
  Detects your architecture, downloads SHA256SUMS first, downloads and checks
  the SHA-256 checksums of aadsec_<ver>_windows_<arch>.exe and
  aadsec-agent_<ver>_windows_<arch>.exe BEFORE writing to the install folder,
  installs atomically, generates PowerShell completion scripts, updates the User
  Path environment variable idempotently, and optionally checks/pulls the
  Docker runner image.

  One-liner usage:
    irm https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.ps1 | iex

  Configurable via $env:AADSEC_VERSION, $env:AADSEC_BASE_URL,
  $env:AADSEC_INSTALL_DIR, $env:AADSEC_SKIP_AGENT, $env:AADSEC_REQUIRE_AGENT,
  $env:AADSEC_NO_MODIFY_PATH, $env:AADSEC_NO_COMPLETION,
  $env:AADSEC_SKIP_IMAGE_PULL, and $env:AADSEC_RUNNER_IMAGE.

  Or download, inspect, and run locally:
    Invoke-WebRequest -UseBasicParsing `
      -Uri https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.ps1 `
      -OutFile install.ps1
    powershell -ExecutionPolicy Bypass -File .\install.ps1

.PARAMETER Version
  Version to install. Default: env AADSEC_VERSION, else 0.2.0.

.PARAMETER BaseUrl
  Base URL (or local path / file:// URI for testing) hosting the assets.

.PARAMETER InstallDir
  Install directory. Default: env AADSEC_INSTALL_DIR, else %LOCALAPPDATA%\aadsec.
#>
[CmdletBinding()]
param(
    [string]$Version     = $env:AADSEC_VERSION,
    [string]$BaseUrl     = $env:AADSEC_BASE_URL,
    [string]$InstallDir  = $env:AADSEC_INSTALL_DIR,
    [switch]$SkipAgent,
    [switch]$RequireAgent,
    [switch]$NoModifyPath,
    [switch]$NoCompletion,
    [switch]$SkipImagePull,
    [string]$RunnerImage = $env:AADSEC_RUNNER_IMAGE
)

$ErrorActionPreference = 'Stop'

# Enable TLS 1.2 for Windows PowerShell 5.1
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch {}

$DefaultVersion = '0.2.0'
if ([string]::IsNullOrWhiteSpace($Version))    { $Version = $DefaultVersion }
if ($Version -notmatch '^[0-9A-Za-z][0-9A-Za-z._-]*$' -or $Version.Contains('..')) {
    throw "Invalid version '$Version'."
}

if ([string]::IsNullOrWhiteSpace($BaseUrl))    { $BaseUrl = "https://github.com/aadieng100/aadsec-public/releases/download/v$Version" }
$BaseUrl = $BaseUrl.TrimEnd('/')

if ([string]::IsNullOrWhiteSpace($InstallDir)) { $InstallDir = Join-Path $env:LOCALAPPDATA 'aadsec' }

if (-not $PSBoundParameters.ContainsKey('SkipAgent') -and $env:AADSEC_SKIP_AGENT -eq '1')         { $SkipAgent = $true }
if (-not $PSBoundParameters.ContainsKey('RequireAgent') -and $env:AADSEC_REQUIRE_AGENT -eq '1')   { $RequireAgent = $true }
if (-not $PSBoundParameters.ContainsKey('NoModifyPath') -and $env:AADSEC_NO_MODIFY_PATH -eq '1')  { $NoModifyPath = $true }
if (-not $PSBoundParameters.ContainsKey('NoCompletion') -and $env:AADSEC_NO_COMPLETION -eq '1')  { $NoCompletion = $true }
if (-not $PSBoundParameters.ContainsKey('SkipImagePull') -and $env:AADSEC_SKIP_IMAGE_PULL -eq '1'){ $SkipImagePull = $true }

if ([string]::IsNullOrWhiteSpace($RunnerImage)) { $RunnerImage = "ghcr.io/aadieng100/aadsec-runner:$Version" }
if ($RunnerImage.StartsWith('-') -or $RunnerImage -notmatch '^[0-9A-Za-z._:/@-]+$') {
    throw "Invalid runner image '$RunnerImage'."
}

# Detect native architecture (check WOW64 override first)
$archRaw = $env:PROCESSOR_ARCHITEW6432
if ([string]::IsNullOrWhiteSpace($archRaw)) {
    $archRaw = $env:PROCESSOR_ARCHITECTURE
}
switch ($archRaw) {
    'AMD64' { $arch = 'amd64' }
    'ARM64' { $arch = 'arm64' }
    default { throw "Unsupported architecture '$archRaw'." }
}

$assetCli   = "aadsec_${Version}_windows_${arch}.exe"
$assetAgent = "aadsec-agent_${Version}_windows_${arch}.exe"
Write-Host "-> Installing AADSec $Version for windows/$arch"

function Get-Asset {
    param([string]$Name, [string]$Dest)
    if ($BaseUrl -match '^https?://') {
        $uri = "$BaseUrl/$Name"
        Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $Dest
    } else {
        $localBase = $BaseUrl -replace '^file:/{2,3}', ''
        $src = Join-Path $localBase $Name
        if (-not (Test-Path -LiteralPath $src -PathType Leaf)) {
            throw "Local source not found: $src"
        }
        Copy-Item -LiteralPath $src -Destination $Dest -Force
    }
}

function Get-ExpectedChecksum {
    param(
        [string]$SumsPath,
        [string]$AssetName
    )
    $count = 0
    $foundHash = $null
    foreach ($line in Get-Content -LiteralPath $SumsPath) {
        if ([string]::IsNullOrEmpty($line)) { continue }
        $mentionsAsset = $false
        $fields = $line.Trim() -split '\s+'
        if ($fields.Count -ge 2) {
            $second = $fields[1]
            if ($second -ceq $AssetName -or $second -ceq "*$AssetName" -or $second.EndsWith("/$AssetName", [StringComparison]::Ordinal)) {
                $mentionsAsset = $true
            }
        }
        if ($mentionsAsset) {
            if ($line -notmatch '^([0-9a-fA-F]{64})  ([^ *\r\n]+)$') {
                throw "Malformed checksum line for $AssetName in SHA256SUMS - refusing to install."
            }
            $lineHash = $Matches[1]
            $lineName = $Matches[2]
            if ($lineName -ceq $AssetName) {
                $count++
                $foundHash = $lineHash.ToLowerInvariant()
            } else {
                throw "Malformed checksum entry for $AssetName in SHA256SUMS - refusing to install."
            }
        }
    }
    if ($count -gt 1) {
        throw "Duplicate checksum entries for $AssetName in SHA256SUMS - refusing to install."
    }
    return $foundHash
}

function Install-BinaryAtomic {
    param(
        [string]$SourcePath,
        [string]$TargetDir,
        [string]$TargetName
    )
    $targetDirItem = Get-Item -LiteralPath $TargetDir -Force -ErrorAction SilentlyContinue
    if ($null -ne $targetDirItem -and (($targetDirItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)) {
        throw "Target directory '$TargetDir' is a reparse point - refusing to install."
    }
    $dest = Join-Path $TargetDir $TargetName
    if (Test-Path -LiteralPath $dest) {
        if (Test-Path -LiteralPath $dest -PathType Container) {
            throw "Target path '$dest' is a directory - refusing to overwrite."
        }
        if (((Get-Item -LiteralPath $dest -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "Target path '$dest' is a reparse point - refusing to overwrite."
        }
    }
    $stageName = ".aadsec.tmp." + [System.Guid]::NewGuid().ToString('N') + ".exe"
    $stagePath = Join-Path $TargetDir $stageName
    try {
        Copy-Item -LiteralPath $SourcePath -Destination $stagePath -Force
        Move-Item -LiteralPath $stagePath -Destination $dest -Force
    } finally {
        if (Test-Path -LiteralPath $stagePath) {
            Remove-Item -LiteralPath $stagePath -Force -ErrorAction SilentlyContinue
        }
    }
    return $dest
}

function Write-CompletionAtomic {
    param(
        [string]$BinaryPath,
        [string]$CompDir,
        [string]$FileName
    )
    $compDirItem = Get-Item -LiteralPath $CompDir -Force -ErrorAction SilentlyContinue
    if ($null -ne $compDirItem -and (($compDirItem.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)) {
        Write-Warning "Refusing to write completions into reparse point '$CompDir'."
        return
    }
    $dest = Join-Path $CompDir $FileName
    if (Test-Path -LiteralPath $dest) {
        if (Test-Path -LiteralPath $dest -PathType Container) {
            Write-Warning "Refusing to overwrite directory '$dest' for shell completion."
            return
        }
        if (((Get-Item -LiteralPath $dest -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            Write-Warning "Refusing to overwrite reparse point '$dest' for shell completion."
            return
        }
    }
    $savedEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $rawOut = & $BinaryPath completion powershell 2>$null
        $compExit = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $savedEap
    }
    if ($compExit -ne 0) {
        return
    }
    $text = ($rawOut | Out-String)
    if ([string]::IsNullOrWhiteSpace($text)) {
        return
    }
    $stage = Join-Path $CompDir (".comp.tmp." + [System.Guid]::NewGuid().ToString('N') + ".ps1")
    try {
        Set-Content -LiteralPath $stage -Value $text -Encoding UTF8
        Move-Item -LiteralPath $stage -Destination $dest -Force
    } finally {
        if (Test-Path -LiteralPath $stage) {
            Remove-Item -LiteralPath $stage -Force -ErrorAction SilentlyContinue
        }
    }
}

$tmp = Join-Path $env:TEMP ("aadsec-install-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
try {
    Write-Host "-> Downloading SHA256SUMS..."
    $sumsPath = Join-Path $tmp 'SHA256SUMS'
    Get-Asset -Name 'SHA256SUMS' -Dest $sumsPath
    $sumsBytes = [System.IO.File]::ReadAllBytes($sumsPath)
    if ($sumsBytes.Length -eq 0) {
        throw "SHA256SUMS is empty - refusing to install."
    }
    if ($sumsBytes -contains [byte]13) {
        throw "SHA256SUMS contains CR characters - refusing to install."
    }

    $expectedCli = Get-ExpectedChecksum -SumsPath $sumsPath -AssetName $assetCli
    if ([string]::IsNullOrWhiteSpace($expectedCli)) {
        throw "No checksum entry for $assetCli in SHA256SUMS - refusing to install."
    }

    Write-Host "-> Downloading and checking $assetCli..."
    $cliTmpPath = Join-Path $tmp $assetCli
    Get-Asset -Name $assetCli -Dest $cliTmpPath
    $actualCli = (Get-FileHash -Algorithm SHA256 -LiteralPath $cliTmpPath).Hash
    if ($actualCli -notmatch '^[0-9a-fA-F]{64}$' -or $actualCli.ToLowerInvariant() -cne $expectedCli) {
        throw "Checksum mismatch for ${assetCli}!`n  expected: $expectedCli`n  actual:   $actualCli`nRefusing to install."
    }
    Write-Host "OK  Checksum verified for $assetCli (SHA256: $($actualCli.ToLowerInvariant()))"

    $installAgent = $false
    $agentTmpPath = Join-Path $tmp $assetAgent
    if (-not $SkipAgent) {
        $expectedAgent = Get-ExpectedChecksum -SumsPath $sumsPath -AssetName $assetAgent
        if (-not [string]::IsNullOrWhiteSpace($expectedAgent)) {
            Write-Host "-> Downloading and checking $assetAgent..."
            Get-Asset -Name $assetAgent -Dest $agentTmpPath
            $actualAgent = (Get-FileHash -Algorithm SHA256 -LiteralPath $agentTmpPath).Hash
            if ($actualAgent -notmatch '^[0-9a-fA-F]{64}$' -or $actualAgent.ToLowerInvariant() -cne $expectedAgent) {
                throw "Checksum mismatch for ${assetAgent}!`n  expected: $expectedAgent`n  actual:   $actualAgent`nRefusing to install."
            }
            Write-Host "OK  Checksum verified for $assetAgent (SHA256: $($actualAgent.ToLowerInvariant()))"
            $installAgent = $true
        } else {
            if ($RequireAgent) {
                throw "No checksum entry for $assetAgent in SHA256SUMS - refusing to install."
            }
            Write-Warning "$assetAgent not listed in SHA256SUMS; installing aadsec CLI only."
        }
    }

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    $destCli = Install-BinaryAtomic -SourcePath $cliTmpPath -TargetDir $InstallDir -TargetName 'aadsec.exe'
    Write-Host "OK  Installed aadsec to $destCli"

    $destAgent = $null
    if ($installAgent) {
        $destAgent = Install-BinaryAtomic -SourcePath $agentTmpPath -TargetDir $InstallDir -TargetName 'aadsec-agent.exe'
        Write-Host "OK  Installed aadsec-agent to $destAgent"
    }

    if (-not $NoCompletion) {
        $compDir = Join-Path $InstallDir 'completions'
        New-Item -ItemType Directory -Path $compDir -Force | Out-Null
        Write-CompletionAtomic -BinaryPath $destCli -CompDir $compDir -FileName 'aadsec.ps1'
        if ($installAgent -and $null -ne $destAgent) {
            Write-CompletionAtomic -BinaryPath $destAgent -CompDir $compDir -FileName 'aadsec-agent.ps1'
        }
    }

    if (-not $NoModifyPath) {
        $hasControl = $false
        foreach ($ch in $InstallDir.ToCharArray()) {
            if ([char]::IsControl($ch)) { $hasControl = $true; break }
        }
        if ($InstallDir.Contains(';') -or $InstallDir.Contains('"') -or $hasControl) {
            Write-Warning "Install directory '$InstallDir' contains unsupported characters; skipping User Path modification."
        } else {
            $normTarget = $InstallDir.TrimEnd('\')
            $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
            $existing = @()
            if (-not [string]::IsNullOrWhiteSpace($userPath)) {
                $existing = @($userPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
            }
            $alreadyPresent = $false
            foreach ($entry in $existing) {
                if ([string]::Equals($entry.TrimEnd('\'), $normTarget, [StringComparison]::OrdinalIgnoreCase)) {
                    $alreadyPresent = $true
                    break
                }
            }
            if (-not $alreadyPresent) {
                $newEntries = @($InstallDir) + $existing
                $newUserPath = ($newEntries -join ';')
                [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User')
            }
            $sessionEntries = @($env:PATH -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
            $onSession = $false
            foreach ($entry in $sessionEntries) {
                if ([string]::Equals($entry.TrimEnd('\'), $normTarget, [StringComparison]::OrdinalIgnoreCase)) {
                    $onSession = $true
                    break
                }
            }
            if (-not $onSession) {
                $env:PATH = "$InstallDir;$env:PATH"
            }
        }
    }

    if (-not $SkipImagePull) {
        $dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
        if ($null -eq $dockerCmd) {
            Write-Host "Note: Docker is not installed. Install Docker Desktop before running 'aadsec scan', then pull $RunnerImage."
        } else {
            $savedEap = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try {
                & docker info *> $null
                $infoExit = $LASTEXITCODE
                if ($infoExit -ne 0) {
                    Write-Host "Note: Docker daemon is not running or not accessible. Start Docker, then run: docker pull $RunnerImage"
                } else {
                    & docker image inspect $RunnerImage *> $null
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "OK  Runner image $RunnerImage is already available locally"
                    } else {
                        Write-Host "-> Pulling runner image $RunnerImage..."
                        & docker pull $RunnerImage
                        if ($LASTEXITCODE -eq 0) {
                            Write-Host "OK  Pulled runner image $RunnerImage"
                        } else {
                            Write-Warning "Could not pull $RunnerImage (offline or registry unreachable). Pull it later with: docker pull $RunnerImage"
                        }
                    }
                }
            } finally {
                $ErrorActionPreference = $savedEap
            }
        }
    }

    Write-Host ""
    Write-Host "Done. Verify with: aadsec --version (expected: $Version)"
} finally {
    if (Test-Path -LiteralPath $tmp) {
        Remove-Item -Recurse -Force -LiteralPath $tmp
    }
}
