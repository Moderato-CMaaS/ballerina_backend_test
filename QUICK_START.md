# 🚀 Quick Start Guide

Get your Ballerina CRUD app running in 5 minutes!

## Prerequisites Check

Ensure you have these installed:
- [ ] **Ballerina** 2201.12.7+ → [Download](https://ballerina.io/downloads/)
- [ ] **Node.js** 16+ → [Download](https://nodejs.org/)
- [ ] **Supabase Account** → [Sign up](https://supabase.com)

## 🏃‍♂️ Super Quick Setup

### Option 1: Automated Setup (Recommended)

**Windows PowerShell:**
```powershell
.\setup.ps1
```

**macOS/Linux:**
```bash
chmod +x setup.sh
./setup.sh
```

### Option 2: Manual Setup (3 steps)

#### Step 1: Database Setup
1. Create a [Supabase](https://supabase.com) project
2. Go to SQL Editor, run this:
   ```sql
   CREATE TABLE IF NOT EXISTS users (
       id SERIAL PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       email VARCHAR(150) UNIQUE NOT NULL,
       created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
   );
   ```

#### Step 2: Backend Config
Create `crud-app/Config.toml`:
```toml
DB_HOST = "db.xxxxxxxxxxxxx.supabase.co"
DB_NAME = "postgres"
DB_USERNAME = "postgres"
DB_PASSWORD = "your-password"
DB_PORT = 5432
```

#### Step 3: Install & Run
```bash
# Backend
cd crud-app
bal build
bal run

# Frontend (new terminal)
cd crud-app/react-frontend
npm install
npm run dev
```

## 🎯 Access Your App

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080/api/users

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| `bal: command not found` | Install Ballerina from [ballerina.io](https://ballerina.io/downloads/) |
| `node: command not found` | Install Node.js from [nodejs.org](https://nodejs.org/) |
| Database connection error | Check your Config.toml credentials |
| Port 8080 in use | Kill the process: `netstat -ano \| findstr :8080` |
| CORS errors | Ensure both backend (8080) and frontend (3000) are running |

## 🎉 Success!

You should see:
- ✅ A React form to add users
- ✅ A list showing existing users  
- ✅ Edit/Delete buttons working
- ✅ Real-time updates

## 📱 Quick Test

Try the API directly:
```bash
# Get all users
curl http://localhost:8080/api/users

# Add a user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Test User", "email": "test@example.com"}'
```

---

**Need help?** Check the full [README.md](README.md) for detailed documentation.
