Write-Host "🚀 Starting Ballerina Backend..." -ForegroundColor Green
Write-Host "================================"
Write-Host ""
Write-Host "Backend will be available at: http://localhost:8080" -ForegroundColor Yellow
Write-Host "API endpoints: http://localhost:8080/api/users" -ForegroundColor Yellow
Write-Host ""

# Resolve path relative to this script so it works from any current directory
$backendPath = Join-Path $PSScriptRoot 'crud-app'
if (-not (Test-Path $backendPath)) {
	Write-Host "Could not find path: $backendPath" -ForegroundColor Red
	Write-Host "Ensure the repository structure matches and you're running this script from the repo." -ForegroundColor Yellow
	exit 1
}

Set-Location $backendPath
& bal run
