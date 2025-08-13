#!/bin/bash

# Ballerina CRUD App Setup Script
# This script automates the setup process for the Ballerina CRUD application

set -e  # Exit on any error

echo "🚀 Ballerina CRUD App Setup Script"
echo "=================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running on Windows (Git Bash/WSL)
check_os() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        print_info "Detected Windows environment"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_info "Detected Linux environment"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS environment"
    else
        OS="unknown"
        print_warning "Unknown OS: $OSTYPE"
    fi
}

# Check if Ballerina is installed
check_ballerina() {
    print_info "Checking Ballerina installation..."
    
    if command -v bal &> /dev/null; then
        BAL_VERSION=$(bal version | head -n 1)
        print_status "Ballerina is installed: $BAL_VERSION"
        return 0
    else
        print_error "Ballerina is not installed!"
        echo ""
        echo "Please install Ballerina:"
        echo "  Windows: Download from https://ballerina.io/downloads/"
        echo "  macOS:   brew install ballerina"
        echo "  Linux:   curl -sSL https://dist.ballerina.io/bvm/get-ballerina.sh | bash"
        echo ""
        return 1
    fi
}

# Check if Node.js is installed
check_nodejs() {
    print_info "Checking Node.js installation..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        print_status "Node.js is installed: $NODE_VERSION"
        print_status "npm is installed: v$NPM_VERSION"
        return 0
    else
        print_error "Node.js is not installed!"
        echo ""
        echo "Please install Node.js:"
        echo "  Download from https://nodejs.org/"
        echo "  Or use nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
        echo ""
        return 1
    fi
}

# Setup database configuration
setup_database_config() {
    print_info "Setting up database configuration..."
    
    if [ -f "crud-app/Config.toml" ]; then
        print_warning "Config.toml already exists. Skipping database setup."
        return 0
    fi
    
    echo ""
    echo "🗄️  Database Configuration"
    echo "=========================="
    echo ""
    echo "You need to provide your Supabase database credentials."
    echo "You can find these in your Supabase project settings under 'Database'."
    echo ""
    
    read -p "Enter your Supabase Host (db.xxxxxxxxxxxxx.supabase.co): " DB_HOST
    read -p "Enter your Database Name (usually 'postgres'): " DB_NAME
    read -p "Enter your Database Username (usually 'postgres'): " DB_USERNAME
    read -s -p "Enter your Database Password: " DB_PASSWORD
    echo ""
    read -p "Enter your Database Port (usually 5432): " DB_PORT
    
    # Create Config.toml
    cat > crud-app/Config.toml << EOF
# Database Configuration for Supabase
DB_HOST = "$DB_HOST"
DB_NAME = "$DB_NAME"
DB_USERNAME = "$DB_USERNAME"
DB_PASSWORD = "$DB_PASSWORD"
DB_PORT = $DB_PORT
EOF
    
    print_status "Database configuration saved to crud-app/Config.toml"
    print_warning "Remember to run the SQL script in your Supabase SQL editor!"
    echo "  File: crud-app/database_setup.sql"
}

# Setup backend dependencies
setup_backend() {
    print_info "Setting up Ballerina backend..."
    
    cd crud-app || exit 1
    
    print_info "Building Ballerina project..."
    if bal build; then
        print_status "Ballerina project built successfully"
    else
        print_error "Failed to build Ballerina project"
        return 1
    fi
    
    cd ..
    return 0
}

# Setup frontend dependencies
setup_frontend() {
    print_info "Setting up React frontend..."
    
    cd crud-app/react-frontend || exit 1
    
    print_info "Installing npm dependencies..."
    if npm install; then
        print_status "Frontend dependencies installed successfully"
    else
        print_error "Failed to install frontend dependencies"
        return 1
    fi
    
    cd ../..
    return 0
}

# Create start scripts
create_start_scripts() {
    print_info "Creating start scripts..."
    
    # Backend start script
    cat > start-backend.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Ballerina Backend..."
cd crud-app
bal run
EOF
    chmod +x start-backend.sh
    
    # Frontend start script
    cat > start-frontend.sh << 'EOF'
#!/bin/bash
echo "🌐 Starting React Frontend..."
cd crud-app/react-frontend
npm run dev
EOF
    chmod +x start-frontend.sh
    
    # Windows batch files
    cat > start-backend.bat << 'EOF'
@echo off
echo 🚀 Starting Ballerina Backend...
cd crud-app
bal run
pause
EOF
    
    cat > start-frontend.bat << 'EOF'
@echo off
echo 🌐 Starting React Frontend...
cd crud-app\react-frontend
npm run dev
pause
EOF
    
    print_status "Start scripts created:"
    print_info "  ./start-backend.sh (or .bat on Windows)"
    print_info "  ./start-frontend.sh (or .bat on Windows)"
}

# Main setup function
main() {
    echo "Starting automated setup..."
    echo ""
    
    # Check OS
    check_os
    echo ""
    
    # Check prerequisites
    if ! check_ballerina; then
        exit 1
    fi
    echo ""
    
    if ! check_nodejs; then
        exit 1
    fi
    echo ""
    
    # Setup database configuration
    setup_database_config
    echo ""
    
    # Setup backend
    if ! setup_backend; then
        exit 1
    fi
    echo ""
    
    # Setup frontend
    if ! setup_frontend; then
        exit 1
    fi
    echo ""
    
    # Create start scripts
    create_start_scripts
    echo ""
    
    print_status "Setup completed successfully! 🎉"
    echo ""
    echo "📋 Next Steps:"
    echo "=============="
    echo ""
    echo "1. 🗄️  Setup your Supabase database:"
    echo "   - Go to your Supabase project"
    echo "   - Open SQL Editor"
    echo "   - Run the script from: crud-app/database_setup.sql"
    echo ""
    echo "2. 🚀 Start the application:"
    echo "   Backend:  ./start-backend.sh (or start-backend.bat)"
    echo "   Frontend: ./start-frontend.sh (or start-frontend.bat)"
    echo ""
    echo "3. 🌐 Open your browser:"
    echo "   - Frontend: http://localhost:3000"
    echo "   - Backend API: http://localhost:8080/api/users"
    echo ""
    echo "🎊 Happy coding!"
}

# Run main function
main
