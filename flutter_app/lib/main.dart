import 'package:flutter/material.dart';
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

import 'package:provider/provider.dart';
import 'services/app_state.dart';
import 'services/firebase_service.dart';
import 'utils/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => SalonAppState(),
      child: const ZalonoPartnerApp(),
    ),
  );
}

class ZalonoPartnerApp extends StatelessWidget {
  const ZalonoPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zalono Salon Partner',
      debugShowCheckedModeBanner: false,
      theme: ZalonoTheme.lightTheme,
      initialRoute:
          AppStorage.loadString('logged_in') == 'true' ? '/main' : '/',
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
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
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
}
