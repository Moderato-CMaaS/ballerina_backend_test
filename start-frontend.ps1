Write-Host "🌐 Starting React Frontend..." -ForegroundColor Green
Write-Host "============================="
Write-Host ""
Write-Host "Frontend will be available at: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Make sure the backend is running on port 8080" -ForegroundColor Yellow
Write-Host ""

# Resolve path relative to this script so it works from any current directory
$frontendPath = Join-Path $PSScriptRoot 'crud-app\react-frontend'
if (-not (Test-Path $frontendPath)) {
	Write-Host "Could not find path: $frontendPath" -ForegroundColor Red
	Write-Host "Ensure the repository structure matches and you're running this script from the repo." -ForegroundColor Yellow
	exit 1
}

Set-Location $frontendPath

# Ensure package.json exists
if (-not (Test-Path 'package.json')) {
	Write-Host "package.json not found in $frontendPath" -ForegroundColor Red
	exit 1
}

# Install dependencies if missing
if (-not (Test-Path 'node_modules')) {
	Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
	if (Test-Path 'package-lock.json') {
		& npm ci
	} else {
		& npm install
	}
	if ($LASTEXITCODE -ne 0) {
		Write-Host "npm install failed. Check your network and Node.js installation." -ForegroundColor Red
		exit $LASTEXITCODE
	}
}

# Verify the dev script exists
try {
	$pkg = Get-Content package.json -Raw | ConvertFrom-Json
	$hasDev = $pkg.scripts -and $pkg.scripts.dev
} catch {
	$hasDev = $false
}

if (-not $hasDev) {
	Write-Host "No \"dev\" script found in package.json. Available scripts:" -ForegroundColor Yellow
	& npm run
	exit 1
}

& npm run dev
