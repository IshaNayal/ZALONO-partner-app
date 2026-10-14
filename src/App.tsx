import React, { useState } from 'react';
import {
  Smartphone,
  Code2,
  Layers,
  Sparkles,
  RotateCcw,
  Home as HomeIcon,
  Calendar,
  Menu,
  CheckCircle2,
  ExternalLink,
} from 'lucide-react';
import { DeviceFrame } from './components/DeviceFrame';
import { RegistrationScreens } from './components/screens/RegistrationScreens';
import { LoginFlow } from './components/screens/LoginFlow';
import { HomeScreen } from './components/screens/HomeScreen';
import { AddWalkInSheet } from './components/screens/AddWalkInSheet';
import { BookingsScreen } from './components/screens/BookingsScreen';
import { BookingDetailSheet } from './components/screens/BookingDetailSheet';
import { CollectPaymentSheet } from './components/screens/CollectPaymentSheet';
import { StylistsScreen } from './components/screens/StylistsScreen';
import { NotificationsScreen } from './components/screens/NotificationsScreen';
import { MoreScreens } from './components/screens/MoreScreens';
import { ScreenCatalog, ALL_SCREENS } from './components/ScreenCatalog';
import { FlutterCodeViewer } from './components/FlutterCodeViewer';
import {
  INITIAL_HISTORY_BOOKINGS,
  INITIAL_NOTIFICATIONS,
  INITIAL_STYLISTS,
  INITIAL_UPCOMING_BOOKINGS,
} from './mockData';
import { Booking, NotificationItem, Platform, ScreenId, Stylist } from './types';

