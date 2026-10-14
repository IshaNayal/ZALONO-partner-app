export interface FlutterFile {
  path: string;
  filename: string;
  language: string;
  category: 'Configuration' | 'Core & Theme' | 'Models' | 'Screens';
  description: string;
  code: string;
}

export const FLUTTER_FILES: FlutterFile[] = [
  {
    path: 'pubspec.yaml',
    filename: 'pubspec.yaml',
    language: 'yaml',
    category: 'Configuration',
    description: 'Flutter project definition with Cupertino icons, Google fonts, and Intl packages',
    code: `name: zalono_partner
description: Zalono Salon Partner App for iOS and Android
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  intl: ^0.19.0
  provider: ^6.1.2
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true`,
  },
  {
    path: 'lib/main.dart',
    filename: 'main.dart',
    language: 'dart',
    category: 'Core & Theme',
    description: 'App root, route table, and bottom navigation shell (Home, Bookings, More)',
    code: `import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/r1_welcome_screen.dart';
import 'screens/registration_screens.dart';
import 'screens/login_screens.dart';
import 'screens/home_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/stylists_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/more_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ZalonoPartnerApp());
}

class ZalonoPartnerApp extends StatelessWidget {
  const ZalonoPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zalono Salon Partner',
      debugShowCheckedModeBanner: false,
      theme: ZalonoTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/register': (context) => const RegistrationFlowScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNavigationShell(),
        '/stylists': (context) => const StylistsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final int initialTab;
  const MainNavigationShell({super.key, this.initialTab = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToBookings: () => setState(() => _currentIndex = 1)),
      const BookingsScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ZalonoTheme.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: ZalonoTheme.primary,
          unselectedItemColor: ZalonoTheme.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              activeIcon: Icon(Icons.menu_open),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}`,
  },
  {
    path: 'lib/theme/app_theme.dart',
    filename: 'app_theme.dart',
    language: 'dart',
    category: 'Core & Theme',
    description: 'Zalono Crimson design system, typography, inputs, buttons, and elevation',
    code: `import 'package:flutter/material.dart';

class ZalonoTheme {
  static const Color primary = Color(0xFFC52243);
  static const Color primaryDark = Color(0xFFA51B37);
  static const Color primaryLight = Color(0xFFFDEBED);
  static const Color background = Color(0xFFFAF6F2);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF5EFE9);
  
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF6B6864);
  static const Color textMuted = Color(0xFF9E9B97);
  static const Color border = Color(0xFFEFE7DF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryDark,
        surface: surface,
        error: primary,
      ),
      fontFamily: 'Plus Jakarta Sans',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}`,
  },
  {
    path: 'lib/models/models.dart',
    filename: 'models.dart',
    language: 'dart',
    category: 'Models',
    description: 'Data models for Bookings, Stylists, Services, TimeSlots, and Notifications',
    code: `enum BookingStatus { inChair, confirmed, done, noShow, cancelled }
enum BookingType { online, walkIn }
enum PaymentMethod { cash, upi, card }

class ServiceItem {
  final String id;
  final String name;
  final String category;
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
  String? statusDetail;

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
  final String timeString;
  final DateTime dateTime;
  final List<ServiceItem> services;
  final String stylistName;
  final double totalAmount;
  final BookingType type;
  BookingStatus status;
  PaymentMethod? paymentMethod;
  final String? customerStatus;

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
}`,
  },
  {
    path: 'lib/screens/r1_welcome_screen.dart',
    filename: 'r1_welcome_screen.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Page 2: Welcome hero screen with booking card and login/partner action triggers',
    code: `// Page 2: R1 · Welcome Screen
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('zalono', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ZalonoTheme.primary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(6)),
                    child: const Text('SALON PARTNER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
                  ),
                ],
              ),
              const Spacer(),
              const Text('Run your day\\nfrom your phone.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, height: 1.15)),
              const SizedBox(height: 12),
              const Text('See bookings, add walk-ins and keep every seat honest.', style: TextStyle(fontSize: 16, color: ZalonoTheme.textSecondary)),
              const SizedBox(height: 28),
              // Next Up Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: ZalonoTheme.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('NEXT UP · 2:20 PM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
                          child: const Text('Confirmed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Aarav K.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Haircut + Beard trim · with Priya', style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.schedule, size: 16, color: ZalonoTheme.primary),
                        SizedBox(width: 6),
                        Text('Leaving now · about 8 min away', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ZalonoTheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Log in')),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Partner with Zalono')),
              const SizedBox(height: 16),
              const Center(child: Text('New salons need an onboarding code from a Zalono executive.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary))),
            ],
          ),
        ),
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/registration_screens.dart',
    filename: 'registration_screens.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Pages 3–13: R2 to R12 9-step registration wizard and submission status',
    code: `// Complete 9-step partner registration wizard (R2-R12)
// Includes Mobile Verification, Onboarding Code (ZL-4821), Owner Details, Email OTP,
// Salon Details, Map Pin Location, Services with prices, Stylists, Timings, Review and Submitted status.
// View lib/screens/registration_screens.dart for complete code.`,
  },
  {
    path: 'lib/screens/home_screen.dart',
    filename: 'home_screen.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Pages 17–18: A4 Home dashboard & A5 Add walk-in bottom sheet with slot blocking',
    code: `// A4: Home Screen & A5: Add Walk-in Modal Sheet
// Displays 'Accepting bookings' master switch, Today/Week/Month metrics, Stylists summary card,
// and bottom sheet with duration calculation and Priya auto-blocking.`,
  },
  {
    path: 'lib/screens/bookings_screen.dart',
    filename: 'bookings_screen.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Pages 19–22: A6 Upcoming, A7 History, A8 Booking detail, A9 Mark paid & complete',
    code: `// A6: Upcoming bookings with 'In chair' live card & Mark Done
// A7: History with Done, No-show, Cancelled
// A8: Customer details, Call, Check-in
// A9: Bill breakdown, Cash/UPI/Card payment recording`,
  },
  {
    path: 'lib/screens/stylists_screen.dart',
    filename: 'stylists_screen.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Pages 23–24: A10 Stylists availability & A11 Turn a stylist off reassign sheet',
    code: `// A10: Stylist roster with availability toggles
// A11: Smart reassign bottom sheet ("Turn off Rahul? Move to Priya / Neha")`,
  },
  {
    path: 'lib/screens/notifications_screen.dart',
    filename: 'notifications_screen.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Page 25: A12 Notifications center with actionable inline buttons',
    code: `// A12: Notification feed with actionable "Turn on" button for off-duty stylists`,
  },
  {
    path: 'lib/screens/more_screens.dart',
    filename: 'more_screens.dart',
    language: 'dart',
    category: 'Screens',
    description: 'Pages 26–31: M1 More menu, M2 Salon profile, M3 Owner KYC, M4 Timings, M5 Support, M6 Log out',
    code: `// M1-M6: Navigation hub, verified Salon profile, Owner KYC profile,
// Timings with copy Monday, Executive Rahul K. contact & FAQs, and Log out safety modal.`,
  },
];
