-- 🚀 COPY THIS ENTIRE SCRIPT TO SUPABASE SQL EDITOR
-- 
-- Instructions:
-- 1. Go to https://supabase.com/dashboard
-- 2. Select your project (db.tfvkvayimblfwfjkrjgt.supabase.co)
-- 3. Click "SQL Editor" in left sidebar
-- 4. Copy and paste this entire script
-- 5. Click "Run" button
-- 6. You should see "SUCCESS" messages

-- Create the users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john.doe@example.com'),
    ('Jane Smith', 'jane.smith@example.com'),
    ('Bob Johnson', 'bob.johnson@example.com'),
    ('Alice Wilson', 'alice.wilson@example.com'),
    ('Charlie Brown', 'charlie.brown@example.com')
ON CONFLICT (email) DO NOTHING;

-- Verify the setup worked
SELECT 
    'Table created successfully!' as status,
    COUNT(*) as total_users 
FROM users;

-- Show all users
SELECT * FROM users ORDER BY id;
