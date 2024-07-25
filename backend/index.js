// index.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = 3001;

app.use(cors());
app.use(bodyParser.json());

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
const therapySessionsRoutes = safeImport('./routes/therapySessionsRoutes');
const adminReportRouter = safeImport('./routes/adminReportRoutes');
const adminUserRouter = safeImport('./routes/adminUserRoutes');
const adminTherapistRouter = safeImport('./routes/adminTherapistRoutes');

app.use('/web-api/auth', authWebRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/moodlogs', moodLogsRoutes);
app.use('/api/chats', chatRoutes);
app.use('/api/therapy-sessions', therapySessionsRoutes);
app.use('/api/admin/reports', adminReportRouter);
app.use('/api/admin/users', adminUserRouter);
app.use('/api/admin/therapists', adminTherapistRouter);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});