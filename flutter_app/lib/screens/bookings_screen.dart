import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int tabIndex = 0; // 0: Upcoming (A6), 1: History (A7)
  String subFilter = 'All'; // All, Online, Walk-in for upcoming; All, Done, No-show, Cancelled for history

  void _openBookingDetail(Map<String, dynamic> booking) {
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

  void _openCollectPaymentSheet(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CollectPaymentSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bookings',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
              ),
              const SizedBox(height: 16),

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
                          subFilter = 'All';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: tabIndex == 0 ? ZalonoTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Upcoming',
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
                          subFilter = 'All';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: tabIndex == 1 ? ZalonoTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'History',
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
              if (tabIndex == 0) _buildUpcomingSubFilters() else _buildHistorySubFilters(),

              const SizedBox(height: 16),

              // Main content list
              Expanded(
                child: tabIndex == 0 ? _buildUpcomingList() : _buildHistoryList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSubFilters() {
    return Row(
      children: [
        ...['All', 'Online', 'Walk-in'].map((f) {
          final active = f == subFilter;
          return GestureDetector(
            onTap: () => setState(() => subFilter = f),
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
                  fontSize: 13,
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
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHistorySubFilters() {
    return Column(
      children: [
        Row(
          children: ['All', 'Done', 'No-show', 'Cancelled'].map((f) {
            final active = f == subFilter;
            return GestureDetector(
              onTap: () => setState(() => subFilter = f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
          children: const [
            Row(
              children: [
                Text('Last 7 days', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: ZalonoTheme.primary)),
                Icon(Icons.keyboard_arrow_down, size: 18, color: ZalonoTheme.primary),
              ],
            ),
            Text(
              '42 bookings · 3 no-shows',
              style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // A6 Upcoming List
  Widget _buildUpcomingList() {
    return ListView(
      children: [
        // NOW Section
        const Text('NOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),

        // In Chair Card (Karan M.)
        Container(
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
                  const Text(
                    '1:50 PM · in chair',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: ZalonoTheme.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Text('In chair', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Karan M.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              const Text('Pedicure · Neha', style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary)),
              const SizedBox(height: 14),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 42),
                      backgroundColor: ZalonoTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                    ),
                    onPressed: () {
                      _openCollectPaymentSheet({
                        'name': 'Karan M.',
                        'services': 'Pedicure',
                        'stylist': 'Neha',
                        'price': 599,
                      });
                    },
                    child: const Text('Mark done', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Neha opens again for online booking after this.',
                      style: TextStyle(fontSize: 11, color: ZalonoTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // LATER TODAY Section
        const Text('LATER TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),

        _buildLaterBookingCard(
          time: '2:20 PM · 45 min',
          name: 'Aarav K.',
          service: 'Haircut + Beard trim · Priya',
          onTap: () {
            _openBookingDetail({
              'id': 'ZAL-6849',
              'name': 'Aarav K.',
              'time': 'Today · 2:20 PM',
              'services': 'Haircut + Beard trim',
              'stylist': 'Priya',
              'price': 548,
              'status': 'Left home · about 8 min away',
            });
          },
        ),
        const SizedBox(height: 10),

        _buildLaterBookingCard(
          time: '3:00 PM · 60 min',
          name: 'Sneha R.',
          service: 'Facial · Rahul',
          onTap: () {},
        ),
        const SizedBox(height: 10),

        _buildLaterBookingCard(
          time: '4:00 PM · 90 min',
          name: 'Ankit D.',
          service: 'Hair colour · Priya',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLaterBookingCard({
    required String time,
    required String name,
    required String service,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: const Text('Confirmed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(service, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  // A7 History List
  Widget _buildHistoryList() {
    return ListView(
      children: [
        const Text('YESTERDAY · SUN 11 OCT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        _buildHistoryCard(time: '6:30 PM · 60 min', name: 'Ritu S.', service: 'Facial · Rahul', status: 'Done', amount: '₹1,200'),
        const SizedBox(height: 10),
        _buildHistoryCard(time: '5:00 PM · 45 min', name: 'Vikram A.', service: 'Haircut (Men) · Priya', status: 'No-show', amount: null),
        const SizedBox(height: 10),
        _buildHistoryCard(time: '3:30 PM · 45 min', name: 'Pooja M.', service: 'Manicure · Neha', status: 'Done', amount: '₹599'),
        const SizedBox(height: 16),
        const Text('SAT 10 OCT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        _buildHistoryCard(time: '7:00 PM · 15 min', name: 'Arjun R.', service: 'Beard trim · Priya', status: 'Cancelled', amount: null),
      ],
    );
  }

  Widget _buildHistoryCard({
    required String time,
    required String name,
    required String service,
    required String status,
    String? amount,
  }) {
    return Container(
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
              Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: status == 'Done' ? ZalonoTheme.surfaceMuted : ZalonoTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: status == 'Done' ? ZalonoTheme.textSecondary : ZalonoTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              if (amount != null)
                Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 2),
          Text(service, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
        ],
      ),
    );
  }
}

// A8: Booking Detail Sheet
class _BookingDetailSheet extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onProceedToPayment;

  const _BookingDetailSheet({required this.booking, required this.onProceedToPayment});

  @override
  Widget build(BuildContext context) {
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
                child: const Text('Confirmed', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('BOOKING #${booking['id'] ?? 'ZAL-6849'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(booking['name'] ?? 'Aarav K.', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),

          _buildDetailRow('Time', booking['time'] ?? 'Today · 2:20 PM'),
          _buildDetailRow('Services', booking['services'] ?? 'Haircut + Beard trim'),
          _buildDetailRow('Stylist', booking['stylist'] ?? 'Priya'),
          _buildDetailRow('Total', '₹${booking['price'] ?? 548} · pay at salon'),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: ZalonoTheme.primary),
                const SizedBox(width: 8),
                Text(
                  booking['status'] ?? 'Left home · about 8 min away',
                  style: const TextStyle(color: ZalonoTheme.primaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onProceedToPayment,
                  child: const Text('Check in'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () {}, child: const Text('Mark no-show', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700))),
              TextButton(onPressed: () {}, child: const Text('Cancel booking', style: TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600))),
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
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// A9: Complete and Mark Paid Sheet
class _CollectPaymentSheet extends StatefulWidget {
  final Map<String, dynamic> booking;
  const _CollectPaymentSheet({required this.booking});

  @override
  State<_CollectPaymentSheet> createState() => _CollectPaymentSheetState();
}

class _CollectPaymentSheetState extends State<_CollectPaymentSheet> {
  String selectedPayment = 'UPI'; // Cash, UPI, Card

  @override
  Widget build(BuildContext context) {
    final price = widget.booking['price'] ?? 548;

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
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
            ],
          ),
          Text(
            'Collect ₹$price',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.booking['name']} · ${widget.booking['services']} · ${widget.booking['stylist']}',
            style: const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Line items
          _buildItemRow('Haircut (Men)', '₹399'),
          _buildItemRow('Beard trim', '₹149'),
          const Divider(),
          _buildItemRow('Total', '₹$price', isBold: true),

          const SizedBox(height: 20),
          const Text('HOW DID THEY PAY?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
          const SizedBox(height: 8),

          Row(
            children: ['Cash', 'UPI', 'Card'].map((mode) {
              final active = mode == selectedPayment;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedPayment = mode),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: active ? ZalonoTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      mode,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: active ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'Zalono does not process this payment. You are only recording it. It adds to Online revenue on Home.',
              style: TextStyle(fontSize: 12, color: ZalonoTheme.primaryDark, height: 1.35),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded! Added to Online revenue.'), backgroundColor: ZalonoTheme.primary),
              );
            },
            child: const Text('Mark paid and complete'),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Online revenue today will become ₹4,798',
              style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
          Text(price, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w800 : FontWeight.w700)),
        ],
      ),
    );
  }
}
