const express = require('express');
const router = express.Router();
const db = require('../db');

// Fetch chats for a user
router.get('/:userId', (req, res) => {
  const userId = req.params.userId;
  const query = `
    SELECT 
      c.ChatID,
      CASE 
        WHEN c.SenderID = ? THEN u2.Username
        ELSE u1.Username
      END AS contactName,
      CASE 
        WHEN c.SenderID = ? THEN u2.UserID
        ELSE u1.UserID
      END AS contactId,
      c.Message,
      c.Timestamp,
      CASE 
        WHEN c.SenderID = ? THEN u2.Gender
        ELSE u1.Gender
      END AS Gender
    FROM chats c
    JOIN users u1 ON c.SenderID = u1.UserID
    JOIN users u2 ON c.ReceiverID = u2.UserID
    WHERE (c.SenderID = ? OR c.ReceiverID = ?)
      AND c.Timestamp = (
        SELECT MAX(Timestamp)
        FROM chats c2
        WHERE (c2.SenderID = c.SenderID AND c2.ReceiverID = c.ReceiverID)
           OR (c2.SenderID = c.ReceiverID AND c2.ReceiverID = c.SenderID)
      )
    ORDER BY c.Timestamp DESC;
  `;

  db.query(query, [userId, userId, userId, userId, userId], (err, results) => {
    if (err) {
      console.error('Error fetching chat messages:', err);
      return res.status(500).json({ error: 'Internal server error' });
    }
    const sanitizedResults = results.map(result => ({
      ...result,
      contactName: result.contactName || 'Unknown',
      Message: result.Message || '',
      Timestamp: result.Timestamp || new Date().toISOString()
    }));
    res.json(sanitizedResults);
  });
});

// Fetch messages for a specific chat
router.get('/messages/:userId/:contactId', (req, res) => {
  const userId = req.params.userId;
  const contactId = req.params.contactId;

  const query = `
    SELECT 
      Message as text,
      CASE 
        WHEN SenderID = ? THEN 'user'
        ELSE 'contact'
      END AS sender,
      Timestamp
    FROM chats
    WHERE (SenderID = ? AND ReceiverID = ?) OR (SenderID = ? AND ReceiverID = ?)
    ORDER BY Timestamp DESC;
  `;

  db.query(query, [userId, userId, contactId, contactId, userId], (err, results) => {
    if (err) {
      console.error('Error fetching chat messages:', err);
      return res.status(500).json({ error: 'Internal server error' });
    }
    res.json(results);
  });
});

// Fetch new messages
router.get('/messages/:userId/:contactId/new', (req, res) => {
  const userId = req.params.userId;
  const contactId = req.params.contactId;
  const latestTimestamp = req.query.timestamp;

  const query = `
    SELECT 
      Message as text,
      CASE 
        WHEN SenderID = ? THEN 'user'
        ELSE 'contact'
      END AS sender,
      Timestamp
    FROM chats
    WHERE ((SenderID = ? AND ReceiverID = ?) OR (SenderID = ? AND ReceiverID = ?))
      AND Timestamp > ?
    ORDER BY Timestamp ASC;
  `;

  db.query(query, [userId, userId, contactId, contactId, userId, latestTimestamp], (err, results) => {
    if (err) {
      console.error('Error fetching new messages:', err);
      return res.status(500).json({ error: 'Internal server error' });
    }
    res.json(results);
  });
});

// Note: The 'send' route is no longer needed here as it's handled by WebSocket

module.exports = router;