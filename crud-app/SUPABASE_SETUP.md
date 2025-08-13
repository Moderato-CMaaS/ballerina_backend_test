# 🚀 Quick Supabase Setup Guide

## Step 1: Create the Database Table

1. Go to your Supabase dashboard: https://supabase.com/dashboard
2. Select your project (the one with `db.tfvkvayimblfwfjkrjgt.supabase.co`)
3. Click on **SQL Editor** in the left sidebar
4. Copy and paste this SQL code:

```sql
-- Create users table
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
    ('Bob Johnson', 'bob.johnson@example.com')
ON CONFLICT (email) DO NOTHING;

-- Verify the table was created
SELECT * FROM users;
```

5. Click **Run** button
6. You should see the sample users in the results

## Step 2: Test the Connection

After creating the table, your React app will be able to:
- ✅ Fetch all users from Supabase
- ✅ Add new users through the form
- ✅ Edit existing users
- ✅ Delete users

## Troubleshooting

If you get connection errors:
1. Make sure your Supabase project is active
2. Verify the database credentials in Config.toml
3. Check that the table was created successfully

That's it! Your CRUD app will be fully functional with Supabase!
