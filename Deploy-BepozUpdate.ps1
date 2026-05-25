<#
    Deploy-BepozUpdate.ps1
    Downloads the latest Bepoz Update.zip from GitHub Releases,
    wipes C:\Bepoz\New Version, and extracts the zip into it.

    Run from an elevated PowerShell prompt:
        powershell -ExecutionPolicy Bypass -File .\Deploy-BepozUpdate.ps1

    Or one-liner from any machine (after you've published the release):
        iwr -UseB https://raw.githubusercontent.com/<owner>/<repo>/main/Deploy-BepozUpdate.ps1 | iex
#>

# ---- Config -----------------------------------------------------------------
$GitHubOwner = 'StephenShawBepoz'
$GitHubRepo  = '4823-repack'
$AssetName   = 'Update.zip'
$TargetDir   = 'C:\Bepoz\New Version'
# -----------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadsDir = Join-Path $env:USERPROFILE 'Downloads'
$ZipPath      = Join-Path $DownloadsDir $AssetName
$ReleaseUrl   = "https://github.com/$GitHubOwner/$GitHubRepo/releases/latest/download/$AssetName"

Write-Host "Downloading $AssetName from $ReleaseUrl"
Invoke-WebRequest -Uri $ReleaseUrl -OutFile $ZipPath -UseBasicParsing
Write-Host "Saved to $ZipPath"

if (Test-Path $TargetDir) {
    Write-Host "Clearing existing contents of $TargetDir"
    Get-ChildItem -LiteralPath $TargetDir -Force | Remove-Item -Recurse -Force
} else {
    Write-Host "Creating $TargetDir"
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

Write-Host "Extracting to $TargetDir"
Expand-Archive -LiteralPath $ZipPath -DestinationPath $TargetDir -Force

Write-Host "Done. Bepoz new version deployed to $TargetDir"
