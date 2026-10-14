import 'package:flutter/foundation.dart';

enum SalonCategory { basic, medium, premium, ultraPremium }
enum BookingStatus { inChair, confirmed, done, noShow, cancelled }
enum BookingType { online, walkIn }
enum PaymentMethod { cash, upi, card }

class ServiceItem {
  final String id;
  final String name;
  final String category; // Hair, Skin, Nails, Body
  final int durationMinutes;
  final double price;
  bool isSelected;

  ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.price,
    this.isSelected = false,
  });
}

class StylistItem {
  final String id;
  final String name;
  final String role;
  final List<String> services;
  bool isAvailable;
  String? statusDetail; // e.g., "Off until 5:00 PM", "With a walk-in till 3:20 PM"

  StylistItem({
    required this.id,
    required this.name,
    required this.role,
    required this.services,
    this.isAvailable = true,
    this.statusDetail,
  });

  String get initials => name.isNotEmpty ? name[0] : '';
}

class BookingItem {
  final String id;
  final String customerName;
  final String customerPhone;
  final String timeString; // e.g. "2:20 PM"
  final DateTime dateTime;
  final List<ServiceItem> services;
  final String stylistName;
  final double totalAmount;
  final BookingType type;
  BookingStatus status;
  PaymentMethod? paymentMethod;
  final String? customerStatus; // "Leaving now · about 8 min away"

  BookingItem({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.timeString,
    required this.dateTime,
    required this.services,
    required this.stylistName,
    required this.totalAmount,
    required this.type,
    required this.status,
    this.paymentMethod,
    this.customerStatus,
  });
}

class DayTiming {
  final String dayName;
  final List<TimeSlot> slots;
  bool isOpen;

  DayTiming({
    required this.dayName,
    required this.slots,
    this.isOpen = true,
  });
}

class TimeSlot {
  final String start;
  final String end;
  bool isEnabled;

  TimeSlot({required this.start, required this.end, this.isEnabled = true});
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final String type; // 'stylist_off', 'stylist_free', 'customer_status', 'new_booking'
  bool isRead;
  final bool hasAction;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
    this.hasAction = false,
  });
}
