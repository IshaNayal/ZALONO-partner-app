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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'durationMinutes': durationMinutes,
    'price': price,
    'isSelected': isSelected,
  };

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    durationMinutes: json['durationMinutes'] as int,
    price: (json['price'] as num).toDouble(),
    isSelected: json['isSelected'] as bool? ?? false,
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'services': services,
    'isAvailable': isAvailable,
    'statusDetail': statusDetail,
  };

  factory StylistItem.fromJson(Map<String, dynamic> json) => StylistItem(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    services: (json['services'] as List).cast<String>(),
    isAvailable: json['isAvailable'] as bool? ?? true,
    statusDetail: json['statusDetail'] as String?,
  );
}

class BookingItem {
  final String id;
  final String customerName;
  final String customerPhone;
  final String timeString; // e.g. "2:20 PM2:20 PM in chair"
  final DateTime dateTime;
  final List<ServiceItem> services;
  final String stylistName;
  final double totalAmount;
  final BookingType type;
  BookingStatus status;
  PaymentMethod? paymentMethod;
  final String? customerStatus; // "Leaving now Â· about 8 min away"

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'timeString': timeString,
    'dateTime': dateTime.toIso8601String(),
    'services': services.map((s) => s.toJson()).toList(),
    'stylistName': stylistName,
    'totalAmount': totalAmount,
    'type': type.name,
    'status': status.name,
    'paymentMethod': paymentMethod?.name,
    'customerStatus': customerStatus,
  };

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
    id: json['id'] as String,
    customerName: json['customerName'] as String,
    customerPhone: json['customerPhone'] as String,
    timeString: json['timeString'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    services: (json['services'] as List).map((s) => ServiceItem.fromJson(s as Map<String, dynamic>)).toList(),
    stylistName: json['stylistName'] as String,
    totalAmount: (json['totalAmount'] as num).toDouble(),
    type: BookingType.values.firstWhere((e) => e.name == json['type']),
    status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
    paymentMethod: json['paymentMethod'] != null
        ? PaymentMethod.values.firstWhere((e) => e.name == json['paymentMethod'])
        : null,
    customerStatus: json['customerStatus'] as String?,
  );
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
