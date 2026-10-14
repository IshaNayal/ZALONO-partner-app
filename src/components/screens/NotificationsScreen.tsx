import React, { useState } from 'react';
import { ChevronLeft, Users, Check, Clock, Calendar } from 'lucide-react';
import { NotificationItem } from '../../types';

interface NotificationsScreenProps {
  notifications: NotificationItem[];
  onBack: () => void;
  onTurnOnRahul: () => void;
}

export const NotificationsScreen: React.FC<NotificationsScreenProps> = ({
  notifications,
  onBack,
  onTurnOnRahul,
}) => {
  const [items, setItems] = useState<NotificationItem[]>(notifications);
  const [rahulTurnedOn, setRahulTurnedOn] = useState(false);

  const markAllRead = () => {
    setItems(items.map((it) => ({ ...it, unread: false })));
  };

  const handleTurnOn = () => {
    setRahulTurnedOn(true);
    onTurnOnRahul();
  };

  return (
    <div className="flex-1 bg-[#FAF6F2] p-5 flex flex-col justify-between overflow-y-auto no-scrollbar">
      <div>
        {/* Top Header */}
        <div className="flex items-center justify-between">
          <button
            onClick={onBack}
            className="w-9 h-9 rounded-full bg-white border border-[#EFE7DF] flex items-center justify-center text-stone-700 hover:bg-stone-50 active:scale-95 transition"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>

          <button
            onClick={markAllRead}
            className="text-xs font-bold text-[#C52243] hover:underline"
          >
            Mark all read
          </button>
        </div>

        {/* Title */}
        <h1 className="text-3xl font-extrabold text-stone-900 tracking-tight mt-4">
          Notifications
        </h1>

        <span className="text-[10px] font-black text-stone-500 uppercase tracking-widest block mt-6 mb-3">
          TODAY
        </span>

        {/* Notification Cards */}
        <div className="space-y-3">
          {items.map((item) => {
            if (item.id === 'n1') {
              // Rahul off time ended card (with action buttons)
              return (
                <div
                  key={item.id}
                  className="bg-white rounded-2xl p-4.5 border border-[#C52243] shadow-sm"
                >
                  <div className="flex items-start space-x-3">
                    <div className="w-9 h-9 rounded-xl bg-[#FDEBED] text-[#C52243] flex items-center justify-center shrink-0">
                      <Users className="w-4.5 h-4.5" />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between">
                        <h4 className="text-sm font-extrabold text-stone-900 leading-snug">
                          {item.title}
                        </h4>
                        <div className="flex items-center space-x-1.5 shrink-0 ml-2">
                          <span className="text-[11px] text-stone-500">{item.time}</span>
                          {item.unread && (
                            <span className="w-2 h-2 rounded-full bg-[#C52243]" />
                          )}
                        </div>
                      </div>

                      <p className="text-xs text-stone-600 mt-1">{item.body}</p>

                      <div className="flex items-center space-x-2 mt-3.5">
                        <button
                          onClick={handleTurnOn}
                          className="bg-[#C52243] hover:bg-[#B31D3B] text-white text-xs font-bold px-4 py-1.5 rounded-full shadow-sm transition active:scale-95"
                        >
                          {rahulTurnedOn ? 'Turned on' : 'Turn on'}
                        </button>
                        <button className="text-xs font-semibold text-stone-500 hover:text-stone-800 px-2 py-1">
                          Later
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              );
            }

            return (
              <div
                key={item.id}
                className="bg-white rounded-2xl p-4 border border-[#EFE7DF] shadow-sm flex items-start space-x-3"
              >
                <div className="w-9 h-9 rounded-xl bg-[#FDEBED] text-[#C52243] flex items-center justify-center shrink-0">
                  {item.type === 'stylist_open' ? (
                    <Check className="w-4.5 h-4.5 stroke-[3]" />
                  ) : item.type === 'on_way' ? (
                    <Clock className="w-4.5 h-4.5" />
                  ) : (
                    <Calendar className="w-4.5 h-4.5" />
                  )}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <h4 className="text-sm font-extrabold text-stone-900 truncate">
                      {item.title}
                    </h4>
                    <div className="flex items-center space-x-1.5 shrink-0 ml-2">
                      <span className="text-[11px] text-stone-500">{item.time}</span>
                      {item.unread && (
                        <span className="w-2 h-2 rounded-full bg-[#C52243]" />
                      )}
                    </div>
                  </div>

                  <p className="text-xs text-stone-600 mt-1 leading-normal">{item.body}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
