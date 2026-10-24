import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/action_dialogs.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40 > 0
                      ? constraints.maxHeight - 40
                      : 0,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Tag
                      Row(
                        children: [
                          const Text(
                            'Zalono',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: ZalonoTheme.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: ZalonoTheme.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SALON PARTNER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.primary,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),

                      // Hero Heading
                      const Text(
                        'Run your day\nfrom your phone.',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          letterSpacing: -0.6,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'See bookings, add walk-ins and keep every seat honest.',
                        style: TextStyle(
                          fontSize: 16,
                          color: ZalonoTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      const _WelcomeBookingCarousel(),

                      const Spacer(flex: 2),

                      // Action Buttons
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Log in'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: const Text('Partner with Zalono'),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'New salons need an onboarding code from a Zalono\nexecutive.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: ZalonoTheme.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: GestureDetector(
                          onTap: () => ActionDialogs.showTermsSheet(context),
                          child: const Text(
                            'By continuing you accept the Terms & Privacy Policy.',
                            style: TextStyle(
                              fontSize: 12,
                              color: ZalonoTheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeBookingCarousel extends StatefulWidget {
  const _WelcomeBookingCarousel();

  @override
  State<_WelcomeBookingCarousel> createState() =>
      _WelcomeBookingCarouselState();
}

class _WelcomeBookingCarouselState extends State<_WelcomeBookingCarousel> {
  static const _cards = [
    (
      time: '2:20 PM',
      name: 'Aarav K.',
      details: 'Haircut + Beard trim · with Priya',
      status: 'Leaving now · about 8 min away',
    ),
    (
      time: '3:00 PM',
      name: 'Meera S.',
      details: 'Hair spa + Blow dry · with Neha',
      status: 'On the way · about 12 min away',
    ),
    (
      time: '4:15 PM',
      name: 'Rohan M.',
      details: 'Facial · with Rahul',
      status: 'Booking confirmed',
    ),
  ];

  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _cards.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_currentIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      layoutBuilder: (currentChild, previousChildren) =>
          currentChild ?? const SizedBox.shrink(),
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: child),
        );
      },
      child: Container(
        key: ValueKey(card.name),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ZalonoTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NEXT UP · ${card.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ZalonoTheme.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ZalonoTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              card.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.details,
              style: const TextStyle(
                fontSize: 14,
                color: ZalonoTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule,
                    size: 16, color: ZalonoTheme.primary),
                const SizedBox(width: 6),
                Text(
                  card.status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ZalonoTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
