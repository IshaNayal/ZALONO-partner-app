const express = require('express');
const { db } = require('../firebase');
const { requireAuth } = require('../middleware/require-auth');

const router = express.Router();

router.get('/me', requireAuth, async (req, res, next) => {
  try {
    const snapshot = await db.collection('users').doc(req.user.uid).get();
    return res.json({
      user: {
        uid: req.user.uid,
        email: req.user.email || null,
        phoneNumber: req.user.phone_number || null,
        emailVerified: Boolean(req.user.email_verified),
        profile: snapshot.exists ? snapshot.data() : null
      }
    });
  } catch (error) {
    return next(error);
  }
});

router.put('/profile', requireAuth, async (req, res, next) => {
  const allowedFields = [
    'ownerName',
    'salonName',
    'salonCategory',
    'salonServes',
    'address',
    'gstNumber'
  ];
  const profile = {};

  for (const field of allowedFields) {
    if (req.body[field] !== undefined) {
      if (typeof req.body[field] !== 'string') {
        return res.status(400).json({ error: `${field} must be a string` });
      }
      profile[field] = req.body[field].trim();
    }
  }

  if (Object.keys(profile).length === 0) {
    return res.status(400).json({ error: 'At least one profile field is required' });
  }

  try {
    profile.updatedAt = new Date();
    await db.collection('users').doc(req.user.uid).set(profile, { merge: true });
    return res.json({ profile });
  } catch (error) {
    return next(error);
  }
});

module.exports = router;
