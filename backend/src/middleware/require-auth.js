const { auth } = require('../firebase');

async function requireAuth(req, res, next) {
  const header = req.get('authorization') || '';
  const match = header.match(/^Bearer\s+(.+)$/i);

  if (!match) {
    return res.status(401).json({ error: 'Missing Bearer token' });
  }

  try {
    req.user = await auth.verifyIdToken(match[1], true);
    return next();
  } catch (error) {
    if (error.code === 'auth/id-token-revoked') {
      return res.status(401).json({ error: 'Firebase ID token has been revoked' });
    }
    if (error.code === 'auth/argument-error' || error.code === 'auth/invalid-argument') {
      return res.status(401).json({
        error: 'Invalid Firebase ID token',
        details: 'The token may be malformed or issued for a different Firebase project.'
      });
    }
    console.error('Firebase ID token verification failed:', error.code, error.message);
    return res.status(401).json({
      error: 'Invalid Firebase ID token',
      details: 'Check that the backend uses the zalono-partner Firebase project and a valid Admin SDK service account.'
    });
  }
}

module.exports = { requireAuth };
