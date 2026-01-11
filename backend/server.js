const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const spRoutes = require('./routes/sp.routes');
const adminRoutes = require('./routes/admin.routes');
const conversationRoutes = require('./routes/conversation.routes');
const reviewRoutes = require('./routes/review.routes');
const profileRoutes = require('./routes/profile.routes');
const homeownerRoutes = require('./routes/homeownerRoutes');
const loginRoutes = require('./routes/login.routes');
const verificationRoutes = require('./routes/verification.routes');

const app = express();
// These endpoints are user-specific and should not be cached by browsers/CDNs.
// Disabling ETags avoids 304 responses that can prevent clients from receiving
// updated profile fields (like profile pictures) after login.
app.set('etag', false);
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/profile', (req, res, next) => {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  next();
});

app.use('/api/auth', loginRoutes);
app.use('/api/verification', verificationRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api', conversationRoutes);
app.use('/api', reviewRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/sp', spRoutes);
app.use('/homeowner', homeownerRoutes);
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 5000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;
