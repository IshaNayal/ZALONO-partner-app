import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/action_dialogs.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int tabIndex = 1; // 0: Upcoming, 1: History
  String upcomingFilter = 'All'; // All, Online, Walk-in
  String historyFilter = 'All'; // All, Done, No-show, Cancelled
  String historyTimeframe = 'Last 7 days'; // Today, Yesterday, Last 7 days, Last 30 days
  String? selectedStylistFilter; // null = all stylists

  void _openBookingDetail(BookingItem booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookingDetailSheet(
        booking: booking,
        onProceedToPayment: () {
          Navigator.pop(ctx);
          _openCollectPaymentSheet(booking);
        },
      ),
    );
  }

  void _openCollectPaymentSheet(BookingItem booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CollectPaymentScreen(booking: booking),
      ),
    );
  }

  void _showFilterOptions(BuildContext context, SalonAppState state) {
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
                const Text('Filter by Stylist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => selectedStylistFilter = null);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedStylistFilter == null ? ZalonoTheme.primary : ZalonoTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text('All Stylists', style: TextStyle(fontWeight: FontWeight.w700, color: selectedStylistFilter == null ? Colors.white : ZalonoTheme.textPrimary)),
                  ),
                ),
                ...state.stylists.map((st) {
                  final active = selectedStylistFilter == st.name.split(' ').first;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedStylistFilter = st.name.split(' ').first);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? ZalonoTheme.primary : ZalonoTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(st.name.split(' ').first, style: TextStyle(fontWeight: FontWeight.w700, color: active ? Colors.white : ZalonoTheme.textPrimary)),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showHistoryTimeframeSheet(BuildContext context) {
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
            const Text('Select Timeframe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...['Today', 'Yesterday', 'Last 7 days', 'Last 30 days'].map((tf) {
              return ListTile(
                title: Text(tf, style: TextStyle(fontWeight: historyTimeframe == tf ? FontWeight.w800 : FontWeight.w600, color: historyTimeframe == tf ? ZalonoTheme.primary : ZalonoTheme.textPrimary)),
                trailing: historyTimeframe == tf ? const Icon(Icons.check, color: ZalonoTheme.primary) : null,
                onTap: () {
                  setState(() => historyTimeframe = tf);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<SalonAppState>();

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bookings',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
                  ),
                  if (selectedStylistFilter != null)
                    Chip(
                      label: Text('Stylist: $selectedStylistFilter', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: ZalonoTheme.primary,
                      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
                      onDeleted: () => setState(() => selectedStylistFilter = null),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Segmented Tab: Upcoming | History
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: ZalonoTheme.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          tabIndex = 0;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: tabIndex == 0 ? ZalonoTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Upcoming (${appState.upcomingBookings.length})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: tabIndex == 0 ? Colors.white : ZalonoTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          tabIndex = 1;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: tabIndex == 1 ? ZalonoTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'History (${appState.historyBookings.length})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: tabIndex == 1 ? Colors.white : ZalonoTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sub-filters row
              if (tabIndex == 0) _buildUpcomingSubFilters(appState) else _buildHistorySubFilters(appState),

              const SizedBox(height: 16),

              // Main content list
              Expanded(
                child: tabIndex == 0 ? _buildUpcomingList(appState) : _buildHistoryList(appState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSubFilters(SalonAppState state) {
    return Row(
      children: [
        ...['All', 'Online', 'Walk-in'].map((f) {
          final active = f == upcomingFilter;
          return GestureDetector(
            onTap: () => setState(() => upcomingFilter = f),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? ZalonoTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : ZalonoTheme.textPrimary,
                ),
              ),
            ),
          );
        }),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.filter_list, color: ZalonoTheme.textPrimary),
          onPressed: () => _showFilterOptions(context, state),
        ),
      ],
    );
  }

  Widget _buildHistorySubFilters(SalonAppState state) {
    final totalCount = _getHistoryBookingCount(state);
    final noShows =
        state.historyBookings.where((b) => b.status == BookingStatus.noShow).length;

    return Column(
      children: [
        Row(
          children: ['All', 'Done', 'No-show', 'Cancelled'].map((f) {
            final active = f == historyFilter;
            return GestureDetector(
              onTap: () => setState(() => historyFilter = f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:                 const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? ZalonoTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : ZalonoTheme.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _showHistoryTimeframeSheet(context),
              child: Row(
                children: [
                  Text(historyTimeframe, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: ZalonoTheme.primary)),
                  const Icon(Icons.keyboard_arrow_down, size: 18, color: ZalonoTheme.primary),
                ],
              ),
            ),
            Text(
              '$totalCount bookings · $noShows no-shows',
              style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  int _getHistoryBookingCount(SalonAppState state) {
    return state.historyBookings.length;
  }

  Widget _buildUpcomingList(SalonAppState state) {
    var list = state.upcomingBookings;
    if (upcomingFilter == 'Online') {
      list = list.where((b) => b.type == BookingType.online).toList();
    } else if (upcomingFilter == 'Walk-in') {
      list = list.where((b) => b.type == BookingType.walkIn).toList();
    }
    if (selectedStylistFilter != null) {
      list = list.where((b) => b.stylistName.toLowerCase().contains(selectedStylistFilter!.toLowerCase())).toList();
    }

    final inChairList = list.where((b) => b.status == BookingStatus.inChair).toList();
    final laterList = list.where((b) => b.status == BookingStatus.confirmed).toList();

    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 48, color: ZalonoTheme.textMuted),
            SizedBox(height: 12),
            Text('No upcoming bookings right now', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (inChairList.isNotEmpty) ...[
          const Text('NOW IN CHAIR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          ...inChairList.map((b) => _buildInChairCard(b)),
          const SizedBox(height: 20),
        ],
        if (laterList.isNotEmpty) ...[
          const Text('UPCOMING TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          ...laterList.map((b) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: _buildUpcomingBookingCard(b),
          )),
        ],
      ],
    );
  }

  Widget _buildInChairCard(BookingItem booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZalonoTheme.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_bookingTime(booking)} · ${_bookingDuration(booking)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ZalonoTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'In chair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(booking.customerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(
            '${booking.services.map((s) => s.name).join(", ")} · ${booking.stylistName}',
            style: const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 42),
                  backgroundColor: ZalonoTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                ),
                onPressed: () => _openCollectPaymentSheet(booking),
                child: const Text('Mark done', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${booking.stylistName} opens again for booking after this.',
                  style: const TextStyle(fontSize: 11, color: ZalonoTheme.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingCard(BookingItem booking) {
    return GestureDetector(
      onTap: () => _openBookingDetail(booking),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ZalonoTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_bookingTime(booking), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
                if (booking.type != BookingType.walkIn)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ZalonoTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Confirmed',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(booking.customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(
              '${booking.services.map((s) => s.name).join(", ")} · ${booking.stylistName}',
              style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _bookingTime(BookingItem booking) {
    return DateFormat('h:mm a').format(booking.dateTime);
  }

  String _bookingDuration(BookingItem booking) {
    final minutes = booking.services.fold(
      0,
      (total, service) => total + service.durationMinutes,
    );
    return '$minutes min';
  }

  Widget _buildHistoryList(SalonAppState state) {
    var list = state.historyBookings;
    if (historyFilter == 'Done') {
      list = list.where((b) => b.status == BookingStatus.done).toList();
    } else if (historyFilter == 'No-show') {
      list = list.where((b) => b.status == BookingStatus.noShow).toList();
    } else if (historyFilter == 'Cancelled') {
      list = list.where((b) => b.status == BookingStatus.cancelled).toList();
    }
    if (selectedStylistFilter != null) {
      list = list.where((b) => b.stylistName.toLowerCase().contains(selectedStylistFilter!.toLowerCase())).toList();
    }

    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: ZalonoTheme.textMuted),
            SizedBox(height: 12),
            Text('No historical records match your filter', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final b = list[index];
        final showDateHeader = index == 0 ||
            _historyDateKey(list[index - 1]) != _historyDateKey(b);
        String statusLabel = 'Done';
        if (b.status == BookingStatus.noShow) statusLabel = 'No-show';
        if (b.status == BookingStatus.cancelled) statusLabel = 'Cancelled';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: EdgeInsets.only(
                    top: index == 0 ? 0 : 8, bottom: 8),
                child: Text(
                  _historyDateLabel(b),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: ZalonoTheme.textSecondary,
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ZalonoTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _bookingTime(b),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: ZalonoTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '· ${_bookingDuration(b)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ZalonoTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: b.status == BookingStatus.done
                              ? ZalonoTheme.surfaceMuted
                              : ZalonoTheme.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: b.status == BookingStatus.done
                                ? ZalonoTheme.textSecondary
                                : ZalonoTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(b.customerName,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800)),
                      if (b.status == BookingStatus.done)
                        Text('₹${b.totalAmount.toInt()}',
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${b.services.map((s) => s.name).join(", ")} · ${b.stylistName}',
                    style: const TextStyle(
                        fontSize: 13, color: ZalonoTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _historyDateKey(BookingItem booking) {
    return booking.timeString.split(' · ').first;
  }

  String _historyDateLabel(BookingItem booking) {
    final key = _historyDateKey(booking).toLowerCase();
    if (key == 'yesterday') return 'YESTERDAY · SUN 11 OCT';
    return key.toUpperCase();
  }
}

// A8: Booking Detail Sheet
class _BookingDetailSheet extends StatelessWidget {
  final BookingItem booking;
  final VoidCallback onProceedToPayment;

  const _BookingDetailSheet({required this.booking, required this.onProceedToPayment});

  void _confirmNoShow(BuildContext context, SalonAppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark No-show?'),
        content: Text('Are you sure ${booking.customerName} did not show up? ${booking.stylistName}\'s slots will be reopened immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ZalonoTheme.primary),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              state.markNoShow(booking.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${booking.customerName} marked as no-show. Stylist freed.'), backgroundColor: ZalonoTheme.primary),
              );
            },
            child: const Text('Mark No-show'),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, SalonAppState state) {
    String reason = 'Customer requested';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cancel Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select cancellation reason for ${booking.customerName}:'),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: reason,
                onChanged: (val) {
                  if (val != null) setState(() => reason = val);
                },
                child: Column(
                  children: ['Customer requested', 'Salon unavailable', 'Emergency reschedule'].map((r) {
                    return RadioListTile<String>(
                      title: Text(r, style: const TextStyle(fontSize: 14)),
                      value: r,
                      activeColor: ZalonoTheme.primary,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                state.cancelBooking(booking.id, reason);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking cancelled ($reason).'), backgroundColor: Colors.red[800]),
                );
              },
              child: const Text('Cancel Booking'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<SalonAppState>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: ZalonoTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  booking.status == BookingStatus.inChair ? 'In Chair' : 'Confirmed',
                  style: const TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('BOOKING #${booking.id}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(booking.customerName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),

          _buildDetailRow('Time', booking.timeString),
          _buildDetailRow('Services', booking.services.map((s) => s.name).join(", ")),
          _buildDetailRow('Stylist', booking.stylistName),
          _buildDetailRow('Total', '₹${booking.totalAmount.toInt()} · pay at salon'),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: ZalonoTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.customerStatus ?? 'Booking confirmed on Zalono',
                    style: const TextStyle(color: ZalonoTheme.primaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ActionDialogs.showCallSheet(
                    context,
                    name: booking.customerName,
                    phone: booking.customerPhone,
                    subtitle: 'Customer · ${booking.services.first.name}',
                  ),
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (booking.status == BookingStatus.inChair) {
                      onProceedToPayment();
                    } else {
                      appState.checkInBooking(booking.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${booking.customerName} checked in and now in chair!'),
                          backgroundColor: ZalonoTheme.primary,
                        ),
                      );
                    }
                  },
                  child: Text(booking.status == BookingStatus.inChair ? 'Collect Payment' : 'Check in'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => _confirmNoShow(context, appState),
                child: const Text('Mark no-show', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
              ),
              TextButton(
                onPressed: () => _confirmCancel(context, appState),
                child: const Text('Cancel booking', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ZalonoTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

// A9: Complete and Mark Paid Screen
class CollectPaymentScreen extends StatefulWidget {
  final BookingItem booking;
  const CollectPaymentScreen({super.key, required this.booking});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  String selectedPayment = 'UPI'; // Cash, UPI, Card

  @override
  Widget build(BuildContext context) {
    final appState = context.read<SalonAppState>();
    final price = widget.booking.totalAmount.toInt();
    final newRevenue = (appState.todayOnlineRevenue + (widget.booking.type == BookingType.online ? widget.booking.totalAmount : 0)).toInt();
    final servicesClean = widget.booking.services
        .map((s) => s.name.replaceAll(RegExp(r'\s*\([^)]*\)'), ''))
        .join(' + ');

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 36 > 0 ? constraints.maxHeight - 36 : 0,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rounded White Square Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 26,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Title
                      Text(
                        'Collect ₹$price',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        '${widget.booking.customerName} · $servicesClean · ${widget.booking.stylistName}',
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFF6B6864),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // White Card with Line Items & Total
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          children: [
                            ...List.generate(widget.booking.services.length, (idx) {
                              final s = widget.booking.services[idx];
                              return Column(
                                children: [
                                  if (idx > 0)
                                    const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          s.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6B6864),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '₹${s.price.toInt()}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1E1E1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  Text(
                                    '₹$price',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // HOW DID THEY PAY? Label
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 10),
                        child: Text(
                          'HOW DID THEY PAY?',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B6864),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      // Payment Method Pills
                      Row(
                        children: ['Cash', 'UPI', 'Card'].map((mode) {
                          final isSelected = mode == selectedPayment;
                          return GestureDetector(
                            onTap: () => setState(() => selectedPayment = mode),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: mode == 'UPI' ? 24 : 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? ZalonoTheme.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? ZalonoTheme.primary : const Color(0xFFEFE8E1),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                mode,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Notice Box
                      Container(
                        margin: const EdgeInsets.only(top: 18),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Zalono does not process this payment. You are only recording it. It adds to Online revenue on Home.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF7A162B),
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

                      // Mark Paid and Complete Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            PaymentMethod method = PaymentMethod.upi;
                            if (selectedPayment == 'Cash') method = PaymentMethod.cash;
                            if (selectedPayment == 'Card') method = PaymentMethod.card;

                            appState.completeBookingAndCollectPayment(widget.booking.id, method, widget.booking.totalAmount);
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Payment of ₹$price recorded via $selectedPayment! Added to Online revenue.'),
                                backgroundColor: ZalonoTheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ZalonoTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Mark paid and complete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sub-button info text
                      Center(
                        child: Text(
                          'Online revenue today will become ₹${NumberFormat.decimalPattern().format(newRevenue)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5A5753),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
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
