import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/zalono_switch.dart';

class StylistsScreen extends StatefulWidget {
  const StylistsScreen({super.key});

  @override
  State<StylistsScreen> createState() => _StylistsScreenState();
}

class _StylistsScreenState extends State<StylistsScreen> {
  bool priyaAvailable = true;
  bool rahulAvailable = false; // Off until 5:00 PM
  bool nehaAvailable = true;

  void _showTurnOffRahulSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TurnOffStylistSheet(
        stylistName: 'Rahul',
        onConfirm: () {
          setState(() {
            rahulAvailable = false;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(100, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {},
              child: const Text('+ Add stylist',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stylists',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Turn a stylist off when they are not in. Customers stop seeing them and their slots close automatically.',
                style:
                    TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // Priya Sharma
              _buildStylistCard(
                initial: 'P',
                name: 'Priya Sharma',
                status: 'Available · 4 bookings today',
                isAvailable: priyaAvailable,
                onToggle: (val) => setState(() => priyaAvailable = val),
              ),
              const SizedBox(height: 12),

              // Rahul Das
              _buildRahulCard(),
              const SizedBox(height: 12),

              // Neha Patel
              _buildStylistCard(
                initial: 'N',
                name: 'Neha Patel',
                status:
                    'With a walk-in till 3:20 PM ·\nopens again automatically',
                isAvailable: nehaAvailable,
                onToggle: (val) => setState(() => nehaAvailable = val),
              ),
              const SizedBox(height: 28),

              // What customers see footer
              const Text(
                'WHAT CUSTOMERS SEE',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (priyaAvailable) _buildCustomerSeeBadge('Priya'),
                  if (rahulAvailable) _buildCustomerSeeBadge('Rahul'),
                  if (nehaAvailable) _buildCustomerSeeBadge('Neha'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                rahulAvailable
                    ? 'All 3 stylists are open for booking.'
                    : "Rahul is hidden until 5:00 PM. Neha's slots reopen after 3:20 PM.",
                style: const TextStyle(
                    fontSize: 13, color: ZalonoTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSeeBadge(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZalonoTheme.border),
      ),
      child: Text(name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildStylistCard({
    required String initial,
    required String name,
    required String status,
    required bool isAvailable,
    required ValueChanged<bool> onToggle,
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
          CircleAvatar(
            radius: 20,
            backgroundColor: ZalonoTheme.primaryLight,
            child: Text(initial,
                style: const TextStyle(
                    color: ZalonoTheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(status,
                    style: const TextStyle(
                        fontSize: 13, color: ZalonoTheme.textSecondary)),
              ],
            ),
          ),
          ZalonoSwitch(
            value: isAvailable,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildRahulCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZalonoTheme.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: ZalonoTheme.primaryLight,
                child: Text('R',
                    style: TextStyle(
                        color: ZalonoTheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rahul Das',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      rahulAvailable
                          ? 'Available · 1 booking today'
                          : 'Off until 5:00 PM',
                      style: const TextStyle(
                          fontSize: 13, color: ZalonoTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              ZalonoSwitch(
                value: rahulAvailable,
                onChanged: (val) {
                  if (!val) {
                    _showTurnOffRahulSheet();
                  } else {
                    setState(() => rahulAvailable = true);
                  }
                },
              ),
            ],
          ),
          if (!rahulAvailable) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ZalonoTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1 booking needs a new stylist',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: ZalonoTheme.primaryDark)),
                        SizedBox(height: 1),
                        Text('Sneha R. · 3:00 PM · Facial',
                            style: TextStyle(
                                fontSize: 11, color: ZalonoTheme.primaryDark)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ZalonoTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Reassign',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.notifications_none,
                    size: 14, color: ZalonoTheme.primary),
                SizedBox(width: 6),
                Text(
                  'We will remind you at 5:00 PM to turn Rahul on.',
                  style:
                      TextStyle(fontSize: 11, color: ZalonoTheme.textSecondary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// A11: Turn a Stylist Off Bottom Sheet
class _TurnOffStylistSheet extends StatefulWidget {
  final String stylistName;
  final VoidCallback onConfirm;
  const _TurnOffStylistSheet(
      {required this.stylistName, required this.onConfirm});

  @override
  State<_TurnOffStylistSheet> createState() => _TurnOffStylistSheetState();
}

class _TurnOffStylistSheetState extends State<_TurnOffStylistSheet> {
  String selectedOffDuration = 'Until 5:00 PM';
  String selectedReassignTarget = 'Priya';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Turn off ${widget.stylistName}?',
            style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Customers will not see ${widget.stylistName}, and his slots close automatically.',
            style:
                const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          const Text('OFF FOR',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: ZalonoTheme.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children:
                ['Until 5:00 PM', 'Today', 'Tomorrow', 'Custom'].map((dur) {
              final active = dur == selectedOffDuration;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedOffDuration = dur),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? ZalonoTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: active
                              ? ZalonoTheme.primary
                              : ZalonoTheme.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dur,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: active ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.notifications_none,
                  size: 14, color: ZalonoTheme.primary),
              SizedBox(width: 6),
              Text('We will remind you at 5:00 PM to turn Rahul on.',
                  style: TextStyle(
                      fontSize: 12, color: ZalonoTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('1 BOOKING TO MOVE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: ZalonoTheme.textSecondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ZalonoTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ZalonoTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sneha R. · 3:00 PM · Facial',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  children: ['Move to Priya', 'Move to Neha'].map((opt) {
                    final target = opt.replaceAll('Move to ', '');
                    final active = selectedReassignTarget == target;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedReassignTarget = target),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? ZalonoTheme.primary : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: active
                                    ? ZalonoTheme.primary
                                    : ZalonoTheme.border),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            opt,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: active
                                    ? Colors.white
                                    : ZalonoTheme.textPrimary),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                const Text('The customer is told about the change.',
                    style: TextStyle(
                        fontSize: 11, color: ZalonoTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onConfirm,
            child: Text('Turn off ${widget.stylistName}'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
