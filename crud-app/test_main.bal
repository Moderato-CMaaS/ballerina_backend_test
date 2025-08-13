import ballerina/http;
import ballerina/io;

// Simple HTTP service without database for testing
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
    
    // Mock users data for testing
    resource function get users() returns json {
        return [
            {"id": 1, "name": "John Doe", "email": "john@example.com", "created_at": "2025-08-13T10:00:00Z"},
            {"id": 2, "name": "Jane Smith", "email": "jane@example.com", "created_at": "2025-08-13T10:01:00Z"}
        ];
    }
}

public function main() returns error? {
    io:println("🚀 CRUD API server starting on port 8080...");
    io:println("✅ Backend is ready! Try: http://localhost:8080/api/test");
}
