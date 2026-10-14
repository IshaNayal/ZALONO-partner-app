import React, { useState } from 'react';
import { ChevronLeft, Lock, Bell, Sparkles } from 'lucide-react';

interface LoginFlowProps {
  onLoginSuccess: () => void;
  onBackToWelcome: () => void;
  initialMode?: 'A1' | 'A2' | 'A3';
}

export const LoginFlow: React.FC<LoginFlowProps> = ({
  onLoginSuccess,
  onBackToWelcome,
  initialMode = 'A1',
}) => {
  const [mobile] = useState('98765 43210');
  const [otp, setOtp] = useState(['4', '2', '7', '', '', '']);
  const [isBlocked, setIsBlocked] = useState(initialMode === 'A2');
  const [showNotificationScreen, setShowNotificationScreen] = useState(initialMode === 'A3');

  const fillCompleteCode = () => {
    setOtp(['4', '2', '7', '9', '0', '1']);
    setIsBlocked(true);
  };

  // Screen 16: A3 Approved notification / Lock screen
  if (showNotificationScreen) {
    return (
      <div className="flex-1 bg-gradient-to-b from-[#8C1B30] to-[#5C0F1E] text-white p-6 flex flex-col justify-between">
        <div className="pt-10 text-center">
          <p className="text-rose-200 text-xs font-semibold tracking-wide">Monday, 12 October</p>
          <h1 className="text-7xl font-extrabold tracking-tighter mt-1 text-white">2:41</h1>

          {/* Interactive Push Notification Banner */}
          <div
            onClick={onLoginSuccess}
            className="mt-8 bg-white text-stone-900 rounded-3xl p-4.5 text-left shadow-2xl hover:scale-[1.02] active:scale-[0.98] transition cursor-pointer border border-white/20"
          >
            <div className="flex items-start space-x-3">
              <div className="w-9 h-9 rounded-xl bg-[#C52243] flex items-center justify-center text-white font-black text-lg shrink-0 shadow-md shadow-rose-300">
                Z
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <span className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider">
                    ZALONO PARTNER
                  </span>
                  <span className="text-[10px] text-stone-400">now</span>
                </div>
                <h4 className="text-sm font-extrabold text-stone-900 mt-1">
                  Glow Studio is approved
                </h4>
                <p className="text-xs text-stone-600 mt-0.5 leading-snug">
                  You can now log in and start taking bookings.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="pb-4 text-center">
          <p className="text-xs font-medium text-rose-200 animate-pulse">
            Tap the notification to open Zalono Partner
          </p>
        </div>
      </div>
    );
  }

  // Screens 14 & 15: A1 & A2 Login
  return (
    <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between">
      <div>
        <div className="flex items-center justify-between">
          <button
            onClick={onBackToWelcome}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <div className="w-9" />
        </div>

        {/* Brand */}
        <div className="flex items-center space-x-2 mt-4">
          <span className="text-2xl font-black text-[#C52243] tracking-tight">zalono</span>
          <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider">
            SALON PARTNER
          </span>
        </div>

        <h2 className="text-3xl font-extrabold text-stone-900 mt-6 leading-tight">Log in</h2>
        <p className="text-xs text-stone-500 mt-1.5 leading-normal">
          Use the mobile number you registered with.
        </p>

        {/* Mobile Number Box */}
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

        {/* 6-Digit Code */}
        <div className="mt-5">
          <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
            ENTER THE 6-DIGIT CODE
          </label>
          <div className="flex justify-between mt-2">
            {otp.map((d, i) => (
              <div
                key={i}
                onClick={fillCompleteCode}
                className={`w-11 h-12 rounded-xl bg-white flex items-center justify-center font-bold text-lg cursor-pointer transition ${
                  i === 3 && !isBlocked
                    ? 'border-2 border-[#C52243] text-stone-900'
                    : 'border border-[#EFE7DF] text-stone-900'
                }`}
              >
                {d}
              </div>
            ))}
          </div>

          {!isBlocked && (
            <p className="text-xs text-stone-500 mt-3">Resend code in 0:24</p>
          )}
        </div>

        {/* A2: Blocked Warning Card */}
        {isBlocked && (
          <div className="bg-[#FDEBED] rounded-2xl p-4.5 mt-5 border border-rose-200 flex items-start space-x-3 animate-in fade-in duration-300">
            <div className="w-8 h-8 rounded-xl bg-[#C52243] text-white flex items-center justify-center shrink-0">
              <Lock className="w-4 h-4 stroke-[2.5]" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-stone-900">Not approved yet</h4>
              <p className="text-[11px] text-stone-600 mt-1 leading-relaxed">
                Glow Studio is still being verified by the Zalono team. Login works once you are approved, and we will send you a notification.
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Action Footer */}
      <div className="space-y-3 pb-2">
        {isBlocked && (
          <button
            onClick={() => setShowNotificationScreen(true)}
            className="w-full flex items-center justify-center space-x-2 bg-rose-100/70 hover:bg-rose-100 text-[#C52243] font-bold py-2.5 rounded-full text-xs transition"
          >
            <Bell className="w-4 h-4" />
            <span>Simulate "Glow Studio is approved" Push Notification</span>
          </button>
        )}

        <button
          onClick={() => {
            if (!isBlocked) {
              fillCompleteCode();
            } else {
              onLoginSuccess();
            }
          }}
          className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
        >
          {isBlocked ? 'Log in (Approved)' : 'Log in'}
        </button>

        {isBlocked ? (
          <button className="w-full text-center text-xs font-bold text-[#C52243] py-1">
            Contact support
          </button>
        ) : (
          <p className="text-[11px] text-stone-500 text-center leading-tight">
            New salon? Ask a Zalono executive for an onboarding code.
          </p>
        )}
      </div>
    </div>
  );
};
