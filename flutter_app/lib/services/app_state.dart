import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/app_storage.dart';

class SalonAppState extends ChangeNotifier {
  // Salon Information
  String salonName = '';
  String salonCategory = '';
  String salonServes = '';
  String address = '';
  String ownerName = '';
  String ownerPhone = '';
  String ownerEmail = '';
  String gstNumber = '';
  bool panCardAdded = false;
  bool aadhaarAdded = false;
  bool businessProofAdded = false;
  Uint8List? panCardBytes;
  String? panCardFileName;
  Uint8List? aadhaarBytes;
  String? aadhaarFileName;
  Uint8List? businessProofBytes;
  String? businessProofFileName;
  List<Uint8List> salonPhotos = [];
  int salonServicesCount = 0;

  SalonAppState() {
    bookings.clear();
    notifications.clear();
    baseRevenue = 0;
    _loadPersistedState();
  }

  void _loadPersistedState() {
    try {
      final savedPhotos = AppStorage.loadString('salon_photos');
      if (savedPhotos != null && savedPhotos.isNotEmpty) {
        final List decoded = jsonDecode(savedPhotos);
        salonPhotos = decoded.map((s) => base64Decode(s as String)).toList();
      }
      final savedPan = AppStorage.loadString('pan_bytes');
      if (savedPan != null && savedPan.isNotEmpty) {
        panCardBytes = base64Decode(savedPan);
        panCardFileName = AppStorage.loadString('pan_name') ?? 'pan_card.jpg';
        panCardAdded = true;
      }
      final savedAadhaar = AppStorage.loadString('aadhaar_bytes');
      if (savedAadhaar != null && savedAadhaar.isNotEmpty) {
        aadhaarBytes = base64Decode(savedAadhaar);
        aadhaarFileName = AppStorage.loadString('aadhaar_name') ?? 'aadhaar_card.jpg';
        aadhaarAdded = true;
      }
      final savedBusiness = AppStorage.loadString('business_bytes');
      if (savedBusiness != null && savedBusiness.isNotEmpty) {
        businessProofBytes = base64Decode(savedBusiness);
        businessProofFileName = AppStorage.loadString('business_name') ?? 'business_proof.jpg';
        businessProofAdded = true;
      }
      final savedName = AppStorage.loadString('salon_name');
      if (savedName != null && savedName.isNotEmpty) salonName = savedName;
      final savedCategory = AppStorage.loadString('salon_category');
      if (savedCategory != null && savedCategory.isNotEmpty) salonCategory = savedCategory;
      final savedAddress = AppStorage.loadString('salon_address');
      if (savedAddress != null && savedAddress.isNotEmpty) address = savedAddress;
      final savedOwner = AppStorage.loadString('owner_name');
      if (savedOwner != null && savedOwner.isNotEmpty) ownerName = savedOwner;
      final savedPhone = AppStorage.loadString('owner_phone');
      if (savedPhone != null && savedPhone.isNotEmpty) ownerPhone = savedPhone;
    } catch (e) {
      debugPrint('Error loading persisted state: $e');
    }
  }

  void _persistPhotos() {
    try {
      final encoded = jsonEncode(salonPhotos.map(base64Encode).toList());
      AppStorage.saveString('salon_photos', encoded);
    } catch (e) {
      debugPrint('Error persisting photos: $e');
    }
  }

  void setDocument(String docType, Uint8List bytes, String fileName) {
    if (docType.contains('PAN')) {
      panCardAdded = true;
      panCardBytes = bytes;
      panCardFileName = fileName;
      AppStorage.saveString('pan_bytes', base64Encode(bytes));
      AppStorage.saveString('pan_name', fileName);
    } else if (docType.contains('Aadhaar')) {
      aadhaarAdded = true;
      aadhaarBytes = bytes;
      aadhaarFileName = fileName;
      AppStorage.saveString('aadhaar_bytes', base64Encode(bytes));
      AppStorage.saveString('aadhaar_name', fileName);
    } else if (docType.contains('Business')) {
      businessProofAdded = true;
      businessProofBytes = bytes;
      businessProofFileName = fileName;
      AppStorage.saveString('business_bytes', base64Encode(bytes));
      AppStorage.saveString('business_name', fileName);
    }
    notifyListeners();
  }

