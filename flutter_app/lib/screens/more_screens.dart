import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'stylists_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  void _openSalonProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SalonProfileScreen()));
  }

  void _openOwnerProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerProfileScreen()));
  }

  void _openTimings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const TimingsScreen()));
  }

  void _openSupport() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()));
  }

  void _showLogoutDialog() {
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
            const Text(
              'Log out of Glow Studio?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will not get booking alerts on this phone until you log in again.',
              style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary, height: 1.35),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Log out'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Stay logged in'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'More',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
              ),
              const SizedBox(height: 20),

              // Salon Card with Verified badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ZalonoTheme.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: ZalonoTheme.primaryLight,
                      child: const Text('G', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w800, fontSize: 20)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Glow Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          SizedBox(height: 2),
                          Text('Saheed Nagar,\nBhubaneswar', style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(12)),
                      child: const Text('✓ Verified', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Navigation Links
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ZalonoTheme.border),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.storefront_outlined, 'Salon profile', _openSalonProfile),
                    _buildDivider(),
                    _buildMenuItem(Icons.person_outline, 'Owner profile', _openOwnerProfile),
                    _buildDivider(),
                    _buildMenuItem(Icons.groups_outlined, 'Stylists', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const StylistsScreen()));
                    }),
                    _buildDivider(),
                    _buildMenuItem(Icons.schedule_outlined, 'Timings', _openTimings),
                    _buildDivider(),
                    _buildMenuItem(Icons.headset_mic_outlined, 'Support', _openSupport),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Log out button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ZalonoTheme.border),
                ),
                child: ListTile(
                  onTap: _showLogoutDialog,
                  leading: const Icon(Icons.logout, color: ZalonoTheme.primary),
                  title: const Text('Log out', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 32),

              const Center(
                child: Text('Zalono Partner · pilot version', style: TextStyle(fontSize: 12, color: ZalonoTheme.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: ZalonoTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border);
}

// M2: Salon Profile (View Only)
class SalonProfileScreen extends StatelessWidget {
  const SalonProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: ZalonoTheme.surfaceMuted, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: const [
                Icon(Icons.lock_outline, size: 14, color: ZalonoTheme.textSecondary),
                SizedBox(width: 4),
                Text('View only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.textSecondary)),
              ],
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
              const Text('Salon profile', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              // Photos row
              Row(
                children: List.generate(3, (idx) => Expanded(
                  child: Container(
                    height: 70,
                    margin: EdgeInsets.only(right: idx < 2 ? 10 : 0),
                    decoration: BoxDecoration(color: const Color(0xFFE9B5B8), borderRadius: BorderRadius.circular(14)),
                  ),
                )),
              ),
              const SizedBox(height: 24),
              _buildViewRow('Salon name', 'Glow Studio'),
              _buildViewRow('Category', 'Premium'),
              _buildViewRow('Serves', 'Unisex, Kids salon'),
              _buildViewRow('Address', 'Plot No. 123, Saheed Nagar, Near Big Bazaar, Bhubaneswar 751007'),
              _buildViewRow('Services', '4 services'),
              _buildViewRow('Stylists', '3 people'),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'Need to change something here? Contact Zalono support and we will update it for you.',
                  style: TextStyle(fontSize: 13, color: ZalonoTheme.primaryDark, height: 1.35),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(onPressed: () {}, child: const Text('Contact support')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ZalonoTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

// M3: Owner Profile (View Only)
class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: ZalonoTheme.surfaceMuted, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: const [
                Icon(Icons.lock_outline, size: 14, color: ZalonoTheme.textSecondary),
                SizedBox(width: 4),
                Text('View only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.textSecondary)),
              ],
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
              const Text('Owner profile', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              _buildOwnerRow('Full name', 'Rohan Mehta'),
              _buildOwnerRow('Mobile (login)', '+91 98765 43210'),
              _buildOwnerRow('Email', 'rohan@glowstudio.in'),
              const SizedBox(height: 20),

              const Text('DOCUMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
              const SizedBox(height: 8),
              _buildDocStatus('PAN card', '✓ Added', true),
              _buildDocStatus('Aadhaar card', 'Not added', false),
              _buildDocStatus('Business proof', 'Not added', false),
              _buildDocStatus('GST number', '22ABCDE1234F1Z5', false, isGst: true),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'Documents are optional. To add or change anything here, contact Zalono support.',
                  style: TextStyle(fontSize: 13, color: ZalonoTheme.primaryDark, height: 1.35),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(onPressed: () {}, child: const Text('Contact support')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ZalonoTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildDocStatus(String label, String status, bool added, {bool isGst = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ZalonoTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
          if (isGst)
            Text(status, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))
          else if (added)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(border: Border.all(color: ZalonoTheme.primary), borderRadius: BorderRadius.circular(12)),
              child: Text(status, style: const TextStyle(color: ZalonoTheme.primary, fontSize: 11, fontWeight: FontWeight.w700)),
            )
          else
            Text(status, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// M4: Timings Screen
class TimingsScreen extends StatefulWidget {
  const TimingsScreen({super.key});

  @override
  State<TimingsScreen> createState() => _TimingsScreenState();
}

class _TimingsScreenState extends State<TimingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Timings', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.',
                style: TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              _buildTimingGroup('Mon', ['10:00 AM – 2:00 PM', '4:00 PM – 10:00 PM']),
              _buildTimingGroup('Tue', ['10:00 AM – 10:00 PM']),
              _buildTimingGroup('Wed', ['10:00 AM – 10:00 PM']),
              _buildTimingGroup('Thu', ['10:00 AM – 10:00 PM']),
              _buildTimingGroup('Fri', ['10:00 AM – 10:00 PM']),
              _buildTimingGroup('Sat', ['10:00 AM – 10:00 PM']),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Copy Monday's timings to all days", style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimingGroup(String day, List<String> slots) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 44, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...slots.map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: ZalonoTheme.border)),
                          child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(value: true, activeColor: ZalonoTheme.primary, onChanged: (v) {}),
                    ],
                  ),
                )),
                const Text('+ Add timing', style: TextStyle(color: ZalonoTheme.primary, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// M5: Support Screen
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Support', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),

              // Executive Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: ZalonoTheme.border)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: ZalonoTheme.primaryLight,
                      child: const Text('R', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('YOUR ZALONO EXECUTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
                          SizedBox(height: 2),
                          Text('Rahul K.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 38),
                        backgroundColor: ZalonoTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('Call', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Direct options
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: ZalonoTheme.border)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.call_outlined, color: ZalonoTheme.primary),
                      title: const Text('Call Zalono support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    ListTile(
                      leading: const Icon(Icons.mail_outline, color: ZalonoTheme.primary),
                      title: const Text('Email support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('COMMON QUESTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: ZalonoTheme.border)),
                child: Column(
                  children: [
                    _buildFaqItem('How do I check in a customer?'),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    _buildFaqItem('A customer did not show up'),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    _buildFaqItem('Change my salon details'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: ZalonoTheme.primaryLight, shape: BoxShape.circle),
        child: const Icon(Icons.help_outline, color: ZalonoTheme.primary, size: 16),
      ),
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
      onTap: () {},
    );
  }
}
