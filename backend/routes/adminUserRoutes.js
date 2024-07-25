// backend/routes/adminUserRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../db');

// Get all users
router.get('/', (req, res) => {
  db.query('SELECT UserID, Username, Email, FullName, DateOfBirth, Gender, IsAnonymous FROM users', (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(results);
  });
});

// Get a single user
router.get('/:id', (req, res) => {
  db.query('SELECT UserID, Username, Email, FullName, DateOfBirth, Gender, IsAnonymous FROM users WHERE UserID = ?', [req.params.id], (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (results.length === 0) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    res.json(results[0]);
  });
});

// Create a new user
router.post('/', (req, res) => {
  const { Username, Email, PasswordHash, FullName, DateOfBirth, Gender, IsAnonymous } = req.body;
  db.query(
    'INSERT INTO users (Username, Email, PasswordHash, FullName, DateOfBirth, Gender, IsAnonymous) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [Username, Email, PasswordHash, FullName, DateOfBirth, Gender, IsAnonymous],
    (err, result) => {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.status(201).json({ id: result.insertId, ...req.body });
    }
  );
});

// Update a user
router.put('/:id', (req, res) => {
  const { Username, Email, FullName, DateOfBirth, Gender, IsAnonymous } = req.body;
  db.query(
    'UPDATE users SET Username = ?, Email = ?, FullName = ?, DateOfBirth = ?, Gender = ?, IsAnonymous = ? WHERE UserID = ?',
    [Username, Email, FullName, DateOfBirth, Gender, IsAnonymous, req.params.id],
    (err, result) => {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ error: 'User not found' });
        return;
      }
      res.json({ id: req.params.id, ...req.body });
    }
  );
});

// Delete a user
router.delete('/:id', (req, res) => {
  db.query('DELETE FROM users WHERE UserID = ?', [req.params.id], (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    res.json({ message: 'User deleted successfully' });
  });
});

module.exports = router;