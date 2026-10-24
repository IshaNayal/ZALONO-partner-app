import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/action_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phoneController;
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;

  bool isBlocked = false;
  bool showNotificationSim = false;
  int resendCountdown = 24;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _otpFocusNodes = List.generate(6, (_) => FocusNode());

    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (resendCountdown > 0) {
        setState(() => resendCountdown--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _resendCode() {
    setState(() {
      resendCountdown = 30;
      isBlocked = false;
      for (var c in _otpControllers) {
        c.clear();
      }
    });
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent to +91 ${_phoneController.text}: 427901'),
        backgroundColor: ZalonoTheme.primary,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits of the code.'),
          backgroundColor: ZalonoTheme.primary,
        ),
      );
      return;
    }

    if (!isBlocked) {
      // First attempt triggers A2: Login Blocked / Not approved yet
      setState(() {
        isBlocked = true;
      });
    } else {
      // If tapped again or approved, enter the app
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('logged_in', true);
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  bool get _isOtpComplete =>
      _otpControllers.every((controller) => controller.text.isNotEmpty);

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
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                const SizedBox(height: 24),

                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: ZalonoTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use the mobile number you registered with.',
                  style:
                      TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
                ),
                const SizedBox(height: 24),

                // MOBILE NUMBER: in-line editable field identical to R2
                const Text(
                  'MOBILE NUMBER',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: ZalonoTheme.textSecondary),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ZalonoTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Text('+91',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      Container(
                          width: 1, height: 24, color: ZalonoTheme.border),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Enter mobile number',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Icon(Icons.edit_outlined,
                          size: 18, color: ZalonoTheme.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ENTER THE 6-DIGIT CODE: Manual input by hand
                const Text(
                  'ENTER THE 6-DIGIT CODE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: ZalonoTheme.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final isFocused = _otpFocusNodes[index].hasFocus;
                    final hasVal = _otpControllers[index].text.isNotEmpty;
                    return Container(
                      width: 46,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFocused
                              ? ZalonoTheme.primary
                              : (hasVal
                                  ? ZalonoTheme.textPrimary
                                  : ZalonoTheme.border),
                          width: isFocused ? 1.8 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (val.isNotEmpty && index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            }
                            final code =
                                _otpControllers.map((c) => c.text).join();
                            if (code.length == 6) {
                              _otpFocusNodes[5].unfocus();
                            }
                          });
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                if (!isBlocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resend code in 0:${resendCountdown.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 13, color: ZalonoTheme.textSecondary),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              const dummy = ['4', '2', '7', '9', '0', '1'];
                              for (int i = 0; i < 6; i++) {
                                _otpControllers[i].text = dummy[i];
                              }
                              setState(() {});
                            },
                            child: const Text('Auto-fill',
                                style: TextStyle(
                                    color: ZalonoTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _resendCode,
                            child: const Text('Resend now',
                                style: TextStyle(
                                    color: ZalonoTheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ],
                  ),

                // A2: Blocked Card
                if (_isOtpComplete || isBlocked) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ZalonoTheme.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: ZalonoTheme.primary.withValues(alpha: 0.3)),
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
                          child: const Icon(Icons.lock,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isOtpComplete ? _handleLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isOtpComplete
                        ? ZalonoTheme.primary
                        : const Color(0xFFD0CBC6),
                  ),
                  child: Text(isBlocked ? 'Log in (Approved)' : 'Log in',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),

                Center(
                  child: (_isOtpComplete || isBlocked)
                      ? TextButton(
                          onPressed: () =>
                              ActionDialogs.showSupportSheet(context),
                          child: const Text('Contact support',
                              style: TextStyle(
                                  color: ZalonoTheme.primary,
                                  fontWeight: FontWeight.w700)),
                        )
                      : TextButton(
                          onPressed: () =>
                              ActionDialogs.showSupportSheet(context),
                          child: const Text(
                            'New salon? Ask a Zalono executive for an onboarding code.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: ZalonoTheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
              ],
            ),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Monday, 12 October',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
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
                          color: Colors.black.withValues(alpha: 0.15),
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
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ZALONO PARTNER',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: ZalonoTheme.textSecondary)),
                                  Text('now',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: ZalonoTheme.textMuted)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('Glow Studio is approved',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: ZalonoTheme.textPrimary)),
                              SizedBox(height: 2),
                              Text(
                                'You can now log in and start taking bookings.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ZalonoTheme.textSecondary,
                                    height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Tap the notification to open Zalono Partner',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
