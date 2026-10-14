import React, { useState } from 'react';
import { ChevronLeft, Plus, Bell, X } from 'lucide-react';
import { Stylist } from '../../types';

interface StylistsScreenProps {
  stylists: Stylist[];
  onToggleStylist: (id: string, isAvailable: boolean) => void;
  onBack: () => void;
  showTurnOffModalDirect?: boolean;
}

export const StylistsScreen: React.FC<StylistsScreenProps> = ({
  stylists,
  onToggleStylist,
  onBack,
  showTurnOffModalDirect = false,
}) => {
  const [showTurnOffSheet, setShowTurnOffSheet] = useState(showTurnOffModalDirect);
  const [offDuration, setOffDuration] = useState<'Until 5:00 PM' | 'Today' | 'Tomorrow' | 'Custom'>('Until 5:00 PM');
  const [reassignTarget, setReassignTarget] = useState<'Priya' | 'Neha'>('Priya');

  const rahul = stylists.find((s) => s.id === 'st-rahul') || stylists[1];
  const priya = stylists.find((s) => s.id === 'st-priya') || stylists[0];
  const neha = stylists.find((s) => s.id === 'st-neha') || stylists[2];

  const handleRahulToggle = (checked: boolean) => {
    if (!checked) {
      setShowTurnOffSheet(true);
    } else {
      onToggleStylist('st-rahul', true);
    }
  };

  const confirmTurnOffRahul = () => {
    onToggleStylist('st-rahul', false);
    setShowTurnOffSheet(false);
  };

  return (
    <div className="flex-1 bg-[#FAF6F2] p-5 flex flex-col justify-between relative overflow-y-auto no-scrollbar">
      <div>
        {/* Top Header */}
        <div className="flex items-center justify-between">
          <button
            onClick={onBack}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          <button className="text-xs font-bold text-[#C52243] bg-white border border-[#C52243] px-3.5 py-1.5 rounded-full hover:bg-rose-50 transition">
            + Add stylist
          </button>
        </div>

        {/* Title */}
        <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-4">Stylists</h1>
        <p className="text-xs text-stone-500 mt-1.5 leading-relaxed">
          Turn a stylist off when they are not in. Customers stop seeing them and their slots close automatically.
        </p>

        {/* Stylist Cards */}
        <div className="mt-6 space-y-3">
          {/* Priya */}
          <div className="bg-white rounded-2xl p-4 border border-[#EFE7DF] flex items-center justify-between shadow-sm">
            <div className="flex items-start space-x-3">
              <div className="w-10 h-10 rounded-full bg-[#FDEBED] text-[#C52243] font-black text-base flex items-center justify-center shrink-0">
                P
              </div>
              <div>
                <h3 className="text-sm font-extrabold text-stone-900">{priya?.name}</h3>
                <p className="text-xs text-stone-500 mt-0.5">Available · 4 bookings today</p>
              </div>
            </div>

            {/* Toggle */}
            <button
              onClick={() => onToggleStylist('st-priya', !priya?.isAvailable)}
              className={`w-12 h-6.5 rounded-full p-0.5 transition-colors flex items-center ${
                priya?.isAvailable ? 'bg-[#C52243]' : 'bg-stone-300'
              }`}
            >
              <div
                className={`w-5.5 h-5.5 rounded-full bg-white shadow transition-transform ${
                  priya?.isAvailable ? 'translate-x-5.5' : 'translate-x-0'
                }`}
              />
            </button>
          </div>

          {/* Rahul Das */}
          <div className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm">
            <div className="flex items-center justify-between">
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 rounded-full bg-[#FDEBED] text-[#C52243] font-black text-base flex items-center justify-center shrink-0">
                  R
                </div>
                <div>
                  <h3 className="text-sm font-extrabold text-stone-900">{rahul?.name}</h3>
                  <p className="text-xs text-stone-500 mt-0.5">
                    {rahul?.isAvailable ? 'Available · 1 booking today' : 'Off until 5:00 PM'}
                  </p>
                </div>
              </div>

              {/* Toggle */}
              <button
                onClick={() => handleRahulToggle(!rahul?.isAvailable)}
                className={`w-12 h-6.5 rounded-full p-0.5 transition-colors flex items-center ${
                  rahul?.isAvailable ? 'bg-[#C52243]' : 'bg-stone-300'
                }`}
              >
                <div
                  className={`w-5.5 h-5.5 rounded-full bg-white shadow transition-transform ${
                    rahul?.isAvailable ? 'translate-x-5.5' : 'translate-x-0'
                  }`}
                />
              </button>
            </div>

            {/* Reassign alert inside Rahul card if off */}
            {!rahul?.isAvailable && (
              <div className="mt-3 pt-3 border-t border-[#EFE7DF]">
                <div className="bg-[#FDEBED] rounded-xl p-3 flex items-center justify-between">
                  <div>
                    <h5 className="text-[11px] font-black text-[#A51B37]">
                      1 booking needs a new stylist
                    </h5>
                    <p className="text-[11px] text-[#A51B37]/80">Sneha R. · 3:00 PM · Facial</p>
                  </div>
                  <button
                    onClick={() => setShowTurnOffSheet(true)}
                    className="bg-[#C52243] text-white text-[10px] font-bold px-3 py-1.5 rounded-full hover:bg-rose-700 active:scale-95"
                  >
                    Reassign
                  </button>
                </div>

                <div className="flex items-center space-x-1.5 text-stone-500 text-[11px] font-semibold mt-2 px-1">
                  <Bell className="w-3.5 h-3.5 text-[#C52243]" />
                  <span>We will remind you at 5:00 PM to turn Rahul on.</span>
                </div>
              </div>
            )}
          </div>

          {/* Neha Patel */}
          <div className="bg-white rounded-2xl p-4 border border-[#EFE7DF] flex items-center justify-between shadow-sm">
            <div className="flex items-start space-x-3">
              <div className="w-10 h-10 rounded-full bg-[#FDEBED] text-[#C52243] font-black text-base flex items-center justify-center shrink-0">
                N
              </div>
              <div>
                <h3 className="text-sm font-extrabold text-stone-900">{neha?.name}</h3>
                <p className="text-xs text-stone-500 mt-0.5 leading-snug">
                  With a walk-in till 3:20 PM ·<br />opens again automatically
                </p>
              </div>
            </div>

            {/* Toggle */}
            <button
              onClick={() => onToggleStylist('st-neha', !neha?.isAvailable)}
              className={`w-12 h-6.5 rounded-full p-0.5 transition-colors flex items-center ${
                neha?.isAvailable ? 'bg-[#C52243]' : 'bg-stone-300'
              }`}
            >
              <div
                className={`w-5.5 h-5.5 rounded-full bg-white shadow transition-transform ${
                  neha?.isAvailable ? 'translate-x-5.5' : 'translate-x-0'
                }`}
              />
            </button>
          </div>
        </div>

        {/* What customers see footer card */}
        <div className="mt-7">
          <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mb-2">
            WHAT CUSTOMERS SEE
          </span>
          <div className="flex space-x-2">
            {priya?.isAvailable && (
              <span className="bg-white border border-[#EFE7DF] text-xs font-bold text-stone-900 px-3 py-1.5 rounded-xl shadow-xs">
                Priya
              </span>
            )}
            {rahul?.isAvailable && (
              <span className="bg-white border border-[#EFE7DF] text-xs font-bold text-stone-900 px-3 py-1.5 rounded-xl shadow-xs">
                Rahul
              </span>
            )}
            {neha?.isAvailable && (
              <span className="bg-white border border-[#EFE7DF] text-xs font-bold text-stone-900 px-3 py-1.5 rounded-xl shadow-xs">
                Neha
              </span>
            )}
          </div>
          <p className="text-xs text-stone-500 mt-2 leading-relaxed">
            {rahul?.isAvailable
              ? 'All 3 stylists are open for booking.'
              : "Rahul is hidden until 5:00 PM. Neha's slots reopen after 3:20 PM."}
          </p>
        </div>
      </div>

      {/* A11: Turn a stylist off Bottom Sheet Modal */}
      {showTurnOffSheet && (
        <div className="absolute inset-0 z-50 bg-black/50 flex flex-col justify-end animate-in fade-in duration-200">
          <div className="bg-white rounded-t-[32px] p-6 shadow-2xl border-t border-stone-200">
            <h3 className="text-2xl font-black text-stone-900 tracking-tight">Turn off Rahul?</h3>
            <p className="text-xs text-stone-500 mt-1 leading-normal">
              Customers will not see Rahul, and his slots close automatically.
            </p>

            <div className="mt-5 space-y-4">
              <div>
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  OFF FOR
                </label>
                <div className="grid grid-cols-4 gap-1.5 mt-1.5">
                  {(['Until 5:00 PM', 'Today', 'Tomorrow', 'Custom'] as const).map((d) => (
                    <button
                      key={d}
                      onClick={() => setOffDuration(d)}
                      className={`py-2 px-1 text-[11px] font-bold rounded-xl text-center transition ${
                        offDuration === d
                          ? 'bg-[#C52243] text-white shadow-sm'
                          : 'bg-white text-stone-700 border border-[#EFE7DF]'
                      }`}
                    >
                      {d}
                    </button>
                  ))}
                </div>
                <div className="flex items-center space-x-1.5 text-stone-500 text-[11px] font-semibold mt-2.5">
                  <Bell className="w-3.5 h-3.5 text-[#C52243]" />
                  <span>We will remind you at 5:00 PM to turn Rahul on.</span>
                </div>
              </div>

              {/* 1 Booking to move */}
              <div>
                <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
                  1 BOOKING TO MOVE
                </label>
                <div className="bg-[#FAF6F2] rounded-2xl p-3.5 mt-1.5 border border-[#EFE7DF]">
                  <p className="text-xs font-bold text-stone-900">Sneha R. · 3:00 PM · Facial</p>
                  <div className="grid grid-cols-2 gap-2 mt-2">
                    <button
                      onClick={() => setReassignTarget('Priya')}
                      className={`py-2 text-xs font-bold rounded-xl transition ${
                        reassignTarget === 'Priya'
                          ? 'bg-[#C52243] text-white shadow-sm'
                          : 'bg-white text-stone-800 border border-[#EFE7DF]'
                      }`}
                    >
                      Move to Priya
                    </button>
                    <button
                      onClick={() => setReassignTarget('Neha')}
                      className={`py-2 text-xs font-bold rounded-xl transition ${
                        reassignTarget === 'Neha'
                          ? 'bg-[#C52243] text-white shadow-sm'
                          : 'bg-white text-stone-800 border border-[#EFE7DF]'
                      }`}
                    >
                      Move to Neha
                    </button>
                  </div>
                  <p className="text-[11px] text-stone-500 mt-2">
                    The customer is told about the change.
                  </p>
                </div>
              </div>
            </div>

            {/* Actions */}
            <div className="mt-6 space-y-2 pb-1">
              <button
                onClick={confirmTurnOffRahul}
                className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
              >
                Turn off Rahul
              </button>
              <button
                onClick={() => setShowTurnOffSheet(false)}
                className="w-full bg-white hover:bg-stone-50 text-stone-800 border border-stone-200 font-bold py-3 rounded-full text-sm transition"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
