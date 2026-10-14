import React, { useState } from 'react';
import {
  ChevronLeft,
  ChevronRight,
  Store,
  User,
  Users,
  Clock,
  Headphones,
  LogOut,
  Lock,
  Phone,
  Mail,
  HelpCircle,
  Check,
} from 'lucide-react';

interface MoreScreensProps {
  onNavigateToStylists: () => void;
  onLogout: () => void;
  initialSubScreen?: 'M1' | 'M2' | 'M3' | 'M4' | 'M5' | 'M6';
}

export const MoreScreens: React.FC<MoreScreensProps> = ({
  onNavigateToStylists,
  onLogout,
  initialSubScreen = 'M1',
}) => {
  const [subScreen, setSubScreen] = useState<'menu' | 'salon' | 'owner' | 'timings' | 'support'>(
    initialSubScreen === 'M2'
      ? 'salon'
      : initialSubScreen === 'M3'
      ? 'owner'
      : initialSubScreen === 'M4'
      ? 'timings'
      : initialSubScreen === 'M5'
      ? 'support'
      : 'menu'
  );

  const [showLogoutModal, setShowLogoutModal] = useState(initialSubScreen === 'M6');

  // M2: Salon Profile (View Only)
  if (subScreen === 'salon') {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between overflow-y-auto no-scrollbar">
        <div>
          <div className="flex items-center justify-between">
            <button
              onClick={() => setSubScreen('menu')}
              className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <div className="bg-[#EFEAE4] text-stone-600 text-[11px] font-bold px-2.5 py-1 rounded-md flex items-center space-x-1">
              <Lock className="w-3 h-3" />
              <span>View only</span>
            </div>
          </div>

          <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-5">
            Salon profile
          </h1>

          {/* Photos */}
          <div className="grid grid-cols-3 gap-2.5 mt-5">
            <div className="h-16 rounded-xl bg-[#E8A5AA]"></div>
            <div className="h-16 rounded-xl bg-[#E8A5AA]"></div>
            <div className="h-16 rounded-xl bg-[#F0CACD]"></div>
          </div>

          {/* Fields */}
          <div className="mt-6 divide-y divide-[#EFE7DF] border-t border-b border-[#EFE7DF]">
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Salon name</span>
              <span className="font-extrabold text-stone-900">Glow Studio</span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Category</span>
              <span className="font-extrabold text-stone-900">Premium</span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Serves</span>
              <span className="font-extrabold text-stone-900">Unisex, Kids salon</span>
            </div>
            <div className="py-3 flex justify-between items-start text-xs">
              <span className="text-stone-500 font-semibold shrink-0 w-16">Address</span>
              <span className="font-extrabold text-stone-900 text-right leading-tight max-w-[210px]">
                Plot No. 123, Saheed Nagar, Near Big Bazaar, Bhubaneswar 751007
              </span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Services</span>
              <span className="font-extrabold text-stone-900">4 services</span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Stylists</span>
              <span className="font-extrabold text-stone-900">3 people</span>
            </div>
          </div>

          {/* Notice Box */}
          <div className="bg-[#FDEBED] rounded-2xl p-4 mt-6 border border-rose-200">
            <p className="text-xs text-[#A51B37] leading-relaxed">
              Need to change something here? Contact Zalono support and we will update it for you.
            </p>
          </div>
        </div>

        <div className="pt-6 pb-2">
          <button
            onClick={() => setSubScreen('support')}
            className="w-full bg-white hover:bg-stone-50 text-[#C52243] border border-[#C52243] font-bold py-3.5 rounded-full text-sm transition"
          >
            Contact support
          </button>
        </div>
      </div>
    );
  }

  // M3: Owner Profile (View Only)
  if (subScreen === 'owner') {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between overflow-y-auto no-scrollbar">
        <div>
          <div className="flex items-center justify-between">
            <button
              onClick={() => setSubScreen('menu')}
              className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <div className="bg-[#EFEAE4] text-stone-600 text-[11px] font-bold px-2.5 py-1 rounded-md flex items-center space-x-1">
              <Lock className="w-3 h-3" />
              <span>View only</span>
            </div>
          </div>

          <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-5">
            Owner profile
          </h1>

          <div className="mt-6 divide-y divide-[#EFE7DF] border-t border-b border-[#EFE7DF]">
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Full name</span>
              <span className="font-extrabold text-stone-900">Rohan Mehta</span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Mobile (login)</span>
              <span className="font-extrabold text-stone-900">+91 98765 43210</span>
            </div>
            <div className="py-3 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Email</span>
              <span className="font-extrabold text-stone-900">rohan@glowstudio.in</span>
            </div>
          </div>

          <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mt-5 mb-2">
            DOCUMENTS
          </span>

          <div className="divide-y divide-[#EFE7DF] border-t border-b border-[#EFE7DF]">
            <div className="py-2.5 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">PAN card</span>
              <span className="text-[11px] font-bold text-[#C52243] border border-[#C52243] px-2.5 py-0.5 rounded-full">
                ✓ Added
              </span>
            </div>
            <div className="py-2.5 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Aadhaar card</span>
              <span className="text-xs font-bold text-stone-400">Not added</span>
            </div>
            <div className="py-2.5 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">Business proof</span>
              <span className="text-xs font-bold text-stone-400">Not added</span>
            </div>
            <div className="py-2.5 flex justify-between items-center text-xs">
              <span className="text-stone-500 font-semibold">GST number</span>
              <span className="font-extrabold text-stone-900">22ABCDE1234F1Z5</span>
            </div>
          </div>

          <div className="bg-[#FDEBED] rounded-2xl p-4 mt-6 border border-rose-200">
            <p className="text-xs text-[#A51B37] leading-relaxed">
              Documents are optional. To add or change anything here, contact Zalono support.
            </p>
          </div>
        </div>

        <div className="pt-6 pb-2">
          <button
            onClick={() => setSubScreen('support')}
            className="w-full bg-white hover:bg-stone-50 text-[#C52243] border border-[#C52243] font-bold py-3.5 rounded-full text-sm transition"
          >
            Contact support
          </button>
        </div>
      </div>
    );
  }

  // M4: Timings Screen
  if (subScreen === 'timings') {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between overflow-y-auto no-scrollbar">
        <div>
          <button
            onClick={() => setSubScreen('menu')}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-4">Timings</h1>
          <p className="text-xs text-stone-500 mt-1 leading-relaxed">
            Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.
          </p>

          <div className="space-y-3.5 mt-5">
            {/* Mon */}
            <div className="flex items-start space-x-3">
              <span className="w-8 font-bold text-sm text-stone-900 pt-2">Mon</span>
              <div className="flex-1 space-y-2">
                <div className="flex items-center space-x-2">
                  <div className="flex-1 bg-white border border-[#EFE7DF] rounded-xl px-3 py-2 text-xs font-semibold text-stone-900">
                    10:00 AM – 2:00 PM
                  </div>
                  <div className="w-10 h-6 bg-[#C52243] rounded-full p-0.5 flex items-center justify-end">
                    <div className="w-5 h-5 bg-white rounded-full"></div>
                  </div>
                </div>
                <div className="flex items-center space-x-2">
                  <div className="flex-1 bg-white border border-[#EFE7DF] rounded-xl px-3 py-2 text-xs font-semibold text-stone-900">
                    4:00 PM – 10:00 PM
                  </div>
                  <div className="w-10 h-6 bg-[#C52243] rounded-full p-0.5 flex items-center justify-end">
                    <div className="w-5 h-5 bg-white rounded-full"></div>
                  </div>
                </div>
                <button className="text-[11px] font-bold text-[#C52243]">+ Add timing</button>
              </div>
            </div>

            {/* Tue to Sat */}
            {['Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) => (
              <div key={d} className="flex items-start space-x-3">
                <span className="w-8 font-bold text-sm text-stone-900 pt-2">{d}</span>
                <div className="flex-1 space-y-1.5">
                  <div className="flex items-center space-x-2">
                    <div className="flex-1 bg-white border border-[#EFE7DF] rounded-xl px-3 py-2 text-xs font-semibold text-stone-900">
                      10:00 AM – 10:00 PM
                    </div>
                    <div className="w-10 h-6 bg-[#C52243] rounded-full p-0.5 flex items-center justify-end">
                      <div className="w-5 h-5 bg-white rounded-full"></div>
                    </div>
                  </div>
                  <button className="text-[11px] font-bold text-[#C52243]">+ Add timing</button>
                </div>
              </div>
            ))}
          </div>

          <button className="w-full text-center text-xs font-bold text-[#C52243] mt-5 hover:underline">
            Copy Monday's timings to all days
          </button>
        </div>

        <div className="pt-4 pb-2">
          <button
            onClick={() => setSubScreen('menu')}
            className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
          >
            Save changes
          </button>
        </div>
      </div>
    );
  }

  // M5: Support Screen
  if (subScreen === 'support') {
    return (
      <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between overflow-y-auto no-scrollbar">
        <div>
          <button
            onClick={() => setSubScreen('menu')}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-4">Support</h1>

          {/* Dedicated Executive Card */}
          <div className="bg-white rounded-2xl p-4.5 mt-5 border border-[#EFE7DF] flex items-center justify-between shadow-sm">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 rounded-full bg-[#FDEBED] text-[#C52243] font-black text-base flex items-center justify-center shrink-0">
                R
              </div>
              <div>
                <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block">
                  YOUR ZALONO EXECUTIVE
                </span>
                <h4 className="text-base font-extrabold text-stone-900">Rahul K.</h4>
              </div>
            </div>

            <button
              onClick={() => window.open('tel:9876543210')}
              className="bg-[#C52243] hover:bg-[#B31D3B] text-white text-xs font-bold px-4 py-2 rounded-full flex items-center space-x-1.5 shadow-sm active:scale-95 transition"
            >
              <Phone className="w-3.5 h-3.5" />
              <span>Call</span>
            </button>
          </div>

          {/* Quick Channels */}
          <div className="bg-white rounded-2xl mt-4 border border-[#EFE7DF] divide-y divide-[#EFE7DF] shadow-sm">
            <button
              onClick={() => window.open('tel:1800123456')}
              className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
            >
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 rounded-full bg-[#FDEBED] text-[#C52243] flex items-center justify-center">
                  <Phone className="w-4 h-4" />
                </div>
                <span className="text-xs font-extrabold text-stone-900">Call Zalono support</span>
              </div>
              <ChevronRight className="w-4 h-4 text-stone-400" />
            </button>

            <button
              onClick={() => window.open('mailto:partner@zalono.com')}
              className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
            >
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 rounded-full bg-[#FDEBED] text-[#C52243] flex items-center justify-center">
                  <Mail className="w-4 h-4" />
                </div>
                <span className="text-xs font-extrabold text-stone-900">Email support</span>
              </div>
              <ChevronRight className="w-4 h-4 text-stone-400" />
            </button>
          </div>

          {/* Common Questions */}
          <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mt-6 mb-2">
            COMMON QUESTIONS
          </span>

          <div className="bg-white rounded-2xl border border-[#EFE7DF] divide-y divide-[#EFE7DF] shadow-sm">
            {[
              'How do I check in a customer?',
              'A customer did not show up',
              'Change my salon details',
            ].map((q, idx) => (
              <div key={idx} className="p-4 flex items-center justify-between hover:bg-stone-50/50 transition cursor-pointer">
                <div className="flex items-center space-x-3">
                  <div className="w-6 h-6 rounded-full bg-[#FDEBED] text-[#C52243] flex items-center justify-center text-xs font-bold">
                    ?
                  </div>
                  <span className="text-xs font-bold text-stone-900">{q}</span>
                </div>
                <ChevronRight className="w-4 h-4 text-stone-400" />
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  // M1: More Main Menu
  return (
    <div className="flex-1 bg-[#FAF6F2] p-5 flex flex-col justify-between overflow-y-auto no-scrollbar relative">
      <div>
        <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight">More</h1>

        {/* Salon Card with Verified Badge */}
        <div className="bg-white rounded-2xl p-4 mt-5 border border-[#EFE7DF] flex items-center justify-between shadow-sm">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-full bg-[#FDEBED] text-[#C52243] font-black text-xl flex items-center justify-center shrink-0">
              G
            </div>
            <div>
              <h3 className="text-base font-extrabold text-stone-900">Glow Studio</h3>
              <p className="text-xs text-stone-500 leading-tight">
                Saheed Nagar,<br />Bhubaneswar
              </p>
            </div>
          </div>

          <span className="bg-[#FDEBED] text-[#C52243] text-xs font-bold px-2.5 py-1 rounded-full flex items-center space-x-1">
            <Check className="w-3 h-3 stroke-[3]" />
            <span>Verified</span>
          </span>
        </div>

        {/* Navigation Items Group */}
        <div className="bg-white rounded-2xl mt-4 border border-[#EFE7DF] divide-y divide-[#EFE7DF] shadow-sm">
          <button
            onClick={() => setSubScreen('salon')}
            className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
          >
            <div className="flex items-center space-x-3 text-stone-900">
              <Store className="w-5 h-5 text-[#C52243]" />
              <span className="text-sm font-bold">Salon profile</span>
            </div>
            <ChevronRight className="w-4 h-4 text-stone-400" />
          </button>

          <button
            onClick={() => setSubScreen('owner')}
            className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
          >
            <div className="flex items-center space-x-3 text-stone-900">
              <User className="w-5 h-5 text-[#C52243]" />
              <span className="text-sm font-bold">Owner profile</span>
            </div>
            <ChevronRight className="w-4 h-4 text-stone-400" />
          </button>

          <button
            onClick={onNavigateToStylists}
            className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
          >
            <div className="flex items-center space-x-3 text-stone-900">
              <Users className="w-5 h-5 text-[#C52243]" />
              <span className="text-sm font-bold">Stylists</span>
            </div>
            <ChevronRight className="w-4 h-4 text-stone-400" />
          </button>

          <button
            onClick={() => setSubScreen('timings')}
            className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
          >
            <div className="flex items-center space-x-3 text-stone-900">
              <Clock className="w-5 h-5 text-[#C52243]" />
              <span className="text-sm font-bold">Timings</span>
            </div>
            <ChevronRight className="w-4 h-4 text-stone-400" />
          </button>

          <button
            onClick={() => setSubScreen('support')}
            className="w-full p-4 flex items-center justify-between hover:bg-stone-50/50 transition text-left"
          >
            <div className="flex items-center space-x-3 text-stone-900">
              <Headphones className="w-5 h-5 text-[#C52243]" />
              <span className="text-sm font-bold">Support</span>
            </div>
            <ChevronRight className="w-4 h-4 text-stone-400" />
          </button>
        </div>

        {/* Log Out Option */}
        <div className="bg-white rounded-2xl mt-4 border border-[#EFE7DF] shadow-sm">
          <button
            onClick={() => setShowLogoutModal(true)}
            className="w-full p-4 flex items-center space-x-3 text-[#C52243] hover:bg-rose-50/30 transition text-left rounded-2xl"
          >
            <LogOut className="w-5 h-5" />
            <span className="text-sm font-bold">Log out</span>
          </button>
        </div>
      </div>

      <p className="text-[11px] text-stone-400 text-center py-4 font-medium">
        Zalono Partner · pilot version
      </p>

      {/* M6: Log Out Confirmation Modal Sheet */}
      {showLogoutModal && (
        <div className="absolute inset-0 z-50 bg-black/50 flex flex-col justify-end animate-in fade-in duration-200">
          <div className="bg-white rounded-t-[32px] p-6 shadow-2xl border-t border-stone-200">
            <h3 className="text-2xl font-black text-stone-900 tracking-tight">
              Log out of Glow Studio?
            </h3>
            <p className="text-xs text-stone-500 mt-2 leading-relaxed">
              You will not get booking alerts on this phone until you log in again.
            </p>

            <div className="mt-6 space-y-2.5 pb-2">
              <button
                onClick={() => {
                  setShowLogoutModal(false);
                  onLogout();
                }}
                className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
              >
                Log out
              </button>
              <button
                onClick={() => setShowLogoutModal(false)}
                className="w-full bg-white hover:bg-stone-50 text-[#C52243] border-1.5 border-[#C52243] font-bold py-3.5 rounded-full text-sm transition"
              >
                Stay logged in
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
