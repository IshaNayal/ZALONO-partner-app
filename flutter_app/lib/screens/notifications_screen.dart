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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 38, 14, 32),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(context),
                Padding(
                  padding: const EdgeInsets.only(top: 11, right: 2),
                  child: GestureDetector(
                    onTap: appState.unreadNotificationsCount == 0
                        ? null
                        : appState.markAllNotificationsRead,
                    child: Text(
                      'Mark all read',
                      style: TextStyle(
                        color: appState.unreadNotificationsCount == 0
                            ? ZalonoTheme.textMuted
                            : ZalonoTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 29,
                height: 1.1,
                fontWeight: FontWeight.w900,
                color: ZalonoTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'TODAY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textSecondary,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 9),
            if (appState.notifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text('No notifications right now',
                      style: TextStyle(
                          color: ZalonoTheme.textSecondary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ...appState.notifications.map(
              (notif) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Dismissible(
                  key: Key(notif.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    appState.dismissNotification(notif.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification dismissed.')),
                    );
                  },
                  child: _buildNotificationCard(context, notif, appState),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFD9D2)),
        ),
        child: const Icon(Icons.chevron_left,
            size: 26, color: ZalonoTheme.textPrimary),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, NotificationModel notif, SalonAppState state) {
    IconData icon = Icons.notifications;
    if (notif.type == 'stylist_off') icon = Icons.people_outline;
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
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: ZalonoTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notif.isRead ? const Color(0xFFEFD9D2) : ZalonoTheme.primary,
            width: notif.isRead ? 1 : 1.1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: ZalonoTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: ZalonoTheme.primary, size: 20),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(notif.title,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 8),
                          Text(notif.time,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: ZalonoTheme.textSecondary)),
                          if (!notif.isRead) ...[
                            const SizedBox(width: 9),
                            const CircleAvatar(
                                radius: 4,
                                backgroundColor: ZalonoTheme.primary),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.body,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: ZalonoTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (notif.hasAction && !notif.isRead) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const SizedBox(width: 49),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(85, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      backgroundColor: ZalonoTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      state.turnOnStylist('Rahul');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Rahul turned on! Now available for booking.'),
                            backgroundColor: ZalonoTheme.primary),
                      );
                    },
                    child: const Text('Turn on',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 3),
                  TextButton(
                    onPressed: () {
                      state.markNotificationRead(notif.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Reminder snoozed for 30 minutes.')),
                      );
                    },
                    child: const Text('Later',
                        style: TextStyle(
                            color: ZalonoTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
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
