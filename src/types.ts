export type ScreenId =
  // Registration Flow (pp. 2-13)
  | 'R1_WELCOME'
  | 'R2_VERIFY_MOBILE'
  | 'R3_ONBOARDING_CODE'
  | 'R4_ABOUT_OWNER'
  | 'R5_VERIFY_EMAIL'
  | 'R6_SALON_DETAILS'
  | 'R7_LOCATION'
  | 'R8_SERVICES'
  | 'R9_WHO_WORKS_HERE'
  | 'R10_TIMINGS'
  | 'R11_REVIEW_AGREE'
  | 'R12_SUBMITTED'
  // Daily Use & Login (pp. 14-25)
  | 'A1_LOGIN'
  | 'A2_LOGIN_BLOCKED'
  | 'A3_APPROVED_NOTIFICATION'
  | 'A4_HOME'
  | 'A5_ADD_WALKIN'
  | 'A6_BOOKINGS_UPCOMING'
  | 'A7_BOOKINGS_HISTORY'
  | 'A8_BOOKING_DETAIL'
  | 'A9_COMPLETE_MARK_PAID'
  | 'A10_STYLISTS'
  | 'A11_TURN_OFF_STYLIST'
  | 'A12_NOTIFICATIONS'
  // More (pp. 26-31)
  | 'M1_MORE'
  | 'M2_SALON_PROFILE'
  | 'M3_OWNER_PROFILE'
  | 'M4_TIMINGS'
  | 'M5_SUPPORT'
  | 'M6_LOGOUT';

export type Platform = 'ios' | 'android';

export interface ServiceItem {
  id: string;
  name: string;
  category: 'Hair' | 'Skin' | 'Nails' | 'Body';
  durationMinutes: number;
  price: number;
  checked?: boolean;
}

export interface Stylist {
  id: string;
  name: string;
  role: string;
  services: string;
  isAvailable: boolean;
  statusNote: string;
  avatarColor?: string;
  reassignmentNeeded?: boolean;
}

export interface Booking {
  id: string;
  customerName: string;
  customerPhone?: string;
  timeString: string;
  durationMinutes: number;
  services: string;
  stylistName: string;
  totalAmount: number;
  status: 'in_chair' | 'confirmed' | 'done' | 'no_show' | 'cancelled';
  statusDescription?: string;
  type: 'online' | 'walk_in';
  dateLabel?: string;
  paymentMethod?: 'Cash' | 'UPI' | 'Card';
}

export interface NotificationItem {
  id: string;
  title: string;
  body: string;
  time: string;
  type: 'stylist_off' | 'stylist_open' | 'on_way' | 'new_booking';
  unread: boolean;
  hasAction?: boolean;
}
