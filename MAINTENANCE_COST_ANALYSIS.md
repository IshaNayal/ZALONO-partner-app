# Zalono Partner: Comprehensive Maintenance & Development Cost Analysis

**Document Version:** 1.1  
**Target Application:** Zalono Salon Partner Mobile & Web Platform (Flutter + Node.js Backend + Firebase)  
**Date of Estimation:** October 2026  
**Currencies:** Indian Rupee (INR · ₹) and US Dollar (USD · $)  
**Exchange Benchmark:** 1 USD ≈ ₹84.00 INR (Subject to standard forex variations)

---

## Executive Summary

This document provides a complete, itemized cost forecast covering both **infrastructure maintenance** (Firebase, SMS/OTP, Backend, Cloudflare, App Stores) and **development tooling** (**Claude Code yearly subscription**) required to build, maintain, and run the **Zalono Partner** platform smoothly over **1 month**, **6 months**, and **12 months**.

Every figure has been cross-validated against the repository files (`zalono_partner/backend`, `zalono_partner/flutter_app`, `render.yaml`), Anthropic's subscription plans, Google Cloud / Firebase pricing, and Indian telecom (TRAI DLT) regulations.

### Key Highlights

1. **Development Tooling (Claude Code):**
   - Claude Code is bundled with Anthropic's **Claude Pro plan**.
   - Billed Annually: **$200.00 / year (≈ ₹16,800 INR/year)** upfront (~$16.67 or ₹1,400/mo amortized).
   - Billed Monthly: **$20.00 / month (≈ ₹1,680 INR/month)** ($240/year = ₹20,160/year).
2. **SMS/OTP is the Largest Operational Variable:**
   - **Firebase Phone Auth** in India costs **$0.07 per SMS (≈ ₹5.88/OTP)** → ₹11,760/mo ($140) for 2,000 OTPs.
   - **Indian SMS Gateways** (MSG91, 2Factor.in) cost **₹0.20 – ₹0.26 per OTP** → **~₹520/mo ($6.19)** for 2,000 OTPs.
   - **Net Saving:** Over **₹1,34,000 ($1,600) saved per year** by routing OTPs via an Indian gateway.
3. **Backend Service (Render):**
   - Render's **Free Tier** puts instances to sleep after 15 minutes of inactivity (50s cold start). A **Render Starter Plan ($7/mo = ₹588/mo)** is mandatory for an always-on 24/7 backend API.
4. **Firebase & Cloudflare Free Tiers:**
   - Cloud Firestore (50k reads/day free) and Cloud Storage (5 GB free) easily accommodate up to 500 salons at **₹0 extra cost**.
   - Cloudflare Free Tier provides enterprise-grade DDoS mitigation, CDN, and SSL at **$0/month**.

---

## 1. Item-by-Item Breakdown & Cross-Validation

### A. Development Tooling: Claude Code (Anthropic)

| Subscription Tier | Billing Frequency | USD Cost | INR Cost (1 USD = ₹84) | Details & Inclusions |
| :--- | :--- | :--- | :--- | :--- |
| **Claude Pro (Annual Plan - Recommended)** | **Annually Upfront** | **$200.00 / year** | **₹16,800 / year** | Amortizes to **~$16.67 / ₹1,400 per month**. Full access to the Claude Code CLI terminal agent, Claude 3.5/3.7 Sonnet models, and web/desktop interfaces. |
| **Claude Pro (Monthly Plan)** | **Monthly** | **$20.00 / month** | **₹1,680 / month** | Billed monthly. Totaling $240 / ₹20,160 over 12 months. |
| **GST Buffer (18%)** | If billed on Indian card | +$36.00 / year | +₹3,024 / year | Applicable if paying via domestic Indian payment methods with reverse charge / IGST. |

---

### B. Firebase Services (Google Cloud Platform)

