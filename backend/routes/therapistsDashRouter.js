// src/backend/routes/therapists.js
const express = require('express');
const router = express.Router();
const TherapistController = require('../controllers/TherapistController');
const { authenticate, authorize } = require('../middleware/authMiddleware');

router.get('/dashboard', authenticate, authorize('therapist'), TherapistController.getDashboardData);
router.get('/sessions', authenticate, authorize('therapist'), TherapistController.getSessions);
router.post('/sessions', authenticate, authorize('therapist'), TherapistController.addSession);
router.put('/sessions/:id', authenticate, authorize('therapist'), TherapistController.updateSession);
router.delete('/sessions/:id', authenticate, authorize('therapist'), TherapistController.deleteSession);

router.get('/session-logs', authenticate, authorize('therapist'), TherapistController.getSessionLogs);
router.put('/session-logs/:id', authenticate, authorize('therapist'), TherapistController.updateSessionLog);

router.get('/mood-logs', authenticate, authorize('therapist'), TherapistController.getMoodLogs);

router.get('/notifications', authenticate, authorize('therapist'), TherapistController.getNotifications);
router.post('/notifications/:id/read', authenticate, authorize('therapist'), TherapistController.markNotificationAsRead);

router.get('/analytics', authenticate, authorize('therapist'), TherapistController.getAnalyticsData);

router.get('/clients', authenticate, authorize('therapist'), TherapistController.getClients);
router.get('/clients/:username', authenticate, authorize('therapist'), TherapistController.getClientDetails);

module.exports = router;
