import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ActionDialogs {
  static void showCallSheet(
    BuildContext context, {
    required String name,
    required String phone,
    String subtitle = 'Customer',
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: ZalonoTheme.primaryLight,
                  child: Text(
                    name.isNotEmpty ? name[0] : 'C',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ZalonoTheme.primary),
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
            const SizedBox(height: 2),
            Text('$subtitle · $phone', style: const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZalonoTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text('Call now', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling $name at $phone...'),
                          backgroundColor: ZalonoTheme.primary,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy number', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: phone));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phone number copied to clipboard!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF25D366)),
                label: const Text('Send WhatsApp message', style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.w700)),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening WhatsApp chat with $name...'),
                      backgroundColor: const Color(0xFF25D366),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Contact Zalono Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Need assistance with your salon account or bookings? We are here to help.', style: TextStyle(color: ZalonoTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: ZalonoTheme.primaryLight,
                child: Icon(Icons.person, color: ZalonoTheme.primary),
              ),
              title: const Text('Call Dedicated Executive (Rahul K.)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('+91 98000 12345 · Mon–Sat 9AM–8PM', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.call, color: ZalonoTheme.primary),
              onTap: () {
                Navigator.pop(ctx);
                showCallSheet(context, name: 'Rahul K. (Executive)', phone: '+91 98000 12345', subtitle: 'Zalono Salon Partner Executive');
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: ZalonoTheme.primaryLight,
                child: Icon(Icons.headset_mic, color: ZalonoTheme.primary),
              ),
              title: const Text('Zalono Partner 24/7 Helpline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('1800 200 4821 (Toll-free)', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.phone_in_talk, color: ZalonoTheme.primary),
              onTap: () {
                Navigator.pop(ctx);
                showCallSheet(context, name: 'Zalono Support Desk', phone: '1800 200 4821', subtitle: 'Toll-free Partner Care');
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: ZalonoTheme.primaryLight,
                child: Icon(Icons.email_outlined, color: ZalonoTheme.primary),
              ),
              title: const Text('Email Partner Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('partner-care@zalono.com', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
              onTap: () {
                Navigator.pop(ctx);
                Clipboard.setData(const ClipboardData(text: 'partner-care@zalono.com'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email partner-care@zalono.com copied to clipboard!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showFaqAnswer(BuildContext context, String question) {
    String answer = '';
    if (question.contains('check in')) {
      answer = 'To check in a customer, tap on their booking in the "Bookings" tab and select "Check in". This updates their status to "In chair" and signals to the customer that their service has started.';
    } else if (question.contains('show up')) {
      answer = 'If a customer hasn\'t arrived within 15 minutes of their slot, tap on their booking in the "Bookings" tab and select "Mark no-show". This immediately reopens the stylist for online booking.';
    } else {
      answer = 'Salon profile details (like salon name, address, or tax IDs) can be updated anytime by contacting your dedicated Zalono Executive (Rahul K.) or calling Partner Care.';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.help_outline, color: ZalonoTheme.primary, size: 28),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Text(question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
            const SizedBox(height: 14),
            Text(answer, style: const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary, height: 1.45)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  static void showTermsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Terms & Privacy Policy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '1. Partner Agreement\nBy registering with Zalono Partner, you agree to honor bookings scheduled through the Zalono customer platform.\n\n'
                  '2. Accurate Availability\nYou agree to maintain accurate stylist attendance and salon opening hours to avoid overlapping bookings and cancellations.\n\n'
                  '3. Payments & Settlements\nZalono records in-salon payments (Cash, UPI, Card). Any online payouts from pre-paid bookings are credited weekly to your registered bank account.\n\n'
                  '4. Quality & Hygiene\nPartners maintain professional standards, sanitization, and pricing transparency.\n\n'
                  '5. Privacy\nCustomer data (names, phone numbers) must only be used for fulfilling service appointments.',
                  style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('I Understand'),
            ),
          ],
        ),
      ),
    );
  }
}
