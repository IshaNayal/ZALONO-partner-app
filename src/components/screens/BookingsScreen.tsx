import React, { useState } from 'react';
import { SlidersHorizontal, ChevronDown } from 'lucide-react';
import { Booking } from '../../types';

interface BookingsScreenProps {
  upcomingBookings: Booking[];
  historyBookings: Booking[];
  onSelectBooking: (booking: Booking) => void;
  onMarkDoneDirect: (booking: Booking) => void;
  initialTab?: 'Upcoming' | 'History';
}

export const BookingsScreen: React.FC<BookingsScreenProps> = ({
  upcomingBookings,
  historyBookings,
  onSelectBooking,
  onMarkDoneDirect,
  initialTab = 'Upcoming',
}) => {
  const [tab, setTab] = useState<'Upcoming' | 'History'>(initialTab);
  const [upcomingFilter, setUpcomingFilter] = useState<'All' | 'Online' | 'Walk-in'>('All');
  const [historyFilter, setHistoryFilter] = useState<'All' | 'Done' | 'No-show' | 'Cancelled'>('All');

  // Filter upcoming
  const filteredUpcoming = upcomingBookings.filter((b) => {
    if (upcomingFilter === 'Online') return b.type === 'online';
    if (upcomingFilter === 'Walk-in') return b.type === 'walk_in';
    return true;
  });

  // Split into "Now (in chair)" vs "Later today"
  const nowBookings = filteredUpcoming.filter((b) => b.status === 'in_chair');
  const laterBookings = filteredUpcoming.filter((b) => b.status !== 'in_chair');

  // Filter history
  const filteredHistory = historyBookings.filter((b) => {
    if (historyFilter === 'Done') return b.status === 'done';
    if (historyFilter === 'No-show') return b.status === 'no_show';
    if (historyFilter === 'Cancelled') return b.status === 'cancelled';
    return true;
  });

  return (
    <div className="flex-1 bg-[#FAF6F2] p-5 flex flex-col overflow-y-auto no-scrollbar">
      {/* Title */}
      <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight">Bookings</h1>

      {/* Main Segmented Toggle: Upcoming | History */}
      <div className="bg-[#EFEAE4] p-1 rounded-full flex mt-4 border border-[#E5DDD4]">
        <button
          onClick={() => setTab('Upcoming')}
          className={`flex-1 py-2 text-xs font-bold rounded-full transition ${
            tab === 'Upcoming' ? 'bg-[#C52243] text-white shadow-sm' : 'text-stone-700 hover:text-stone-900'
          }`}
        >
          Upcoming
        </button>
        <button
          onClick={() => setTab('History')}
          className={`flex-1 py-2 text-xs font-bold rounded-full transition ${
            tab === 'History' ? 'bg-[#C52243] text-white shadow-sm' : 'text-stone-700 hover:text-stone-900'
          }`}
        >
          History
        </button>
      </div>

      {/* Sub-Filters */}
      {tab === 'Upcoming' ? (
        <div className="flex items-center justify-between mt-4">
          <div className="flex space-x-1.5">
            {(['All', 'Online', 'Walk-in'] as const).map((f) => (
              <button
                key={f}
                onClick={() => setUpcomingFilter(f)}
                className={`px-3.5 py-1.5 rounded-full text-xs font-bold transition ${
                  upcomingFilter === f
                    ? 'bg-[#C52243] text-white'
                    : 'bg-white text-stone-700 border border-[#EFE7DF]'
                }`}
              >
                {f}
              </button>
            ))}
          </div>

          <button className="w-8 h-8 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50">
            <SlidersHorizontal className="w-3.5 h-3.5" />
          </button>
        </div>
      ) : (
        <div className="mt-4">
          <div className="flex space-x-1.5">
            {(['All', 'Done', 'No-show', 'Cancelled'] as const).map((f) => (
              <button
                key={f}
                onClick={() => setHistoryFilter(f)}
                className={`px-3 py-1.5 rounded-full text-xs font-bold transition ${
                  historyFilter === f
                    ? 'bg-[#C52243] text-white'
                    : 'bg-white text-stone-700 border border-[#EFE7DF]'
                }`}
              >
                {f}
              </button>
            ))}
          </div>

          <div className="flex items-center justify-between text-xs text-stone-500 mt-3 pt-1">
            <div className="flex items-center space-x-1 font-bold text-stone-800 cursor-pointer">
              <span>Last 7 days</span>
              <ChevronDown className="w-3.5 h-3.5" />
            </div>
            <span>42 bookings · 3 no-shows</span>
          </div>
        </div>
      )}

      {/* Content List */}
      <div className="mt-5 space-y-4 pb-6">
        {tab === 'Upcoming' ? (
          <>
            {/* NOW Section */}
            {nowBookings.length > 0 && (
              <div>
                <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mb-2">
                  NOW
                </span>

                <div className="space-y-2.5">
                  {nowBookings.map((b) => (
                    <div
                      key={b.id}
                      className="bg-white rounded-2xl p-4.5 border-2 border-[#C52243] shadow-sm"
                    >
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-black text-[#C52243]">
                          {b.timeString}
                        </span>
                        <span className="bg-[#C52243] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">
                          In chair
                        </span>
                      </div>

                      <h3 className="text-lg font-bold text-stone-900 mt-2">{b.customerName}</h3>
                      <p className="text-xs text-stone-500 mt-0.5">
                        {b.services} · {b.stylistName}
                      </p>

                      <div className="flex items-center space-x-3 mt-4 pt-1">
                        <button
                          onClick={() => onMarkDoneDirect(b)}
                          className="bg-[#C52243] hover:bg-[#B31D3B] text-white text-xs font-bold px-4 py-2 rounded-full shadow-sm transition active:scale-95"
                        >
                          Mark done
                        </button>
                        <p className="text-[11px] text-stone-500 flex-1 leading-tight">
                          {b.statusDescription || `${b.stylistName} opens again for online booking after this.`}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* LATER TODAY Section */}
            <div>
              <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mb-2 mt-2">
                LATER TODAY
              </span>

              <div className="space-y-2.5">
                {laterBookings.map((b) => (
                  <div
                    key={b.id}
                    onClick={() => onSelectBooking(b)}
                    className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm hover:border-[#C52243]/50 transition cursor-pointer"
                  >
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-black text-[#C52243]">{b.timeString}</span>
                      <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-bold px-2 py-0.5 rounded-full">
                        Confirmed
                      </span>
                    </div>

                    <h3 className="text-base font-bold text-stone-900 mt-2">{b.customerName}</h3>
                    <p className="text-xs text-stone-500 mt-0.5">
                      {b.services} · {b.stylistName}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          </>
        ) : (
          /* A7: History List */
          <div className="space-y-4">
            <div>
              <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mb-2">
                YESTERDAY · SUN 11 OCT
              </span>

              <div className="space-y-2.5">
                {filteredHistory
                  .filter((b) => b.dateLabel?.includes('SUN 11 OCT') || !b.dateLabel)
                  .map((b) => (
                    <div
                      key={b.id}
                      className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm"
                    >
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#C52243]">{b.timeString}</span>
                        <span
                          className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full ${
                            b.status === 'done'
                              ? 'bg-stone-100 text-stone-600'
                              : 'bg-[#FDEBED] text-[#C52243]'
                          }`}
                        >
                          {b.status === 'done'
                            ? 'Done'
                            : b.status === 'no_show'
                            ? 'No-show'
                            : 'Cancelled'}
                        </span>
                      </div>

                      <div className="flex items-baseline justify-between mt-2">
                        <h3 className="text-base font-bold text-stone-900">{b.customerName}</h3>
                        {b.status === 'done' && (
                          <span className="text-sm font-extrabold text-stone-900">
                            ₹{b.totalAmount.toLocaleString('en-IN')}
                          </span>
                        )}
                      </div>

                      <p className="text-xs text-stone-500 mt-0.5">{b.services}</p>
                    </div>
                  ))}
              </div>
            </div>

            <div>
              <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mb-2">
                SAT 10 OCT
              </span>

              <div className="space-y-2.5">
                {filteredHistory
                  .filter((b) => b.dateLabel?.includes('SAT 10 OCT'))
                  .map((b) => (
                    <div
                      key={b.id}
                      className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm"
                    >
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#C52243]">{b.timeString}</span>
                        <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-bold px-2.5 py-0.5 rounded-full">
                          Cancelled
                        </span>
                      </div>

                      <h3 className="text-base font-bold text-stone-900 mt-2">{b.customerName}</h3>
                      <p className="text-xs text-stone-500 mt-0.5">{b.services}</p>
                    </div>
                  ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
