const admin = require('firebase-admin');

function parseServiceAccount() {
  const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (!raw) {
    return undefined;
  }

  try {
    const credentials = JSON.parse(raw);
    if (credentials.private_key) {
      credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
    }
    return credentials;
  } catch (error) {
    throw new Error(`FIREBASE_SERVICE_ACCOUNT_JSON is not valid JSON: ${error.message}`);
  }
}

function initializeFirebase() {
  if (admin.apps.length > 0) {
    return admin.app();
  }

  const serviceAccount = parseServiceAccount();
  const options = {
    projectId: process.env.FIREBASE_PROJECT_ID || serviceAccount?.project_id,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET
  };

  if (serviceAccount) {
    options.credential = admin.credential.cert(serviceAccount);
  } else {
    options.credential = admin.credential.applicationDefault();
  }

  return admin.initializeApp(options);
}

const firebaseApp = initializeFirebase();

module.exports = {
  admin,
  auth: admin.auth(firebaseApp),
  db: admin.firestore(firebaseApp),
  bucket: admin.storage(firebaseApp).bucket()
};
