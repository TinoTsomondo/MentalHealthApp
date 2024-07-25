const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', (req, res) => {
  const userId = req.query.userId;
  console.log('Fetching therapy sessions for user:', userId);

  const query = `
    SELECT SessionID, UserID, TherapistID, ScheduledAt, Duration, SessionAgenda, 
           CreatedAt, UpdatedAt, TherapistName, TherapistEmail 
    FROM therapy_sessions 
    WHERE UserID = ?
    ORDER BY ScheduledAt DESC
  `;
  
  db.query(query, [userId], (error, results) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }
    console.log('Fetched therapy sessions:', results);
    res.status(200).json(results);
  });
});

module.exports = router;