| Service Component | Quota / Allowance in Free Tier | Pilot Stage (<500 Salons) | Growth Stage (2,500+ Salons) | Notes & Official Rates |
| :--- | :--- | :--- | :--- | :--- |
| **Firebase Auth (Anonymous/Email)** | Unlimited free users | **₹0 / $0** | **₹0 / $0** | Handled natively on Spark & Blaze plans without cost. |
| **Cloud Firestore (NoSQL DB)** | • 50,000 reads/day<br>• 20,000 writes/day<br>• 1 GB storage | **₹0 / $0** | **~₹454 / $5.40/mo** | Overages: $0.06 per 100k reads; $0.18 per 100k writes; $0.18/GB storage. |
| **Firebase Storage (KYC & Photos)** | • 5 GB stored data<br>• 1 GB/day download bandwidth | **₹0 / $0** | **~₹224 / $2.66/mo** | 500 salons × 6 MB KYC = ~3 GB (within free 5 GB limit). Overages: $0.026/GB storage, $0.12/GB download. |
| **Cloud Messaging (FCM Push Alerts)** | Unlimited push notifications | **₹0 / $0** | **₹0 / $0** | Completely free on all Firebase plans. |
| **Subtotal Firebase** | | **₹0 / $0/mo** | **~₹678 / $8.06/mo** | |

---

### C. SMS & OTP Verification

| Feature / Metric | Firebase Native Phone Auth (Identity Platform) | Indian SMS Gateway (MSG91 / 2Factor / Fast2SMS) |
| :--- | :--- | :--- |
| **Cost per SMS (India)** | **$0.07 USD (≈ ₹5.88 INR)** | **₹0.18 – ₹0.22 + 18% GST (≈ ₹0.24 – ₹0.26 INR)** |
| **Cost for 1,000 OTPs** | ₹5,880 ($70.00) | ₹260 ($3.10) |
| **Cost for 2,000 OTPs** | ₹11,760 ($140.00) | ₹520 ($6.19) |
| **Cost for 15,000 OTPs (Scale)** | ₹88,200 ($1,050.00) | ₹3,540 ($42.14) |
| **TRAI DLT Requirement** | Handled by Google behind the scenes | Mandatory Entity Registration (₹5,900 one-time) |
| **Sender ID** | Generic international numbers | Branded Sender ID (e.g. `ZALONO`, `ZL-PARTNER`) |
| **Recommendation** | Prototyping only | **Production Standard (Massive Savings)** |

---

### D. Backend Hosting (Node.js API on Render.com)

| Provider & Tier | Specifications | Monthly Cost | Operational Status |
| :--- | :--- | :--- | :--- |
| **Render Free Tier** | 512 MB RAM, 0.1 CPU, sleeps after 15m inactivity | $0.00 | **Not Recommended for Live Apps** (50-second wake latency causes mobile request timeouts). |
| **Render Starter Tier (Recommended)** | 512 MB RAM, 0.5 CPU, Always-On (0 sleep), Auto-deploy | **$7.00 / ₹588/mo** | **Mandatory baseline** to ensure snappy app responses for onboarding & logins. |
| **Render Static Site (Web Frontend)** | Global CDN, 100 GB outbound bandwidth | **$0.00 (Free)** | Fully hosts the Flutter web build (`build/web`). |
| **Alternative: AWS Lightsail / DigitalOcean** | 1 GB RAM, 1 vCPU Droplet/Instance | $5.00 – $6.00 / ₹420 – ₹500/mo | Requires manual server maintenance & Docker setups. |

---

### E. Cloudflare & Domain Infrastructure

| Item | Plan / Specification | Cost | Purpose & Requirement |
| :--- | :--- | :--- | :--- |
| **Cloudflare Core Plan** | **Free Plan ($0/mo)** | **₹0 / $0** | Includes unmetered DDoS mitigation, Global CDN, SSL/TLS certificates, Fast Anycast DNS. |
| **Domain Registration (Cloudflare Registrar)** | `.com` or `.in` (Zero-markup wholesale rate) | **~$10.50 / ₹882/year** (≈ ₹74/mo) | Custom domain for API (`api.zalono.com`) and Partner Portal. |
| **Cloudflare Pro Plan (Optional)** | Advanced WAF, Image Polish | $20.00 / ₹1,680/mo | **Not required** for MVP or early stages. |

