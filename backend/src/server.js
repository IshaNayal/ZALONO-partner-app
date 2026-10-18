require('dotenv').config();

const cors = require('cors');
const express = require('express');
const helmet = require('helmet');
const { auth } = require('./firebase');
const authRoutes = require('./routes/auth');
const onboardingRoutes = require('./routes/onboarding');

const app = express();
const port = Number(process.env.PORT || 8080);
const allowedOrigins = (process.env.ALLOWED_ORIGINS || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);
const isDevelopment = process.env.NODE_ENV !== 'production';

app.use(helmet());
app.use(express.json({ limit: '100kb' }));
app.use(cors({
  origin(origin, callback) {
    const isLocalOrigin = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin || '');
    if (!origin || allowedOrigins.includes('*') || allowedOrigins.includes(origin) ||
        (isDevelopment && isLocalOrigin)) {
      return callback(null, true);
    }
    return callback(new Error('Origin is not allowed by CORS'));
  }
}));

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'zalono-partner-backend' });
});

app.get('/api/auth/config', (_req, res) => {
  res.json({ projectId: process.env.FIREBASE_PROJECT_ID || null });
});

app.use('/api/auth', authRoutes);
app.use('/api/onboarding', onboardingRoutes);

app.use((error, _req, res, _next) => {
  if (error.message === 'Origin is not allowed by CORS') {
    return res.status(403).json({ error: error.message });
  }
  console.error(error);
  return res.status(500).json({ error: 'Internal server error' });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Zalono Partner backend listening on port ${port}`);
  });
}

module.exports = app;
