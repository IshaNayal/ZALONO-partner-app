const express = require('express');
const multer = require('multer');
const { admin, db } = require('../firebase');
const { requireAuth } = require('../middleware/require-auth');

const router = express.Router();
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    files: 10,
    fileSize: 10 * 1024 * 1024
  }
});

const uploadFields = upload.fields([
  { name: 'panCard', maxCount: 1 },
  { name: 'aadhaarCard', maxCount: 1 },
  { name: 'businessProof', maxCount: 1 },
  { name: 'salonPhotos', maxCount: 7 }
]);

function parseJsonField(body, name, fallback) {
  if (body[name] === undefined || body[name] === '') {
    return fallback;
  }
  if (typeof body[name] !== 'string') {
    return body[name];
  }
  try {
    return JSON.parse(body[name]);
  } catch (_error) {
    throw new Error(`${name} must be valid JSON`);
  }
}

function requireString(body, name) {
  const value = body[name];
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(`${name} is required`);
  }
  return value.trim();
}

function optionalString(body, name) {
  const value = body[name];
  if (value === undefined || value === '') {
    return '';
  }
  if (typeof value !== 'string') {
    throw new Error(`${name} must be a string`);
  }
  return value.trim();
}

function validateLocation(value) {
  if (!value || typeof value !== 'object') {
    throw new Error('location is required');
  }
  const latitude = Number(value.latitude);
  const longitude = Number(value.longitude);
  if (!Number.isFinite(latitude) || latitude < -90 || latitude > 90) {
    throw new Error('location.latitude must be between -90 and 90');
  }
  if (!Number.isFinite(longitude) || longitude < -180 || longitude > 180) {
    throw new Error('location.longitude must be between -180 and 180');
  }
  return new admin.firestore.GeoPoint(latitude, longitude);
}

function validateArray(value, name) {
  if (!Array.isArray(value)) {
    throw new Error(`${name} must be an array`);
  }
  return value;
}

router.put('/', requireAuth, uploadFields, async (req, res, next) => {
  try {
    const applicationRef = db.collection('onboardingApplications').doc(req.user.uid);
    const existingApplication = await applicationRef.get();
    const now = new Date();
    const location = validateLocation(parseJsonField(req.body, 'location', null));
    const salonServices = validateArray(
      parseJsonField(req.body, 'salonServices', []),
      'salonServices'
    );
    const serviceOfferings = validateArray(
      parseJsonField(req.body, 'serviceOfferings', []),
      'serviceOfferings'
    );
    const stylists = validateArray(
      parseJsonField(req.body, 'stylists', []),
      'stylists'
    );
    const timings = parseJsonField(req.body, 'timings', {});
    if (!timings || typeof timings !== 'object' || Array.isArray(timings)) {
      throw new Error('timings must be an object');
    }

    const application = {
      mobileNumber: requireString(req.body, 'mobileNumber'),
      fullName: requireString(req.body, 'fullName'),
      email: requireString(req.body, 'email'),
      gstNumber: optionalString(req.body, 'gstNumber'),
      salonName: requireString(req.body, 'salonName'),
      salonCategory: requireString(req.body, 'salonCategory'),
      salonServices,
      serviceOfferings,
      location,
      completeAddress: requireString(req.body, 'completeAddress'),
      pincode: requireString(req.body, 'pincode'),
      stylists,
      timings,
      documents: {},
      salonPhotos: [],
      status: 'submitted',
      ...(existingApplication.exists
        ? {}
        : {
            registeredAt: admin.firestore.Timestamp.fromDate(now),
            registrationDate: now.toISOString().slice(0, 10),
            registrationTime: now.toISOString().slice(11, 19),
            registrationTimeZone: 'UTC'
          }),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    await applicationRef.set(application, {
      merge: true
    });
    return res.status(200).json({
      application: {
        ...application,
        updatedAt: undefined
      }
    });
  } catch (error) {
    console.error('Onboarding submission failed:', error);
    if (error.code === 404 && error.message.includes('bucket does not exist')) {
      return res.status(503).json({
        error: 'Firebase Storage is not enabled or the configured storage bucket does not exist.',
        details: 'Create Firebase Storage and set FIREBASE_STORAGE_BUCKET to the bucket name shown in Firebase Console.'
      });
    }
    if (error instanceof multer.MulterError || error.message.endsWith('is required') ||
        error.message.includes('must be') || error.message.includes('must be between')) {
      return res.status(400).json({ error: error.message });
    }
    return next(error);
  }
});

router.get('/', requireAuth, async (req, res, next) => {
  try {
    const snapshot = await db.collection('onboardingApplications').doc(req.user.uid).get();
    return res.json({ application: snapshot.exists ? snapshot.data() : null });
  } catch (error) {
    return next(error);
  }
});

module.exports = router;