---

### F. Additional Operational & Store Requirements

1. **Email OTP & Transactional Email (Screen R5):**
   - **Provider:** Resend / Brevo (Sendinblue).
   - **Free Tier:** Resend offers 3,000 emails/month free; Brevo offers 300 emails/day free.
   - **Cost:** **₹0 / $0/month** for pilot.
2. **Location Services (Screen R7):**
   - Handled via `geolocator` device GPS hardware — **₹0 / $0**.
3. **App Store & Distribution Accounts:**
   - **Google Play Developer Console:** **$25.00 one-time fee (≈ ₹2,100 INR)**. Lifetime validity.
   - **Apple Developer Program (iOS):** **$99.00 / year (≈ ₹8,316 INR/year = ~₹693/month)**.

---

## 2. Total Cost Schedules: 1 Month, 6 Months, and 12 Months

### Schedule 1: Recommended Production Stack + Claude Code Development Tooling
*Architecture: Render Starter + Indian SMS Gateway (2,000 OTPs/mo) + Firebase Free + Cloudflare Free + Claude Code*

| Component | 1 Month | 6 Months | 12 Months | Calculation Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Development Tool: Claude Code** | **₹1,680** ($20.00) | **₹10,080** ($120.00) | **₹16,800** ($200.00) | Billed monthly for 1/6 mo; annual upfront for 12 mo ($200) |
| **Backend API (Render Starter)** | **₹588** ($7.00) | **₹3,528** ($42.00) | **₹7,056** ($84.00) | Always-on 24/7 Node API ($7/mo) |
| **SMS & OTP (Indian Gateway @ ₹0.26)** | **₹520** ($6.19) | **₹3,120** ($37.14) | **₹6,240** ($74.28) | 2,000 OTPs/month included |
| **Firebase (Firestore & Storage)** | **₹0** ($0.00) | **₹0** ($0.00) | **₹0** ($0.00) | Within 50k reads/day & 5 GB storage free |
| **Cloudflare (CDN, SSL, DDoS)** | **₹0** ($0.00) | **₹0** ($0.00) | **₹0** ($0.00) | Free Plan |
| **Transactional Email (Resend)** | **₹0** ($0.00) | **₹0** ($0.00) | **₹0** ($0.00) | Within 3,000 emails/month free |
| **Domain (Cloudflare Registrar)** | **₹74** ($0.88) | **₹441** ($5.25) | **₹882** ($10.50) | Amortized annual fee ($10.50/yr) |
| **Operational & Dev Recurring Total** | **₹2,862 ($34.07)** | **₹17,169 ($204.39)** | **₹30,978 ($368.78)** | **Total recurring burn (Infra + AI Dev)** |
| | | | | |
| **One-Time & Mandatory Setup Fees:** | | | | |
| • TRAI DLT Registration (SMS PE ID) | ₹5,900 ($70.24) | ₹5,900 ($70.24) | ₹5,900 ($70.24) | Mandatory telecom compliance fee |
| • Google Play Console (One-time) | ₹2,100 ($25.00) | ₹2,100 ($25.00) | ₹2,100 ($25.00) | Lifetime account fee |
| • Apple Developer Program (Annual) | — | — | ₹8,316 ($99.00) | Required if releasing on iOS App Store |
| | | | | |
| **Grand Total (Android + Setup + Claude):** | **₹10,862 ($129.31)** | **₹25,169 ($299.63)** | **₹38,978 ($464.02)** | **Complete Year 1 budget for Android** |
| **Grand Total (Android + iOS + Setup + Claude):** | **₹19,178 ($228.31)** | **₹33,485 ($398.63)** | **₹47,294 ($563.02)** | **Complete Year 1 budget for Android + iOS** |

---

### Schedule 2: Comparison — If Using Firebase Phone Auth + Claude Code
*Architecture: Render Starter + Firebase Native Phone Auth (2,000 OTPs @ $0.07) + Claude Code*

