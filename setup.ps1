$ErrorActionPreference = "Stop"

$scriptPath = (Get-Item -Path $MyInvocation.MyCommand.Path).Directory.FullName
$homeDir = Join-Path $scriptPath "home"
$profileDir = Join-Path $scriptPath "winprofile"

# Install python
if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Python..."
    winget install --id "Python.Python.3.13" -i --accept-source-agreements --accept-package-agreements
}

# Install uv
# https://github.com/astral-sh/uv?tab=readme-ov-file#installation
if (-not (Get-Command "uv" -ErrorAction SilentlyContinue)) {
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
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..."
    winget install --id "Git.Git" -i --accept-source-agreements --accept-package-agreements
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
if (-not (Get-Command "vim" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Vim..."
    winget install --id "vim.vim" -i --accept-source-agreements --accept-package-agreements
}

# Copy .gitconfig
Copy-Item -Path (Join-Path $profileDir ".gitconfig") -Destination (Join-Path $HOME ".gitconfig") -Force -Confirm

# Copy .commit_template
Copy-Item -Path (Join-Path $homeDir ".commit_template") -Destination (Join-Path $HOME ".commit_template") -Force -Confirm

Write-Host "Dotfiles installed successfully!" -ForegroundColor Green
