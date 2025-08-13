Write-Host "🌐 Starting React Frontend..." -ForegroundColor Green
Write-Host "============================="
Write-Host ""
Write-Host "Frontend will be available at: http://localhost:3000" -ForegroundColor Yellow
Write-Host "Make sure the backend is running on port 8080" -ForegroundColor Yellow
Write-Host ""

Set-Location crud-app\react-frontend
& npm run dev
