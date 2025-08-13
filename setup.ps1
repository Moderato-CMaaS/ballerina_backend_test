# Ballerina CRUD App Setup Script for Windows PowerShell
# Run this script in PowerShell to automate the setup process

param(
    [switch]$SkipDependencyCheck,
    [switch]$Help
)

# Color functions for better output
function Write-Success { 
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green 
}

function Write-Info { 
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue 
}

function Write-Warning { 
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow 
}

function Write-Error { 
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red 
}

function Show-Help {
    Write-Host @"
🚀 Ballerina CRUD App Setup Script
==================================

Usage: .\setup.ps1 [OPTIONS]

Options:
  -SkipDependencyCheck    Skip checking for Ballerina and Node.js
  -Help                   Show this help message

Examples:
  .\setup.ps1                        # Full setup with dependency checks
  .\setup.ps1 -SkipDependencyCheck   # Skip dependency verification

This script will:
1. Check for required dependencies (Ballerina, Node.js)
2. Set up database configuration
3. Build the Ballerina backend
4. Install React frontend dependencies
5. Create start scripts for easy development

Make sure you have:
- Ballerina 2201.12.7 or later
- Node.js 16 or later
- A Supabase account with a project created
"@
}

function Test-Command {
    param([string]$Command)
    try {
        & $Command --version 2>$null | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Test-Ballerina {
    Write-Info "Checking Ballerina installation..."
    
    if (Test-Command "bal") {
        $version = & bal version 2>$null | Select-Object -First 1
        Write-Success "Ballerina is installed: $version"
        return $true
    }
    else {
        Write-Error "Ballerina is not installed!"
        Write-Host ""
        Write-Host "Please install Ballerina:"
        Write-Host "  1. Go to https://ballerina.io/downloads/"
        Write-Host "  2. Download the Windows MSI installer"
        Write-Host "  3. Run the installer and follow the setup wizard"
        Write-Host "  4. Restart PowerShell and run this script again"
        Write-Host ""
        return $false
    }
}

function Test-NodeJS {
    Write-Info "Checking Node.js installation..."
    
    if ((Test-Command "node") -and (Test-Command "npm")) {
        $nodeVersion = & node --version 2>$null
        $npmVersion = & npm --version 2>$null
        Write-Success "Node.js is installed: $nodeVersion"
        Write-Success "npm is installed: v$npmVersion"
        return $true
    }
    else {
        Write-Error "Node.js or npm is not installed!"
        Write-Host ""
        Write-Host "Please install Node.js:"
        Write-Host "  1. Go to https://nodejs.org/"
        Write-Host "  2. Download the Windows Installer (.msi)"
        Write-Host "  3. Run the installer (npm is included)"
        Write-Host "  4. Restart PowerShell and run this script again"
        Write-Host ""
        return $false
    }
}

function Set-DatabaseConfig {
    Write-Info "Setting up database configuration..."
    
    if (Test-Path "crud-app\Config.toml") {
        Write-Warning "Config.toml already exists. Skipping database setup."
        return $true
    }
    
    Write-Host ""
    Write-Host "🗄️  Database Configuration" -ForegroundColor Cyan
    Write-Host "=========================="
    Write-Host ""
    Write-Host "You need to provide your Supabase database credentials."
    Write-Host "You can find these in your Supabase project settings under 'Database'."
    Write-Host ""
    
    $dbHost = Read-Host "Enter your Supabase Host (db.xxxxxxxxxxxxx.supabase.co)"
    $dbName = Read-Host "Enter your Database Name (usually 'postgres')"
    $dbUsername = Read-Host "Enter your Database Username (usually 'postgres')"
    $dbPassword = Read-Host "Enter your Database Password" -AsSecureString
    $dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))
    $dbPort = Read-Host "Enter your Database Port (usually 5432)"
    
    # Create Config.toml
    $configContent = @"
# Database Configuration for Supabase
DB_HOST = "$dbHost"
DB_NAME = "$dbName"
DB_USERNAME = "$dbUsername"
DB_PASSWORD = "$dbPasswordPlain"
DB_PORT = $dbPort
"@
    
    try {
        $configContent | Out-File -FilePath "crud-app\Config.toml" -Encoding UTF8
        Write-Success "Database configuration saved to crud-app\Config.toml"
        Write-Warning "Remember to run the SQL script in your Supabase SQL editor!"
        Write-Host "  File: crud-app\database_setup.sql"
        return $true
    }
    catch {
        Write-Error "Failed to create Config.toml: $_"
        return $false
    }
}

