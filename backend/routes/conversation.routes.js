const express = require('express');
const router = express.Router();
const conversationController = require('../controllers/conversation.controller');
//const { authenticate } = require('../middlewares/auth.middleware');

// All routes require authentication
//router.use(authenticate);



// Get conversations for the authenticated user (homeowner OR service provider)
router.get('/conversations', conversationController.getUserConversations);

// Start a new conversation (any user can start with any other user)
router.post('/conversations', conversationController.startConversation);

// Get conversation participants
router.get('/conversations/:conversationId/participants', conversationController.getConversationParticipants);

// Get messages in a conversation
router.get('/conversations/:conversationId/messages', conversationController.getConversationMessages);

// Send a new message
router.post('/conversations/:conversationId/messages', conversationController.sendMessage);

module.exports = router;