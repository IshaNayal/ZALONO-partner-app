import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/file_upload_helper.dart';
import '../widgets/action_dialogs.dart';
import '../widgets/zalono_switch.dart';
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
    final appState = context.watch<SalonAppState>();

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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ZalonoTheme.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: appState.salonPhotos.isNotEmpty
                          ? Image.memory(appState.salonPhotos.first, fit: BoxFit.cover)
                          : Center(
                              child: Text(
                                appState.salonName.isNotEmpty ? appState.salonName[0] : 'S',
                                style: const TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w800, fontSize: 20),
                              ),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appState.salonName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(appState.address, style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                child: Text('Zalono Partner · pilot version 1.0', style: TextStyle(fontSize: 12, color: ZalonoTheme.textMuted)),
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
    final state = context.watch<SalonAppState>();

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
                      const SizedBox(height: 20),

                      // Title & View only Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Salon profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1E1E),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE8E3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline, size: 13, color: Color(0xFF5A5753)),
                                SizedBox(width: 4),
                                Text(
                                  'View only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5A5753),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Photos row
                      Row(
                        children: List.generate(3, (index) {
                          final photo = index < state.salonPhotos.length ? state.salonPhotos[index] : null;
                          final fallbackColors = [
                            const Color(0xFFEBC7C0),
                            const Color(0xFFE2A69D),
                            const Color(0xFFF4DDD6),
                          ];
                          final hasExtra = index == 2 && state.salonPhotos.length > 3;
                          final extraCount = state.salonPhotos.length - 3;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await FileUploadHelper.pickImageFile();
                                if (picked != null && context.mounted) {
                                  if (index < state.salonPhotos.length) {
                                    context.read<SalonAppState>().updateSalonPhoto(index, picked.bytes);
                                  } else {
                                    context.read<SalonAppState>().addSalonPhoto(picked.bytes);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Salon photo updated: ${picked.name}'),
                                      backgroundColor: ZalonoTheme.primary,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 76,
                                margin: EdgeInsets.only(right: index == 2 ? 0 : 10),
                                decoration: BoxDecoration(
                                  color: fallbackColors[index % fallbackColors.length],
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (photo != null && photo.isNotEmpty)
                                      Image.memory(
                                        photo,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                    else
                                      const Center(
                                        child: Icon(Icons.add_photo_alternate_outlined, size: 22, color: Color(0xFF8A5A53)),
                                      ),
                                    if (hasExtra)
                                      Positioned(
                                        bottom: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xA6000000),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '+$extraCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 18),

                      // Information Card
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
                            _buildViewRow('Salon name', state.salonName),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildViewRow('Category', state.salonCategory),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildViewRow('Serves', state.salonServes),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildViewRow('Address', state.address),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildViewRow('Services', '${state.salonServicesCount} services'),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildViewRow('Stylists', '${state.stylists.length} people'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Notice Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Need to change something here? Contact Zalono support and we will update it for you.',
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

                      // Contact Support Outlined Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => ActionDialogs.showSupportSheet(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ZalonoTheme.primary,
                            side: const BorderSide(color: ZalonoTheme.primary, width: 1.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Contact support',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ZalonoTheme.primary,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildViewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6864),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// M3: Owner Profile (View Only)
class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  Future<void> _pickAndSaveDocument(BuildContext context, String docName) async {
    try {
      final picked = await FileUploadHelper.pickDocumentFile();
      if (picked != null) {
        if (context.mounted) {
          context.read<SalonAppState>().setDocument(docName, picked.bytes, picked.name);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$docName uploaded: ${picked.name}'),
              backgroundColor: ZalonoTheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick document: $e'),
            backgroundColor: ZalonoTheme.primary,
          ),
        );
      }
    }
  }

  void _showDocumentSheet(BuildContext context, String docName, bool added) {
    final state = context.read<SalonAppState>();
    Uint8List? docBytes;
    String? fileName;
    if (docName.toLowerCase().contains('pan')) {
      docBytes = state.panCardBytes;
      fileName = state.panCardFileName;
    } else if (docName.toLowerCase().contains('aadhaar')) {
      docBytes = state.aadhaarBytes;
      fileName = state.aadhaarFileName;
    } else if (docName.toLowerCase().contains('business')) {
      docBytes = state.businessProofBytes;
      fileName = state.businessProofFileName;
    }
    final isAdded = added || docBytes != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                Text(docName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isAdded
                  ? (fileName != null ? 'File: $fileName' : 'Document uploaded and on file.')
                  : 'Upload a clear photo or PDF of your $docName from local storage.',
              style: const TextStyle(color: ZalonoTheme.textSecondary, fontSize: 14),
            ),
            if (docBytes != null) ...[
              const SizedBox(height: 16),
              if (fileName?.toLowerCase().endsWith('.pdf') == true)
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8EC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF0BDC6)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: ZalonoTheme.primary, size: 48),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          fileName ?? 'PDF Document',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E1E1E), fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    docBytes,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _pickAndSaveDocument(context, docName);
                },
                icon: const Icon(Icons.upload_file, size: 20),
                label: Text(isAdded ? 'Replace Photo from Storage' : 'Upload Photo from Storage'),
              ),
            ),
            if (isAdded) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<SalonAppState>().removeDocument(docName);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$docName removed')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ZalonoTheme.primary,
                    side: const BorderSide(color: ZalonoTheme.primary),
                  ),
                  child: const Text('Remove Document'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SalonAppState>();

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
                      const SizedBox(height: 20),

                      // Title & View only Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Owner profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1E1E),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEBE6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline, size: 13, color: Color(0xFF5A5753)),
                                SizedBox(width: 4),
                                Text(
                                  'View only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5A5753),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Personal Information Card
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
                            _buildInfoRow('Full name', state.ownerName),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildInfoRow('Mobile (login)', state.ownerPhone),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildInfoRow('Email', state.ownerEmail),
                          ],
                        ),
                      ),

                      // Documents Section Header
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 10),
                        child: Text(
                          'DOCUMENTS',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B6864),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      // Documents Card
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
                            _buildDocRow(
                              context,
                              'PAN card',
                              state.panCardAdded,
                              onTap: () => _showDocumentSheet(context, 'PAN card', state.panCardAdded),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildDocRow(
                              context,
                              'Aadhaar card',
                              state.aadhaarAdded,
                              onTap: () => _showDocumentSheet(context, 'Aadhaar card', state.aadhaarAdded),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            _buildDocRow(
                              context,
                              'Business proof',
                              state.businessProofAdded,
                              onTap: () => _showDocumentSheet(context, 'Business proof', state.businessProofAdded),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF3ECE5)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'GST number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B6864),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    state.gstNumber.isNotEmpty ? state.gstNumber : '',
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
                        ),
                      ),

                      // Notice Box
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Documents are optional. To add or change anything here, contact Zalono support.',
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

                      // Contact Support Outlined Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => ActionDialogs.showSupportSheet(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ZalonoTheme.primary,
                            side: const BorderSide(color: ZalonoTheme.primary, width: 1.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Contact support',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ZalonoTheme.primary,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B6864),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRow(BuildContext context, String label, bool isAdded, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6864),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isAdded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ZalonoTheme.primary, width: 1.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 13, color: ZalonoTheme.primary),
                    SizedBox(width: 4),
                    Text(
                      'Added',
                      style: TextStyle(
                        color: ZalonoTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8E3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Not added',
                  style: TextStyle(
                    color: Color(0xFF5A5753),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
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
  void _addNewTimingDialog(int dayIndex, String dayName, SalonAppState state) async {
    final start = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      helpText: 'Select Start Time for $dayName',
    );
    if (!mounted || start == null) return;

    final end = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
      helpText: 'Select End Time for $dayName',
    );
    if (!mounted || end == null) return;

    final startStr = start.format(context);
    final endStr = end.format(context);
    state.addTimingSlot(dayIndex, startStr, endStr);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $startStr – $endStr to $dayName.'),
        backgroundColor: ZalonoTheme.primary,
      ),
    );
  }

  void _editSlotDialog(int dayIndex, int slotIndex, TimeSlot slot, SalonAppState state) async {
    final start = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      helpText: 'Edit Start Time',
    );
    if (!mounted || start == null) return;

    final end = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
      helpText: 'Edit End Time',
    );
    if (!mounted || end == null) return;

    final startStr = start.format(context);
    final endStr = end.format(context);
    state.updateTimingSlot(dayIndex, slotIndex, startStr, endStr);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SalonAppState>();

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Spec Header: MORE | M4 · Timings
            Container(
              width: double.infinity,
              color: const Color(0xFFEFE7E3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MORE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B6864),
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    'M4 · Timings',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B6864),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content with floating gradient bottom controls
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rounded White Square Back Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  size: 24,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Heading
                          const Text(
                            'Timings',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E1E1E),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6864),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Enclosing Card for All Days
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            child: Column(
                              children: [
                                for (int dayIdx = 0; dayIdx < state.salonTimings.length; dayIdx++) ...[
                                  if (dayIdx > 0)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFFF3ECE5),
                                      ),
                                    ),
                                  _buildTimingGroup(
                                    context,
                                    dayIdx,
                                    state.salonTimings[dayIdx].dayName,
                                    state.salonTimings[dayIdx].slots,
                                    state,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Bottom Action Bar with Gradient Fade
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ZalonoTheme.background.withValues(alpha: 0.0),
                            ZalonoTheme.background.withValues(alpha: 0.85),
                            ZalonoTheme.background,
                          ],
                          stops: const [0.0, 0.28, 0.55],
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                state.copyMondayTimingsToAll();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Monday's timings copied to all days!"),
                                    backgroundColor: ZalonoTheme.primary,
                                  ),
                                );
                              },
                              child: const Text(
                                "Copy Monday's timings to all days",
                                style: TextStyle(
                                  color: ZalonoTheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Timings saved successfully!'),
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
                                  'Save changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingGroup(
    BuildContext context,
    int dayIdx,
    String day,
    List<dynamic> slots,
    SalonAppState state,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(slots.length, (slotIdx) {
                final slot = slots[slotIdx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _editSlotDialog(dayIdx, slotIdx, slot, state),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                            ),
                            child: Text(
                              '${slot.start} – ${slot.end}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: slot.isEnabled
                                    ? const Color(0xFF1E1E1E)
                                    : const Color(0xFF9E9B97),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ZalonoSwitch(
                        value: slot.isEnabled,
                        onChanged: (v) {
                          state.toggleTimingSlot(dayIdx, slotIdx, v);
                        },
                      ),
                    ],
                  ),
                );
              }),
              GestureDetector(
                onTap: () => _addNewTimingDialog(dayIdx, day, state),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '+ Add timing',
                    style: TextStyle(
                      color: ZalonoTheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: ZalonoTheme.primaryLight,
                      child: Text('R', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      onPressed: () => ActionDialogs.showCallSheet(
                        context,
                        name: 'Rahul K. (Executive)',
                        phone: '+91 98000 12345',
                        subtitle: 'Dedicated Partner Manager',
                      ),
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
                      onTap: () => ActionDialogs.showCallSheet(
                        context,
                        name: 'Zalono Support Desk',
                        phone: '1800 200 4821',
                        subtitle: 'Toll-free 24/7 Helpline',
                      ),
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    ListTile(
                      leading: const Icon(Icons.mail_outline, color: ZalonoTheme.primary),
                      title: const Text('Email support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: 'support@zalono.com'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email support@zalono.com copied to clipboard!')),
                        );
                      },
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
                    _buildFaqItem(context, 'How do I check in a customer?'),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    _buildFaqItem(context, 'A customer did not show up'),
                    const Divider(height: 1, indent: 56, endIndent: 16, color: ZalonoTheme.border),
                    _buildFaqItem(context, 'Change my salon details'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: ZalonoTheme.primaryLight, shape: BoxShape.circle),
        child: const Icon(Icons.help_outline, color: ZalonoTheme.primary, size: 16),
      ),
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: ZalonoTheme.textSecondary),
      onTap: () => ActionDialogs.showFaqAnswer(context, question),
    );
  }
}
