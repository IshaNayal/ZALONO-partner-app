import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<SalonAppState>();

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              appState.markAllNotificationsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
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

            if (appState.notifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text('No notifications right now', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
                ),
              ),

            ...appState.notifications.map((notif) {
              return Dismissible(
                key: Key(notif.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  appState.dismissNotification(notif.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification dismissed.')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildNotificationCard(context, notif, appState),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationModel notif, SalonAppState state) {
    IconData icon = Icons.notifications;
    if (notif.type == 'stylist_off') icon = Icons.group_outlined;
    if (notif.type == 'stylist_free') icon = Icons.check;
    if (notif.type == 'customer_status') icon = Icons.schedule;
    if (notif.type == 'new_booking') icon = Icons.calendar_today_outlined;

    return GestureDetector(
      onTap: () {
        state.markNotificationRead(notif.id);
        if (notif.type == 'stylist_off' || notif.type == 'stylist_free') {
          Navigator.pushNamed(context, '/stylists');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notif.isRead ? ZalonoTheme.border : ZalonoTheme.primary,
            width: notif.isRead ? 1 : 1.3,
          ),
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
                            child: Text(notif.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                          ),
                          Row(
                            children: [
                              Text(notif.time, style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary)),
                              if (!notif.isRead) ...[
                                const SizedBox(width: 6),
                                const CircleAvatar(radius: 4, backgroundColor: ZalonoTheme.primary),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(notif.body, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            if (notif.hasAction && !notif.isRead) ...[
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
                      state.turnOnStylist('Rahul');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rahul turned on! Now available for booking.'), backgroundColor: ZalonoTheme.primary),
                      );
                    },
                    child: const Text('Turn on', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      state.markNotificationRead(notif.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reminder snoozed for 30 minutes.')),
                      );
                    },
                    child: const Text('Later', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
