$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dotDir = Join-Path $scriptDir 'winprofile'

Get-ChildItem -LiteralPath $dotDir -Force | ForEach-Object {
    if (-not $_.PSIsContainer) {
        $src = $_.FullName
        $dest = Join-Path $HOME $_.Name
        Write-Host "git diff --no-index $src $dest" -ForegroundColor Cyan
        if (Test-Path $dest) {
            git diff --no-index $src $dest
        } else {
            Write-Host "Target '$dest' does not exist." -ForegroundColor Yellow
        }
    }
}