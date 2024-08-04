const express = require('express');
const router = express.Router();
const db = require('../db'); // Ensure this path is correct
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken'); // For JWT token generation
const saltRounds = 10;
const JWT_SECRET = 'your_jwt_secret'; // Replace with your actual secret key

// Route to create a new account
router.post('/createAccount', async (req, res) => {
  const { username, password, email, fullName, dateOfBirth, gender, isAnonymous } = req.body;

  if (!username || !password || !email || !fullName || !dateOfBirth || !gender) {
    return res.status(400).send({ error: 'All fields are required' });
  }

  try {
    // Check if the username or email already exists
    const checkQuery = 'SELECT * FROM users WHERE Username = ? OR Email = ?';
    db.query(checkQuery, [username, email], async (checkError, checkResults) => {
      if (checkError) {
        console.error('Database error:', checkError);
        return res.status(500).send({ error: 'Database error: ' + checkError.message });
      }

      if (checkResults.length > 0) {
        return res.status(409).send({ error: 'Username or email already exists' });
      }

      // Hash the password and insert a new user into the database
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      const query = 'INSERT INTO users (Username, PasswordHash, Email, FullName, DateOfBirth, Gender, IsAnonymous) VALUES (?, ?, ?, ?, ?, ?, ?)';
      const values = [username, hashedPassword, email, fullName, dateOfBirth, gender, isAnonymous];

      db.query(query, values, (error, results) => {
        if (error) {
          console.error('Database error:', error);
          return res.status(500).send({ error: 'Database error: ' + error.message });
        }
        res.status(201).send({ message: 'Account created successfully', userId: results.insertId });
      });
    });
  } catch (err) {
    console.error('Error hashing password:', err);
    res.status(500).send({ error: 'Error hashing password: ' + err.message });
  }
});

// Route to log in
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).send({ error: 'Username and password are required' });
  }

  try {
    const query = 'SELECT UserID, PasswordHash FROM users WHERE Username = ?'; // Ensure field names are correct
    db.query(query, [username], async (error, results) => {
      if (error) {
        console.error('Database error:', error);
        return res.status(500).send({ error: 'Database error: ' + error.message });
      }

      if (results.length === 0) {
        return res.status(401).send({ error: 'Invalid username or password' });
      }

      const { UserID, PasswordHash } = results[0];
      const match = await bcrypt.compare(password, PasswordHash);

      if (match) {
        // Generate a JWT token
        const token = jwt.sign({ userId: UserID, username: username }, JWT_SECRET, { expiresIn: '1h' });
        res.status(200).send({ 
          message: 'Login successful',
          userId: UserID, // Include userId in the response
          token: token // Send JWT token back to client
        });
      } else {
        res.status(401).send({ error: 'Invalid username or password' });
      }
    });
  } catch (err) {
    console.error('Error during login:', err);
    res.status(500).send({ error: 'Error during login: ' + err.message });
  }
});

// New route for account deletion
router.delete('/deleteAccount/:userId', async (req, res) => {
  const userId = req.params.userId;

  if (!userId) {
    return res.status(400).send({ error: 'User ID is required' });
  }

  try {
    const query = 'DELETE FROM users WHERE UserID = ?';
    db.query(query, [userId], (error, results) => {
      if (error) {
        console.error('Database error:', error);
        return res.status(500).send({ error: 'Database error: ' + error.message });
      }
      
      if (results.affectedRows === 0) {
        return res.status(404).send({ error: 'User not found' });
      }
      
      res.status(200).send({ message: 'Account deleted successfully' });
    });
  } catch (err) {
    console.error('Error during account deletion:', err);
    res.status(500).send({ error: 'Error during account deletion: ' + err.message });
  }
});

module.exports = router;
