$ErrorActionPreference = "Stop"

$scriptPath = (Get-Item -Path $MyInvocation.MyCommand.Path).Directory.FullName
$homeDir = Join-Path $scriptPath "home"
$profileDir = Join-Path $scriptPath "winprofile"

# Check for Python
if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    Write-Warning @"
Python is not available in your terminal.

To install Python, please visit the Microsoft Store or download it from:

    https://www.python.org/downloads/windows/

After installation, restart your terminal and run this script again.
"@
    exit 1
}

try {
    $pythonVersionOutput = & python --version 2>&1
    if ($pythonVersionOutput -eq "Python") {
        throw "Python is a placeholder. Manual installation required."
    }
    Write-Host "Python is installed: $pythonVersionOutput"
} catch {
    Write-Warning @"
Python is not currently available in your terminal.

On Windows 10/11, Python may be bundled but not installed yet.
Please run the following command once in PowerShell to trigger the installation via Microsoft Store:

    python

After installation completes, restart your terminal.

"@
    exit 1
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
$vimInstalled = winget list --source winget | Select-String -Pattern '^Vim\s'
if (-not $vimInstalled) {
    Write-Host "Installing Vim..."
    winget install --id "vim.vim" -i --accept-source-agreements --accept-package-agreements
}
# Check if vim is available in PATH
if (-not (Get-Command "vim" -ErrorAction SilentlyContinue)) {
    Write-Warning @"
Vim appears to be installed but is not available in your PATH.
You may need to restart your terminal or manually add Vim's install directory to your PATH.
Common install path:
    C:\Program Files\Vim\vim91
"@

    # Try to find vim.exe under Program Files
    $vimPath = Get-ChildItem -Path "C:\Program Files" -Recurse -Filter "vim.exe" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like "*\Vim\vim*\vim.exe" } |
        Select-Object -First 1 -ExpandProperty FullName

    if ($vimPath) {
        Write-Host "`nFound Vim at: $($vimPath)"
        $confirm = Read-Host "Do you want to add a Set-Alias to '$PROFILE'? (Y/N)"
        if ($confirm -match '^(Y|y)$') {
            # Ensure profile exists
            if (-not (Test-Path -Path $PROFILE)) {
                New-Item -ItemType File -Path $PROFILE -Force | Out-Null
            }
            # Add Set-Alias to PowerShell profile
            if (-not (Select-String -Path $PROFILE -Pattern 'Set-Alias vim' -Quiet)) {
                Add-Content -Path $PROFILE -Value "`nSet-Alias vim ""$vimPath"""
                Write-Host "Alias added to $PROFILE"
            } else {
                Write-Host "Alias already exists in $PROFILE"
            }
        } else {
            Write-Host "Alias not added."
        }
    }
}

# Copy .gitconfig
Copy-Item -Path (Join-Path $profileDir ".gitconfig") -Destination (Join-Path $HOME ".gitconfig") -Force -Confirm

# Copy .commit_template
Copy-Item -Path (Join-Path $homeDir ".commit_template") -Destination (Join-Path $HOME ".commit_template") -Force -Confirm

Write-Host "Dotfiles installed successfully!" -ForegroundColor Green