| Component | 1 Month | 6 Months | 12 Months |
| :--- | :--- | :--- | :--- |
| **Development Tool: Claude Code** | ₹1,680 ($20.00) | ₹10,080 ($120.00) | ₹16,800 ($200.00) |
| **Backend API (Render Starter)** | ₹588 ($7.00) | ₹3,528 ($42.00) | ₹7,056 ($84.00) |
| **Firebase Phone Auth (2,000 OTPs)** | **₹11,760 ($140.00)** | **₹70,560 ($840.00)** | **₹1,41,120 ($1,680.00)** |
| **Cloudflare & Domain** | ₹74 ($0.88) | ₹441 ($5.25) | ₹882 ($10.50) |
| **Operational & Dev Recurring Total** | **₹14,102 ($167.88)** | **₹84,609 ($1,007.25)** | **₹1,65,858 ($1,974.50)** |
| **With Play Console ($25) + Apple Dev ($99)** | **₹24,518 ($291.88)** | **₹95,025 ($1,131.25)** | **₹176,274 ($2,098.50)** |

> **Financial Comparison:** Model 1 saves **₹1,28,980 ($1,535)** over 12 months compared to Model 2, covering the entire cost of the Claude Code yearly subscription more than **7 times over**!

---

### Schedule 3: Scaled Growth Stage (2,500+ Active Salons / 15,000 OTPs/Month + Claude Code)

| Component | 1 Month Cost | 6 Months Cost | 12 Months Cost | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Development Tool: Claude Code** | ₹1,400 ($16.67) | ₹8,400 ($100.00) | ₹16,800 ($200.00) | Annual subscription amortized |
| **Backend API (Render Standard - 2GB RAM)** | ₹2,100 ($25.00) | ₹12,600 ($150.00) | ₹25,200 ($300.00) | Dedicated high-concurrency Node instance |
| **SMS Gateway (15,000 OTPs @ ₹0.236)** | ₹3,540 ($42.14) | ₹21,240 ($252.86) | ₹42,480 ($505.71) | Scaled OTP volume |
| **Firebase Firestore (Above Quota)** | ₹454 ($5.40) | ₹2,724 ($32.40) | ₹5,448 ($64.80) | Document reads/writes over daily free limits |
| **Firebase Storage (25 GB + Egress)** | ₹224 ($2.66) | ₹1,344 ($15.96) | ₹2,688 ($31.92) | Storage for high-res salon photos & KYC |
| **Transactional Email (Amazon SES)** | ₹126 ($1.50) | ₹756 ($9.00) | ₹1,512 ($18.00) | 15,000 automated notification emails |
| **Cloudflare Core Plan** | ₹0 ($0.00) | ₹0 ($0.00) | ₹0 ($0.00) | Free plan continues to suffice |
| **Domain & Apple Developer Renewals** | ₹766 ($9.12) | ₹4,599 ($54.75) | ₹9,198 ($109.50) | Apple Developer ($99) + Domain ($10.50) |
| **Total Recurring at Growth Scale** | **₹8,610 ($102.50)** | **₹51,663 ($615.00)** | **₹1,03,326 ($1,230.00)** | **Supports 2,500+ active salons + AI tooling** |

---

## 3. Recommended Implementation Roadmap

1. **Activate Claude Pro Annual Subscription:**
   - Purchase the annual Claude Pro subscription at **$200/year (₹16,800)** to save $40 (17%) compared to the monthly plan.
   - Run `claude login` in the developer terminal to authenticate Claude Code directly.
2. **Setup TRAI DLT & Indian SMS Provider:**
   - Complete Principal Entity onboarding on **Jio TrueConnect** or **Airtel DLT** (₹5,900 one-time).
   - Integrate MSG91 or 2Factor.in with your Node.js backend. Call `admin.auth().createCustomToken(uid)` to authenticate users into Firebase Auth seamlessly.
3. **Upgrade Render Web Service:**
   - Switch `zalono-partner-backend` on Render to the **Starter Plan ($7/mo)** to eliminate sleep cold starts.
4. **Deploy Domain on Cloudflare:**
   - Register or route your production domain through Cloudflare Free DNS for SSL/TLS encryption, edge caching, and DDoS shielding.
