import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerina/io;

// Database configuration for Supabase
configurable string DB_HOST = ?;
configurable string DB_NAME = ?;
configurable string DB_USERNAME = ?;
configurable string DB_PASSWORD = ?;
configurable int DB_PORT = 5432;

// User record type
type User record {
    int id?;
    string name;
    string email;
    string created_at?;
};

// User input type for POST/PUT requests
type UserInput record {
    string name;
    string email;
};

// Database client
postgresql:Client dbClient = check new (
    host = DB_HOST,
    username = DB_USERNAME,
    password = DB_PASSWORD,
    database = DB_NAME,
    port = DB_PORT
);

// HTTP service for CRUD operations
service /api on new http:Listener(8080) {
    
    // Enable CORS for React frontend - handle OPTIONS for users endpoint
    resource function options users() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, Origin, X-Requested-With");
        response.setHeader("Access-Control-Max-Age", "86400");
        response.statusCode = 200;
        io:println("OPTIONS request for /users received - CORS headers added");
        return response;
    }

    // Enable CORS for React frontend - handle OPTIONS for users with ID
    resource function options users/[int id]() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, Origin, X-Requested-With");
        response.setHeader("Access-Control-Max-Age", "86400");
        response.statusCode = 200;
        io:println("OPTIONS request for /users/" + id.toString() + " received - CORS headers added");
        return response;
    }

    // Test endpoint
    resource function get test() returns json {
        return {"message": "Backend is working!", "status": "success"};
    }

    // GET all users
    resource function get users() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        sql:ParameterizedQuery query = `SELECT id, name, email, created_at FROM users ORDER BY id`;
        stream<User, error?> resultStream = dbClient->query(query);
        User[] users = [];
        
        error? result = from User user in resultStream
            do {
                users.push(user);
            };
        
        if result is error {
            io:println("Error fetching users: ", result.message());
            response.statusCode = 500;
            response.setJsonPayload({"error": "Database error"});
            return response;
        }
        
        response.setJsonPayload(users.toJson());
        return response;
    }

    // GET user by ID
    resource function get users/[int id]() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        sql:ParameterizedQuery query = `SELECT id, name, email, created_at FROM users WHERE id = ${id}`;
        User|error result = dbClient->queryRow(query);
        
        if result is User {
            response.setJsonPayload(result.toJson());
            return response;
        } else if result is sql:NoRowsError {
            response.statusCode = 404;
            response.setJsonPayload({"error": "User not found"});
            return response;
        } else {
            io:println("Error fetching user: ", result.message());
            response.statusCode = 500;
            response.setJsonPayload({"error": "Database error"});
            return response;
        }
    }

    // POST create new user
    resource function post users(@http:Payload UserInput newUser) returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, Origin, X-Requested-With");
        
        io:println("Received POST request to create user: ", newUser.name, " - ", newUser.email);
        
        if newUser.name.trim() == "" || newUser.email.trim() == "" {
            io:println("Validation failed: empty name or email");
            response.statusCode = 400;
            response.setJsonPayload({"error": "Name and email are required"});
            return response;
        }
        
        sql:ParameterizedQuery query = `INSERT INTO users (name, email) VALUES (${newUser.name}, ${newUser.email}) RETURNING id, name, email, created_at`;
        User|error result = dbClient->queryRow(query);
        
        if result is User {
            io:println("Created user: ", result.name);
            response.statusCode = 201;
            response.setJsonPayload(result.toJson());
            return response;
        } else {
            io:println("Error creating user: ", result.message());
            response.statusCode = 500;
            response.setJsonPayload({"error": "Failed to create user"});
            return response;
        }
    }

    // PUT update user
    resource function put users/[int id](@http:Payload UserInput updatedUser) returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        if updatedUser.name.trim() == "" || updatedUser.email.trim() == "" {
            response.statusCode = 400;
            response.setJsonPayload({"error": "Name and email are required"});
            return response;
        }
        
        // Update the user
        sql:ParameterizedQuery updateQuery = `UPDATE users SET name = ${updatedUser.name}, email = ${updatedUser.email} WHERE id = ${id} RETURNING id, name, email, created_at`;
        User|error result = dbClient->queryRow(updateQuery);
        
        if result is User {
            io:println("Updated user: ", result.name);
            response.statusCode = 200;
            response.setJsonPayload(result.toJson());
            return response;
        } else if result is sql:NoRowsError {
            response.statusCode = 404;
            response.setJsonPayload({"error": "User not found"});
            return response;
        } else {
            io:println("Error updating user: ", result.message());
            response.statusCode = 500;
            response.setJsonPayload({"error": "Failed to update user"});
            return response;
        }
    }

    // DELETE user
    resource function delete users/[int id]() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        sql:ParameterizedQuery query = `DELETE FROM users WHERE id = ${id}`;
        sql:ExecutionResult|error result = dbClient->execute(query);
        
        if result is sql:ExecutionResult {
            if result.affectedRowCount > 0 {
                io:println("Deleted user with id: ", id);
                response.statusCode = 200;
                response.setJsonPayload({"message": "User deleted successfully"});
                return response;
            } else {
                response.statusCode = 404;
                response.setJsonPayload({"error": "User not found"});
                return response;
            }
        } else {
            io:println("Error deleting user: ", result.message());
            response.statusCode = 500;
            response.setJsonPayload({"error": "Failed to delete user"});
            return response;
        }
    }
}

public function main() returns error? {
    io:println("🚀 CRUD API server starting on port 8080...");
    io:println("✅ Connecting to Supabase PostgreSQL database...");
    io:println("📡 Backend ready for CRUD operations!");
}
