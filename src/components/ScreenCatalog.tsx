import React from 'react';
import { ScreenId } from '../types';

export interface ScreenSpec {
  id: ScreenId;
  page: number;
  label: string;
  category: 'Registration' | 'Login & Daily Use' | 'More';
  description: string;
}

export const ALL_SCREENS: ScreenSpec[] = [
  // Registration
  { id: 'R1_WELCOME', page: 2, label: 'R1 · Welcome', category: 'Registration', description: 'Hero value prop, Next up booking card, Log in & Partner CTA' },
  { id: 'R2_VERIFY_MOBILE', page: 3, label: 'R2 · Verify mobile', category: 'Registration', description: 'Step 1 of 9: +91 98765 43210 mobile number & 6-digit OTP' },
  { id: 'R3_ONBOARDING_CODE', page: 4, label: 'R3 · Onboarding code', category: 'Registration', description: 'Step 2 of 9: ZL-4821 code verification unlock' },
  { id: 'R4_ABOUT_OWNER', page: 5, label: 'R4 · About the owner', category: 'Registration', description: 'Step 3 of 9: Rohan Mehta, email verify, PAN & KYC documents' },
  { id: 'R5_VERIFY_EMAIL', page: 6, label: 'R5 · Verify email', category: 'Registration', description: 'Step 3 of 9 (Email): 6-digit code sent to rohan@glowstudio.in' },
  { id: 'R6_SALON_DETAILS', page: 7, label: 'R6 · Salon details', category: 'Registration', description: 'Step 4 of 9: Glow Studio photos, category, and serves filters' },
  { id: 'R7_LOCATION', page: 8, label: 'R7 · Location', category: 'Registration', description: 'Step 5 of 9: Saheed Nagar map pin & pincode 751007' },
  { id: 'R8_SERVICES', page: 9, label: 'R8 · Services', category: 'Registration', description: 'Step 6 of 9: Hair/Skin/Nails/Body checklist with price & duration' },
  { id: 'R9_WHO_WORKS_HERE', page: 10, label: 'R9 · Who works here', category: 'Registration', description: 'Step 7 of 9: Stylist roster (Priya, Rahul, Neha)' },
  { id: 'R10_TIMINGS', page: 11, label: 'R10 · Timings', category: 'Registration', description: 'Step 8 of 9: Mon-Fri opening hours & split breaks' },
  { id: 'R11_REVIEW_AGREE', page: 12, label: 'R11 · Review and agree', category: 'Registration', description: 'Step 9 of 9: Summary overview with Edit jumps and terms check' },
  { id: 'R12_SUBMITTED', page: 13, label: 'R12 · Submitted', category: 'Registration', description: 'Application submitted progress tracker & verification notice' },

  // Login & Daily Use
  { id: 'A1_LOGIN', page: 14, label: 'A1 · Login', category: 'Login & Daily Use', description: 'Mobile login with OTP entry & 0:24 resend countdown' },
  { id: 'A2_LOGIN_BLOCKED', page: 15, label: 'A2 · Login blocked', category: 'Login & Daily Use', description: 'Not approved yet warning card & verification notice' },
  { id: 'A3_APPROVED_NOTIFICATION', page: 16, label: 'A3 · Approved notification', category: 'Login & Daily Use', description: 'Lock screen push alert: Glow Studio is approved' },
  { id: 'A4_HOME', page: 17, label: 'A4 · Home', category: 'Login & Daily Use', description: 'Accepting bookings toggle, online revenue ₹4,250, bookings, + Add walk-in' },
  { id: 'A5_ADD_WALKIN', page: 18, label: 'A5 · Add walk-in', category: 'Login & Daily Use', description: 'Walk-in bottom sheet with customer name, services, & Priya time block' },
  { id: 'A6_BOOKINGS_UPCOMING', page: 19, label: 'A6 · Bookings · Upcoming', category: 'Login & Daily Use', description: 'Now (In chair - Karan M.) & Later today queue (Aarav K., Sneha R.)' },
  { id: 'A7_BOOKINGS_HISTORY', page: 20, label: 'A7 · Bookings · History', category: 'Login & Daily Use', description: 'Done, No-show, Cancelled historical logs grouped by date' },
  { id: 'A8_BOOKING_DETAIL', page: 21, label: 'A8 · Booking detail', category: 'Login & Daily Use', description: 'Aarav K. #ZAL-6849 with call action, check in, & ETA status' },
  { id: 'A9_COMPLETE_MARK_PAID', page: 22, label: 'A9 · Complete and mark paid', category: 'Login & Daily Use', description: 'Collect ₹548 bill breakdown & Cash/UPI/Card payment recording' },
  { id: 'A10_STYLISTS', page: 23, label: 'A10 · Stylists', category: 'Login & Daily Use', description: 'Staff availability switchers & customer visibility preview' },
  { id: 'A11_TURN_OFF_STYLIST', page: 24, label: 'A11 · Turn a stylist off', category: 'Login & Daily Use', description: 'Reassign Sneha R. booking to Priya/Neha and pause shift' },
  { id: 'A12_NOTIFICATIONS', page: 25, label: 'A12 · Notifications', category: 'Login & Daily Use', description: 'Actionable alerts hub with inline "Turn on" button for Rahul' },

  // More
  { id: 'M1_MORE', page: 26, label: 'M1 · More', category: 'More', description: 'Glow Studio verified header and partner management navigation' },
  { id: 'M2_SALON_PROFILE', page: 27, label: 'M2 · Salon profile', category: 'More', description: 'View-only verified salon details & photo gallery' },
  { id: 'M3_OWNER_PROFILE', page: 28, label: 'M3 · Owner profile', category: 'More', description: 'View-only owner KYC details & PAN verification status' },
  { id: 'M4_TIMINGS', page: 29, label: 'M4 · Timings', category: 'More', description: 'Weekly shift schedules & Copy Monday timings to all days' },
  { id: 'M5_SUPPORT', page: 30, label: 'M5 · Support', category: 'More', description: 'Dedicated executive Rahul K. phone action & FAQs' },
  { id: 'M6_LOGOUT', page: 31, label: 'M6 · Log out', category: 'More', description: 'Confirmation modal preventing missed booking alerts' },
];

