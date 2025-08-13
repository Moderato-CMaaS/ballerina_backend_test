# CRUD App - React + Ballerina + Supabase

This project demonstrates a full-stack CRUD application using:
- **Frontend**: React with Vite
- **Backend**: Ballerina REST API
- **Database**: Supabase (PostgreSQL)

## Architecture Overview

```
React Frontend (Port 3000)
       ↓
Ballerina API (Port 8080)
       ↓
Supabase PostgreSQL Database
```

## Prerequisites

1. **Ballerina**: Already installed ✅ (Version 2201.12.7)
2. **Node.js**: Required for React frontend
3. **Supabase Account**: For database hosting

## Setup Instructions

### 1. Supabase Setup

1. Create a free account at [supabase.com](https://supabase.com)
2. Create a new project
3. Go to Settings > Database
4. Note down your connection details:
   - Host: `db.your-project-ref.supabase.co`
   - Database name: `postgres`
   - Username: `postgres`
   - Password: `your-password`
   - Port: `5432`

5. Run the SQL script in Supabase SQL Editor:
   ```sql
   -- Copy and paste contents from database_setup.sql
   ```

### 2. Backend Configuration

1. Update `Config.toml` with your Supabase credentials:
   ```toml
   DB_HOST = "db.your-project-ref.supabase.co"
   DB_NAME = "postgres"
   DB_USERNAME = "postgres"
   DB_PASSWORD = "your-actual-password"
   DB_PORT = 5432
   ```

2. Install Ballerina dependencies and run:
   ```bash
   bal run
   ```

### 3. Frontend Setup

1. Navigate to the React frontend:
   ```bash
   cd react-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

## API Endpoints

The Ballerina backend provides these REST endpoints:

- `GET /api/users` - Get all users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

## Features

### Backend (Ballerina)
- ✅ RESTful API with proper HTTP methods
- ✅ PostgreSQL database integration
- ✅ CORS support for React frontend
- ✅ Error handling and validation
- ✅ Type-safe record definitions
- ✅ SSL connection to Supabase

### Frontend (React)
- ✅ Modern React with hooks
- ✅ CRUD operations interface
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Responsive design
- ✅ Real-time updates

### Database (Supabase)
- ✅ PostgreSQL with proper schema
- ✅ Auto-generated timestamps
- ✅ Primary keys and constraints
- ✅ SSL connections

## Testing the Application

1. **Start Backend**: `bal run` (Port 8080)
2. **Start Frontend**: `npm run dev` in react-frontend folder (Port 3000)
3. **Open Browser**: Navigate to `http://localhost:3000`

You should see:
- A form to add new users
- A list of existing users
- Edit/Delete buttons for each user
- Real-time updates when performing CRUD operations

## Verification Checklist

✅ **Ballerina Backend**
- REST API endpoints working
- Database connection established
- CORS enabled for React
- Error handling implemented

✅ **React Frontend**
- Components rendering correctly
- API calls working
- Form submissions functional
- State management working

✅ **Supabase Integration**
- Database connection successful
- SSL connection working
- CRUD operations persisting data
- Auto-generated timestamps

## Troubleshooting

### Common Issues:

1. **Database Connection Error**
   - Verify Supabase credentials in Config.toml
   - Check if Supabase project is active
   - Ensure SSL mode is enabled

2. **CORS Errors**
   - Backend includes CORS headers
   - Frontend uses proxy configuration

3. **Port Conflicts**
   - Backend: 8080
   - Frontend: 3000
   - Change ports if needed

## Next Steps

This basic setup can be extended with:
- Authentication (Supabase Auth)
- Input validation
- Pagination
- Search functionality
- File uploads
- Real-time subscriptions
- Unit tests
- Deployment configuration

## Project Structure

```
crud-app/
├── main.bal                 # Ballerina API server
├── Ballerina.toml          # Ballerina project config
├── Config.toml             # Database configuration
├── database_setup.sql      # Database schema
└── react-frontend/         # React application
    ├── src/
    │   ├── App.jsx         # Main React component
    │   ├── App.css         # Styling
    │   └── main.jsx        # React entry point
    ├── package.json        # Node.js dependencies
    └── vite.config.js      # Vite configuration
```

## Conclusion

✅ **YES, you can definitely implement a CRUD app with React + Ballerina + Supabase!**

This setup provides:
- Type-safe backend with Ballerina
- Modern React frontend
- Reliable PostgreSQL database via Supabase
- Full CRUD operations
- Production-ready architecture

The combination works excellently together and provides a solid foundation for building scalable web applications.
