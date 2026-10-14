import React, { useState } from 'react';
import { ChevronLeft } from 'lucide-react';
import { Booking } from '../../types';

interface CollectPaymentSheetProps {
  booking: Booking;
  currentOnlineRevenue: number;
  onClose: () => void;
  onCompleteAndPaid: (amount: number, method: 'Cash' | 'UPI' | 'Card') => void;
}

export const CollectPaymentSheet: React.FC<CollectPaymentSheetProps> = ({
  booking,
  currentOnlineRevenue,
  onClose,
  onCompleteAndPaid,
}) => {
  const [method, setMethod] = useState<'Cash' | 'UPI' | 'Card'>('UPI');
  const amount = booking.totalAmount || 548;
  const projectedRevenue = currentOnlineRevenue + amount;

  return (
    <div className="flex-1 bg-[#FAF6F2] p-6 flex flex-col justify-between">
      <div>
        {/* Top Header */}
        <div className="flex items-center justify-between">
          <button
            onClick={onClose}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <div className="w-9" />
        </div>

        {/* Heading */}
        <h2 className="text-3xl font-extrabold text-stone-900 mt-5 tracking-tight">
          Collect ₹{amount}
        </h2>
        <p className="text-xs text-stone-500 mt-1">
          {booking.customerName} · {booking.services} · {booking.stylistName}
        </p>

        {/* Breakdown Items */}
        <div className="mt-6 divide-y divide-[#EFE7DF] border-t border-b border-[#EFE7DF]">
          <div className="py-2.5 flex justify-between items-center text-xs">
            <span className="text-stone-700 font-medium">Haircut (Men)</span>
            <span className="font-extrabold text-stone-900">₹399</span>
          </div>
          <div className="py-2.5 flex justify-between items-center text-xs">
            <span className="text-stone-700 font-medium">Beard trim</span>
            <span className="font-extrabold text-stone-900">₹149</span>
          </div>
          <div className="py-3 flex justify-between items-center text-sm font-black text-stone-900">
            <span>Total</span>
            <span className="text-base">₹{amount}</span>
          </div>
        </div>

        {/* Payment Method Selector */}
        <div className="mt-6">
          <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
            HOW DID THEY PAY?
          </label>
          <div className="grid grid-cols-3 gap-2 mt-2">
            {(['Cash', 'UPI', 'Card'] as const).map((m) => (
              <button
                key={m}
                onClick={() => setMethod(m)}
                className={`py-3 rounded-2xl text-xs font-bold transition ${
                  method === m
                    ? 'bg-[#C52243] text-white shadow-sm'
                    : 'bg-white text-stone-800 border border-[#EFE7DF]'
                }`}
              >
                {m}
              </button>
            ))}
          </div>
        </div>

        {/* Info Box */}
        <div className="bg-[#FDEBED] rounded-2xl p-4 mt-6 border border-rose-200">
          <p className="text-xs text-[#A51B37] leading-relaxed">
            Zalono does not process this payment. You are only recording it. It adds to Online revenue on Home.
          </p>
        </div>
      </div>

      {/* Complete Action Button */}
      <div className="space-y-2 pb-2">
        <button
          onClick={() => onCompleteAndPaid(amount, method)}
          className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
        >
          Mark paid and complete
        </button>
        <p className="text-[11px] text-stone-500 text-center font-medium">
          Online revenue today will become ₹{projectedRevenue.toLocaleString('en-IN')}
        </p>
      </div>
    </div>
  );
};