export default function App() {
  // Top-level View Mode
  const [activeTab, setActiveTab] = useState<'simulator' | 'catalog' | 'flutter_code'>('simulator');
  const [platform, setPlatform] = useState<Platform>('ios');
  const [zoomScale, setZoomScale] = useState<number>(0.92);

  // App Navigation State
  // 'registration' | 'login' | 'main'
  const [appSection, setAppSection] = useState<'registration' | 'login' | 'main'>('main');
  const [regStep, setRegStep] = useState<number>(1); // 0 = Cover, 1 = R1, 2 = R2 ... 12 = R12
  const [loginMode, setLoginMode] = useState<'A1' | 'A2' | 'A3'>('A1');

  // Main App Bottom Tab
  const [bottomNavIndex, setBottomNavIndex] = useState<number>(0); // 0: Home, 1: Bookings, 2: More

  // Modals & Sheets
  const [showAddWalkIn, setShowAddWalkIn] = useState<boolean>(false);
  const [selectedBookingForDetail, setSelectedBookingForDetail] = useState<Booking | null>(null);
  const [selectedBookingForPayment, setSelectedBookingForPayment] = useState<Booking | null>(null);
  const [showStylistsScreen, setShowStylistsScreen] = useState<boolean>(false);
  const [showTurnOffRahulModalDirect, setShowTurnOffRahulModalDirect] = useState<boolean>(false);
  const [showNotificationsScreen, setShowNotificationsScreen] = useState<boolean>(false);
  const [moreSubScreen, setMoreSubScreen] = useState<'M1' | 'M2' | 'M3' | 'M4' | 'M5' | 'M6'>('M1');

  // Live Reactive App Data
  const [onlineRevenue, setOnlineRevenue] = useState<number>(4250);
  const [isAcceptingBookings, setIsAcceptingBookings] = useState<boolean>(true);
  const [upcomingBookings, setUpcomingBookings] = useState<Booking[]>(INITIAL_UPCOMING_BOOKINGS);
  const [historyBookings, setHistoryBookings] = useState<Booking[]>(INITIAL_HISTORY_BOOKINGS);
  const [stylists, setStylists] = useState<Stylist[]>(INITIAL_STYLISTS);
  const [notifications, setNotifications] = useState<NotificationItem[]>(INITIAL_NOTIFICATIONS);

  // Toast feedback message
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

  // Reset to initial state
  const handleResetData = () => {
    setOnlineRevenue(4250);
    setIsAcceptingBookings(true);
    setUpcomingBookings(INITIAL_UPCOMING_BOOKINGS);
    setHistoryBookings(INITIAL_HISTORY_BOOKINGS);
    setStylists(INITIAL_STYLISTS);
    setNotifications(INITIAL_NOTIFICATIONS);
    setAppSection('main');
    setBottomNavIndex(0);
    setShowAddWalkIn(false);
    setSelectedBookingForDetail(null);
    setSelectedBookingForPayment(null);
    setShowStylistsScreen(false);
    setShowNotificationsScreen(false);
    setMoreSubScreen('M1');
    showToast('Reset to default pilot demo data');
  };

  // Jump to specific screen from the 31 design pages
  const handleJumpToScreen = (screenId: ScreenId) => {
    // Close existing sub-modals
    setShowAddWalkIn(false);
    setSelectedBookingForDetail(null);
    setSelectedBookingForPayment(null);
    setShowStylistsScreen(false);
    setShowNotificationsScreen(false);
    setShowTurnOffRahulModalDirect(false);

    switch (screenId) {
      case 'R1_WELCOME':
        setAppSection('registration');
        setRegStep(1);
        break;
      case 'R2_VERIFY_MOBILE':
        setAppSection('registration');
        setRegStep(2);
        break;
      case 'R3_ONBOARDING_CODE':
        setAppSection('registration');
        setRegStep(3);
        break;
      case 'R4_ABOUT_OWNER':
        setAppSection('registration');
        setRegStep(4);
        break;
      case 'R5_VERIFY_EMAIL':
        setAppSection('registration');
        setRegStep(5);
        break;
      case 'R6_SALON_DETAILS':
        setAppSection('registration');
        setRegStep(6);
        break;
      case 'R7_LOCATION':
        setAppSection('registration');
        setRegStep(7);
        break;
      case 'R8_SERVICES':
        setAppSection('registration');
        setRegStep(8);
        break;
      case 'R9_WHO_WORKS_HERE':
        setAppSection('registration');
        setRegStep(9);
        break;
      case 'R10_TIMINGS':
        setAppSection('registration');
        setRegStep(10);
        break;
      case 'R11_REVIEW_AGREE':
        setAppSection('registration');
        setRegStep(11);
        break;
      case 'R12_SUBMITTED':
        setAppSection('registration');
        setRegStep(12);
        break;

      case 'A1_LOGIN':
        setAppSection('login');
        setLoginMode('A1');
        break;
      case 'A2_LOGIN_BLOCKED':
        setAppSection('login');
        setLoginMode('A2');
        break;
      case 'A3_APPROVED_NOTIFICATION':
        setAppSection('login');
        setLoginMode('A3');
        break;

      case 'A4_HOME':
        setAppSection('main');
        setBottomNavIndex(0);
        break;
      case 'A5_ADD_WALKIN':
        setAppSection('main');
        setBottomNavIndex(0);
        setShowAddWalkIn(true);
        break;
      case 'A6_BOOKINGS_UPCOMING':
        setAppSection('main');
        setBottomNavIndex(1);
        break;
      case 'A7_BOOKINGS_HISTORY':
        setAppSection('main');
        setBottomNavIndex(1);
        break;
      case 'A8_BOOKING_DETAIL':
        setAppSection('main');
        setBottomNavIndex(1);
        setSelectedBookingForDetail(
          upcomingBookings.find((b) => b.id === 'ZAL-6849') || upcomingBookings[0]
        );
        break;
      case 'A9_COMPLETE_MARK_PAID':
        setAppSection('main');
        setBottomNavIndex(1);
        setSelectedBookingForPayment(
          upcomingBookings.find((b) => b.id === 'ZAL-6849') || upcomingBookings[0]
        );
        break;
      case 'A10_STYLISTS':
        setAppSection('main');
        setShowStylistsScreen(true);
        setShowTurnOffRahulModalDirect(false);
        break;
      case 'A11_TURN_OFF_STYLIST':
        setAppSection('main');
        setShowStylistsScreen(true);
        setShowTurnOffRahulModalDirect(true);
        break;
      case 'A12_NOTIFICATIONS':
        setAppSection('main');
        setShowNotificationsScreen(true);
        break;

      case 'M1_MORE':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M1');
        break;
      case 'M2_SALON_PROFILE':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M2');
        break;
      case 'M3_OWNER_PROFILE':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M3');
        break;
      case 'M4_TIMINGS':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M4');
        break;
      case 'M5_SUPPORT':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M5');
        break;
      case 'M6_LOGOUT':
        setAppSection('main');
        setBottomNavIndex(2);
        setMoreSubScreen('M6');
        break;
    }
  };

  // Handle new walkin added
  const handleAddWalkInBooking = (bookingData: Partial<Booking>) => {
    const newBooking: Booking = {
      id: bookingData.id || `WLK-${Math.floor(1000 + Math.random() * 9000)}`,
      customerName: bookingData.customerName || 'Walk-in Guest',
      customerPhone: bookingData.customerPhone || '+91 98765 12345',
      timeString: bookingData.timeString || '2:40 PM · in chair',
      durationMinutes: bookingData.durationMinutes || 45,
      services: bookingData.services || 'Haircut (Men)',
      stylistName: bookingData.stylistName || 'Priya',
      totalAmount: bookingData.totalAmount || 548,
      status: 'in_chair',
      type: 'walk_in',
      statusDescription: `${bookingData.stylistName || 'Priya'} opens again automatically when you mark done.`,
    };

    setUpcomingBookings([newBooking, ...upcomingBookings]);
    showToast(`Walk-in added! ${newBooking.stylistName} is blocked.`);
  };

  // Handle payment complete
  const handleCompletePayment = (amount: number, method: 'Cash' | 'UPI' | 'Card') => {
    setOnlineRevenue((prev) => prev + amount);

    // Remove from upcoming and add to history
    if (selectedBookingForPayment) {
      const updatedUpcoming = upcomingBookings.filter(
        (b) => b.id !== selectedBookingForPayment.id
      );
      setUpcomingBookings(updatedUpcoming);

      const completedBooking: Booking = {
        ...selectedBookingForPayment,
        status: 'done',
        paymentMethod: method,
        timeString: 'Just now · Done',
        dateLabel: 'TODAY · MON 12 OCT',
      };
      setHistoryBookings([completedBooking, ...historyBookings]);
    }

    setSelectedBookingForPayment(null);
    showToast(`Payment of ₹${amount} recorded via ${method}. Revenue updated!`);
  };

  // Stylist availability toggle
  const handleToggleStylist = (id: string, isAvailable: boolean) => {
    setStylists(
      stylists.map((st) => (st.id === id ? { ...st, isAvailable } : st))
    );
    showToast(
      `${id === 'st-rahul' ? 'Rahul' : id === 'st-priya' ? 'Priya' : 'Neha'} is now ${
        isAvailable ? 'available' : 'off-duty'
      }.`
    );
  };

  // Identify current screen ID for navigator highlighting
  const getCurrentScreenId = (): ScreenId => {
    if (appSection === 'registration') {
      if (regStep === 1) return 'R1_WELCOME';
      if (regStep === 2) return 'R2_VERIFY_MOBILE';
      if (regStep === 3) return 'R3_ONBOARDING_CODE';
      if (regStep === 4) return 'R4_ABOUT_OWNER';
      if (regStep === 5) return 'R5_VERIFY_EMAIL';
      if (regStep === 6) return 'R6_SALON_DETAILS';
      if (regStep === 7) return 'R7_LOCATION';
      if (regStep === 8) return 'R8_SERVICES';
      if (regStep === 9) return 'R9_WHO_WORKS_HERE';
      if (regStep === 10) return 'R10_TIMINGS';
      if (regStep === 11) return 'R11_REVIEW_AGREE';
      if (regStep === 12) return 'R12_SUBMITTED';
    }
    if (appSection === 'login') {
      if (loginMode === 'A1') return 'A1_LOGIN';
      if (loginMode === 'A2') return 'A2_LOGIN_BLOCKED';
      if (loginMode === 'A3') return 'A3_APPROVED_NOTIFICATION';
    }
    if (showAddWalkIn) return 'A5_ADD_WALKIN';
    if (selectedBookingForDetail) return 'A8_BOOKING_DETAIL';
    if (selectedBookingForPayment) return 'A9_COMPLETE_MARK_PAID';
    if (showStylistsScreen) {
      if (showTurnOffRahulModalDirect) return 'A11_TURN_OFF_STYLIST';
      return 'A10_STYLISTS';
    }
    if (showNotificationsScreen) return 'A12_NOTIFICATIONS';

    if (bottomNavIndex === 0) return 'A4_HOME';
    if (bottomNavIndex === 1) return 'A6_BOOKINGS_UPCOMING';
    if (bottomNavIndex === 2) {
      if (moreSubScreen === 'M2') return 'M2_SALON_PROFILE';
      if (moreSubScreen === 'M3') return 'M3_OWNER_PROFILE';
      if (moreSubScreen === 'M4') return 'M4_TIMINGS';
      if (moreSubScreen === 'M5') return 'M5_SUPPORT';
      if (moreSubScreen === 'M6') return 'M6_LOGOUT';
      return 'M1_MORE';
    }
    return 'A4_HOME';
  };

  const unreadNotifCount = notifications.filter((n) => n.unread).length;

  return (
    <div className="min-h-screen bg-stone-950 text-stone-100 flex flex-col font-sans">
      {/* Top Navbar */}
      <header className="bg-stone-900 border-b border-stone-800 px-6 py-3.5 flex flex-wrap items-center justify-between gap-4 sticky top-0 z-50 shadow-md">
        {/* Brand */}
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 rounded-xl bg-[#C52243] flex items-center justify-center font-black text-white text-lg shadow-md shadow-rose-950/40">
            Z
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <span className="font-extrabold text-base tracking-tight text-white">zalono</span>
              <span className="bg-[#FDEBED] text-[#C52243] text-[10px] font-extrabold px-2 py-0.5 rounded uppercase tracking-wider">
                SALON PARTNER APP
              </span>
            </div>
            <p className="text-[11px] text-stone-400">Flutter &amp; Dart MVP Pilot (31 Screens)</p>
          </div>
        </div>

        {/* View Mode Switcher */}
        <div className="flex items-center bg-stone-950 border border-stone-800 rounded-2xl p-1">
          <button
            onClick={() => setActiveTab('simulator')}
            className={`flex items-center space-x-2 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              activeTab === 'simulator'
                ? 'bg-[#C52243] text-white shadow-sm'
                : 'text-stone-400 hover:text-white'
            }`}
          >
            <Smartphone className="w-4 h-4" />
            <span>Mobile Simulator</span>
          </button>

          <button
            onClick={() => setActiveTab('catalog')}
            className={`flex items-center space-x-2 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              activeTab === 'catalog'
                ? 'bg-[#C52243] text-white shadow-sm'
                : 'text-stone-400 hover:text-white'
            }`}
          >
            <Layers className="w-4 h-4" />
            <span>31-Screen Spec</span>
          </button>

          <button
            onClick={() => setActiveTab('flutter_code')}
            className={`flex items-center space-x-2 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              activeTab === 'flutter_code'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-stone-400 hover:text-white'
            }`}
          >
            <Code2 className="w-4 h-4" />
            <span>Flutter &amp; Dart Source</span>
          </button>
        </div>

        {/* Controls: Platform & Reset */}
        <div className="flex items-center space-x-3">
          {/* iOS / Android Toggle */}
          <div className="flex items-center bg-stone-950 border border-stone-800 rounded-xl p-0.5">
            <button
              onClick={() => setPlatform('ios')}
              className={`px-3 py-1 text-xs font-bold rounded-lg transition ${
                platform === 'ios' ? 'bg-stone-800 text-white' : 'text-stone-400 hover:text-stone-200'
              }`}
            >
              iOS
            </button>
            <button
              onClick={() => setPlatform('android')}
              className={`px-3 py-1 text-xs font-bold rounded-lg transition ${
                platform === 'android' ? 'bg-stone-800 text-white' : 'text-stone-400 hover:text-stone-200'
              }`}
            >
              Android
            </button>
          </div>

          {/* Reset Demo State Button */}
          <button
            onClick={handleResetData}
            title="Reset pilot demo state"
            className="p-2 rounded-xl bg-stone-800 hover:bg-stone-700 text-stone-300 border border-stone-700 active:scale-95 transition"
          >
            <RotateCcw className="w-4 h-4" />
          </button>
        </div>
      </header>

      {/* Toast Banner */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-[#C52243] text-white px-4 py-2.5 rounded-2xl shadow-2xl flex items-center space-x-2 text-xs font-bold animate-in fade-in slide-in-from-bottom-2">
          <CheckCircle2 className="w-4 h-4" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Main Work Area */}
      <main className="flex-1 p-4 lg:p-6 flex flex-col justify-center">
        {/* Tab 1: Simulator */}
        {activeTab === 'simulator' && (
          <div className="flex flex-col lg:flex-row items-center lg:items-start justify-center gap-8 max-w-7xl mx-auto w-full">
            {/* Quick Screen Selector Dropdown on Left for easy switching */}
            <div className="w-full lg:w-72 hidden lg:flex flex-col space-y-4">
              <div className="bg-stone-900 border border-stone-800 rounded-3xl p-4 shadow-xl">
                <div className="flex items-center justify-between pb-3 border-b border-stone-800">
                  <h3 className="text-xs font-extrabold uppercase tracking-wider text-stone-400">
                    Direct Screen Jump
                  </h3>
                  <span className="text-[10px] bg-rose-500/10 text-rose-400 px-2 py-0.5 rounded-full font-mono">
                    31 Screens
                  </span>
                </div>

                <div className="mt-3 space-y-1.5 max-h-[560px] overflow-y-auto pr-1 no-scrollbar text-xs">
                  {ALL_SCREENS.map((s) => {
                    const isCur = getCurrentScreenId() === s.id;
                    return (
                      <button
                        key={s.id}
                        onClick={() => handleJumpToScreen(s.id)}
                        className={`w-full text-left p-2 rounded-xl transition flex items-center justify-between ${
                          isCur
                            ? 'bg-[#C52243] text-white font-bold'
                            : 'hover:bg-stone-800 text-stone-300'
                        }`}
                      >
                        <span className="truncate">{s.label}</span>
                        <span
                          className={`text-[10px] font-mono ml-1 shrink-0 ${
                            isCur ? 'text-rose-100' : 'text-stone-500'
                          }`}
                        >
                          p.{s.page}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Status Note */}
              <div className="bg-stone-900/60 border border-stone-800 rounded-2xl p-3 text-[11px] text-stone-400">
                <p className="font-bold text-stone-300">Live Interactive Mode:</p>
                <p className="mt-1 leading-relaxed">
                  Tapping buttons, checking in customers, creating walk-ins, and changing stylist toggles interact with live reactive state in real time.
                </p>
              </div>
            </div>

            {/* Mobile Device Frame */}
            <div
              className="flex justify-center shrink-0 transition-transform duration-300"
              style={{ transform: `scale(${zoomScale})` }}
            >
              <DeviceFrame platform={platform} currentTime="2:41">
                {/* 1. Registration Flow */}
                {appSection === 'registration' && (
                  <RegistrationScreens
                    currentStep={regStep}
                    onStepChange={(step) => {
                      if (step < 0) {
                        setAppSection('main');
                      } else {
                        setRegStep(step);
                      }
                    }}
                    onNavigateToLogin={() => {
                      setAppSection('login');
                      setLoginMode('A1');
                    }}
                    onCompleteRegistration={() => {
                      setAppSection('main');
                      showToast('Registration submitted! Review pending.');
                    }}
                  />
                )}

                {/* 2. Login Flow */}
                {appSection === 'login' && (
                  <LoginFlow
                    initialMode={loginMode}
                    onLoginSuccess={() => {
                      setAppSection('main');
                      setBottomNavIndex(0);
                      showToast('Logged in to Glow Studio');
                    }}
                    onBackToWelcome={() => {
                      setAppSection('registration');
                      setRegStep(1);
                    }}
                  />
                )}

                {/* 3. Main Partner App (A4 to M6) */}
                {appSection === 'main' && (
                  <div className="flex-1 flex flex-col justify-between relative overflow-hidden bg-[#FAF6F2]">
                    {/* Active Tab Screen */}
                    <div className="flex-1 flex flex-col overflow-y-auto no-scrollbar relative">
                      {bottomNavIndex === 0 && (
                        <HomeScreen
                          onlineRevenue={onlineRevenue}
                          onlineBookingsCount={upcomingBookings.length + historyBookings.length}
                          completedBookingsCount={
                            historyBookings.filter((b) => b.status === 'done').length
                          }
                          upcomingBookingsCount={upcomingBookings.length}
                          isAcceptingBookings={isAcceptingBookings}
                          onToggleAcceptingBookings={(val) => {
                            setIsAcceptingBookings(val);
                            showToast(
                              val
                                ? 'Accepting bookings is ON'
                                : 'Accepting bookings is PAUSED'
                            );
                          }}
                          unreadNotificationsCount={unreadNotifCount}
                          stylists={stylists}
                          onOpenAddWalkIn={() => setShowAddWalkIn(true)}
                          onOpenStylists={() => setShowStylistsScreen(true)}
                          onOpenNotifications={() => setShowNotificationsScreen(true)}
                          onNavigateToBookings={() => setBottomNavIndex(1)}
                        />
                      )}

                      {bottomNavIndex === 1 && (
                        <BookingsScreen
                          upcomingBookings={upcomingBookings}
                          historyBookings={historyBookings}
                          onSelectBooking={(b) => setSelectedBookingForDetail(b)}
                          onMarkDoneDirect={(b) => setSelectedBookingForPayment(b)}
                        />
                      )}

                      {bottomNavIndex === 2 && (
                        <MoreScreens
                          initialSubScreen={moreSubScreen}
                          onNavigateToStylists={() => setShowStylistsScreen(true)}
                          onLogout={() => {
                            setAppSection('registration');
                            setRegStep(1);
                            showToast('Logged out of Glow Studio');
                          }}
                        />
                      )}

                      {/* Overlays / Modals */}
                      {showAddWalkIn && (
                        <AddWalkInSheet
                          onClose={() => setShowAddWalkIn(false)}
                          onAddBooking={handleAddWalkInBooking}
                        />
                      )}

                      {selectedBookingForDetail && (
                        <div className="absolute inset-0 z-40 bg-[#FAF6F2]">
                          <BookingDetailSheet
                            booking={selectedBookingForDetail}
                            onClose={() => setSelectedBookingForDetail(null)}
                            onCheckIn={() => {
                              setSelectedBookingForPayment(selectedBookingForDetail);
                              setSelectedBookingForDetail(null);
                            }}
                            onMarkNoShow={() => {
                              setHistoryBookings([
                                { ...selectedBookingForDetail, status: 'no_show' },
                                ...historyBookings,
                              ]);
                              setUpcomingBookings(
                                upcomingBookings.filter(
                                  (b) => b.id !== selectedBookingForDetail.id
                                )
                              );
                              setSelectedBookingForDetail(null);
                              showToast('Booking marked as No-show');
                            }}
                            onCancelBooking={() => {
                              setHistoryBookings([
                                { ...selectedBookingForDetail, status: 'cancelled' },
                                ...historyBookings,
                              ]);
                              setUpcomingBookings(
                                upcomingBookings.filter(
                                  (b) => b.id !== selectedBookingForDetail.id
                                )
                              );
                              setSelectedBookingForDetail(null);
                              showToast('Booking cancelled');
                            }}
                          />
                        </div>
                      )}

                      {selectedBookingForPayment && (
                        <div className="absolute inset-0 z-40 bg-[#FAF6F2]">
                          <CollectPaymentSheet
                            booking={selectedBookingForPayment}
                            currentOnlineRevenue={onlineRevenue}
                            onClose={() => setSelectedBookingForPayment(null)}
                            onCompleteAndPaid={handleCompletePayment}
                          />
                        </div>
                      )}

                      {showStylistsScreen && (
                        <div className="absolute inset-0 z-40 bg-[#FAF6F2]">
                          <StylistsScreen
                            stylists={stylists}
                            onToggleStylist={handleToggleStylist}
                            onBack={() => {
                              setShowStylistsScreen(false);
                              setShowTurnOffRahulModalDirect(false);
                            }}
                            showTurnOffModalDirect={showTurnOffRahulModalDirect}
                          />
                        </div>
                      )}

                      {showNotificationsScreen && (
                        <div className="absolute inset-0 z-40 bg-[#FAF6F2]">
                          <NotificationsScreen
                            notifications={notifications}
                            onBack={() => setShowNotificationsScreen(false)}
                            onTurnOnRahul={() => {
                              handleToggleStylist('st-rahul', true);
                            }}
                          />
                        </div>
                      )}
                    </div>

                    {/* Bottom Navigation Bar */}
                    <div className="bg-white border-t border-[#EFE7DF] px-6 py-2 flex items-center justify-around shrink-0 z-30">
                      <button
                        onClick={() => {
                          setBottomNavIndex(0);
                          setShowStylistsScreen(false);
                          setShowNotificationsScreen(false);
                        }}
                        className={`flex flex-col items-center py-1 transition ${
                          bottomNavIndex === 0 &&
                          !showStylistsScreen &&
                          !showNotificationsScreen
                            ? 'text-[#C52243] font-bold'
                            : 'text-stone-400 font-medium'
                        }`}
                      >
                        <HomeIcon className="w-5 h-5" />
                        <span className="text-[11px] mt-0.5">Home</span>
                      </button>

                      <button
                        onClick={() => {
                          setBottomNavIndex(1);
                          setShowStylistsScreen(false);
                          setShowNotificationsScreen(false);
                        }}
                        className={`flex flex-col items-center py-1 transition ${
                          bottomNavIndex === 1 &&
                          !showStylistsScreen &&
                          !showNotificationsScreen
                            ? 'text-[#C52243] font-bold'
                            : 'text-stone-400 font-medium'
                        }`}
                      >
                        <Calendar className="w-5 h-5" />
                        <span className="text-[11px] mt-0.5">Bookings</span>
                      </button>

                      <button
                        onClick={() => {
                          setBottomNavIndex(2);
                          setMoreSubScreen('M1');
                          setShowStylistsScreen(false);
                          setShowNotificationsScreen(false);
                        }}
                        className={`flex flex-col items-center py-1 transition ${
                          bottomNavIndex === 2 &&
                          !showStylistsScreen &&
                          !showNotificationsScreen
                            ? 'text-[#C52243] font-bold'
                            : 'text-stone-400 font-medium'
                        }`}
                      >
                        <Menu className="w-5 h-5" />
                        <span className="text-[11px] mt-0.5">More</span>
                      </button>
                    </div>
                  </div>
                )}
              </DeviceFrame>
            </div>

            {/* Quick Action Hints on Right */}
            <div className="w-full lg:w-80 space-y-4">
              <div className="bg-stone-900 border border-stone-800 rounded-3xl p-5 shadow-xl">
                <h3 className="text-sm font-extrabold text-white flex items-center space-x-2">
                  <Sparkles className="w-4 h-4 text-rose-400" />
                  <span>Key Pilot Flows Tested</span>
                </h3>

                <div className="space-y-3 mt-4 text-xs text-stone-300">
                  <div className="p-2.5 rounded-xl bg-stone-950/70 border border-stone-800">
                    <p className="font-bold text-rose-400">1. Onboarding Code Gate</p>
                    <p className="text-[11px] text-stone-400 mt-0.5">
                      Registration is locked until executive code <code className="text-white bg-stone-800 px-1 rounded">ZL-4821</code> is validated (R3).
                    </p>
                  </div>

                  <div className="p-2.5 rounded-xl bg-stone-950/70 border border-stone-800">
                    <p className="font-bold text-rose-400">2. Walk-in Auto Slot Blocking</p>
                    <p className="text-[11px] text-stone-400 mt-0.5">
                      Adding a walk-in immediately blocks online slots for Priya or Neha to prevent double-booking (A5).
                    </p>
                  </div>

                  <div className="p-2.5 rounded-xl bg-stone-950/70 border border-stone-800">
                    <p className="font-bold text-rose-400">3. Check-in to Payment</p>
                    <p className="text-[11px] text-stone-400 mt-0.5">
                      Check-in loads the itemized bill (A8 -&gt; A9) with Cash/UPI/Card and increments online revenue.
                    </p>
                  </div>

                  <div className="p-2.5 rounded-xl bg-stone-950/70 border border-stone-800">
                    <p className="font-bold text-rose-400">4. Intelligent Stylist Reassignment</p>
                    <p className="text-[11px] text-stone-400 mt-0.5">
                      Turning off Rahul pops sheet A11 to shift Sneha's 3:00 PM appointment to Priya or Neha.
                    </p>
                  </div>
                </div>
              </div>

              {/* Zoom scale controller */}
              <div className="bg-stone-900 border border-stone-800 rounded-2xl p-3 flex items-center justify-between text-xs">
                <span className="text-stone-400 font-semibold">Scale Preview:</span>
                <div className="flex items-center space-x-1">
                  {[0.85, 0.92, 1.0].map((sc) => (
                    <button
                      key={sc}
                      onClick={() => setZoomScale(sc)}
                      className={`px-2.5 py-1 rounded-lg text-[11px] font-bold ${
                        zoomScale === sc
                          ? 'bg-[#C52243] text-white'
                          : 'bg-stone-800 text-stone-400 hover:text-white'
                      }`}
                    >
                      {Math.round(sc * 100)}%
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Tab 2: 31-Screen Specification Navigator */}
        {activeTab === 'catalog' && (
          <div className="max-w-6xl mx-auto w-full h-[780px]">
            <ScreenCatalog
              currentScreenId={getCurrentScreenId()}
              onSelectScreen={(screenId) => {
                handleJumpToScreen(screenId);
                setActiveTab('simulator');
              }}
            />
          </div>
        )}

        {/* Tab 3: Flutter / Dart Source Code Explorer */}
        {activeTab === 'flutter_code' && (
          <div className="max-w-6xl mx-auto w-full h-[780px]">
            <FlutterCodeViewer />
          </div>
        )}
      </main>
    </div>
  );
}
