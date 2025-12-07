const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const spRoutes = require('./routes/sp.routes');
const adminRoutes = require('./routes/admin.routes');
const conversationRoutes = require('./routes/conversation.routes');
const reviewRoutes = require('./routes/review.routes');

const app = express();
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api/sp', spRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api', conversationRoutes);
app.use('/api', reviewRoutes);

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;