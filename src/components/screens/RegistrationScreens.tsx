import React, { useState } from 'react';
import {
  ChevronLeft,
  Check,
  MapPin,
  Clock,
  Plus,
  FileText,
  Lock,
  Compass,
  ArrowRight,
  Sparkles,
} from 'lucide-react';

interface RegistrationScreensProps {
  currentStep: number;
  onStepChange: (step: number) => void;
  onNavigateToLogin: () => void;
  onCompleteRegistration: () => void;
}

export const RegistrationScreens: React.FC<RegistrationScreensProps> = ({
  currentStep,
  onStepChange,
  onNavigateToLogin,
  onCompleteRegistration,
}) => {
  // R2 Mobile Verification state
  const [mobile] = useState('98765 43210');
  const [mobileOtp, setMobileOtp] = useState(['4', '2', '7', '9', '0', '1']);

  // R3 Onboarding Code state
  const [onboardingCode, setOnboardingCode] = useState('ZL-4821');

  // R4 Owner Details state
  const [ownerName, setOwnerName] = useState('Rohan Mehta');
  const [email, setEmail] = useState('rohan@glowstudio.in');
  const [gstNumber, setGstNumber] = useState('22ABCDE1234F1Z5');
  const [panAdded, setPanAdded] = useState(true);
  const [aadhaarAdded, setAadhaarAdded] = useState(false);
  const [businessProofAdded, setBusinessProofAdded] = useState(false);

  // R5 Email OTP state
  const [emailOtp, setEmailOtp] = useState(['5', '3', '8', '2', '0', '4']);

  // R6 Salon Details state
  const [salonName, setSalonName] = useState('Glow Studio');
  const [category, setCategory] = useState<'Basic' | 'Medium' | 'Premium' | 'Ultra premium'>('Premium');
  const [serves, setServes] = useState<string[]>(['Unisex', 'Other']);
  const [customCategory, setCustomCategory] = useState('Kids salon');

  // R7 Location state
  const [address, setAddress] = useState('Plot No. 123, Saheed Nagar, Near Big Bazaar, Bhubaneswar');
  const [pincode, setPincode] = useState('751007');

  // R8 Services state
  const [serviceCat, setServiceCat] = useState('Hair');
  const [servicesList, setServicesList] = useState([
    { name: 'Haircut (Men)', time: '30 min', price: '₹399', checked: true },
    { name: 'Haircut (Women)', time: '45 min', price: '₹699', checked: true },
    { name: 'Beard trim', time: '15 min', price: '₹149', checked: true },
    { name: 'Hair colour', time: '90 min', price: '₹2,499', checked: true },
    { name: 'Hair spa', time: '60 min', price: '₹1,999', checked: false },
  ]);

  // R9 Stylists
  const [stylists, setStylists] = useState([
    { initial: 'P', name: 'Priya Sharma', role: 'Hair specialist', services: 'Haircut, Hair colour, Beard trim' },
    { initial: 'R', name: 'Rahul Das', role: 'Skin specialist', services: 'Facial, Clean-up' },
    { initial: 'N', name: 'Neha Patel', role: 'Nail artist', services: 'Manicure, Pedicure' },
  ]);

  // R10 Timings
  const [timings, setTimings] = useState([
    { day: 'Mon', slots: [{ time: '10:00 AM – 2:00 PM', on: true }, { time: '4:00 PM – 10:00 PM', on: true }] },
    { day: 'Tue', slots: [{ time: '10:00 AM – 10:00 PM', on: true }] },
    { day: 'Wed', slots: [{ time: '10:00 AM – 10:00 PM', on: true }] },
    { day: 'Thu', slots: [{ time: '10:00 AM – 10:00 PM', on: true }] },
    { day: 'Fri', slots: [{ time: '10:00 AM – 10:00 PM', on: true }] },
  ]);

  // R11 Review & Agree
  const [agreed, setAgreed] = useState(false);

  const toggleService = (idx: number) => {
    const next = [...servicesList];
    next[idx].checked = !next[idx].checked;
    setServicesList(next);
  };

  const toggleServes = (s: string) => {
    if (serves.includes(s)) {
      setServes(serves.filter((item) => item !== s));
    } else {
      setServes([...serves, s]);
    }
  };

  // Screen 1: Cover page view
  if (currentStep === 0) {
    return (
      <div className="flex-1 bg-[#C52243] text-white p-7 flex flex-col justify-between">
        <div>
          <div className="flex items-center space-x-2">
            <span className="text-3xl font-extrabold tracking-tight">zalono</span>
            <span className="bg-[#A51B37] text-white text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-wider">
              SALON PARTNER APP
            </span>
          </div>
          <h1 className="text-4xl font-black mt-16 leading-tight">
            Registration<br />and login
          </h1>
          <p className="text-rose-100 text-sm mt-4 leading-relaxed font-normal max-w-[280px]">
            MVP screens for the pilot. Register with an onboarding code, log in once approved, then run the day.
          </p>
        </div>

        <div className="space-y-4 my-8 border-t border-rose-400/30 pt-6">
          <div className="flex justify-between items-baseline border-b border-rose-400/20 pb-3">
            <div>
              <p className="font-bold text-base">Registration</p>
              <p className="text-xs text-rose-200">12 screens</p>
            </div>
            <span className="text-sm font-medium text-rose-200">pp. 2–13</span>
          </div>

          <div className="flex justify-between items-baseline border-b border-rose-400/20 pb-3">
            <div>
              <p className="font-bold text-base">Login and daily use</p>
              <p className="text-xs text-rose-200">12 screens</p>
            </div>
            <span className="text-sm font-medium text-rose-200">pp. 14–25</span>
          </div>

          <div className="flex justify-between items-baseline">
            <div>
              <p className="font-bold text-base">More</p>
              <p className="text-xs text-rose-200">6 screens</p>
            </div>
            <span className="text-sm font-medium text-rose-200">pp. 26–31</span>
          </div>
        </div>

        <div className="space-y-3">
          <button
            onClick={() => onStepChange(1)}
            className="w-full bg-white text-[#C52243] font-bold py-3.5 rounded-full text-sm shadow-lg hover:bg-rose-50 transition active:scale-[0.98]"
          >
            Enter App (R1 Welcome)
          </button>
          <p className="text-[11px] text-rose-200/80 text-center">
            13 October 2026 · pilot version · placeholder names and prices
          </p>
        </div>
      </div>
    );
  }

  // Screen 2: R1 Welcome Screen
  if (currentStep === 1) {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between">
        <div>
          {/* Header Brand */}
          <div className="flex items-center space-x-2 pt-1">
            <span className="text-2xl font-black text-[#C52243] tracking-tight">zalono</span>
            <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider">
              SALON PARTNER
            </span>
          </div>

          {/* Heading */}
          <h2 className="text-3xl font-extrabold text-stone-900 mt-10 leading-tight">
            Run your day<br />from your phone.
          </h2>
          <p className="text-stone-600 text-sm mt-3 leading-relaxed">
            See bookings, add walk-ins and keep every seat honest.
          </p>

          {/* Live Preview Card */}
          <div className="bg-white rounded-2xl p-5 mt-7 border border-[#EFE7DF] shadow-sm">
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-extrabold text-[#C52243] tracking-wider">
                NEXT UP · 2:20 PM
              </span>
              <span className="bg-[#FDEBED] text-[#C52243] text-[11px] font-bold px-2.5 py-0.5 rounded-full">
                Confirmed
              </span>
            </div>
            <h3 className="text-xl font-bold text-stone-900 mt-2.5">Aarav K.</h3>
            <p className="text-xs text-stone-500 mt-0.5">Haircut + Beard trim · with Priya</p>
            <div className="flex items-center text-[#C52243] text-xs font-semibold mt-3 space-x-1.5">
              <Clock className="w-3.5 h-3.5" />
              <span>Leaving now · about 8 min away</span>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="space-y-3 pb-2">
          <button
            onClick={onNavigateToLogin}
            className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
          >
            Log in
          </button>
          <button
            onClick={() => onStepChange(2)}
            className="w-full bg-white hover:bg-rose-50/50 text-[#C52243] border-1.5 border-[#C52243] font-bold py-3.5 rounded-full text-sm transition active:scale-[0.98]"
          >
            Partner with Zalono
          </button>
          <p className="text-[12px] text-stone-500 text-center leading-tight pt-1">
            New salons need an onboarding code from a Zalono executive.
          </p>
          <p className="text-[11px] text-stone-400 text-center">
            By continuing you accept the Terms & Privacy Policy.
          </p>
        </div>
      </div>
    );
  }

  // Screen 13: R12 Submitted
  if (currentStep === 12) {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between">
        <div className="pt-8 text-center flex flex-col items-center">
          <div className="w-16 h-16 rounded-full bg-[#C52243] flex items-center justify-center text-white shadow-lg shadow-rose-200">
            <Check className="w-9 h-9 stroke-[3]" />
          </div>
          <h2 className="text-2xl font-black text-stone-900 mt-6">Application submitted</h2>
          <p className="text-stone-600 text-xs mt-2 max-w-[260px]">
            Thank you. We will notify you as soon as your salon is approved.
          </p>

          {/* Timeline Card */}
          <div className="w-full bg-white rounded-2xl p-5 mt-7 border border-[#EFE7DF] text-left">
            {/* Step 1 */}
            <div className="flex items-start space-x-3">
              <div className="flex flex-col items-center">
                <div className="w-6 h-6 rounded-full bg-[#C52243] text-white flex items-center justify-center text-xs">
                  <Check className="w-3.5 h-3.5 stroke-[3]" />
                </div>
                <div className="w-0.5 h-8 bg-[#C52243]"></div>
              </div>
              <div>
                <h4 className="font-bold text-sm text-stone-900">Application submitted</h4>
                <p className="text-xs text-stone-500">We have your details.</p>
              </div>
            </div>

            {/* Step 2 */}
            <div className="flex items-start space-x-3">
              <div className="flex flex-col items-center">
                <div className="w-6 h-6 rounded-full border-2 border-[#C52243] flex items-center justify-center">
                  <div className="w-2 h-2 rounded-full bg-[#C52243]"></div>
                </div>
                <div className="w-0.5 h-8 bg-stone-200"></div>
              </div>
              <div>
                <h4 className="font-bold text-sm text-stone-900">Zalono verification</h4>
                <p className="text-xs text-stone-500">The team is checking Glow Studio.</p>
              </div>
            </div>

            {/* Step 3 */}
            <div className="flex items-start space-x-3">
              <div className="w-6 h-6 rounded-full border-2 border-stone-300 flex items-center justify-center">
                <div className="w-2 h-2 rounded-full bg-transparent"></div>
              </div>
              <div>
                <h4 className="font-semibold text-sm text-stone-400">Approved</h4>
                <p className="text-xs text-stone-400">You get a notification, then you can log in.</p>
              </div>
            </div>
          </div>

          {/* Note Box */}
          <div className="w-full bg-[#FDEBED] rounded-xl p-3.5 mt-5 text-left border border-rose-200/50">
            <p className="text-xs font-medium text-[#A51B37] leading-relaxed">
              You cannot log in until Zalono approves your salon.
            </p>
          </div>
        </div>

        <div className="pb-2">
          <button
            onClick={onCompleteRegistration}
            className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
          >
            Done
          </button>
        </div>
      </div>
    );
  }

  // 9-Step Wizard Container (R2 to R11)
  const wizardStepNumber = currentStep - 1; // 1 to 9

  return (
    <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between">
      {/* Top Header & Progress */}
      <div>
        <div className="flex items-center justify-between">
          <button
            onClick={() => onStepChange(currentStep - 1)}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <span className="text-[11px] font-extrabold text-[#C52243] tracking-widest uppercase">
            STEP {wizardStepNumber} OF 9
          </span>
          <div className="w-9" />
        </div>

        {/* 9-Segment Progress Bar */}
        <div className="flex space-x-1.5 mt-4">
          {Array.from({ length: 9 }).map((_, i) => (
            <div
              key={i}
              className={`h-1 flex-1 rounded-full transition-all duration-300 ${
                i < wizardStepNumber ? 'bg-[#C52243]' : 'bg-[#E5DCD4]'
              }`}
            />
          ))}
        </div>

        {/* Step-Specific Content */}
        <div className="mt-6 overflow-y-auto no-scrollbar max-h-[580px] pb-4">
          {/* R2: Verify mobile */}
          {currentStep === 2 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">
                Verify your mobile<br />number
              </h2>
              <p className="text-xs text-stone-500 mt-2">
                We send a code to your phone. This number becomes your salon's login.
              </p>

              <div className="mt-6">
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  MOBILE NUMBER
                </label>
                <div className="bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 flex items-center space-x-3 text-stone-900 font-medium text-sm">
                  <span className="font-bold text-stone-700">+91</span>
                  <div className="w-[1px] h-4 bg-stone-200"></div>
                  <span>{mobile}</span>
                </div>
              </div>

              <div className="mt-5">
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  ENTER THE 6-DIGIT CODE
                </label>
                <div className="flex justify-between mt-2">
                  {mobileOtp.map((digit, idx) => (
                    <input
                      key={idx}
                      type="text"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => {
                        const copy = [...mobileOtp];
                        copy[idx] = e.target.value;
                        setMobileOtp(copy);
                      }}
                      className="w-11 h-12 rounded-xl bg-white border border-[#EFE7DF] text-center font-bold text-stone-900 text-lg focus:border-[#C52243] focus:outline-none"
                    />
                  ))}
                </div>
                <div className="flex items-center space-x-1.5 text-[#C52243] text-xs font-bold mt-2.5">
                  <Check className="w-3.5 h-3.5 stroke-[3]" />
                  <span>Number verified</span>
                </div>
              </div>

              <div className="bg-[#FDEBED] rounded-xl p-3.5 mt-6 border border-rose-200/50">
                <p className="text-xs text-[#A51B37] leading-relaxed">
                  Next you will enter an onboarding code from your Zalono executive. Registration stays locked without it.
                </p>
              </div>
            </div>
          )}

          {/* R3: Onboarding Code */}
          {currentStep === 3 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">
                Enter your onboarding<br />code
              </h2>
              <p className="text-xs text-stone-500 mt-2">
                Your Zalono executive gives you this code. Only salons with a code can register.
              </p>

              <div className="mt-6">
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  ONBOARDING CODE
                </label>
                <div className="bg-white rounded-xl px-4 py-3 border-2 border-[#C52243] mt-1.5 flex items-center justify-between">
                  <input
                    type="text"
                    value={onboardingCode}
                    onChange={(e) => setOnboardingCode(e.target.value)}
                    className="font-extrabold text-stone-900 text-lg tracking-wider focus:outline-none bg-transparent"
                  />
                  <div className="w-6 h-6 rounded-full bg-[#C52243] text-white flex items-center justify-center">
                    <Check className="w-3.5 h-3.5 stroke-[3]" />
                  </div>
                </div>
                <div className="flex items-center space-x-1.5 text-[#C52243] text-xs font-bold mt-2.5">
                  <Check className="w-3.5 h-3.5 stroke-[3]" />
                  <span>Code verified · registration unlocked</span>
                </div>
              </div>

              <p className="text-xs text-stone-500 mt-5 leading-normal">
                No code yet? Ask your Zalono executive or contact support.
              </p>
            </div>
          )}

          {/* R4: About the owner */}
          {currentStep === 4 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">About the owner</h2>

              <div className="mt-5 space-y-4">
                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    FULL NAME
                  </label>
                  <input
                    type="text"
                    value={ownerName}
                    onChange={(e) => setOwnerName(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
                  />
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    EMAIL ID
                  </label>
                  <div className="bg-white rounded-xl px-4 py-2 border border-[#EFE7DF] mt-1.5 flex items-center justify-between">
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="font-bold text-stone-900 text-sm focus:outline-none bg-transparent flex-1"
                    />
                    <button
                      onClick={() => onStepChange(5)}
                      className="bg-[#C52243] text-white text-xs font-bold px-3 py-1.5 rounded-full hover:bg-rose-700 active:scale-95"
                    >
                      Verify
                    </button>
                  </div>
                </div>

                <div>
                  <div className="flex justify-between items-center">
                    <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider">
                      DOCUMENTS
                    </label>
                    <span className="text-[11px] font-bold text-[#C52243]">All optional</span>
                  </div>

                  <div className="space-y-2 mt-2">
                    <div className="bg-white p-3 rounded-xl border border-[#EFE7DF] flex items-center justify-between">
                      <div className="flex items-center space-x-2.5">
                        <div className="w-8 h-8 rounded-lg bg-[#FDEBED] flex items-center justify-center text-[#C52243]">
                          <FileText className="w-4 h-4" />
                        </div>
                        <span className="text-xs font-bold text-stone-800">PAN card</span>
                      </div>
                      <span className="text-[11px] font-bold text-[#C52243] border border-[#C52243] px-2.5 py-0.5 rounded-full">
                        ✓ Added
                      </span>
                    </div>

                    <div className="bg-white p-3 rounded-xl border border-[#EFE7DF] flex items-center justify-between">
                      <div className="flex items-center space-x-2.5">
                        <div className="w-8 h-8 rounded-lg bg-[#FDEBED] flex items-center justify-center text-[#C52243]">
                          <FileText className="w-4 h-4" />
                        </div>
                        <span className="text-xs font-bold text-stone-800">Aadhaar card</span>
                      </div>
                      <button
                        onClick={() => setAadhaarAdded(!aadhaarAdded)}
                        className="text-[11px] font-bold text-[#C52243] bg-[#FDEBED] px-3 py-1 rounded-full"
                      >
                        {aadhaarAdded ? '✓ Added' : 'Upload'}
                      </button>
                    </div>

                    <div className="bg-white p-3 rounded-xl border border-[#EFE7DF] flex items-center justify-between">
                      <div className="flex items-center space-x-2.5">
                        <div className="w-8 h-8 rounded-lg bg-[#FDEBED] flex items-center justify-center text-[#C52243]">
                          <FileText className="w-4 h-4" />
                        </div>
                        <div>
                          <p className="text-xs font-bold text-stone-800">Business proof</p>
                          <p className="text-[10px] text-stone-400">Shop licence or Udyam</p>
                        </div>
                      </div>
                      <button
                        onClick={() => setBusinessProofAdded(!businessProofAdded)}
                        className="text-[11px] font-bold text-[#C52243] bg-[#FDEBED] px-3 py-1 rounded-full"
                      >
                        {businessProofAdded ? '✓ Added' : 'Upload'}
                      </button>
                    </div>
                  </div>
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    GST NUMBER · optional
                  </label>
                  <input
                    type="text"
                    value={gstNumber}
                    onChange={(e) => setGstNumber(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
                  />
                </div>
              </div>
            </div>
          )}

          {/* R5: Verify email */}
          {currentStep === 5 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">Verify your email</h2>
              <p className="text-xs text-stone-500 mt-2">
                We sent a 6-digit code to {email}.
              </p>

              <div className="mt-6">
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  ENTER THE 6-DIGIT CODE
                </label>
                <div className="flex justify-between mt-2">
                  {emailOtp.map((digit, idx) => (
                    <input
                      key={idx}
                      type="text"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => {
                        const copy = [...emailOtp];
                        copy[idx] = e.target.value;
                        setEmailOtp(copy);
                      }}
                      className="w-11 h-12 rounded-xl bg-white border border-[#EFE7DF] text-center font-bold text-stone-900 text-lg focus:border-[#C52243] focus:outline-none"
                    />
                  ))}
                </div>
                <div className="flex items-center space-x-1.5 text-[#C52243] text-xs font-bold mt-2.5">
                  <Check className="w-3.5 h-3.5 stroke-[3]" />
                  <span>Email verified</span>
                </div>
              </div>

              <button
                onClick={() => onStepChange(4)}
                className="text-xs font-bold text-[#C52243] mt-5 hover:underline"
              >
                Wrong email? Change it
              </button>
            </div>
          )}

          {/* R6: Salon details */}
          {currentStep === 6 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">Tell us about the salon</h2>

              <div className="mt-5 space-y-4">
                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    SALON PHOTOS · 3 TO 5
                  </label>
                  <div className="flex space-x-2.5 mt-2">
                    <div className="w-16 h-16 rounded-xl bg-[#E8A5AA] flex items-end justify-center p-1 relative">
                      <span className="bg-white text-[#C52243] text-[9px] font-black px-1.5 py-0.5 rounded">
                        Cover
                      </span>
                    </div>
                    <div className="w-16 h-16 rounded-xl bg-[#E8A5AA]"></div>
                    <div className="w-16 h-16 rounded-xl bg-[#F0CACD]"></div>
                    <div className="w-16 h-16 rounded-xl border-2 border-dashed border-[#C52243] flex items-center justify-center text-[#C52243]">
                      <Plus className="w-6 h-6" />
                    </div>
                  </div>
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    SALON NAME
                  </label>
                  <input
                    type="text"
                    value={salonName}
                    onChange={(e) => setSalonName(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
                  />
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    SALON CATEGORY
                  </label>
                  <div className="grid grid-cols-4 gap-1.5 mt-1.5">
                    {(['Basic', 'Medium', 'Premium', 'Ultra premium'] as const).map((cat) => (
                      <button
                        key={cat}
                        onClick={() => setCategory(cat)}
                        className={`py-2 px-1 text-[11px] font-bold rounded-xl text-center transition ${
                          category === cat
                            ? 'bg-[#C52243] text-white shadow-sm'
                            : 'bg-white text-stone-700 border border-[#EFE7DF]'
                        }`}
                      >
                        {cat}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    SALON SERVES
                  </label>
                  <div className="grid grid-cols-4 gap-1.5 mt-1.5">
                    {['Men', 'Women', 'Unisex', 'Other'].map((s) => (
                      <button
                        key={s}
                        onClick={() => toggleServes(s)}
                        className={`py-2 px-1 text-[11px] font-bold rounded-xl text-center transition ${
                          serves.includes(s)
                            ? 'bg-[#C52243] text-white shadow-sm'
                            : 'bg-white text-stone-700 border border-[#EFE7DF]'
                        }`}
                      >
                        {s}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    YOUR CATEGORY
                  </label>
                  <input
                    type="text"
                    value={customCategory}
                    onChange={(e) => setCustomCategory(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
                  />
                  <p className="text-[11px] text-stone-500 mt-1.5 leading-normal">
                    Customers see this as a category in the app. Zalono reviews new categories before they go live.
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* R7: Location */}
          {currentStep === 7 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">Where is the salon?</h2>
              <p className="text-xs text-stone-500 mt-2">
                Stand at the salon so the pin is exact. Customers see walking time from this spot.
              </p>

              {/* Map Canvas Graphic */}
              <div className="w-full h-40 bg-[#EFE8E1] rounded-2xl mt-5 relative overflow-hidden flex items-center justify-center border border-[#E5DCD4]">
                {/* Simulated Map Roads */}
                <svg className="absolute inset-0 w-full h-full stroke-white stroke-[14]" fill="none">
                  <path d="M -20,70 L 400,70" />
                  <path d="M 180,-20 L 180,200" />
                  <path d="M 60,-20 L 320,180" strokeWidth="8" stroke="#F5EDE6" />
                </svg>
                {/* Map Pin */}
                <div className="relative z-10 -mt-2 animate-bounce">
                  <div className="w-10 h-10 rounded-full bg-[#C52243] text-white flex items-center justify-center shadow-lg shadow-rose-900/30">
                    <MapPin className="w-6 h-6 stroke-[2.5]" />
                  </div>
                  <div className="w-3 h-1 bg-stone-500/40 rounded-full mx-auto mt-1 blur-[1px]"></div>
                </div>
              </div>

              <div className="flex items-center space-x-2 text-[#C52243] text-xs font-bold mt-3.5 cursor-pointer">
                <Compass className="w-4 h-4" />
                <span>Use my current location</span>
              </div>

              <div className="mt-5 space-y-3.5">
                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    COMPLETE ADDRESS
                  </label>
                  <textarea
                    rows={2}
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-xs leading-relaxed focus:outline-none focus:border-[#C52243] resize-none"
                  />
                </div>

                <div>
                  <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                    PINCODE
                  </label>
                  <input
                    type="text"
                    value={pincode}
                    onChange={(e) => setPincode(e.target.value)}
                    className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1.5 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
                  />
                </div>
              </div>
            </div>
          )}

          {/* R8: Services */}
          {currentStep === 8 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">What do you offer?</h2>
              <p className="text-xs text-stone-500 mt-2">
                Tick what you offer. Tap a time or price to change it.
              </p>

              {/* Service Categories */}
              <div className="flex space-x-2 mt-4 overflow-x-auto no-scrollbar">
                {['Hair', 'Skin', 'Nails', 'Body', '+ Add'].map((cat) => (
                  <button
                    key={cat}
                    onClick={() => cat !== '+ Add' && setServiceCat(cat)}
                    className={`px-4 py-1.5 rounded-full text-xs font-bold shrink-0 transition ${
                      cat === serviceCat
                        ? 'bg-[#C52243] text-white'
                        : cat === '+ Add'
                        ? 'border border-dashed border-[#C52243] text-[#C52243] bg-white'
                        : 'bg-white text-stone-700 border border-[#EFE7DF]'
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>

              {/* Service Rows */}
              <div className="space-y-2 mt-4">
                {servicesList.map((srv, idx) => (
                  <div
                    key={idx}
                    onClick={() => toggleService(idx)}
                    className="bg-white p-3.5 rounded-xl border border-[#EFE7DF] flex items-center justify-between cursor-pointer hover:border-[#C52243]/50 transition"
                  >
                    <div className="flex items-center space-x-3">
                      <div
                        className={`w-5 h-5 rounded-md flex items-center justify-center transition ${
                          srv.checked ? 'bg-[#C52243] text-white' : 'border border-stone-300'
                        }`}
                      >
                        {srv.checked && <Check className="w-3.5 h-3.5 stroke-[3]" />}
                      </div>
                      <span className="text-xs font-bold text-stone-900">{srv.name}</span>
                    </div>

                    <div className="flex items-center space-x-2">
                      <span className="bg-[#FAF6F2] text-stone-700 text-[11px] font-semibold px-2 py-1 rounded-lg">
                        {srv.time}
                      </span>
                      <span className="bg-[#FAF6F2] text-stone-900 text-[11px] font-bold px-2.5 py-1 rounded-lg">
                        {srv.price}
                      </span>
                    </div>
                  </div>
                ))}

                <button className="w-full py-3.5 rounded-xl border-2 border-dashed border-[#C52243] text-[#C52243] text-xs font-bold hover:bg-rose-50/50 transition">
                  + Add service in Hair
                </button>
              </div>

              <p className="text-xs font-medium text-stone-500 text-center mt-4">
                4 services selected
              </p>
            </div>
          )}

          {/* R9: Who works here */}
          {currentStep === 9 && (
            <div>
              <div className="flex items-center space-x-2">
                <h2 className="text-2xl font-black text-stone-900 leading-tight">Who works here?</h2>
                <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-bold px-2 py-0.5 rounded-md">
                  Optional
                </span>
              </div>
              <p className="text-xs text-stone-500 mt-2">
                Add each stylist and the services they do, so customers can pick one when they book.
              </p>

              <button className="w-full py-3.5 rounded-xl border-2 border-dashed border-[#C52243] text-[#C52243] text-xs font-bold hover:bg-rose-50/50 transition mt-4">
                + Add stylist
              </button>

              <div className="space-y-2.5 mt-4">
                {stylists.map((st, i) => (
                  <div key={i} className="bg-white p-3.5 rounded-xl border border-[#EFE7DF] flex items-start space-x-3">
                    <div className="w-10 h-10 rounded-full bg-[#FDEBED] text-[#C52243] font-bold text-base flex items-center justify-center shrink-0">
                      {st.initial}
                    </div>
                    <div>
                      <h4 className="text-sm font-bold text-stone-900">{st.name}</h4>
                      <p className="text-xs text-stone-500">{st.role}</p>
                      <p className="text-[11px] font-bold text-[#C52243] mt-1">{st.services}</p>
                    </div>
                  </div>
                ))}
              </div>

              <div className="bg-[#FDEBED] rounded-xl p-3.5 mt-5 border border-rose-200/50">
                <p className="text-xs text-[#A51B37] leading-relaxed">
                  Not ready? Skip this. Customers will book the salon without choosing a stylist.
                </p>
              </div>
            </div>
          )}

          {/* R10: Timings */}
          {currentStep === 10 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">When are you open?</h2>
              <p className="text-xs text-stone-500 mt-2">
                Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.
              </p>

              <div className="space-y-4 mt-5">
                {timings.map((t, idx) => (
                  <div key={idx} className="flex items-start space-x-3">
                    <span className="w-9 font-bold text-sm text-stone-900 pt-2">{t.day}</span>
                    <div className="flex-1 space-y-2">
                      {t.slots.map((slot, sIdx) => (
                        <div key={sIdx} className="flex items-center space-x-2">
                          <div className="flex-1 bg-white border border-[#EFE7DF] rounded-xl px-3 py-2 text-xs font-semibold text-stone-900">
                            {slot.time}
                          </div>
                          {/* Simulated Switch */}
                          <button
                            onClick={() => {
                              const copy = [...timings];
                              copy[idx].slots[sIdx].on = !copy[idx].slots[sIdx].on;
                              setTimings(copy);
                            }}
                            className={`w-11 h-6 rounded-full transition-colors p-0.5 flex items-center ${
                              slot.on ? 'bg-[#C52243]' : 'bg-stone-300'
                            }`}
                          >
                            <div
                              className={`w-5 h-5 rounded-full bg-white transition-transform ${
                                slot.on ? 'translate-x-5' : 'translate-x-0'
                              }`}
                            />
                          </button>
                        </div>
                      ))}
                      <button className="text-[11px] font-bold text-[#C52243]">+ Add timing</button>
                    </div>
                  </div>
                ))}
              </div>

              <button className="w-full text-center text-xs font-bold text-[#C52243] mt-5 hover:underline">
                Copy Monday's timings to all days
              </button>
            </div>
          )}

          {/* R11: Review and agree */}
          {currentStep === 11 && (
            <div>
              <h2 className="text-2xl font-black text-stone-900 leading-tight">Review and agree</h2>

              <div className="mt-5 divide-y divide-[#EFE7DF] text-stone-900">
                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Owner</p>
                    <p className="text-xs font-bold">{ownerName} · +91 {mobile}</p>
                  </div>
                  <button onClick={() => onStepChange(4)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>

                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Salon</p>
                    <p className="text-xs font-bold">{salonName} · {category}</p>
                  </div>
                  <button onClick={() => onStepChange(6)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>

                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Location</p>
                    <p className="text-xs font-bold">Saheed Nagar · {pincode}</p>
                  </div>
                  <button onClick={() => onStepChange(7)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>

                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Services</p>
                    <p className="text-xs font-bold">4 services</p>
                  </div>
                  <button onClick={() => onStepChange(8)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>

                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Stylists</p>
                    <p className="text-xs font-bold">3 people</p>
                  </div>
                  <button onClick={() => onStepChange(9)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>

                <div className="py-2.5 flex items-center justify-between">
                  <div>
                    <p className="text-[11px] text-stone-500 font-medium">Timings</p>
                    <p className="text-xs font-bold">Open 7 days · Mon break 2–4 PM</p>
                  </div>
                  <button onClick={() => onStepChange(10)} className="text-xs font-bold text-[#C52243]">
                    Edit
                  </button>
                </div>
              </div>

              {/* Agreement checkbox */}
              <div
                onClick={() => setAgreed(!agreed)}
                className="mt-6 p-4 rounded-xl border-2 border-[#C52243] bg-white flex items-center space-x-3 cursor-pointer"
              >
                <div
                  className={`w-5 h-5 rounded flex items-center justify-center transition ${
                    agreed ? 'bg-[#C52243] text-white' : 'border border-stone-300'
                  }`}
                >
                  {agreed && <Check className="w-3.5 h-3.5 stroke-[3]" />}
                </div>
                <span className="text-xs font-bold text-stone-900 leading-tight">
                  I agree with all terms and policies of Zalono
                </span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Footer Navigation Button */}
      <div className="space-y-2 pt-2">
        <button
          onClick={() => onStepChange(currentStep + 1)}
          disabled={currentStep === 11 && !agreed}
          className={`w-full py-3.5 rounded-full text-sm font-bold shadow-md transition active:scale-[0.98] ${
            currentStep === 11 && !agreed
              ? 'bg-stone-300 text-stone-500 cursor-not-allowed'
              : 'bg-[#C52243] hover:bg-[#B31D3B] text-white'
          }`}
        >
          {currentStep === 11 ? 'Submit for review' : 'Continue'}
        </button>

        {currentStep === 9 && (
          <button
            onClick={() => onStepChange(currentStep + 1)}
            className="w-full text-center text-xs font-bold text-[#C52243] py-1.5"
          >
            Skip for now
          </button>
        )}
      </div>
    </div>
  );
};
