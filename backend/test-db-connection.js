// test-db-connection.js
const pool = require('./db');

async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('Connected to MySQL as ID:', connection.threadId);
    connection.release();
  } catch (err) {
    console.error('Error connecting to MySQL:', err.stack);
  }
}

testConnection();
