import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phone = '98765 43210';
  List<String> enteredOtp = ['4', '2', '7', '', '', ''];
  bool isBlocked = false;
  bool showNotificationSim = false;

  void _fillFullCodeAndCheck() {
    setState(() {
      enteredOtp = ['4', '2', '7', '9', '0', '1'];
      // Trigger blocked state first (like A2 in design), or allow toggle
      isBlocked = true;
    });
  }

  void _simulateApproval() {
    setState(() {
      showNotificationSim = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showNotificationSim) {
      return _buildA3ApprovedNotification();
    }

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header tag
              Row(
                children: [
                  const Text(
                    'zalono',
                    style: TextStyle(
                      fontSize: 24,
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
              const SizedBox(height: 24),

              const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: ZalonoTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use the mobile number you registered with.',
                style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              const Text(
                'MOBILE NUMBER',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ZalonoTheme.border),
                ),
                child: Row(
                  children: [
                    const Text('+91', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 12),
                    Text(phone, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'ENTER THE 6-DIGIT CODE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final digit = enteredOtp[index];
                  final isFocused = index == 3 && !isBlocked;
                  return GestureDetector(
                    onTap: _fillFullCodeAndCheck,
                    child: Container(
                      width: 46,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFocused
                              ? ZalonoTheme.primary
                              : (isBlocked ? ZalonoTheme.border : ZalonoTheme.border),
                          width: isFocused ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        digit,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              if (!isBlocked)
                const Text(
                  'Resend code in 0:24',
                  style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
                ),

              // A2: Blocked Card
              if (isBlocked) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ZalonoTheme.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ZalonoTheme.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ZalonoTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lock, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Not approved yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Glow Studio is still being verified by the Zalono team. Login works once you are approved, and we will send you a notification.',
                              style: TextStyle(
                                fontSize: 13,
                                color: ZalonoTheme.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Quick Pilot Simulation trigger
              if (isBlocked)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.notifications_active, color: ZalonoTheme.primary),
                      label: const Text('Simulate Approval Push Notification', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.bold)),
                      onPressed: _simulateApproval,
                    ),
                  ),
                ),

              ElevatedButton(
                onPressed: () {
                  if (!isBlocked) {
                    _fillFullCodeAndCheck();
                  } else {
                    // Navigate directly into Main Shell once approved
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                },
                child: Text(isBlocked ? 'Log in (Approved)' : 'Log in'),
              ),
              const SizedBox(height: 12),

              Center(
                child: isBlocked
                    ? TextButton(
                        onPressed: () {},
                        child: const Text('Contact support', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
                      )
                    : const Text(
                        'New salon? Ask a Zalono executive for an onboarding\ncode.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // A3: Approved Notification / Lock Screen Simulation
  Widget _buildA3ApprovedNotification() {
    return Scaffold(
      backgroundColor: const Color(0xFF9E1F35),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Monday, 12 October',
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                '2:41',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 30),

              // Push notification card
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/main');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ZalonoTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Z',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('ZALONO PARTNER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
                                Text('now', style: TextStyle(fontSize: 11, color: ZalonoTheme.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text('Glow Studio is approved', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
                            const SizedBox(height: 2),
                            const Text(
                              'You can now log in and start taking bookings.',
                              style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              const Text(
                'Tap the notification to open Zalono Partner',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
