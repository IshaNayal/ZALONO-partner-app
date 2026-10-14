import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool rahulActionTaken = false;
  bool allRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => allRead = true),
            child: const Text('Mark all read', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
            ),
            const SizedBox(height: 20),
            const Text('TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
            const SizedBox(height: 12),

            // Card 1: Rahul off time has ended
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ZalonoTheme.primary, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.group_outlined, color: ZalonoTheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Rahul's off time has\nended", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                Row(
                                  children: [
                                    const Text('5:00 PM', style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary)),
                                    if (!allRead) ...[
                                      const SizedBox(width: 6),
                                      const CircleAvatar(radius: 4, backgroundColor: ZalonoTheme.primary),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Turn Rahul on so customers can book him again.',
                              style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const SizedBox(width: 44),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 36),
                          backgroundColor: ZalonoTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          setState(() => rahulActionTaken = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Rahul turned on! Now available for booking.'), backgroundColor: ZalonoTheme.primary),
                          );
                        },
                        child: Text(rahulActionTaken ? 'Turned on' : 'Turn on', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Later', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Card 2: Priya is open for booking again
            _buildNotificationItem(
              icon: Icons.check,
              title: 'Priya is open for booking again',
              body: 'Walk-in Mohit S. ended at 3:25 PM.',
              time: '3:25 PM',
              unread: !allRead,
            ),
            const SizedBox(height: 12),

            // Card 3: Aarav K. is on the way
            _buildNotificationItem(
              icon: Icons.schedule,
              title: 'Aarav K. is on the way',
              body: 'Left home, about 8 min away for his 2:20 PM booking.',
              time: '2:12 PM',
              unread: false,
            ),
            const SizedBox(height: 12),

            // Card 4: New booking · Divya S.
            _buildNotificationItem(
              icon: Icons.calendar_today_outlined,
              title: 'New booking · Divya S.',
              body: 'Tue 13 Oct · 11:00 AM · Haircut (Women) with Priya',
              time: '2:10 PM',
              unread: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String body,
    required String time,
    required bool unread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZalonoTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: ZalonoTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ),
                    Row(
                      children: [
                        Text(time, style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary)),
                        if (unread) ...[
                          const SizedBox(width: 6),
                          const CircleAvatar(radius: 4, backgroundColor: ZalonoTheme.primary),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
