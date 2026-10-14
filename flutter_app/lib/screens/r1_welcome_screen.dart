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
              // Header Tag
              Row(
                children: [
                  const Text(
                    'zalono',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: ZalonoTheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: ZalonoTheme.textPrimary,
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

              // Next Up Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ZalonoTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
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
                        const Text(
                          'NEXT UP · 2:20 PM',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: ZalonoTheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    const Text(
                      'Aarav K.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: ZalonoTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Haircut + Beard trim · with Priya',
                      style: TextStyle(
                        fontSize: 14,
                        color: ZalonoTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.schedule, size: 16, color: ZalonoTheme.primary),
                        SizedBox(width: 6),
                        Text(
                          'Leaving now · about 8 min away',
                          style: TextStyle(
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

              const Spacer(flex: 2),

              // Action Buttons
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Log in'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
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
              const Center(
                child: Text(
                  'By continuing you accept the Terms & Privacy Policy.',
                  style: TextStyle(
                    fontSize: 12,
                    color: ZalonoTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
