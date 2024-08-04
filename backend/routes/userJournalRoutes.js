// routes/journal.js

const express = require('express');
const router = express.Router();
const db = require('../db');

// Get all journal entries for a user
router.get('/:userId', async (req, res) => {
  try {
    const [rows] = await db.promise().query(
      'SELECT * FROM journal_entries WHERE UserID = ? ORDER BY Date DESC',
      [req.params.userId]
    );
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create a new journal entry
router.post('/', async (req, res) => {
  const { userId, date, title, content } = req.body;
  try {
    const [result] = await db.promise().query(
      'INSERT INTO journal_entries (UserID, Date, Title, EntryContent) VALUES (?, ?, ?, ?)',
      [userId, date, title, content]
    );
    res.status(201).json({ id: result.insertId, message: 'Journal entry created successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get a specific journal entry
router.get('/entry/:id', async (req, res) => {
  try {
    const [rows] = await db.promise().query(
      'SELECT * FROM journal_entries WHERE JournalID = ?',
      [req.params.id]
    );
    if (rows.length === 0) {
      res.status(404).json({ message: 'Journal entry not found' });
    } else {
      res.json(rows[0]);
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;