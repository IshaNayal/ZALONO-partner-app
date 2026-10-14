import React, { useState } from 'react';
import { Bell, ChevronRight, Plus, Sparkles } from 'lucide-react';
import { Stylist } from '../../types';

interface HomeScreenProps {
  onlineRevenue: number;
  onlineBookingsCount: number;
  completedBookingsCount: number;
  upcomingBookingsCount: number;
  isAcceptingBookings: boolean;
  onToggleAcceptingBookings: (val: boolean) => void;
  unreadNotificationsCount: number;
  stylists: Stylist[];
  onOpenAddWalkIn: () => void;
  onOpenStylists: () => void;
  onOpenNotifications: () => void;
  onNavigateToBookings: () => void;
}

export const HomeScreen: React.FC<HomeScreenProps> = ({
  onlineRevenue,
  onlineBookingsCount,
  completedBookingsCount,
  upcomingBookingsCount,
  isAcceptingBookings,
  onToggleAcceptingBookings,
  unreadNotificationsCount,
  stylists,
  onOpenAddWalkIn,
  onOpenStylists,
  onOpenNotifications,
  onNavigateToBookings,
}) => {
  const [selectedFilter, setSelectedFilter] = useState<'Today' | 'This week' | 'This month' | 'Custom'>('Today');

  const availableCount = stylists.filter((s) => s.isAvailable).length;

  return (
    <div className="flex-1 bg-[#FAF6F2] p-5 flex flex-col justify-between">
      <div>
        {/* Top Header */}
        <div className="flex items-start justify-between">
          <div>
            <p className="text-xs text-stone-500 font-semibold">Good afternoon, Rohan</p>
            <h1 className="text-2xl font-black text-stone-900 tracking-tight mt-0.5">
              Glow Studio
            </h1>
            <p className="text-xs text-stone-500 font-medium mt-0.5">Mon 12 Oct</p>
          </div>

          <button
            onClick={onOpenNotifications}
            className="relative w-10 h-10 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-800 hover:bg-stone-50 active:scale-95 transition"
          >
            <Bell className="w-5 h-5" />
            {unreadNotificationsCount > 0 && (
              <span className="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-[#C52243] text-white text-[10px] font-bold flex items-center justify-center border-2 border-[#FAF6F2]">
                {unreadNotificationsCount}
              </span>
            )}
          </button>
        </div>

        {/* Hero Card: Accepting Bookings */}
        <div className="bg-[#C52243] text-white rounded-3xl p-5 mt-5 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-lg font-black tracking-tight">Accepting bookings</h3>
              <p className="text-xs text-rose-100 mt-0.5">Customers can book you now</p>
            </div>

            <div className="flex items-center space-x-2">
              <span className="text-xs font-black tracking-wider">
                {isAcceptingBookings ? 'ON' : 'OFF'}
              </span>
              <button
                onClick={() => onToggleAcceptingBookings(!isAcceptingBookings)}
                className={`w-13 h-7 rounded-full p-0.5 transition-colors flex items-center ${
                  isAcceptingBookings ? 'bg-white' : 'bg-[#8F142D]'
                }`}
              >
                <div
                  className={`w-6 h-6 rounded-full transition-transform ${
                    isAcceptingBookings
                      ? 'translate-x-6 bg-[#C52243]'
                      : 'translate-x-0 bg-stone-300'
                  }`}
                />
              </button>
            </div>
          </div>
        </div>

        {/* Filters Row */}
        <div className="flex space-x-1.5 mt-5 overflow-x-auto no-scrollbar">
          {(['Today', 'This week', 'This month', 'Custom'] as const).map((filter) => (
            <button
              key={filter}
              onClick={() => setSelectedFilter(filter)}
              className={`px-4 py-2 rounded-full text-xs font-bold transition ${
                selectedFilter === filter
                  ? 'bg-[#C52243] text-white shadow-sm'
                  : 'text-stone-700 hover:bg-stone-200/50'
              }`}
            >
              {filter}
            </button>
          ))}
        </div>
        <p className="text-[11px] text-stone-500 mt-2">
          Online bookings only. Walk-ins are not counted.
        </p>

        {/* Revenue & Bookings Metrics */}
        <div className="grid grid-cols-2 gap-3 mt-3.5">
          {/* Online Revenue */}
          <div className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm">
            <span className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
              ONLINE REVENUE
            </span>
            <p className="text-2xl font-black text-stone-900 mt-2">
              ₹{onlineRevenue.toLocaleString('en-IN')}
            </p>
            <p className="text-[11px] text-stone-500 font-medium mt-1">Marked as paid</p>
          </div>

          {/* Online Bookings */}
          <div
            onClick={onNavigateToBookings}
            className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm cursor-pointer hover:border-[#C52243]/40 transition"
          >
            <span className="text-[10px] font-extrabold text-stone-500 uppercase tracking-wider block">
              ONLINE BOOKINGS
            </span>
            <p className="text-2xl font-black text-stone-900 mt-2">{onlineBookingsCount}</p>
            <p className="text-[11px] text-stone-500 font-medium mt-1">
              {completedBookingsCount} done, {upcomingBookingsCount} to come
            </p>
          </div>
        </div>

        {/* Stylists Today Card */}
        <div
          onClick={onOpenStylists}
          className="bg-white rounded-2xl p-4 mt-3 border border-[#EFE7DF] flex items-center justify-between shadow-sm cursor-pointer hover:border-[#C52243]/40 transition"
        >
          <div className="flex items-center space-x-3">
            {/* Avatars */}
            <div className="flex -space-x-1.5 overflow-hidden">
              {stylists.map((st) => (
                <div
                  key={st.id}
                  className="inline-block h-7 w-7 rounded-full ring-2 ring-white bg-[#FDEBED] text-[#C52243] font-extrabold text-xs flex items-center justify-center"
                >
                  {st.name[0]}
                </div>
              ))}
            </div>

            <div>
              <h4 className="text-xs font-extrabold text-stone-900">Stylists today</h4>
              <p className="text-[11px] text-stone-500">
                {availableCount} of {stylists.length} available · Rahul off till 5 PM
              </p>
            </div>
          </div>

          <ChevronRight className="w-4 h-4 text-stone-400" />
        </div>
      </div>

      {/* Floating Add Walk-in Action Button */}
      <div className="pt-4 pb-2">
        <button
          onClick={onOpenAddWalkIn}
          className="w-full bg-[#C52243] hover:bg-[#B31D3B] text-white font-bold py-3.5 rounded-full text-sm shadow-lg shadow-rose-900/20 flex items-center justify-center space-x-2 transition active:scale-[0.98]"
        >
          <Plus className="w-5 h-5 stroke-[2.5]" />
          <span>Add walk-in</span>
        </button>
      </div>
    </div>
  );
};
