$ErrorActionPreference = "Stop"

$scriptPath = (Get-Item -Path $MyInvocation.MyCommand.Path).Directory.FullName
$homeDir = Join-Path $scriptPath "home"
$profileDir = Join-Path $scriptPath "winprofile"

# Test if a command exists
function Has {
    param([string]$Command)
    try {
        $null = Get-Command -Name $Command -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Chocolatey
# https://chocolatey.org/install
if (-not (Has "choco")) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install git
if (-not (Has "git")) {
    Write-Host "Install git..."
    choco install -y git.install
}

# Install vim
if (-not (Has "vim")) {
    Write-Host "Install vim..."
    choco install -y vim
}

# Copy .gitconfig
Copy-Item -Path (Join-Path $profileDir ".gitconfig") -Destination (Join-Path $HOME ".gitconfig") -Force -Confirm

# Copy .commit_template
Copy-Item -Path (Join-Path $homeDir ".commit_template") -Destination (Join-Path $HOME ".commit_template") -Force -Confirm

Write-Host "Dotfiles installed successfully!" -ForegroundColor Green
