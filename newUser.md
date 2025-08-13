## New User Guide: Run the Ballerina + React CRUD app (Windows)

This guide gets you from zero to running the backend (Ballerina) and frontend (React) on Windows using PowerShell.

### What you’ll run
- Backend (Ballerina): http://localhost:8080
- Frontend (React + Vite): http://localhost:3000

---

## 1) Prerequisites
- Windows 10/11 with PowerShell 5.1+
- Node.js LTS (v16+)
- Ballerina 2201.12.7 or later
- Supabase project (Postgres database)

If you don’t have Node/Ballerina yet:

```powershell
# Install Node.js LTS
winget install -e --id OpenJS.NodeJS.LTS

# Install Ballerina (download the Windows installer):
# https://ballerina.io/downloads/
```

Verify:
```powershell
node -v
bal version
```

---

## 2) Get the code
If you don’t already have the project folder, clone or download it. Open a PowerShell window in the repo root:
```powershell
Set-Location "c:\Users\admin\Desktop\ballerina"
```

Repo layout (key parts):
- `crud-app/` Ballerina backend
- `crud-app/react-frontend/` React app
- `start-backend.ps1`, `start-frontend.ps1` helpers

---

## 3) Prepare the database (Supabase)
1) Create a Supabase project.
2) In the Supabase SQL editor, run one of:
   - `crud-app/database_setup.sql` (recommended)
   - or `crud-app/CREATE_TABLE_IN_SUPABASE.sql`
3) Note your DB connection info: host, database, user, password, port (5432 by default).

---

## 4) Configure the backend
Edit `crud-app/Config.toml` and set your database credentials:
- `DB_HOST`
- `DB_NAME`
- `DB_USERNAME`
- `DB_PASSWORD`
- `DB_PORT`

Save the file.

---

## 5) Allow scripts (only if you get a policy error)
If PowerShell says scripts are disabled, enable just for this session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Get-ChildItem ".\*.ps1" | Unblock-File
```

---

## 6) Run the apps
Open two PowerShell windows.

Window 1 — start backend:
```powershell
Set-Location "c:\Users\admin\Desktop\ballerina"
.\start-backend.ps1
# Backend: http://localhost:8080
# API:     http://localhost:8080/api/users
```

Window 2 — start frontend:
```powershell
Set-Location "c:\Users\admin\Desktop\ballerina"
.\start-frontend.ps1
# Frontend: http://localhost:3000
```

Notes:
- The start scripts work from any directory; they compute paths relative to the script location.
- If you prefer Command Prompt or your policy blocks PowerShell scripts, use the batch files:
```powershell
cmd /c start-backend.bat
cmd /c start-frontend.bat
```

---

## 7) Verify
- Open the frontend: http://localhost:3000
- Ping the API:
```powershell
Invoke-WebRequest http://localhost:8080/api/users -UseBasicParsing
```

---

## Manual run (optional, without scripts)
```powershell
# Backend
Set-Location "c:\Users\admin\Desktop\ballerina\crud-app"
bal run

# Frontend
Set-Location "c:\Users\admin\Desktop\ballerina\crud-app\react-frontend"
npm install
npm run dev
```

---

## Troubleshooting
- “.ps1 is not recognized”
  - You may be in `crud-app` while the script is one level up. Run:
    ```powershell
    ..\start-backend.ps1
    ..\start-frontend.ps1
    ```
  - Or run with an absolute path:
    ```powershell
    & "c:\Users\admin\Desktop\ballerina\start-backend.ps1"
    & "c:\Users\admin\Desktop\ballerina\start-frontend.ps1"
    ```
- “Running scripts is disabled on this system”
  - Use the session-only policy change shown above.
- Frontend fails with “Missing script: dev”
  - Ensure it runs inside `crud-app\react-frontend`. Our script handles this automatically.
- npm install/network errors
  - See `crud-app\FIX_NETWORK_ERROR.md` or check your proxy/registry settings.
- Port already in use (8080 or 3000)
  - Stop the other process or change ports in your configs.
- Backend DB connection errors
  - Re-check `crud-app\Config.toml` and confirm the SQL ran successfully in Supabase.

---

Happy hacking! Open frontend at http://localhost:3000 and make sure the backend at http://localhost:8080 is running.
