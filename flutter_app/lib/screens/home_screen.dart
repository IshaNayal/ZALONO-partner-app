import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../widgets/zalono_switch.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToBookings;
  const HomeScreen({super.key, required this.onNavigateToBookings});

  void _openAddWalkInSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddWalkInSheet(),
    );
  }

  void _handleCustomDateRange(BuildContext context, SalonAppState state) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ZalonoTheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      state.setHomeFilter('Custom');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Filtered range: ${picked.start.day}/${picked.start.month} - ${picked.end.day}/${picked.end.month}'),
            backgroundColor: ZalonoTheme.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<SalonAppState>();
    final availableStylistsCount =
        appState.stylists.where((s) => s.isAvailable).length;
    final totalStylistsCount = appState.stylists.length;

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
                    children: [
                      Text(
                        'Good afternoon, ${appState.ownerName.split(" ").first}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: ZalonoTheme.textSecondary,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appState.salonName,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: ZalonoTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${DateTime.now().weekday == DateTime.monday ? 'Mon' : DateTime.now().weekday == DateTime.tuesday ? 'Tue' : DateTime.now().weekday == DateTime.wednesday ? 'Wed' : DateTime.now().weekday == DateTime.thursday ? 'Thu' : DateTime.now().weekday == DateTime.friday ? 'Fri' : DateTime.now().weekday == DateTime.saturday ? 'Sat' : 'Sun'} ${DateTime.now().day} ${DateTime.now().month == DateTime.january ? 'Jan' : DateTime.now().month == DateTime.february ? 'Feb' : DateTime.now().month == DateTime.march ? 'Mar' : DateTime.now().month == DateTime.april ? 'Apr' : DateTime.now().month == DateTime.may ? 'May' : DateTime.now().month == DateTime.june ? 'Jun' : DateTime.now().month == DateTime.july ? 'Jul' : DateTime.now().month == DateTime.august ? 'Aug' : DateTime.now().month == DateTime.september ? 'Sep' : DateTime.now().month == DateTime.october ? 'Oct' : DateTime.now().month == DateTime.november ? 'Nov' : 'Dec'}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: ZalonoTheme.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_none, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Accepting Bookings Banner (Hero Card)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: appState.isAcceptingBookings
                      ? ZalonoTheme.primary
                      : const Color(0xFF6B7280),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.isAcceptingBookings
                              ? 'Accepting bookings'
                              : 'Bookings paused',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.isAcceptingBookings
                              ? 'Customers can book you now'
                              : 'Online slots are temporarily closed',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          appState.isAcceptingBookings ? 'ON' : 'OFF',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        ZalonoSwitch(
                          value: appState.isAcceptingBookings,
                          activeColor: const Color(0xFF8B162C),
                          thumbColor: Colors.white,
                          inactiveColor: Colors.white24,
                          onChanged: (val) {
                            appState.toggleAcceptingBookings(val);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(val
                                    ? 'Salon is now accepting bookings online'
                                    : 'Salon bookings paused'),
                                backgroundColor: val
                                    ? ZalonoTheme.primary
                                    : Colors.grey[800],
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter Tabs
              Row(
                children: ['Today', 'This week', 'This month', 'Custom']
                    .map((filter) {
                  final active = filter == appState.selectedHomeFilter;
                  return GestureDetector(
                    onTap: () {
                      if (filter == 'Custom') {
                        _handleCustomDateRange(context, appState);
                      } else {
                        appState.setHomeFilter(filter);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            active ? ZalonoTheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: active
                                ? ZalonoTheme.primary
                                : ZalonoTheme.border),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color:
                              active ? Colors.white : ZalonoTheme.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Online bookings only. Walk-ins are not counted.',
                style:
                    TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
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
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.textSecondary),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${appState.onlineRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Marked as paid',
                            style: TextStyle(
                                fontSize: 12,
                                color: ZalonoTheme.textSecondary,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onNavigateToBookings,
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ONLINE BOOKINGS',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: ZalonoTheme.textSecondary),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12, color: ZalonoTheme.textSecondary),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${appState.totalBookingsCount}',
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: ZalonoTheme.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${appState.doneBookingsCount} done, ${appState.toComeBookingsCount} to come',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: ZalonoTheme.textSecondary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
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
                        children: appState.stylists.take(3).map((st) {
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: st.isAvailable
                                  ? ZalonoTheme.primaryLight
                                  : ZalonoTheme.surfaceMuted,
                              child: Text(
                                st.initials,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: st.isAvailable
                                      ? ZalonoTheme.primary
                                      : ZalonoTheme.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Stylists today',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text(
                              '$availableStylistsCount of $totalStylistsCount available · ${appState.stylists.any((s) => !s.isAvailable) ? "${appState.stylists.firstWhere((s) => !s.isAvailable).name} is off" : "All active"}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: ZalonoTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: ZalonoTheme.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Large Floating Action Button: + Add walk-in
              ElevatedButton.icon(
                onPressed: () => _openAddWalkInSheet(context),
                icon: const Icon(Icons.add, size: 22),
                label: const Text('Add walk-in', style: TextStyle(fontWeight: FontWeight.bold)),
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
  const _AddWalkInSheet();

  @override
  State<_AddWalkInSheet> createState() => _AddWalkInSheetState();
}

class _AddWalkInSheetState extends State<_AddWalkInSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final List<String> _selectedServices = [];
  String? _selectedStylist;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<SalonAppState>();
    final services = appState.catalogServices;

    double totalPrice = 0;
    int totalMinutes = 0;
    for (var s in services) {
      if (_selectedServices.contains(s.name)) {
        totalPrice += s.price;
        totalMinutes += s.durationMinutes;
      }
    }
    if (totalMinutes == 0) totalMinutes = 30;

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
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ZalonoTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add every customer who walks in, so no one can book the same stylist at the same time.',
              style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
            ),
            const SizedBox(height: 20),

            const Text('CUSTOMER NAME',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Customer name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ZalonoTheme.border)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            const Text('MOBILE NUMBER',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixText: '+91 ',
                hintText: '10-digit phone number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ZalonoTheme.border)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SERVICES',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: ZalonoTheme.textSecondary)),
                Text('Total ₹${totalPrice.toInt()}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: ZalonoTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: services.map((s) {
                final isSelected = _selectedServices.contains(s.name);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedServices.remove(s.name);
                      } else {
                        _selectedServices.add(s.name);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? ZalonoTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected
                              ? ZalonoTheme.primary
                              : ZalonoTheme.border),
                    ),
                    child: Text(
                      '${s.name} · ₹${s.price.toInt()}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('STYLIST · AVAILABLE TODAY',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textSecondary)),
            const SizedBox(height: 8),

            Row(
              children: appState.stylists.where((s) => s.isAvailable).map((st) {
                final isSelected = (_selectedStylist ?? '')
                    .toLowerCase()
                    .contains(st.name.split(' ').first.toLowerCase());
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(
                        () => _selectedStylist = st.name.split(' ').first),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? ZalonoTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isSelected
                                ? ZalonoTheme.primary
                                : ZalonoTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            st.name.split(' ').first,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : ZalonoTheme.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            st.statusDetail ?? 'Available',
                            style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Colors.white70
                                    : ZalonoTheme.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                    decoration: BoxDecoration(
                        color: ZalonoTheme.primary,
                        borderRadius: BorderRadius.circular(6)),
                    child:
                        const Icon(Icons.lock, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_selectedStylist blocked · $totalMinutes min',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.textPrimary)),
                        const SizedBox(height: 2),
                        const Text(
                          'Online booking is closed for this time. Stylist opens again automatically when you mark this walk-in done.',
                          style: TextStyle(
                              fontSize: 12,
                              color: ZalonoTheme.textSecondary,
                              height: 1.3),
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
                final customerName = _nameController.text.trim();
                final phone = _phoneController.text.trim();
                if (customerName.isEmpty || phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Enter the customer name and phone number.')),
                  );
                  return;
                }
                if (_selectedServices.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select at least one service!')),
                  );
                  return;
                }
                if (_selectedStylist == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select an available stylist.')),
                  );
                  return;
                }

                appState.addWalkIn(
                  customerName: customerName,
                  customerPhone: '+91 $phone',
                  serviceNames: _selectedServices,
                  stylistName: _selectedStylist!,
                  totalAmount: totalPrice,
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Walk-in booked! $_selectedStylist is blocked for $totalMinutes min.'),
                    backgroundColor: ZalonoTheme.primary,
                  ),
                );
              },
              child: const Text('Add walk-in and block time'),
            ),
          ],
        ),
      ),
    );
  }
}