  void removeDocument(String docType) {
    if (docType.contains('PAN')) {
      panCardAdded = false;
      panCardBytes = null;
      panCardFileName = null;
      AppStorage.saveString('pan_bytes', '');
    } else if (docType.contains('Aadhaar')) {
      aadhaarAdded = false;
      aadhaarBytes = null;
      aadhaarFileName = null;
      AppStorage.saveString('aadhaar_bytes', '');
    } else if (docType.contains('Business')) {
      businessProofAdded = false;
      businessProofBytes = null;
      businessProofFileName = null;
      AppStorage.saveString('business_bytes', '');
    }
    notifyListeners();
  }

  void addSalonPhoto(Uint8List bytes) {
    salonPhotos.add(bytes);
    _persistPhotos();
    notifyListeners();
  }

  void setSalonPhotos(List<Uint8List> photos) {
    salonPhotos = List.from(photos);
    _persistPhotos();
    notifyListeners();
  }

  void updateSalonPhoto(int index, Uint8List bytes) {
    if (index >= 0 && index < salonPhotos.length) {
      salonPhotos[index] = bytes;
    } else {
      salonPhotos.add(bytes);
    }
    _persistPhotos();
    notifyListeners();
  }

  void removeSalonPhoto(int index) {
    if (index >= 0 && index < salonPhotos.length) {
      salonPhotos.removeAt(index);
      _persistPhotos();
      notifyListeners();
    }
  }

  void updateSalonRegistrationDetails({
    String? name,
    String? category,
    String? serves,
    String? fullAddress,
    String? owner,
    String? phone,
    String? email,
    String? gst,
    List<Uint8List>? photos,
  }) {
    if (name != null && name.isNotEmpty) {
      salonName = name;
      AppStorage.saveString('salon_name', name);
    }
    if (category != null && category.isNotEmpty) {
      salonCategory = category;
      AppStorage.saveString('salon_category', category);
    }
    if (serves != null && serves.isNotEmpty) salonServes = serves;
    if (fullAddress != null && fullAddress.isNotEmpty) {
      address = fullAddress;
      AppStorage.saveString('salon_address', fullAddress);
    }
    if (owner != null && owner.isNotEmpty) {
      ownerName = owner;
      AppStorage.saveString('owner_name', owner);
    }
    if (phone != null && phone.isNotEmpty) {
      ownerPhone = phone;
      AppStorage.saveString('owner_phone', phone);
    }
    if (email != null && email.isNotEmpty) ownerEmail = email;
    if (gst != null) gstNumber = gst;
    if (photos != null && photos.isNotEmpty) {
      salonPhotos = List.from(photos);
      _persistPhotos();
    }
    notifyListeners();
  }

  // Operational State
  bool isAcceptingBookings = true;
  String selectedHomeFilter = 'Today'; // Today, This week, This month, Custom

  // Stylists
  List<StylistItem> stylists = [];

