const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const port = process.env.PORT || 3001;

app.use(cors());
app.use(bodyParser.json());

const db = require('./db');

function safeImport(path) {
    try {
        const module = require(path);
        console.log(`Successfully imported ${path}`);
        return module;
    } catch (error) {
        console.error(`Error importing ${path}:`, error);
        return express.Router(); // Return an empty router
    }
}

const authWebRoutes = safeImport('./routes/authWebRoutes');
const authRoutes = safeImport('./routes/authRoutes');
const moodLogsRoutes = safeImport('./routes/moodLogsRoutes');
const chatRoutes = safeImport('./routes/chatRoutes');
const therapySessionsRoutes = safeImport('./routes/userTherapySessionsRoutes');
const adminReportRouter = safeImport('./routes/adminReportRoutes');
const adminUserRouter = safeImport('./routes/adminUserRoutes');
const adminTherapistRouter = safeImport('./routes/adminTherapistRoutes');
const therapistsDashRouter = safeImport('./routes/therapistsDashRouter');
const userJournalRoutes = safeImport('./routes/userJournalRoutes');
const zoomMeetingRoutes = require('./routes/zoomMeetingRoutes');
const userTherapistsRoutes = require('./routes/userTherapistsRoutes');

app.use('/web-api/auth', authWebRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/moodlogs', moodLogsRoutes);
app.use('/api/chats', chatRoutes);
app.use('/api/therapy-sessions', therapySessionsRoutes);
app.use('/api/admin/reports', adminReportRouter);
app.use('/api/admin/users', adminUserRouter);
app.use('/api/admin/therapists', adminTherapistRouter);
app.use('/api/therapists', therapistsDashRouter);
app.use('/api/journal', userJournalRoutes);
app.use('/api', zoomMeetingRoutes);
app.use('/api/therapists', userTherapistsRoutes); // Add this line

// WebSocket connection handling
io.on('connection', (socket) => {
  console.log('New client connected');

  socket.on('join', (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined their room`);
  });

  socket.on('sendMessage', async (data) => {
    const { senderId, receiverId, message } = data;
    try {
      const query = 'INSERT INTO chats (SenderID, ReceiverID, Message, Timestamp) VALUES (?, ?, ?, NOW())';
      const [result] = await db.promise().query(query, [senderId, receiverId, message]);
      
      const newMessage = {
        text: message,
        sender: 'user',
        timestamp: new Date().toISOString(),
      };

      io.to(senderId).emit('newMessage', newMessage);
      io.to(receiverId).emit('newMessage', { ...newMessage, sender: 'contact' });
    } catch (err) {
      console.error('Error sending message:', err);
    }
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});