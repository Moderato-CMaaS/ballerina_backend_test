# Ballerina CRUD Application

A full-stack CRUD application demonstrating modern web development with Ballerina, React, and Supabase.

## � New User?

**👋 First time here?** Follow our simplified quick-start guide for Windows users!

[![📖 New User Guide](https://img.shields.io/badge/📖%20New%20User%20Guide-Click%20Here-blue?style=for-the-badge)](./newUser.md)

**[→ Click here to go to the New User Guide](./newUser.md)**

The new user guide provides a streamlined setup process specifically designed for Windows users with PowerShell commands and step-by-step instructions.

---

## �🏗️ Architecture

```
React Frontend (Port 3000)
       ↓ HTTP/HTTPS
Ballerina API Server (Port 8080)
       ↓ PostgreSQL Protocol
Supabase PostgreSQL Database
```

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Ballerina** (Version 2201.12.7 or later)
2. **Node.js** (Version 16 or later)
3. **npm** (comes with Node.js)
4. **Git** (for cloning the repository)

## 📦 Installation Guide

### 1. Install Ballerina

#### Windows:
1. Download the MSI installer from [ballerina.io](https://ballerina.io/downloads/)
2. Run the installer and follow the setup wizard
3. Verify installation:
   ```powershell
   bal version
   ```

#### macOS:
```bash
# Using Homebrew
brew install ballerina

# Or download from ballerina.io
```

#### Linux:
```bash
# Download and install the DEB/RPM package from ballerina.io
# Or use the installation script:
curl -sSL https://dist.ballerina.io/bvm/get-ballerina.sh | bash
```

### 2. Install Node.js

#### Windows:
1. Download from [nodejs.org](https://nodejs.org/)
2. Run the installer
3. Verify installation:
   ```powershell
   node --version
   npm --version
   ```

#### macOS/Linux:
```bash
# Using Node Version Manager (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
nvm use node
```

## 🛠️ Project Setup

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd ballerina_backend_test
```

### 2. Database Setup (Supabase)

1. **Create Supabase Account**:
   - Go to [supabase.com](https://supabase.com)
   - Sign up for a free account
   - Create a new project

2. **Get Database Credentials**:
   - Go to Settings → Database
   - Copy your connection details:
     - Host: `db.xxxxxxxxxxxxx.supabase.co`
     - Database name: `postgres`
     - Username: `postgres`
     - Password: (your project password)
     - Port: `5432`

3. **Run Database Setup**:
   - Go to SQL Editor in Supabase
   - Copy and paste the contents of `crud-app/database_setup.sql`
   - Click "Run" to create the users table

### 3. Backend Configuration

1. **Navigate to the project directory**:
   ```bash
   cd crud-app
   ```

2. **Create Configuration File**:
   Create a file named `Config.toml` in the `crud-app` directory:
   
   ```toml
   # Database Configuration for Supabase
   DB_HOST = "db.xxxxxxxxxxxxx.supabase.co"
   DB_NAME = "postgres"
   DB_USERNAME = "postgres"
   DB_PASSWORD = "your-actual-password"
   DB_PORT = 5432
   ```
   
   ⚠️ **Important**: Replace the values with your actual Supabase credentials.

3. **Install Ballerina Dependencies**:
   ```bash
   bal build
   ```

### 4. Frontend Setup

1. **Navigate to React frontend**:
   ```bash
   cd react-frontend
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

## 🚦 Running the Application

### Start the Backend (Terminal 1)

```bash
# Navigate to crud-app directory
cd crud-app

# Run the Ballerina server
bal run
```

The backend will start on `http://localhost:8080`

### Start the Frontend (Terminal 2)

```bash
# Navigate to react-frontend directory
cd crud-app/react-frontend

# Start the development server
npm run dev
```

The frontend will start on `http://localhost:3000`

### 🎉 Access the Application

Open your browser and navigate to: `http://localhost:3000`

You should see a CRUD interface where you can:
- ✅ View all users
- ✅ Add new users
- ✅ Edit existing users
- ✅ Delete users

## 📁 Project Structure

```
ballerina_backend_test/
├── crud-app/
│   ├── main.bal                    # Ballerina API server
│   ├── Ballerina.toml             # Ballerina project configuration
│   ├── Dependencies.toml          # Auto-generated dependencies
│   ├── Config.toml                # Database credentials (create this)
│   ├── database_setup.sql         # Database schema and sample data
│   ├── postgresql-42.7.2.jar     # PostgreSQL JDBC driver
│   ├── README.md                  # Detailed project documentation
│   └── react-frontend/            # React frontend application
│       ├── src/
│       │   ├── App.jsx            # Main React component
│       │   ├── App.css            # Application styles
│       │   └── main.jsx           # React entry point
│       ├── index.html             # HTML template
│       ├── package.json           # Node.js dependencies
│       └── vite.config.js         # Vite build configuration
└── README.md                      # This file
```

## 🔌 API Endpoints

The Ballerina backend provides the following REST API endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | Get all users |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Create new user |
| PUT | `/api/users/{id}` | Update user |
| DELETE | `/api/users/{id}` | Delete user |
| OPTIONS | `/api/users` | CORS preflight |

### Example API Usage

#### Get All Users
```bash
curl http://localhost:8080/api/users
```

#### Create User
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
```

#### Update User
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "John Smith", "email": "john.smith@example.com"}'
```

#### Delete User
```bash
curl -X DELETE http://localhost:8080/api/users/1
```

## 🔧 Development

### Building the Project

```bash
# Build Ballerina project
cd crud-app
bal build

# Build React frontend for production
cd react-frontend
npm run build
```

### Testing the API

You can test the API using:
- **curl** (command line)
- **Postman** (GUI)
- **Insomnia** (GUI)
- **VS Code REST Client** extension

## 🐛 Troubleshooting

### Common Issues

#### 1. Database Connection Error
```
ERROR: Connection refused or timeout
```
**Solution**:
- Verify Supabase credentials in `Config.toml`
- Check if your Supabase project is active
- Ensure you're using the correct host URL

#### 2. CORS Errors in Browser
```
Access to XMLHttpRequest has been blocked by CORS policy
```
**Solution**:
- The backend includes CORS headers
- Ensure both frontend and backend are running
- Check that you're accessing the frontend via `http://localhost:3000`

#### 3. Port Already in Use
```
ERROR: Port 8080 is already in use
```
**Solution**:
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:8080 | xargs kill -9
```

#### 4. Ballerina Dependencies Error
```
ERROR: Cannot resolve dependencies
```
**Solution**:
```bash
# Clean and rebuild
bal clean
bal build
```

#### 5. Node.js Dependencies Error
```
npm ERR! Cannot resolve dependency tree
```
**Solution**:
```bash
# Clear npm cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Environment Variables

If you prefer using environment variables instead of `Config.toml`:

```bash
# Set environment variables (Windows PowerShell)
$env:DB_HOST="db.xxxxxxxxxxxxx.supabase.co"
$env:DB_NAME="postgres"
$env:DB_USERNAME="postgres"
$env:DB_PASSWORD="your-password"
$env:DB_PORT="5432"

# Then run
bal run
```

## 🔒 Security Considerations

### Production Deployment

⚠️ **Important Security Notes**:

1. **Never commit** `Config.toml` with real credentials to version control
2. **Use environment variables** for production deployments
3. **Enable SSL/TLS** for production databases
4. **Implement authentication** for production APIs
5. **Validate and sanitize** all user inputs
6. **Use HTTPS** in production

### Add to .gitignore

```gitignore
# Sensitive configuration
Config.toml
.env
*.env

# Dependencies
node_modules/
target/

# Build outputs
dist/
build/
```

## 🚀 Deployment

### Backend Deployment Options

1. **Docker**:
   ```dockerfile
   FROM ballerina/ballerina:2201.12.7
   COPY . /app
   WORKDIR /app
   EXPOSE 8080
   CMD ["bal", "run", "main.bal"]
   ```

2. **Cloud Platforms**:
   - Heroku
   - DigitalOcean App Platform
   - AWS Elastic Beanstalk
   - Google Cloud Platform

### Frontend Deployment Options

1. **Netlify** (recommended for static sites)
2. **Vercel**
3. **GitHub Pages**
4. **AWS S3 + CloudFront**

## 📚 Additional Resources

### Ballerina Documentation
- [Official Documentation](https://ballerina.io/learn/)
- [Language Guide](https://ballerina.io/learn/language-guide/)
- [HTTP Module](https://lib.ballerina.io/ballerina/http/latest)
- [PostgreSQL Connector](https://lib.ballerina.io/ballerinax/postgresql/latest)

### React Documentation
- [React Official Docs](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)
- [Axios Documentation](https://axios-http.com/)

### Supabase Documentation
- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Review the Ballerina and React documentation
3. Create an issue in the repository
4. Check Supabase status page for database issues

---

**Happy Coding! 🎉**

Built with ❤️ using Ballerina, React, and Supabase.
