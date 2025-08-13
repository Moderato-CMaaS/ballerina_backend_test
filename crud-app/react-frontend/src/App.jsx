import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_BASE_URL = 'http://localhost:8080/api';

function App() {
  const [users, setUsers] = useState([]);
  const [formData, setFormData] = useState({ name: '', email: '' });
  const [editingUser, setEditingUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Fetch all users
  const fetchUsers = async () => {
    try {
      setLoading(true);
      console.log('Fetching users from:', `${API_BASE_URL}/users`);
      const response = await axios.get(`${API_BASE_URL}/users`);
      console.log('Users fetched successfully:', response.data);
      setUsers(response.data);
      setError('');
    } catch (err) {
      console.error('Error fetching users:', err);
      console.error('Error response:', err.response);
      console.error('Error code:', err.code);
      
      let errorMessage = 'Failed to fetch users: ';
      if (err.code === 'ECONNREFUSED') {
        errorMessage += 'Backend server is not running on port 8080';
      } else if (err.response) {
        errorMessage += `Server error ${err.response.status}: ${err.response.data}`;
      } else if (err.request) {
        errorMessage += 'Network error - check if backend is running';
      } else {
        errorMessage += err.message;
      }
      
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  // Create new user
  const createUser = async (userData) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/users`, userData);
      setUsers([...users, response.data]);
      setFormData({ name: '', email: '' });
      setError('');
    } catch (err) {
      setError('Failed to create user: ' + err.message);
    }
  };

  // Update user
  const updateUser = async (id, userData) => {
    try {
      const response = await axios.put(`${API_BASE_URL}/users/${id}`, userData);
      setUsers(users.map(user => user.id === id ? response.data : user));
      setEditingUser(null);
      setFormData({ name: '', email: '' });
      setError('');
    } catch (err) {
      setError('Failed to update user: ' + err.message);
    }
  };

  // Delete user
  const deleteUser = async (id) => {
    if (window.confirm('Are you sure you want to delete this user?')) {
      try {
        await axios.delete(`${API_BASE_URL}/users/${id}`);
        setUsers(users.filter(user => user.id !== id));
        setError('');
      } catch (err) {
        setError('Failed to delete user: ' + err.message);
      }
    }
  };

  // Handle form submission
  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.name || !formData.email) {
      setError('Please fill in all fields');
      return;
    }

    if (editingUser) {
      updateUser(editingUser.id, formData);
    } else {
      createUser(formData);
    }
  };

  // Handle edit button click
  const handleEdit = (user) => {
    setEditingUser(user);
    setFormData({ name: user.name, email: user.email });
  };

  // Handle cancel edit
  const handleCancelEdit = () => {
    setEditingUser(null);
    setFormData({ name: '', email: '' });
  };

  // Load users on component mount
  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <div className="app">
      <div className="container">
        <h1>CRUD App - React + Ballerina + Supabase</h1>
        
        {error && <div className="error">{error}</div>}
        
        {/* User Form */}
        <div className="form-section">
          <h2>{editingUser ? 'Edit User' : 'Add New User'}</h2>
          <form onSubmit={handleSubmit} className="user-form">
            <input
              type="text"
              placeholder="Name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              required
            />
            <input
              type="email"
              placeholder="Email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              required
            />
            <div className="form-actions">
              <button type="submit">
                {editingUser ? 'Update User' : 'Add User'}
              </button>
              {editingUser && (
                <button type="button" onClick={handleCancelEdit} className="cancel-btn">
                  Cancel
                </button>
              )}
            </div>
          </form>
        </div>

        {/* Users List */}
        <div className="users-section">
          <h2>Users List</h2>
          {loading ? (
            <div className="loading">Loading...</div>
          ) : (
            <div className="users-grid">
              {users.map(user => (
                <div key={user.id} className="user-card">
                  <h3>{user.name}</h3>
                  <p>{user.email}</p>
                  <small>Created: {new Date(user.created_at).toLocaleDateString()}</small>
                  <div className="user-actions">
                    <button onClick={() => handleEdit(user)} className="edit-btn">
                      Edit
                    </button>
                    <button onClick={() => deleteUser(user.id)} className="delete-btn">
                      Delete
                    </button>
                  </div>
                </div>
              ))}
              {users.length === 0 && !loading && (
                <p>No users found. Add some users to get started!</p>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
