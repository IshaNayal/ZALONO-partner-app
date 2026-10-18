# Zalono Partner backend

This service provides the server-side boundary for Firebase Authentication and
Firestore-backed partner profiles. The Flutter app must obtain a Firebase ID
token using the Firebase client SDK and send it as:

```http
Authorization: Bearer <firebase-id-token>
```

## Firebase setup

1. Create or select a Firebase project.
2. Enable the Anonymous sign-in provider (the Flutter registration upload uses
   it to obtain a verified ID token), plus Phone and/or Email/Password if those
   providers are used for the app's login UX.
3. Create a Firestore database.
4. Create a Firebase Admin service account.
5. Copy `.env.example` to `.env`.
6. Set `FIREBASE_PROJECT_ID` and either:
   - `FIREBASE_SERVICE_ACCOUNT_JSON` to the service-account JSON as one line, or
   - `GOOGLE_APPLICATION_CREDENTIALS` to a local service-account JSON path.
7. Set `FIREBASE_STORAGE_BUCKET` to the Storage bucket shown in Firebase
   Console > Storage.

Never commit a service-account JSON file or `.env`.

`google-services.json` is a client configuration file and cannot be used as
the Admin SDK credential. For this backend, download a service-account key from
Firebase Console > Project settings > Service accounts, then set
`FIREBASE_SERVICE_ACCOUNT_JSON` to its JSON contents (or use
`GOOGLE_APPLICATION_CREDENTIALS`).

## Run locally

```powershell
cd backend
npm install
Copy-Item .env.example .env
npm start
```

The health check is available at `http://localhost:8080/health`.

In development, requests from any `localhost` or `127.0.0.1` browser port are
allowed. In production, set `ALLOWED_ORIGINS` to the exact deployed app origin.

## API

- `GET /health` - unauthenticated service health check
- `GET /api/auth/config` - exposes only the Firebase project ID
- `GET /api/auth/me` - returns the verified Firebase user and stored profile
- `PUT /api/auth/profile` - merges validated partner profile fields into
  `users/{firebaseUid}` in Firestore
- `PUT /api/onboarding` - stores the complete non-image onboarding form in
  `onboardingApplications/{firebaseUid}`. Send it as `multipart/form-data` with
  the scalar fields `mobileNumber`, `fullName`, `email`, `gstNumber`,
  `salonName`, `salonCategory`, `completeAddress`, and `pincode`; JSON fields
  `location`, `salonServices`, `serviceOfferings`, `stylists`, and `timings`;
  and files named `panCard`, `aadhaarCard`, `businessProof`, and repeated
  `salonPhotos` fields.
- `GET /api/onboarding` - reads the authenticated user's onboarding record

The first successful onboarding submission also stores `registeredAt` as a
Firestore timestamp, plus `registrationDate`, `registrationTime`, and
`registrationTimeZone` (`UTC`). These registration fields remain unchanged on
later edits; `updatedAt` is refreshed on every save.

Image and document persistence is currently disabled. Any uploaded image fields
are accepted for backwards compatibility and discarded. The non-image fields
are stored in Firestore. Firebase Storage can be enabled later without changing
the Firestore application schema.

The Admin SDK verifies tokens against Firebase and rejects revoked tokens.
