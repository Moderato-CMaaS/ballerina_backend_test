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
    
    // Enable CORS for React frontend
    resource function options [string... path]() returns http:Response {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
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
    resource function get users/[int id]() returns User|http:NotFound|http:InternalServerError {
        sql:ParameterizedQuery query = `SELECT id, name, email, created_at FROM users WHERE id = ${id}`;
        User|error result = dbClient->queryRow(query);
        
        if result is User {
            return result;
        } else if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            io:println("Error fetching user: ", result.message());
            return http:INTERNAL_SERVER_ERROR;
        }
    }

    // POST create new user
    resource function post users(@http:Payload UserInput newUser) returns User|http:InternalServerError|http:BadRequest {
        if newUser.name.trim() == "" || newUser.email.trim() == "" {
            return http:BAD_REQUEST;
        }
        
        sql:ParameterizedQuery query = `INSERT INTO users (name, email) VALUES (${newUser.name}, ${newUser.email}) RETURNING id, name, email, created_at`;
        User|error result = dbClient->queryRow(query);
        
        if result is User {
            io:println("Created user: ", result.name);
            return result;
        } else {
            io:println("Error creating user: ", result.message());
            return http:INTERNAL_SERVER_ERROR;
        }
    }

    // PUT update user
    resource function put users/[int id](@http:Payload UserInput updatedUser) returns User|http:NotFound|http:InternalServerError|http:BadRequest {
        if updatedUser.name.trim() == "" || updatedUser.email.trim() == "" {
            return http:BAD_REQUEST;
        }
        
        // Update the user
        sql:ParameterizedQuery updateQuery = `UPDATE users SET name = ${updatedUser.name}, email = ${updatedUser.email} WHERE id = ${id} RETURNING id, name, email, created_at`;
        User|error result = dbClient->queryRow(updateQuery);
        
        if result is User {
            io:println("Updated user: ", result.name);
            return result;
        } else if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            io:println("Error updating user: ", result.message());
            return http:INTERNAL_SERVER_ERROR;
        }
    }

    // DELETE user
    resource function delete users/[int id]() returns http:Ok|http:NotFound|http:InternalServerError {
        sql:ParameterizedQuery query = `DELETE FROM users WHERE id = ${id}`;
        sql:ExecutionResult|error result = dbClient->execute(query);
        
        if result is sql:ExecutionResult {
            if result.affectedRowCount > 0 {
                io:println("Deleted user with id: ", id);
                return http:OK;
            } else {
                return http:NOT_FOUND;
            }
        } else {
            io:println("Error deleting user: ", result.message());
            return http:INTERNAL_SERVER_ERROR;
        }
    }
}

public function main() returns error? {
    io:println("🚀 CRUD API server starting on port 8080...");
    io:println("✅ Connecting to Supabase PostgreSQL database...");
    io:println("📡 Backend ready for CRUD operations!");
}
