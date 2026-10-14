import React from 'react';
import { Wifi, Battery, Signal, ChevronLeft } from 'lucide-react';
import { Platform } from '../types';

interface DeviceFrameProps {
  platform: Platform;
  children: React.ReactNode;
  currentTime?: string;
  onBack?: () => void;
  showBackButton?: boolean;
}

export const DeviceFrame: React.FC<DeviceFrameProps> = ({
  platform,
  children,
  currentTime = '2:41',
  onBack,
  showBackButton,
}) => {
  return (
    <div className="relative mx-auto select-none transition-all duration-300">
      {/* Outer Phone Shell */}
      <div
        className={`relative overflow-hidden transition-all duration-300 shadow-2xl ${
          platform === 'ios'
            ? 'w-[390px] h-[844px] rounded-[52px] border-[10px] border-zinc-800 bg-[#FAF6F2] ring-1 ring-zinc-700/50 shadow-rose-950/20'
            : 'w-[400px] h-[840px] rounded-[44px] border-[10px] border-zinc-800 bg-[#FAF6F2] ring-1 ring-zinc-700/50 shadow-rose-950/20'
        }`}
      >
        {/* Status Bar */}
        <div className="absolute top-0 left-0 right-0 z-40 px-7 pt-3 pb-2 flex items-center justify-between text-zinc-900 pointer-events-none select-none">
          {/* Left: Time */}
          <span className="text-[13px] font-semibold tracking-tight">{currentTime}</span>

          {/* Notch / Dynamic Island */}
          {platform === 'ios' ? (
            <div className="w-[110px] h-[28px] bg-black rounded-full flex items-center justify-between px-2.5 mx-auto -mt-1 pointer-events-auto">
              <div className="w-2.5 h-2.5 rounded-full bg-zinc-900 ring-1 ring-zinc-800/80"></div>
              <div className="w-2.5 h-2.5 rounded-full bg-zinc-900 ring-1 ring-zinc-800/80"></div>
            </div>
          ) : (
            <div className="w-4 h-4 rounded-full bg-zinc-900 ring-2 ring-zinc-800 mx-auto -mt-1 pointer-events-auto"></div>
          )}

          {/* Right: Icons */}
          <div className="flex items-center space-x-1.5 text-zinc-900">
            <Signal className="w-3.5 h-3.5" />
            <Wifi className="w-3.5 h-3.5" />
            <Battery className="w-4 h-4" />
          </div>
        </div>

        {/* Screen Content Container with native-like scroll */}
        <div className="w-full h-full pt-10 pb-7 overflow-y-auto no-scrollbar relative flex flex-col">
          {children}
        </div>

        {/* Bottom Navigation Indicator */}
        <div className="absolute bottom-1.5 left-0 right-0 z-40 flex justify-center pointer-events-none">
          {platform === 'ios' ? (
            <div className="w-32 h-1 bg-zinc-900/60 rounded-full"></div>
          ) : (
            <div className="w-24 h-1 bg-zinc-800/80 rounded-full"></div>
          )}
        </div>
      </div>
    </div>
  );
};
