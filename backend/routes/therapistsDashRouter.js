// src/routes/therapistsDashRouter.js

const express = require('express');
const db = require('../../backend/db'); // Adjust this path to your actual database connection file

const router = express.Router();

router.get('/:therapistId/sessions', async (req, res) => {
  try {
    const therapistId = req.params.therapistId;
    const query = `
      SELECT ts.*, u.Fullname AS PatientName
      FROM therapy_sessions ts
      JOIN users u ON ts.UserID = u.UserID
      WHERE ts.TherapistID = ?
      ORDER BY ts.ScheduledAt ASC
    `;
    const [rows] = await db.query(query, [therapistId]);
    res.json(rows);
  } catch (error) {
    console.error('Error fetching therapist sessions:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add other routes as needed

module.exports = router;