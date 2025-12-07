const express = require('express');
const router = express.Router();
const conversationController = require('../controllers/conversation.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { validate } = require('../middlewares/validation.middleware');
const {
  startConversationValidator,
  sendMessageValidator,
  conversationIdValidator,
} = require('../validators/conversation.validator');

router.use(authenticate);

router.get('/conversations', conversationController.getUserConversations);
router.post('/conversations', validate(startConversationValidator), conversationController.startConversation);
router.get('/conversations/:conversationId/participants', validate(conversationIdValidator), conversationController.getConversationParticipants);
router.get('/conversations/:conversationId/messages', validate(conversationIdValidator), conversationController.getConversationMessages);
router.post('/conversations/:conversationId/messages', validate(sendMessageValidator), conversationController.sendMessage);

module.exports = router;