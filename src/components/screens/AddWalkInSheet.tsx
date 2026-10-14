import React, { useState } from 'react';
import { X, Lock, Check } from 'lucide-react';
import { Booking } from '../../types';

interface AddWalkInSheetProps {
  onClose: () => void;
  onAddBooking: (newBooking: Partial<Booking>) => void;
}

export const AddWalkInSheet: React.FC<AddWalkInSheetProps> = ({ onClose, onAddBooking }) => {
  const [customerName, setCustomerName] = useState('Mohit S.');
  const [mobileNumber, setMobileNumber] = useState('98765 12345');

  const [availableServices, setAvailableServices] = useState([
    { name: 'Haircut (Men)', price: 399, selected: true, duration: 30 },
    { name: 'Beard trim', price: 149, selected: true, duration: 15 },
    { name: 'Hair colour', price: 2499, selected: false, duration: 90 },
    { name: 'Hair spa', price: 1999, selected: false, duration: 60 },
  ]);

  const [selectedStylist, setSelectedStylist] = useState<'Priya' | 'Neha'>('Priya');

  const totalAmount = availableServices
    .filter((s) => s.selected)
    .reduce((sum, s) => sum + s.price, 0);

  const totalDuration = availableServices
    .filter((s) => s.selected)
    .reduce((sum, s) => sum + s.duration, 0);

  const toggleService = (index: number) => {
    const copy = [...availableServices];
    copy[index].selected = !copy[index].selected;
    setAvailableServices(copy);
  };

  const handleSubmit = () => {
    const selectedServiceNames = availableServices
      .filter((s) => s.selected)
      .map((s) => s.name)
      .join(' + ');

    onAddBooking({
      id: `WLK-${Math.floor(1000 + Math.random() * 9000)}`,
      customerName,
      customerPhone: `+91 ${mobileNumber}`,
      timeString: '2:40 PM · in chair',
      durationMinutes: totalDuration,
      services: selectedServiceNames || 'Haircut (Men)',
      stylistName: selectedStylist,
      totalAmount,
      status: 'in_chair',
      type: 'walk_in',
      statusDescription: `${selectedStylist} opens again automatically when marked done.`,
    });
    onClose();
  };

  return (
    <div className="absolute inset-0 z-50 bg-black/50 flex flex-col justify-end animate-in fade-in duration-200">
      <div className="bg-[#FAF6F2] rounded-t-[32px] p-6 max-h-[92%] overflow-y-auto no-scrollbar shadow-2xl border-t border-stone-200">
        {/* Header Close */}
        <div className="flex justify-between items-center">
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-100 transition"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <h2 className="text-2xl font-black text-stone-900 mt-3 tracking-tight">Add walk-in</h2>
        <p className="text-xs text-stone-500 mt-1 leading-normal">
          Add every customer who walks in, so no one can book the same stylist at the same time.
        </p>

        {/* Inputs */}
        <div className="mt-5 space-y-3.5">
          <div>
            <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
              CUSTOMER NAME
            </label>
            <input
              type="text"
              value={customerName}
              onChange={(e) => setCustomerName(e.target.value)}
              className="w-full bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1 font-bold text-stone-900 text-sm focus:outline-none focus:border-[#C52243]"
            />
          </div>

          <div>
            <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
              MOBILE NUMBER
            </label>
            <div className="bg-white rounded-xl px-4 py-3 border border-[#EFE7DF] mt-1 flex items-center space-x-3 text-stone-900 font-medium text-sm">
              <span className="font-bold text-stone-700">+91</span>
              <div className="w-[1px] h-4 bg-stone-200"></div>
              <input
                type="text"
                value={mobileNumber}
                onChange={(e) => setMobileNumber(e.target.value)}
                className="font-bold text-stone-900 text-sm focus:outline-none flex-1 bg-transparent"
              />
            </div>
          </div>

          {/* Services Selection */}
          <div>
            <div className="flex justify-between items-center">
              <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider">
                SERVICES
              </label>
              <span className="text-xs font-black text-stone-900">Total ₹{totalAmount}</span>
            </div>

            <div className="flex flex-wrap gap-2 mt-2">
              {availableServices.map((srv, idx) => (
                <button
                  key={idx}
                  onClick={() => toggleService(idx)}
                  className={`px-3 py-2 rounded-xl text-xs font-bold transition flex items-center space-x-1.5 ${
                    srv.selected
                      ? 'bg-[#C52243] text-white shadow-sm'
                      : 'bg-white text-stone-800 border border-[#EFE7DF]'
                  }`}
                >
                  <span>{srv.name}</span>
                  <span className={srv.selected ? 'text-rose-200' : 'text-stone-500'}>·</span>
                  <span>₹{srv.price}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Stylist Selection */}
          <div>
            <label className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
              STYLIST · AVAILABLE TODAY
            </label>
            <div className="grid grid-cols-2 gap-2 mt-1.5">
              <button
                onClick={() => setSelectedStylist('Priya')}
                className={`p-3 rounded-2xl text-left border transition ${
                  selectedStylist === 'Priya'
                    ? 'bg-[#C52243] text-white border-[#C52243]'
                    : 'bg-white text-stone-900 border-[#EFE7DF]'
                }`}
              >
                <p className="font-bold text-sm">Priya</p>
                <p className={`text-xs mt-0.5 ${selectedStylist === 'Priya' ? 'text-rose-100' : 'text-stone-500'}`}>
                  Free now
                </p>
              </button>

              <button
                onClick={() => setSelectedStylist('Neha')}
                className={`p-3 rounded-2xl text-left border transition ${
                  selectedStylist === 'Neha'
                    ? 'bg-[#C52243] text-white border-[#C52243]'
                    : 'bg-white text-stone-900 border-[#EFE7DF]'
                }`}
              >
                <p className="font-bold text-sm">Neha</p>
                <p className={`text-xs mt-0.5 ${selectedStylist === 'Neha' ? 'text-rose-100' : 'text-stone-500'}`}>
                  Busy till 3:20 PM
                </p>
              </button>
            </div>
          </div>

          {/* Locked Slot Notice Card */}
          <div className="bg-[#FDEBED] rounded-2xl p-3.5 border border-rose-200 flex items-start space-x-3">
            <div className="w-7 h-7 rounded-lg bg-[#C52243] text-white flex items-center justify-center shrink-0">
              <Lock className="w-3.5 h-3.5" />
            </div>
            <div>
              <h4 className="text-xs font-extrabold text-stone-900">
                Priya blocked · 2:40 – 3:25 PM
              </h4>
              <p className="text-[11px] text-stone-600 mt-0.5 leading-relaxed">
                Online booking is closed for this time. Priya opens again automatically when you mark this walk-in done.
              </p>
            </div>
          </div>
        </div>

        {/* Submit */}
        <div className="mt-5 pb-2">
          <button
            onClick={handleSubmit}
            className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-md transition active:scale-[0.98]"
          >
            Add walk-in and block time
          </button>
        </div>
      </div>
    </div>
  );
};
