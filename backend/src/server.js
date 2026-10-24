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

function isLocalNetworkOrigin(origin) {
  try {
    const { hostname, protocol } = new URL(origin);
    if (protocol !== 'http:' && protocol !== 'https:') return false;
    if (hostname === 'localhost' || hostname === '127.0.0.1') return true;
    const octets = hostname.split('.').map(Number);
    if (octets.length !== 4 || octets.some((octet) => !Number.isInteger(octet) || octet < 0 || octet > 255)) {
      return false;
    }
    return octets[0] === 10 ||
      (octets[0] === 172 && octets[1] >= 16 && octets[1] <= 31) ||
      (octets[0] === 192 && octets[1] === 168);
  } catch (_) {
    return false;
  }
}

app.use(helmet());
app.use(express.json({ limit: '100kb' }));
app.use(cors({
  origin(origin, callback) {
    if (!origin || allowedOrigins.includes('*') || allowedOrigins.includes(origin) ||
        isLocalNetworkOrigin(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Origin is not allowed by CORS'));
  }
}));

app.get('/', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'zalono-partner-backend',
    health: '/health'
  });
});

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
  app.listen(port, '0.0.0.0', () => {
    console.log(`Zalono Partner backend listening on port ${port}`);
  });
}

module.exports = app;