  // Bookings
  List<BookingItem> bookings = [
    // In Chair
    BookingItem(
      id: 'ZAL-6848',
      customerName: 'Karan M.',
      customerPhone: '+91 98111 22334',
      timeString: '1:50 PM · in chair',
      dateTime: DateTime.now(),
      services: [
        ServiceItem(id: 's1', name: 'Pedicure', category: 'Nails', durationMinutes: 45, price: 599),
      ],
      stylistName: 'Neha',
      totalAmount: 599,
      type: BookingType.online,
      status: BookingStatus.inChair,
      customerStatus: 'In chair now',
    ),
    // Upcoming
    BookingItem(
      id: 'ZAL-6849',
      customerName: 'Aarav K.',
      customerPhone: '',
      timeString: '2:20 PM',
      dateTime: DateTime.now().add(const Duration(minutes: 30)),
      services: [
        ServiceItem(id: 's2', name: 'Haircut (Men)', category: 'Hair', durationMinutes: 30, price: 399),
        ServiceItem(id: 's3', name: 'Beard trim', category: 'Hair', durationMinutes: 15, price: 149),
      ],
      stylistName: 'Priya',
      totalAmount: 548,
      type: BookingType.online,
      status: BookingStatus.confirmed,
      customerStatus: 'Left home · about 8 min away',
    ),
    BookingItem(
      id: 'ZAL-6850',
      customerName: 'Sneha R.',
      customerPhone: '+91 98222 33445',
      timeString: '3:00 PM',
      dateTime: DateTime.now().add(const Duration(hours: 1)),
      services: [
        ServiceItem(id: 's4', name: 'Facial', category: 'Skin', durationMinutes: 60, price: 1200),
      ],
      stylistName: 'Rahul',
      totalAmount: 1200,
      type: BookingType.online,
      status: BookingStatus.confirmed,
      customerStatus: 'Booking confirmed',
    ),
    BookingItem(
      id: 'ZAL-6851',
      customerName: 'Ankit D.',
      customerPhone: '+91 98333 44556',
      timeString: '4:00 PM',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      services: [
        ServiceItem(id: 's5', name: 'Hair colour', category: 'Hair', durationMinutes: 90, price: 2499),
      ],
      stylistName: 'Priya',
      totalAmount: 2499,
      type: BookingType.online,
      status: BookingStatus.confirmed,
      customerStatus: 'Booking confirmed',
    ),
    // History
    BookingItem(
      id: 'ZAL-6840',
      customerName: 'Ritu S.',
      customerPhone: '+91 98444 55667',
      timeString: 'Yesterday · 6:30 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      services: [
        ServiceItem(id: 's6', name: 'Facial', category: 'Skin', durationMinutes: 60, price: 1200),
      ],
      stylistName: 'Rahul',
      totalAmount: 1200,
      type: BookingType.online,
      status: BookingStatus.done,
      paymentMethod: PaymentMethod.upi,
    ),
    BookingItem(
      id: 'ZAL-6839',
      customerName: 'Vikram A.',
      customerPhone: '+91 98555 66778',
      timeString: 'Yesterday · 5:00 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      services: [
        ServiceItem(id: 's7', name: 'Haircut (Men)', category: 'Hair', durationMinutes: 45, price: 399),
      ],
      stylistName: 'Priya',
      totalAmount: 399,
      type: BookingType.online,
      status: BookingStatus.noShow,
    ),
    BookingItem(
      id: 'ZAL-6838',
      customerName: 'Pooja M.',
      customerPhone: '+91 98666 77889',
      timeString: 'Yesterday · 3:30 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      services: [
        ServiceItem(id: 's8', name: 'Manicure', category: 'Nails', durationMinutes: 45, price: 599),
      ],
      stylistName: 'Neha',
      totalAmount: 599,
      type: BookingType.online,
      status: BookingStatus.done,
      paymentMethod: PaymentMethod.cash,
    ),
    BookingItem(
      id: 'ZAL-6835',
      customerName: 'Arjun R.',
      customerPhone: '+91 98777 88990',
      timeString: 'Sat 10 Oct · 7:00 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      services: [
        ServiceItem(id: 's9', name: 'Beard trim', category: 'Hair', durationMinutes: 15, price: 149),
      ],
      stylistName: 'Priya',
      totalAmount: 149,
      type: BookingType.online,
      status: BookingStatus.cancelled,
    ),
    // More history - Done
    BookingItem(
      id: 'ZAL-6836',
      customerName: 'Meera J.',
      customerPhone: '+91 98888 99001',
      timeString: 'Fri 9 Oct · 11:00 AM',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      services: [
        ServiceItem(id: 's10', name: 'Haircut (Women)', category: 'Hair', durationMinutes: 45, price: 799),
      ],
      stylistName: 'Priya',
      totalAmount: 799,
      type: BookingType.online,
      status: BookingStatus.done,
      paymentMethod: PaymentMethod.card,
    ),
    BookingItem(
      id: 'ZAL-6837',
      customerName: 'Divya T.',
      customerPhone: '+91 98999 00112',
      timeString: 'Fri 9 Oct · 2:30 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      services: [
        ServiceItem(id: 's11', name: 'Facial', category: 'Skin', durationMinutes: 60, price: 1200),
      ],
      stylistName: 'Rahul',
      totalAmount: 1200,
      type: BookingType.online,
      status: BookingStatus.done,
      paymentMethod: PaymentMethod.cash,
    ),
    // More history - No-show
    BookingItem(
      id: 'ZAL-6834',
      customerName: 'Kabir N.',
      customerPhone: '+91 99111 22233',
      timeString: 'Thu 8 Oct · 10:00 AM',
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      services: [
        ServiceItem(id: 's12', name: 'Beard trim', category: 'Hair', durationMinutes: 15, price: 149),
      ],
      stylistName: 'Neha',
      totalAmount: 149,
      type: BookingType.online,
      status: BookingStatus.noShow,
    ),
    BookingItem(
      id: 'ZAL-6833',
      customerName: 'Ishaan P.',
      customerPhone: '+91 99222 33344',
      timeString: 'Thu 8 Oct · 4:00 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      services: [
        ServiceItem(id: 's13', name: 'Hair colour', category: 'Hair', durationMinutes: 90, price: 2499),
      ],
      stylistName: 'Priya',
      totalAmount: 2499,
      type: BookingType.online,
      status: BookingStatus.noShow,
    ),
    // More history - Cancelled
    BookingItem(
      id: 'ZAL-6832',
      customerName: 'Tanisha Q.',
      customerPhone: '+91 99333 44455',
      timeString: 'Wed 7 Oct · 1:00 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      services: [
        ServiceItem(id: 's14', name: 'Manicure', category: 'Nails', durationMinutes: 45, price: 599),
      ],
      stylistName: 'Neha',
      totalAmount: 599,
      type: BookingType.online,
      status: BookingStatus.cancelled,
    ),
    BookingItem(
      id: 'ZAL-6831',
      customerName: 'Rohan R.',
      customerPhone: '+91 99444 55566',
      timeString: 'Wed 7 Oct · 5:30 PM',
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      services: [
        ServiceItem(id: 's15', name: 'Pedicure', category: 'Nails', durationMinutes: 45, price: 599),
      ],
      stylistName: 'Rahul',
      totalAmount: 599,
      type: BookingType.online,
      status: BookingStatus.cancelled,
    ),
  ];

  // Base recorded revenue
  double baseRevenue = 4250;

  // Notifications
  List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_1',
      title: "Rahul's off time has\nended",
      body: 'Turn Rahul on so customers can book him again.',
      time: '5:00 PM',
      type: 'stylist_off',
      isRead: false,
      hasAction: true,
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Priya is open for booking again',
      body: 'Walk-in Mohit S. ended at 3:25 PM.',
      time: '3:25 PM',
      type: 'stylist_free',
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Aarav K. is on the way',
      body: 'Left home, about 8 min away for his 2:20 PM booking.',
      time: '2:12 PM',
      type: 'customer_status',
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_4',
      title: 'New booking · Divya S.',
      body: 'Tue 13 Oct · 11:00 AM · Haircut (Women) with Priya',
      time: '2:10 PM',
      type: 'new_booking',
      isRead: true,
    ),
  ];

  // Salon Timings
  List<DayTiming> salonTimings = [
    DayTiming(
      dayName: 'Mon',
      slots: [
        TimeSlot(start: '10:00 AM', end: '2:00 PM', isEnabled: true),
        TimeSlot(start: '4:00 PM', end: '10:00 PM', isEnabled: true),
      ],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Tue',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Wed',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Thu',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Fri',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Sat',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
    DayTiming(
      dayName: 'Sun',
      slots: [TimeSlot(start: '10:00 AM', end: '10:00 PM', isEnabled: true)],
      isOpen: true,
    ),
  ];

  // Available Services
  List<ServiceItem> catalogServices = [
    ServiceItem(id: 'cs1', name: 'Haircut (Men)', category: 'Hair', durationMinutes: 30, price: 399),
    ServiceItem(id: 'cs2', name: 'Haircut (Women)', category: 'Hair', durationMinutes: 45, price: 699),
    ServiceItem(id: 'cs3', name: 'Beard trim', category: 'Hair', durationMinutes: 15, price: 149),
    ServiceItem(id: 'cs4', name: 'Hair colour', category: 'Hair', durationMinutes: 90, price: 2499),
    ServiceItem(id: 'cs5', name: 'Hair spa', category: 'Hair', durationMinutes: 60, price: 1999),
    ServiceItem(id: 'cs6', name: 'Facial', category: 'Skin', durationMinutes: 60, price: 1200),
    ServiceItem(id: 'cs7', name: 'Clean-up', category: 'Skin', durationMinutes: 30, price: 699),
    ServiceItem(id: 'cs8', name: 'Manicure', category: 'Nails', durationMinutes: 45, price: 599),
    ServiceItem(id: 'cs9', name: 'Pedicure', category: 'Nails', durationMinutes: 45, price: 599),
  ];

  // Computed Properties
  double get onlineRevenue {
    double extraRevenue = 0;
    for (var b in bookings) {
      if (b.type == BookingType.online && b.status == BookingStatus.done) {
        // Count today's done bookings
        if (b.dateTime.day == DateTime.now().day && b.dateTime.month == DateTime.now().month) {
          extraRevenue += b.totalAmount;
        }
      }
    }
    switch (selectedHomeFilter) {
      case 'This week':
        return baseRevenue * 4.2 + extraRevenue;
      case 'This month':
        return baseRevenue * 18.5 + extraRevenue;
      case 'Custom':
        return baseRevenue * 2.1 + extraRevenue;
      case 'Today':
      default:
        return baseRevenue + extraRevenue;
    }
  }

  int get totalBookingsCount {
    int count = bookings.where((b) => b.type == BookingType.online).length;
    switch (selectedHomeFilter) {
      case 'This week':
        return count * 4;
      case 'This month':
        return count * 15;
      case 'Custom':
        return count * 2;
      case 'Today':
      default:
        return count;
    }
  }

  int get doneBookingsCount {
    int doneToday = bookings.where((b) => b.status == BookingStatus.done).length;
    switch (selectedHomeFilter) {
      case 'This week':
        return doneToday * 3;
      case 'This month':
        return doneToday * 12;
      case 'Custom':
        return doneToday * 2;
      case 'Today':
      default:
        return doneToday;
    }
  }

  int get toComeBookingsCount {
    return bookings.where((b) => b.status == BookingStatus.confirmed || b.status == BookingStatus.inChair).length;
  }

  int get unreadNotificationsCount {
    return notifications.where((n) => !n.isRead).length;
  }

  List<BookingItem> get upcomingBookings {
    return bookings.where((b) => b.status == BookingStatus.confirmed || b.status == BookingStatus.inChair).toList();
  }

  List<BookingItem> get historyBookings {
    return bookings.where((b) => b.status == BookingStatus.done || b.status == BookingStatus.noShow || b.status == BookingStatus.cancelled).toList();
  }

  BookingItem? get inChairBooking {
    try {
      return bookings.firstWhere((b) => b.status == BookingStatus.inChair);
    } catch (_) {
      return null;
    }
  }

  // Actions
  void toggleAcceptingBookings(bool val) {
    isAcceptingBookings = val;
    notifyListeners();
  }

  void setHomeFilter(String filter) {
    selectedHomeFilter = filter;
    notifyListeners();
  }

  void addWalkIn({
    required String customerName,
    required String customerPhone,
    required List<String> serviceNames,
    required String stylistName,
    required double totalAmount,
  }) {
    final selectedServicesList = catalogServices.where((s) => serviceNames.contains(s.name)).toList();
    if (selectedServicesList.isEmpty) {
      selectedServicesList.add(
        ServiceItem(id: 'custom_walkin', name: serviceNames.isNotEmpty ? serviceNames.first : 'Quick Service', category: 'Hair', durationMinutes: 30, price: totalAmount),
      );
    }

    final newBooking = BookingItem(
      id: 'WLK-${DateTime.now().millisecondsSinceEpoch % 10000}',
      customerName: customerName,
      customerPhone: customerPhone,
      timeString: 'Walk-in · in chair',
      dateTime: DateTime.now(),
      services: selectedServicesList,
      stylistName: stylistName,
      totalAmount: totalAmount,
      type: BookingType.walkIn,
      status: BookingStatus.inChair,
      customerStatus: 'Walk-in customer in salon',
    );

    // If another booking was inChair for this stylist, update it
    bookings.insert(0, newBooking);

    // Update stylist availability
    final stylistIndex = stylists.indexWhere((s) => s.name.toLowerCase().contains(stylistName.toLowerCase()));
    if (stylistIndex != -1) {
      stylists[stylistIndex].statusDetail = 'With a walk-in ($customerName)';
    }

    // Add notification
    notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Walk-in added · $customerName',
        body: '$stylistName blocked for ${serviceNames.join(", ")}.',
        time: 'Just now',
        type: 'new_booking',
        isRead: false,
      ),
    );

    notifyListeners();
  }

  void checkInBooking(String bookingId) {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      bookings[index].status = BookingStatus.inChair;
      final stylistName = bookings[index].stylistName;
      final stylistIndex = stylists.indexWhere((s) => s.name.toLowerCase().contains(stylistName.toLowerCase()));
      if (stylistIndex != -1) {
        stylists[stylistIndex].statusDetail = 'With ${bookings[index].customerName} in chair';
      }

      notifications.insert(
        0,
        NotificationModel(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Customer checked in',
          body: '${bookings[index].customerName} is now in chair with $stylistName.',
          time: 'Just now',
          type: 'customer_status',
          isRead: false,
        ),
      );

      notifyListeners();
    }
  }

  void completeBookingAndCollectPayment(String bookingId, PaymentMethod paymentMethod, double amount) {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final b = bookings[index];
      b.status = BookingStatus.done;
      b.paymentMethod = paymentMethod;

      // Free the stylist
      final stylistIndex = stylists.indexWhere((s) => s.name.toLowerCase().contains(b.stylistName.toLowerCase()));
      if (stylistIndex != -1) {
        stylists[stylistIndex].isAvailable = true;
        stylists[stylistIndex].statusDetail = 'Available now';
      }

      notifications.insert(
        0,
        NotificationModel(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          title: '${b.stylistName} is open for booking again',
          body: 'Booking for ${b.customerName} completed and paid via ${paymentMethod.name.toUpperCase()}.',
          time: 'Just now',
          type: 'stylist_free',
          isRead: false,
        ),
      );

      notifyListeners();
    }
  }

  void markNoShow(String bookingId) {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final b = bookings[index];
      b.status = BookingStatus.noShow;

      // Free stylist
      final stylistIndex = stylists.indexWhere((s) => s.name.toLowerCase().contains(b.stylistName.toLowerCase()));
      if (stylistIndex != -1) {
        stylists[stylistIndex].isAvailable = true;
        stylists[stylistIndex].statusDetail = 'Available now';
      }

      notifications.insert(
        0,
        NotificationModel(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          title: 'No-show recorded · ${b.customerName}',
          body: '${b.stylistName} slots reopened for online booking.',
          time: 'Just now',
          type: 'stylist_free',
          isRead: false,
        ),
      );

      notifyListeners();
    }
  }

  void cancelBooking(String bookingId, String reason) {
    final index = bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final b = bookings[index];
      b.status = BookingStatus.cancelled;

      final stylistIndex = stylists.indexWhere((s) => s.name.toLowerCase().contains(b.stylistName.toLowerCase()));
      if (stylistIndex != -1) {
        stylists[stylistIndex].isAvailable = true;
        stylists[stylistIndex].statusDetail = 'Available now';
      }

      notifications.insert(
        0,
        NotificationModel(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Booking cancelled · ${b.customerName}',
          body: 'Reason: $reason. ${b.stylistName} is available.',
          time: 'Just now',
          type: 'customer_status',
          isRead: false,
        ),
      );

      notifyListeners();
    }
  }

  void addStylist({required String name, required String role, required List<String> services}) {
    stylists.add(
      StylistItem(
        id: 'stylist_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        role: role,
        services: services,
        isAvailable: true,
        statusDetail: 'Available now',
      ),
    );
    notifyListeners();
  }

  void removeStylist(String stylistId) {
    stylists.removeWhere((s) => s.id == stylistId);
    notifyListeners();
  }

  void turnOffStylist(String stylistName, String duration, String? reassignTarget) {
    final index = stylists.indexWhere((s) => s.name.toLowerCase().contains(stylistName.toLowerCase()));
    if (index != -1) {
      stylists[index].isAvailable = false;
      stylists[index].statusDetail = 'Off $duration';

      // Reassign any bookings belonging to this stylist
      if (reassignTarget != null && reassignTarget.isNotEmpty) {
        for (var b in bookings) {
          if ((b.status == BookingStatus.confirmed || b.status == BookingStatus.inChair) &&
              b.stylistName.toLowerCase().contains(stylistName.toLowerCase())) {
            // Reassign
            bookings[bookings.indexOf(b)] = BookingItem(
              id: b.id,
              customerName: b.customerName,
              customerPhone: b.customerPhone,
              timeString: b.timeString,
              dateTime: b.dateTime,
              services: b.services,
              stylistName: reassignTarget,
              totalAmount: b.totalAmount,
              type: b.type,
              status: b.status,
              customerStatus: 'Reassigned to $reassignTarget',
            );
          }
        }
      }

      notifications.insert(
        0,
        NotificationModel(
          id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
          title: '$stylistName turned off',
          body: 'Off $duration.${reassignTarget != null ? " Bookings reassigned to $reassignTarget." : ""}',
          time: 'Just now',
          type: 'stylist_off',
          isRead: false,
          hasAction: true,
        ),
      );

      notifyListeners();
    }
  }

  void turnOnStylist(String stylistName) {
    final index = stylists.indexWhere((s) => s.name.toLowerCase().contains(stylistName.toLowerCase()));
    if (index != -1) {
      stylists[index].isAvailable = true;
      stylists[index].statusDetail = 'Available · open for booking';

      // Mark any action notification for this stylist as resolved
      for (var n in notifications) {
        if (n.title.toLowerCase().contains(stylistName.toLowerCase()) && n.hasAction) {
          n.isRead = true;
        }
      }

      notifyListeners();
    }
  }

  void toggleStylist(String stylistId, bool isAvailable) {
    final index = stylists.indexWhere((s) => s.id == stylistId);
    if (index != -1) {
      stylists[index].isAvailable = isAvailable;
      stylists[index].statusDetail = isAvailable ? 'Available now' : 'Turned off';
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void dismissNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void copyMondayTimingsToAll() {
    final mondaySlots = salonTimings.first.slots;
    for (int i = 1; i < salonTimings.length; i++) {
      salonTimings[i].slots.clear();
      for (var slot in mondaySlots) {
        salonTimings[i].slots.add(TimeSlot(start: slot.start, end: slot.end, isEnabled: slot.isEnabled));
      }
    }
    notifyListeners();
  }

  void toggleTimingSlot(int dayIndex, int slotIndex, bool isEnabled) {
    if (dayIndex < salonTimings.length && slotIndex < salonTimings[dayIndex].slots.length) {
      salonTimings[dayIndex].slots[slotIndex].isEnabled = isEnabled;
      notifyListeners();
    }
  }

  void updateTimingSlot(int dayIndex, int slotIndex, String start, String end) {
    if (dayIndex < salonTimings.length && slotIndex < salonTimings[dayIndex].slots.length) {
      final isEnabled = salonTimings[dayIndex].slots[slotIndex].isEnabled;
      salonTimings[dayIndex].slots[slotIndex] = TimeSlot(start: start, end: end, isEnabled: isEnabled);
      notifyListeners();
    }
  }

  void addTimingSlot(int dayIndex, String start, String end) {
    if (dayIndex < salonTimings.length) {
      salonTimings[dayIndex].slots.add(TimeSlot(start: start, end: end, isEnabled: true));
      notifyListeners();
    }
  }

  void addService(String name, String category, int duration, double price) {
    catalogServices.add(
      ServiceItem(
        id: 'svc_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        category: category,
        durationMinutes: duration,
        price: price,
      ),
    );
    notifyListeners();
  }
}