interface ScreenCatalogProps {
  currentScreenId: ScreenId;
  onSelectScreen: (id: ScreenId) => void;
}

export const ScreenCatalog: React.FC<ScreenCatalogProps> = ({
  currentScreenId,
  onSelectScreen,
}) => {
  return (
    <div className="bg-zinc-900 border border-zinc-800 rounded-2xl p-4 flex flex-col h-full">
      <div className="flex items-center justify-between pb-3 border-b border-zinc-800">
        <div>
          <h3 className="text-sm font-extrabold text-white flex items-center space-x-2">
            <span>31-Screen Design Navigator</span>
          </h3>
          <p className="text-[11px] text-zinc-400 mt-0.5">
            Click any screen to jump directly into its design specification
          </p>
        </div>
        <span className="text-xs font-bold text-rose-400 bg-rose-950/60 border border-rose-800/60 px-2.5 py-1 rounded-full">
          MVP Pilot
        </span>
      </div>

      <div className="overflow-y-auto space-y-4 pr-1 mt-3 flex-1 no-scrollbar">
        {(['Registration', 'Login & Daily Use', 'More'] as const).map((cat) => {
          const screens = ALL_SCREENS.filter((s) => s.category === cat);
          return (
            <div key={cat}>
              <div className="flex items-center justify-between mb-1.5 px-1">
                <span className="text-[10px] font-black uppercase tracking-wider text-zinc-500">
                  {cat} ({screens.length} screens)
                </span>
                <span className="text-[10px] text-zinc-500 font-mono">
                  pp. {screens[0].page}–{screens[screens.length - 1].page}
                </span>
              </div>

              <div className="space-y-1">
                {screens.map((screen) => {
                  const isActive = currentScreenId === screen.id;
                  return (
                    <button
                      key={screen.id}
                      onClick={() => onSelectScreen(screen.id)}
                      className={`w-full text-left p-2 rounded-xl transition flex items-center justify-between text-xs ${
                        isActive
                          ? 'bg-[#C52243] text-white font-bold shadow-md shadow-rose-950/40'
                          : 'bg-zinc-950/50 hover:bg-zinc-800/80 text-zinc-300 border border-zinc-800/50'
                      }`}
                    >
                      <div className="min-w-0 flex-1 pr-2">
                        <div className="flex items-center space-x-2">
                          <span
                            className={`font-mono text-[10px] px-1.5 py-0.2 rounded font-bold ${
                              isActive ? 'bg-white/20 text-white' : 'bg-zinc-800 text-zinc-400'
                            }`}
                          >
                            p.{screen.page}
                          </span>
                          <span className="truncate font-semibold">{screen.label}</span>
                        </div>
                        <p
                          className={`text-[10px] truncate mt-0.5 ${
                            isActive ? 'text-rose-100' : 'text-zinc-500'
                          }`}
                        >
                          {screen.description}
                        </p>
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};