function Build-Backend {
    Write-Info "Setting up Ballerina backend..."
    
    try {
        Push-Location "crud-app"
        
        Write-Info "Building Ballerina project..."
        $buildResult = & bal build 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Ballerina project built successfully"
            return $true
        }
        else {
            Write-Error "Failed to build Ballerina project"
            Write-Host $buildResult
            return $false
        }
    }
    catch {
        Write-Error "Error building backend: $_"
        return $false
    }
    finally {
        Pop-Location
    }
}

function Install-Frontend {
    Write-Info "Setting up React frontend..."
    
    try {
        Push-Location "crud-app\react-frontend"
        
        Write-Info "Installing npm dependencies..."
        $installResult = & npm install 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Frontend dependencies installed successfully"
            return $true
        }
        else {
            Write-Error "Failed to install frontend dependencies"
            Write-Host $installResult
            return $false
        }
    }
    catch {
        Write-Error "Error setting up frontend: $_"
        return $false
    }
    finally {
        Pop-Location
    }
}

function New-StartScripts {
    Write-Info "Creating start scripts..."
    
    # Backend start script
    $backendScript = @'
@echo off
echo 🚀 Starting Ballerina Backend...
cd crud-app
bal run
pause
'@
    
    # Frontend start script
    $frontendScript = @'
@echo off
echo 🌐 Starting React Frontend...
cd crud-app\react-frontend
npm run dev
pause
'@
    
    # PowerShell scripts
    $backendPS = @'
Write-Host "🚀 Starting Ballerina Backend..." -ForegroundColor Green
Set-Location crud-app
& bal run
'@
    
    $frontendPS = @'
Write-Host "🌐 Starting React Frontend..." -ForegroundColor Green
Set-Location crud-app\react-frontend
& npm run dev
'@
    
    try {
        $backendScript | Out-File -FilePath "start-backend.bat" -Encoding ASCII
        $frontendScript | Out-File -FilePath "start-frontend.bat" -Encoding ASCII
        $backendPS | Out-File -FilePath "start-backend.ps1" -Encoding UTF8
        $frontendPS | Out-File -FilePath "start-frontend.ps1" -Encoding UTF8
        
        Write-Success "Start scripts created:"
        Write-Info "  .\start-backend.bat or .\start-backend.ps1"
        Write-Info "  .\start-frontend.bat or .\start-frontend.ps1"
        return $true
    }
    catch {
        Write-Error "Failed to create start scripts: $_"
        return $false
    }
}

function Show-NextSteps {
    Write-Success "Setup completed successfully! 🎉"
    Write-Host ""
    Write-Host "📋 Next Steps:" -ForegroundColor Cyan
    Write-Host "=============="
    Write-Host ""
    Write-Host "1. 🗄️  Setup your Supabase database:"
    Write-Host "   - Go to your Supabase project"
    Write-Host "   - Open SQL Editor"
    Write-Host "   - Run the script from: crud-app\database_setup.sql"
    Write-Host ""
    Write-Host "2. 🚀 Start the application:"
    Write-Host "   Backend:  .\start-backend.bat (or .\start-backend.ps1)"
    Write-Host "   Frontend: .\start-frontend.bat (or .\start-frontend.ps1)"
    Write-Host ""
    Write-Host "3. 🌐 Open your browser:"
    Write-Host "   - Frontend: http://localhost:3000"
    Write-Host "   - Backend API: http://localhost:8080/api/users"
    Write-Host ""
    Write-Host "💡 Pro tip: Open two PowerShell windows to run backend and frontend simultaneously"
    Write-Host ""
    Write-Host "🎊 Happy coding!"
}

# Main execution
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Write-Host @"
🚀 Ballerina CRUD App Setup Script
==================================
"@ -ForegroundColor Cyan
    Write-Host ""
    
    # Check if we're in the right directory
    if (-not (Test-Path "crud-app\main.bal")) {
        Write-Error "This script must be run from the project root directory"
        Write-Host "Make sure you're in the directory containing the 'crud-app' folder"
        return
    }
    
    # Check dependencies unless skipped
    if (-not $SkipDependencyCheck) {
        Write-Info "Checking prerequisites..."
        
        if (-not (Test-Ballerina)) {
            return
        }
        
        if (-not (Test-NodeJS)) {
            return
        }
        
        Write-Host ""
    }
    
    # Setup database configuration
    if (-not (Set-DatabaseConfig)) {
        return
    }
    Write-Host ""
    
    # Build backend
    if (-not (Build-Backend)) {
        return
    }
    Write-Host ""
    
    # Install frontend dependencies
    if (-not (Install-Frontend)) {
        return
    }
    Write-Host ""
    
    # Create start scripts
    if (-not (New-StartScripts)) {
        return
    }
    Write-Host ""
    
    # Show next steps
    Show-NextSteps
}

# Run the main function
Main
