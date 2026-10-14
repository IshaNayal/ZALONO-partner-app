import React from 'react';
import { ChevronLeft, Phone, Clock, AlertTriangle } from 'lucide-react';
import { Booking } from '../../types';

interface BookingDetailSheetProps {
  booking: Booking;
  onClose: () => void;
  onCheckIn: () => void;
  onMarkNoShow: () => void;
  onCancelBooking: () => void;
}

export const BookingDetailSheet: React.FC<BookingDetailSheetProps> = ({
  booking,
  onClose,
  onCheckIn,
  onMarkNoShow,
  onCancelBooking,
}) => {
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

        {/* Booking Reference */}
        <div className="flex items-center justify-between mt-5">
          <span className="text-[11px] font-black text-stone-500 uppercase tracking-widest">
            BOOKING #{booking.id}
          </span>
          <span className="bg-[#FDEBED] text-[#C52243] text-xs font-bold px-3 py-1 rounded-full">
            Confirmed
          </span>
        </div>

        <h2 className="text-3xl font-extrabold text-stone-900 mt-2 tracking-tight">
          {booking.customerName}
        </h2>

        {/* Detail Table */}
        <div className="mt-6 divide-y divide-[#EFE7DF] border-t border-b border-[#EFE7DF]">
          <div className="py-3 flex justify-between items-center text-sm">
            <span className="text-stone-500 text-xs font-semibold">Time</span>
            <span className="font-extrabold text-stone-900">{booking.timeString}</span>
          </div>

          <div className="py-3 flex justify-between items-center text-sm">
            <span className="text-stone-500 text-xs font-semibold">Services</span>
            <span className="font-extrabold text-stone-900">{booking.services}</span>
          </div>

          <div className="py-3 flex justify-between items-center text-sm">
            <span className="text-stone-500 text-xs font-semibold">Stylist</span>
            <span className="font-extrabold text-stone-900">{booking.stylistName}</span>
          </div>

          <div className="py-3 flex justify-between items-center text-sm">
            <span className="text-stone-500 text-xs font-semibold">Total</span>
            <span className="font-extrabold text-stone-900">
              ₹{booking.totalAmount.toLocaleString('en-IN')} · pay at salon
            </span>
          </div>
        </div>

        {/* Live Customer Status Tag */}
        <div className="bg-[#FDEBED] rounded-2xl p-4 mt-6 flex items-center space-x-2 text-[#C52243] text-xs font-bold">
          <Clock className="w-4 h-4 shrink-0" />
          <span>{booking.statusDescription || 'Left home · about 8 min away'}</span>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="space-y-3 pb-2">
        <div className="grid grid-cols-2 gap-3">
          <button
            onClick={() => {
              window.open(`tel:${booking.customerPhone || '9876543210'}`);
            }}
            className="w-full bg-white hover:bg-stone-50 text-[#C52243] border-1.5 border-[#C52243] font-bold py-3.5 rounded-full text-sm flex items-center justify-center space-x-2 transition active:scale-[0.98]"
          >
            <Phone className="w-4 h-4" />
            <span>Call</span>
          </button>

          <button
            onClick={onCheckIn}
            className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
          >
            Check in
          </button>
        </div>

        <div className="flex justify-between items-center px-4 pt-1">
          <button
            onClick={onMarkNoShow}
            className="text-xs font-bold text-[#C52243] hover:underline"
          >
            Mark no-show
          </button>
          <button
            onClick={onCancelBooking}
            className="text-xs font-bold text-stone-500 hover:text-stone-800"
          >
            Cancel booking
          </button>
        </div>
      </div>
    </div>
  );
};
