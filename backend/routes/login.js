const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

dotenv.config();

const SECRET_KEY = process.env.SECRET_KEY;

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).send({ error: 'Email and password are required' });
  }

  try {
    let query;
    let table;
    let column;
    let redirectUrl;
    let idColumn;

    if (email.endsWith('@weheal.com')) {
      table = 'therapists';
      column = 'Email';
      redirectUrl = '/therapists/dashboard';
      idColumn = 'TherapistID';
    } else if (email.endsWith('@admin.weheal.com')) {
      table = 'admins';
      column = 'Email';
      redirectUrl = '/admins/dashboard';
      idColumn = 'AdminID';
    } else {
      return res.status(401).send({ error: 'Invalid email domain' });
    }

    query = `SELECT * FROM ${table} WHERE ${column} = ?`;

    db.query(query, [email], async (error, results) => {
      if (error) {
        console.error('Database error:', error);
        return res.status(500).send({ error: 'Database error: ' + error.message });
      }

      if (results.length === 0) {
        return res.status(401).send({ error: 'Invalid email or password' });
      }

      const user = results[0];
      console.log('User retrieved from database:', user);

      if (!user.PasswordHash) {
        console.error('PasswordHash is null or undefined for user:', email);
        return res.status(500).send({ error: 'Internal server error' });
      }

      try {
        const match = await bcrypt.compare(password, user.PasswordHash);

        if (!match) {
          return res.status(401).send({ error: 'Invalid email or password' });
        }

        const token = jwt.sign(
          { userId: user[idColumn], role: table === 'therapists' ? 'therapist' : 'admin' },
          SECRET_KEY,
          { expiresIn: '1h' }
        );

        res.status(200).send({ 
          message: 'Login successful', 
          token, 
          redirectUrl,
          userId: user[idColumn],
          role: table === 'therapists' ? 'therapist' : 'admin'
        });
      } catch (bcryptError) {
        console.error('bcrypt compare error:', bcryptError);
        res.status(500).send({ error: 'Error verifying password' });
      }
    });
  } catch (err) {
    console.error('Error during login:', err);
    res.status(500).send({ error: 'Error during login: ' + err.message });
  }
});

module.exports = router;
