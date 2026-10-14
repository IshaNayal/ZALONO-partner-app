# Zalono Salon Partner App (Flutter · iOS & Android)

A complete mobile application for salon owners to register with an onboarding code, manage daily operations, track bookings, add walk-ins, toggle stylist availability, collect payments, and configure salon details. Built with Flutter and Dart for both **iOS** and **Android**.

---

## 📱 Features & Screen Flow (MVP Pilot 31 Screens)

### 1. Registration Flow (`pp. 2–13`)
- **R1 · Welcome**: Value prop ("Run your day from your phone"), live booking preview card, Log in / Partner buttons.
- **R2 · Verify mobile**: 6-digit SMS OTP verification for salon credentials.
- **R3 · Onboarding code**: Gatekeeper screen verifying partner code (`ZL-4821`) from a Zalono executive.
- **R4 · About the owner**: Name, email with instant verify trigger, document checklist (PAN, Aadhaar, Business proof), and optional GST number.
- **R5 · Verify email**: 6-digit email confirmation OTP.
- **R6 · Salon details**: 3–5 photo gallery, name, tier category (Basic, Medium, Premium, Ultra Premium), clientele served (Men, Women, Unisex, Other), custom niche category.
- **R7 · Location**: Visual map pin locator, "Use my current location", complete street address, and PIN code.
- **R8 · Services**: Multi-category offerings (Hair, Skin, Nails, Body), dynamic duration and price tags, "+ Add service".
- **R9 · Who works here**: Stylist roster with specialized service tags.
- **R10 · Timings**: Shift hours, split day timings (e.g., lunch breaks), toggles, and "Copy Monday's timings to all days".
- **R11 · Review and agree**: Complete overview summary with quick "Edit" jump links and terms check.
- **R12 · Submitted**: Multi-stage verification progress tracker.

### 2. Login & Daily Use (`pp. 14–25`)
- **A1 · Login**: Registered phone number login with OTP.
- **A2 · Login blocked**: "Not approved yet" warning card while salon verification is pending.
- **A3 · Approved notification**: Simulated OS push notification alert granting instant entry.
- **A4 · Home**: Real-time "Accepting bookings" master toggle, time filters (Today, This week, This month, Custom), online revenue and bookings KPI cards, stylist availability summary, and primary "+ Add walk-in" action.
- **A5 · Add walk-in**: Customer name, phone, instant multi-service selection, stylist live schedule check, and auto time block calculation.
- **A6 · Bookings (Upcoming)**: Real-time "In chair" customer tracker with "Mark done" and upcoming confirmed queue with ETA status.
- **A7 · Bookings (History)**: Chronological order logs with Done, No-show, and Cancelled filter tabs.
- **A8 · Booking detail**: Customer status ETA, direct call button, and salon check-in.
- **A9 · Complete and mark paid**: Itemized bill breakdown, payment method recorder (Cash, UPI, Card), and real-time daily revenue increment.
- **A10 · Stylists**: Availability toggles for all staff, off-duty status timers, and dynamic customer booking view preview.
- **A11 · Turn a stylist off**: Intelligent conflict resolver bottom sheet allowing shift duration pause and 1-tap booking reassignment to available peers.
- **A12 · Notifications**: Real-time push hub with actionable inline shortcuts (e.g., "Turn Rahul on").

### 3. More Menu (`pp. 26–31`)
- **M1 · More**: Verified salon header card and navigation menu.
- **M2 · Salon profile**: View-only verified business details.
- **M3 · Owner profile**: View-only owner KYC details.
- **M4 · Timings**: Working hours management with batch copy.
- **M5 · Support**: Direct dial to dedicated Zalono Partner executive and contextual FAQs.
- **M6 · Log out**: Safety confirmation preventing accidental missed alerts.

---

## 🚀 Getting Started

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.0.0` or higher).
2. For iOS: macOS with Xcode and CocoaPods installed.
3. For Android: Android Studio with Android SDK and Emulator configured.

### Quick Setup

```bash
# 1. Navigate to the flutter_app directory
cd flutter_app

# 2. Get dependencies
flutter pub get

# 3. Run on an iOS Simulator or connected iPhone
flutter run -d ios

# 4. Run on an Android Emulator or connected device
flutter run -d android
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play Store)
flutter build appbundle --release

# iOS IPA (Apple App Store / TestFlight)
flutter build ipa --release
```

---

## 🎨 Theme & Typography

- **Primary Brand Color**: `#C52243` (Zalono Crimson)
- **Background**: `#FAF6F2` (Warm Soft Sand)
- **Accent Light**: `#FDEBED`
- **Font**: Plus Jakarta Sans (or SF Pro on iOS, Roboto on Android)
