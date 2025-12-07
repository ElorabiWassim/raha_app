const { body, param, query } = require('express-validator');

// Conversation validators
const startConversationValidator = [
  body('other_user_id')
    .notEmpty()
    .withMessage('other_user_id is required')
    .isUUID()
    .withMessage('other_user_id must be a valid UUID'),
];

const sendMessageValidator = [
  param('conversationId')
    .notEmpty()
    .withMessage('conversationId is required')
    .isUUID()
    .withMessage('conversationId must be a valid UUID'),
  body('message_text')
    .optional()
    .isString()
    .withMessage('message_text must be a string')
    .trim()
    .isLength({ min: 1, max: 5000 })
    .withMessage('message_text must be between 1 and 5000 characters'),
  body('attachment_url')
    .optional()
    .isURL()
    .withMessage('attachment_url must be a valid URL'),
  body()
    .custom((value) => {
      if (!value.message_text && !value.attachment_url) {
        throw new Error('Either message_text or attachment_url is required');
      }
      return true;
    }),
];

const conversationIdValidator = [
  param('conversationId')
    .notEmpty()
    .withMessage('conversationId is required')
    .isUUID()
    .withMessage('conversationId must be a valid UUID'),
];

module.exports = {
  startConversationValidator,
  sendMessageValidator,
  conversationIdValidator,
};
