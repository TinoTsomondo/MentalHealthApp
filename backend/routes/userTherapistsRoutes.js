// therapistRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', (req, res) => {
  const query = 'SELECT TherapistID, FullName, Email FROM therapists';
  
  db.query(query, (error, results) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }
    res.status(200).json(results);
  });
});

module.exports = router;