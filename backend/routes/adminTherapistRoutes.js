// routes/adminTherapistRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', (req, res) => {
  db.query('SELECT TherapistID, FullName, Email, Specialization FROM therapists', (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(results);
  });
});

router.get('/:id', (req, res) => {
  const therapistId = req.params.id;
  db.query('SELECT * FROM therapists WHERE TherapistID = ?', [therapistId], (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (results.length === 0) {
      res.status(404).json({ error: 'Therapist not found' });
      return;
    }
    res.json(results[0]);
  });
});

module.exports = router;