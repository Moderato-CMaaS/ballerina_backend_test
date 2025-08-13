import ballerina/sql;
import ballerinax/postgresql;
import ballerina/io;

// Database configuration for Supabase
configurable string DB_HOST = ?;
configurable string DB_NAME = ?;
configurable string DB_USERNAME = ?;
configurable string DB_PASSWORD = ?;
configurable int DB_PORT = 5432;

public function main() returns error? {
    io:println("🔧 Setting up Supabase database table...");
    
    // Database client
    postgresql:Client dbClient = check new (
        host = DB_HOST,
        username = DB_USERNAME,
        password = DB_PASSWORD,
        database = DB_NAME,
        port = DB_PORT
    );
    
    // Create users table
    sql:ParameterizedQuery createTableQuery = `
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(150) UNIQUE NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )
    `;
    
    sql:ExecutionResult result1 = check dbClient->execute(createTableQuery);
    io:println("✅ Users table created successfully!");
    
    // Insert sample data
    sql:ParameterizedQuery insertDataQuery = `
        INSERT INTO users (name, email) VALUES 
            ('John Doe', 'john.doe@example.com'),
            ('Jane Smith', 'jane.smith@example.com'),
            ('Bob Johnson', 'bob.johnson@example.com')
        ON CONFLICT (email) DO NOTHING
    `;
    
    sql:ExecutionResult result2 = check dbClient->execute(insertDataQuery);
    io:println("✅ Sample data inserted!");
    
    // Verify the setup
    sql:ParameterizedQuery selectQuery = `SELECT COUNT(*) as count FROM users`;
    record {} result = check dbClient->queryRow(selectQuery);
    io:println("✅ Table setup complete! Found ", result.get("count"), " users in database");
    
    check dbClient.close();
    io:println("🎉 Database setup finished! Your CRUD app is ready to use!");
}
