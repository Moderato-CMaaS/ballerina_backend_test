# 🛠️ Development Guide

Advanced documentation for developers working with this Ballerina CRUD application.

## 📁 Project Architecture

```
ballerina_backend_test/
├── 📄 README.md                 # Main documentation
├── 📄 QUICK_START.md            # 5-minute setup guide
├── 📄 DEVELOPMENT.md            # This file
├── 🚀 setup.ps1 / setup.sh     # Automated setup scripts
├── 🎬 start-*.bat / start-*.ps1 # Quick start scripts
└── crud-app/                    # Main application
    ├── 🔧 main.bal              # Ballerina API server
    ├── 📋 Ballerina.toml        # Project configuration
    ├── 📦 Dependencies.toml     # Auto-generated dependencies
    ├── 🔐 Config.toml           # Database credentials (create this)
    ├── 🗄️ database_setup.sql    # Database schema
    ├── 📚 postgresql-42.7.2.jar # PostgreSQL JDBC driver
    └── react-frontend/          # React application
        ├── 📱 src/App.jsx       # Main React component
        ├── 🎨 src/App.css       # Styling
        ├── 🏠 index.html        # HTML template
        ├── 📦 package.json      # Dependencies
        └── ⚙️ vite.config.js     # Build configuration
```

## 🔧 Development Workflow

### Backend Development (Ballerina)

#### Hot Reload Development
```bash
cd crud-app
bal run --observability-included
```

#### Code Structure
```ballerina
// Type definitions
type User record {
    int id?;
    string name;
    string email;
    string created_at?;
};

// Service endpoints
service /api on new http:Listener(8080) {
    resource function get users() returns User[]|error {
        // Implementation
    }
    
    resource function post users(UserInput user) returns User|error {
        // Implementation
    }
}
```

#### Adding New Endpoints
1. Define the resource function in `main.bal`
2. Add proper error handling
3. Update CORS configuration if needed
4. Test with curl or Postman

#### Database Operations
```ballerina
// Example query execution
sql:ExecutionResult result = check dbClient->execute(`
    INSERT INTO users (name, email) 
    VALUES (${userInput.name}, ${userInput.email})
`);
```

### Frontend Development (React)

#### Development Server
```bash
cd crud-app/react-frontend
npm run dev
```

#### Key Components
- `App.jsx`: Main application component
- State management using React hooks
- Axios for API communication
- CSS for styling

#### Adding New Features
1. Update the React component
2. Add new API calls
3. Update styling in `App.css`
4. Test functionality

### Database Development

#### Schema Changes
1. Update `database_setup.sql`
2. Run the new SQL in Supabase
3. Update Ballerina record types
4. Update React components if needed

#### Sample Queries
```sql
-- Get user statistics
SELECT 
    COUNT(*) as total_users,
    DATE(created_at) as signup_date
FROM users 
GROUP BY DATE(created_at)
ORDER BY signup_date;

-- Find users by domain
SELECT * FROM users 
WHERE email LIKE '%@gmail.com';
```

## 🧪 Testing

### API Testing with curl

#### Get all users
```bash
curl -X GET http://localhost:8080/api/users
```

#### Create user
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john.doe@example.com"
  }'
```

#### Update user
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "email": "john.smith@example.com"
  }'
```

#### Delete user
```bash
curl -X DELETE http://localhost:8080/api/users/1
```

### Testing with Postman

Import this collection:
```json
{
  "info": {
    "name": "Ballerina CRUD API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Get All Users",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://localhost:8080/api/users",
          "protocol": "http",
          "host": ["localhost"],
          "port": "8080",
          "path": ["api", "users"]
        }
      }
    }
  ]
}
```

## 🔍 Debugging

### Ballerina Debugging
```bash
# Enable debug logging
cd crud-app
bal run --debug
```

### Common Issues & Solutions

#### Database Connection Issues
```ballerina
// Add connection testing
public function main() {
    var result = dbClient->execute(`SELECT 1`);
    if (result is sql:ExecutionResult) {
        io:println("Database connection successful");
    } else {
        io:println("Database connection failed: ", result.message());
    }
}
```

