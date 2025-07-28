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

# Install python
if (-not (Has "python")) {
    Write-Host "Install python..."
    choco install -y python
}

# Install uv
# https://github.com/astral-sh/uv?tab=readme-ov-file#installation
if (-not (Has "uv")) {
    Write-Host "Installing uv..."
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    # Shell autocompletion
    if (!(Test-Path -Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force
    }
    Add-Content -Path $PROFILE -Value '(& uv generate-shell-completion powershell) | Out-String | Invoke-Expression'
    Add-Content -Path $PROFILE -Value '(& uvx --generate-shell-completion powershell) | Out-String | Invoke-Expression'
}

# Install git
if (-not (Has "git")) {
    Write-Host "Install git..."
    choco install -y git.install
}

# Install posh-git
if (-not (Get-Module -ListAvailable -Name posh-git)) {
    Write-Host "Installing posh-git..."
    PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

    # Ensure posh-git is imported in profile
    if (!(Test-Path -Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force
    }
    if (-not (Select-String -Path $PROFILE -Pattern 'Import-Module posh-git' -Quiet)) {
        Add-Content -Path $PROFILE -Value 'Import-Module posh-git'
    }
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
