// userTherapySessionsRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', (req, res) => {
  const userId = req.query.userId;
  console.log('Fetching therapy sessions for user:', userId);

  const query = `
    SELECT 
      ts.SessionID, ts.UserID, ts.TherapistID, ts.ScheduledAt, ts.Duration, ts.SessionAgenda, 
      ts.CreatedAt, ts.UpdatedAt, ts.ZoomMeetingId, ts.ZoomMeetingUrl,
      t.FullName AS TherapistName, t.Email AS TherapistEmail
    FROM therapy_sessions ts
    JOIN therapists t ON ts.TherapistID = t.TherapistID
    WHERE ts.UserID = ?
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

router.post('/', (req, res) => {
  const { UserID, TherapistID, TherapistName, ScheduledAt, Duration, SessionAgenda } = req.body;
  
  console.log("Received booking request with data:", req.body);
  
  const insertQuery = `
    INSERT INTO therapy_sessions 
    (UserID, TherapistID, ScheduledAt, Duration, SessionAgenda, CreatedAt, UpdatedAt, TherapistName)
    VALUES (?, ?, ?, ?, ?, NOW(), NOW(), ?)
  `;
  
  db.query(insertQuery, [UserID, TherapistID, ScheduledAt, Duration, SessionAgenda, TherapistName], (error, result) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }
    
    const insertedId = result.insertId;
    
    // Fetch the inserted session
    const fetchQuery = `
      SELECT 
        ts.SessionID, ts.UserID, ts.TherapistID, ts.ScheduledAt, ts.Duration, ts.SessionAgenda, 
        ts.CreatedAt, ts.UpdatedAt, ts.ZoomMeetingId, ts.ZoomMeetingUrl,
        t.FullName AS TherapistName, t.Email AS TherapistEmail
      FROM therapy_sessions ts
      JOIN therapists t ON ts.TherapistID = t.TherapistID
      WHERE ts.SessionID = ?
    `;
    
    db.query(fetchQuery, [insertedId], (fetchError, fetchResults) => {
      if (fetchError) {
        console.error('Database error:', fetchError);
        return res.status(500).json({ error: 'Database error: ' + fetchError.message });
      }
      
      res.status(201).json(fetchResults[0]);
    });
  });
});

router.put('/:sessionId', (req, res) => {
  const { sessionId } = req.params;
  const { ZoomMeetingId, ZoomMeetingUrl } = req.body;

  console.log(`Updating session ${sessionId} with Zoom details:`, { ZoomMeetingId, ZoomMeetingUrl });

  const updateQuery = `
    UPDATE therapy_sessions ts
    JOIN therapists t ON ts.TherapistID = t.TherapistID
    SET ts.ZoomMeetingId = ?, 
        ts.ZoomMeetingUrl = ?, 
        ts.UpdatedAt = NOW(),
        ts.TherapistEmail = t.Email
    WHERE ts.SessionID = ?
  `;

  db.query(updateQuery, [ZoomMeetingId, ZoomMeetingUrl, sessionId], (error, result) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }

    console.log(`Updated ${result.affectedRows} rows`);

    // Fetch the updated session
    const fetchQuery = `
      SELECT 
        ts.SessionID, ts.UserID, ts.TherapistID, ts.ScheduledAt, ts.Duration, ts.SessionAgenda, 
        ts.CreatedAt, ts.UpdatedAt, ts.ZoomMeetingId, ts.ZoomMeetingUrl,
        t.FullName AS TherapistName, t.Email AS TherapistEmail
      FROM therapy_sessions ts
      JOIN therapists t ON ts.TherapistID = t.TherapistID
      WHERE ts.SessionID = ?
    `;

    db.query(fetchQuery, [sessionId], (fetchError, fetchResults) => {
      if (fetchError) {
        console.error('Database error:', fetchError);
        return res.status(500).json({ error: 'Database error: ' + fetchError.message });
      }

      console.log('Updated session:', fetchResults[0]);
      res.status(200).json(fetchResults[0]);
    });
  });
});

router.get('/therapists', (req, res) => {
  const query = 'SELECT TherapistID, FullName FROM therapists';
  
  db.query(query, (error, results) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }
    console.log('Fetched therapists:', results);
    res.status(200).json(results);
  });
});


// Add these new routes:

router.put('/reschedule/:sessionId', (req, res) => {
  const { sessionId } = req.params;
  const { ScheduledAt, Duration, SessionAgenda } = req.body;

  const updateQuery = `
    UPDATE therapy_sessions
    SET ScheduledAt = ?, Duration = ?, SessionAgenda = ?, UpdatedAt = NOW()
    WHERE SessionID = ?
  `;

  db.query(updateQuery, [ScheduledAt, Duration, SessionAgenda, sessionId], (error, result) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }

    // Fetch the updated session
    const fetchQuery = `
      SELECT 
        ts.SessionID, ts.UserID, ts.TherapistID, ts.ScheduledAt, ts.Duration, ts.SessionAgenda, 
        ts.CreatedAt, ts.UpdatedAt, ts.ZoomMeetingId, ts.ZoomMeetingUrl,
        t.FullName AS TherapistName, t.Email AS TherapistEmail
      FROM therapy_sessions ts
      JOIN therapists t ON ts.TherapistID = t.TherapistID
      WHERE ts.SessionID = ?
    `;

    db.query(fetchQuery, [sessionId], (fetchError, fetchResults) => {
      if (fetchError) {
        console.error('Database error:', fetchError);
        return res.status(500).json({ error: 'Database error: ' + fetchError.message });
      }

      res.status(200).json(fetchResults[0]);
    });
  });
});

router.delete('/:sessionId', (req, res) => {
  const { sessionId } = req.params;

  const deleteQuery = `
    DELETE FROM therapy_sessions
    WHERE SessionID = ?
  `;

  db.query(deleteQuery, [sessionId], (error, result) => {
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Database error: ' + error.message });
    }

    res.status(200).json({ message: 'Session cancelled successfully' });
  });
});

module.exports = router;