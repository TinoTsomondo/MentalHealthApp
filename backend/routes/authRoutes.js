const express = require('express');
const router = express.Router();
const db = require('../db'); // Ensure this path is correct
const bcrypt = require('bcrypt');
const saltRounds = 10;

// Route to create a new account
router.post('/createAccount', async (req, res) => {
  const { username, password, email, fullName, dateOfBirth, gender, isAnonymous } = req.body;

  if (!username || !password || !email || !fullName || !dateOfBirth || !gender) {
    return res.status(400).send({ error: 'All fields are required' });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const query = 'INSERT INTO users (Username, PasswordHash, Email, FullName, DateOfBirth, Gender) VALUES (?, ?, ?, ?, ?, ?)';
    const values = [username, hashedPassword, email, fullName, dateOfBirth, gender];

    db.query(query, values, (error, results) => {
      if (error) {
        console.error('Database error:', error);
        return res.status(500).send({ error: 'Database error: ' + error.message });
      }
      res.status(201).send({ message: 'Account created successfully', userId: results.insertId });
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
        res.status(200).send({ 
          message: 'Login successful',
          userId: UserID // Include userId in the response
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
