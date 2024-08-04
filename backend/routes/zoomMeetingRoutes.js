// zoomMeetingRoutes.js
const express = require('express');
const router = express.Router();
const axios = require('axios');

const zoomAccountId = 'r9DzO1mLSYamuHcygWt9jA';
const zoomClientId = 'MJSiAjTAQj6MgfESYsE1wQ';
const zoomClientSecret = 'CuUUK2VvaIx6zTtwWm9ykrTH7IYWBRH8';

async function getZoomAccessToken() {
  const response = await axios.post('https://zoom.us/oauth/token', null, {
    params: {
      grant_type: 'account_credentials',
      account_id: zoomAccountId,
    },
    auth: {
      username: zoomClientId,
      password: zoomClientSecret,
    },
  });
  return response.data.access_token;
}

router.post('/create-zoom-meeting', async (req, res) => {
  const { userId, sessionId, topic, start_time, duration } = req.body;

  console.log('Received request to create Zoom meeting:', req.body);

  try {
    const accessToken = await getZoomAccessToken();
    
    const response = await axios.post('https://api.zoom.us/v2/users/me/meetings', {
      topic: topic,
      type: 2, // Scheduled meeting
      start_time: start_time,
      duration: duration,
      timezone: 'UTC'
    }, {
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      }
    });

    const meetingDetails = response.data;
    console.log('Zoom meeting created:', meetingDetails);

    res.status(200).json({
      id: meetingDetails.id,
      join_url: meetingDetails.join_url
    });
  } catch (error) {
    console.error('Zoom API error:', error.response ? error.response.data : error.message);
    res.status(500).json({ error: 'Failed to create Zoom meeting' });
  }
});

module.exports = router;