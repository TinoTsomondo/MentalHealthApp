// moodLogsRoutes.js
// Path: backend/routes/moodLogsRoutes.js

const express = require('express');
const router = express.Router();
const db = require('../db'); // Import the db connection

// Fetch mood logs for a specific user
router.get('/:userId', (req, res) => {
  const userId = req.params.userId;

  // Query the database for mood logs of the specified user
  db.query('SELECT * FROM mood_logs WHERE UserID = ?', [userId], (err, results) => {
    if (err) {
      // Handle database query error
      return res.status(500).json({ error: 'Database query failed' });
    }
    // Send the results as a response
    res.json(results);
  });
});

// Log a new mood entry
router.post('/', (req, res) => {
  const { UserID, MoodRating, MoodDescription, MoodTags } = req.body;
  const CreatedAt = new Date();
  const UpdatedAt = new Date();

  // Insert a new mood log into the database
  db.query(
    'INSERT INTO mood_logs (UserID, MoodRating, MoodDescription, MoodTags, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?)',
    [UserID, MoodRating, MoodDescription, MoodTags, CreatedAt, UpdatedAt],
    (err, results) => {
      if (err) {
        // Handle database query error
        return res.status(500).json({ error: 'Database query failed' });
      }
      // Send success message and new entry ID
      res.status(201).json({ message: 'Mood log added successfully', id: results.insertId });
    }
  );
});

module.exports = router;