#### CORS Issues
- Ensure OPTIONS method is handled
- Check Access-Control headers
- Verify frontend is running on port 3000

#### Performance Issues
- Add connection pooling
- Implement query optimization
- Add caching layer

## 📦 Build & Deployment

### Local Build
```bash
# Backend
cd crud-app
bal build

# Frontend
cd react-frontend
npm run build
```

### Docker Deployment

#### Backend Dockerfile
```dockerfile
FROM ballerina/ballerina:2201.12.7
WORKDIR /app
COPY . .
EXPOSE 8080
CMD ["bal", "run", "main.bal"]
```

#### Frontend Dockerfile
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "preview"]
```

### Environment Variables

For production, use environment variables instead of `Config.toml`:

```bash
export DB_HOST="your-production-host"
export DB_NAME="postgres"
export DB_USERNAME="postgres"
export DB_PASSWORD="secure-password"
export DB_PORT="5432"
```

## 🔒 Security Best Practices

### Backend Security
1. **Input Validation**: Validate all user inputs
2. **SQL Injection**: Use parameterized queries (already implemented)
3. **CORS**: Configure proper CORS settings for production
4. **HTTPS**: Use TLS in production
5. **Rate Limiting**: Implement API rate limiting
6. **Authentication**: Add JWT or session-based auth

### Database Security
1. **Connection Encryption**: Use SSL (enabled by default with Supabase)
2. **Credentials**: Never commit credentials to version control
3. **Principle of Least Privilege**: Use dedicated database users
4. **Backup**: Regular database backups

### Frontend Security
1. **Input Sanitization**: Sanitize user inputs
2. **XSS Prevention**: Escape dynamic content
3. **HTTPS**: Serve over HTTPS in production
4. **Content Security Policy**: Implement CSP headers

## 📊 Monitoring & Logging

### Ballerina Observability
```toml
# In Ballerina.toml
[build-options]
observabilityIncluded = true
```

### Custom Logging
```ballerina
import ballerina/log;

log:printInfo("User created successfully", id = userId);
log:printError("Database connection failed", 'error = err);
```

### Health Check Endpoint
```ballerina
resource function get health() returns json {
    return {
        status: "UP",
        timestamp: time:utcNow(),
        database: checkDatabaseHealth()
    };
}
```

## 🚀 Performance Optimization

### Backend Optimization
1. **Connection Pooling**: Configure database connection pools
2. **Caching**: Implement Redis or in-memory caching
3. **Async Processing**: Use Ballerina's async capabilities
4. **Load Balancing**: Use multiple instances behind a load balancer

### Frontend Optimization
1. **Code Splitting**: Implement React lazy loading
2. **Bundling**: Optimize Vite build configuration
3. **CDN**: Serve static assets from CDN
4. **Caching**: Implement proper browser caching

### Database Optimization
1. **Indexing**: Add appropriate indexes
2. **Query Optimization**: Analyze and optimize slow queries
3. **Connection Limits**: Configure appropriate connection limits

## 🔄 CI/CD Pipeline

### GitHub Actions Example
```yaml
name: Build and Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Ballerina
        uses: ballerina-platform/setup-ballerina@v1
        with:
          version: 2201.12.7
      - name: Build Backend
        run: |
          cd crud-app
          bal build
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Build Frontend
        run: |
          cd crud-app/react-frontend
          npm ci
          npm run build
```

## 📚 Additional Resources

### Ballerina Resources
- [Language Guide](https://ballerina.io/learn/language-guide/)
- [HTTP Module Docs](https://lib.ballerina.io/ballerina/http/latest)
- [PostgreSQL Connector](https://lib.ballerina.io/ballerinax/postgresql/latest)
- [Observability](https://ballerina.io/learn/observe-ballerina-code/)

### React Resources
- [React Documentation](https://react.dev/)
- [Vite Guide](https://vitejs.dev/guide/)
- [Axios Documentation](https://axios-http.com/docs/intro)

### Database Resources
- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Manual](https://www.postgresql.org/docs/)

---

**Happy Development! 🎉**

For questions or contributions, please create an issue or pull request.
