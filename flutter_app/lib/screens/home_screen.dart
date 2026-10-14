import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToBookings;
  const HomeScreen({super.key, required this.onNavigateToBookings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAcceptingBookings = true;
  String selectedFilter = 'Today'; // Today, This week, This month, Custom
  int unreadNotifications = 2;

  // Live Metrics
  double onlineRevenue = 4250;
  int totalBookings = 8;
  int doneBookings = 3;
  int toComeBookings = 5;

  void _openAddWalkInSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddWalkInSheet(
        onWalkInAdded: (amount) {
          setState(() {
            // Updating local counts
            totalBookings += 1;
            toComeBookings += 1;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Walk-in booked! Priya is blocked for 45 min.'),
              backgroundColor: ZalonoTheme.primary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good afternoon, Rohan',
                        style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Glow Studio',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Mon 12 Oct',
                        style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                        icon: const Icon(Icons.notifications_none, size: 28),
                      ),
                      if (unreadNotifications > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: ZalonoTheme.primary,
                            child: Text(
                              '$unreadNotifications',
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Accepting Bookings Banner (Hero Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: ZalonoTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Accepting bookings',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Customers can book you now',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          isAcceptingBookings ? 'ON' : 'OFF',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: isAcceptingBookings,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFF8B162C),
                          onChanged: (val) => setState(() => isAcceptingBookings = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter Tabs
              Row(
                children: ['Today', 'This week', 'This month', 'Custom'].map((filter) {
                  final active = filter == selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? ZalonoTheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
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
              const SizedBox(height: 10),
              const Text(
                'Online bookings only. Walk-ins are not counted.',
                style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 16),

              // Metric Cards Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ZalonoTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ONLINE REVENUE',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${onlineRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Marked as paid',
                            style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ZalonoTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ONLINE BOOKINGS',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$totalBookings',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$doneBookings done, $toComeBookings to come',
                            style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stylists Today Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/stylists'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ZalonoTheme.border),
                  ),
                  child: Row(
                    children: [
                      // Stylist avatars
                      Row(
                        children: ['P', 'R', 'N'].map((initial) {
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: ZalonoTheme.primaryLight,
                              child: Text(
                                initial,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: ZalonoTheme.primary),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Stylists today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            SizedBox(height: 2),
                            Text(
                              '2 of 3 available · Rahul off till 5 PM',
                              style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Large Floating Action Button: + Add walk-in
              ElevatedButton.icon(
                onPressed: _openAddWalkInSheet,
                icon: const Icon(Icons.add, size: 22),
                label: const Text('Add walk-in'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// A5: Add Walk-in Modal Sheet
class _AddWalkInSheet extends StatefulWidget {
  final ValueChanged<double> onWalkInAdded;
  const _AddWalkInSheet({required this.onWalkInAdded});

  @override
  State<_AddWalkInSheet> createState() => _AddWalkInSheetState();
}

class _AddWalkInSheetState extends State<_AddWalkInSheet> {
  String name = 'Mohit S.';
  String phone = '98765 12345';
  List<String> selectedServices = ['Haircut (Men)', 'Beard trim'];
  String selectedStylist = 'Priya';

  final List<Map<String, dynamic>> services = [
    {'name': 'Haircut (Men)', 'price': 399},
    {'name': 'Beard trim', 'price': 149},
    {'name': 'Hair colour', 'price': 2499},
    {'name': 'Hair spa', 'price': 1999},
  ];

  double get totalPrice {
    double sum = 0;
    for (var s in services) {
      if (selectedServices.contains(s['name'])) {
        sum += (s['price'] as int).toDouble();
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: ZalonoTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text(
              'Add walk-in',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add every customer who walks in, so no one can book the same stylist at the same time.',
              style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
            ),
            const SizedBox(height: 20),

            const Text('CUSTOMER NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
              child: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 16),

            const Text('MOBILE NUMBER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
              child: Row(
                children: [
                  const Text('+91', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 10),
                  Text(phone, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SERVICES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
                Text('Total ₹${totalPrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: services.map((s) {
                final isSelected = selectedServices.contains(s['name']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedServices.remove(s['name']);
                      } else {
                        selectedServices.add(s['name']);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? ZalonoTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? ZalonoTheme.primary : ZalonoTheme.border),
                    ),
                    child: Text(
                      '${s['name']} · ₹${s['price']}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('STYLIST · AVAILABLE TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedStylist = 'Priya'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selectedStylist == 'Priya' ? ZalonoTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selectedStylist == 'Priya' ? ZalonoTheme.primary : ZalonoTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priya', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: selectedStylist == 'Priya' ? Colors.white : ZalonoTheme.textPrimary)),
                          const SizedBox(height: 2),
                          Text('Free now', style: TextStyle(fontSize: 12, color: selectedStylist == 'Priya' ? Colors.white70 : ZalonoTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedStylist = 'Neha'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selectedStylist == 'Neha' ? ZalonoTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: selectedStylist == 'Neha' ? ZalonoTheme.primary : ZalonoTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Neha', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: selectedStylist == 'Neha' ? Colors.white : ZalonoTheme.textPrimary)),
                          const SizedBox(height: 2),
                          Text('Busy till 3:20 PM', style: TextStyle(fontSize: 12, color: selectedStylist == 'Neha' ? Colors.white70 : ZalonoTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Blocked notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ZalonoTheme.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: ZalonoTheme.primary, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.lock, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Priya blocked · 2:40 – 3:25 PM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
                        SizedBox(height: 2),
                        Text(
                          'Online booking is closed for this time. Priya opens again automatically when you mark this walk-in done.',
                          style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.onWalkInAdded(totalPrice);
                Navigator.pop(context);
              },
              child: const Text('Add walk-in and block time'),
            ),
          ],
        ),
      ),
    );
  }
}
