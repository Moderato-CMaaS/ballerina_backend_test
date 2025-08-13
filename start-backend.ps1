Write-Host "🚀 Starting Ballerina Backend..." -ForegroundColor Green
Write-Host "================================"
Write-Host ""
Write-Host "Backend will be available at: http://localhost:8080" -ForegroundColor Yellow
Write-Host "API endpoints: http://localhost:8080/api/users" -ForegroundColor Yellow
Write-Host ""

Set-Location crud-app
& bal run
