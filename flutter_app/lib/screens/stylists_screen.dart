import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/zalono_switch.dart';

class StylistsScreen extends StatefulWidget {
  const StylistsScreen({super.key});

  @override
  State<StylistsScreen> createState() => _StylistsScreenState();
}

class _StylistsScreenState extends State<StylistsScreen> {
  void _showTurnOffStylistSheet(
      BuildContext context, SalonAppState appState, StylistItem stylist) {
    final otherStylists = appState.stylists
        .where((s) => s.id != stylist.id)
        .map((s) => s.name.split(' ').first)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TurnOffStylistSheet(
        stylistName: stylist.name.split(' ').first,
        otherStylists: otherStylists,
        onConfirmWithDetails: (duration, target) {
          appState.turnOffStylist(stylist.name, duration, target);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showAddStylistSheet(BuildContext context, SalonAppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddStylistSheet(
        onAdd: (name, role, services) {
          appState.addStylist(
            name: name,
            role: role,
            services: services,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name added to stylists'),
              backgroundColor: ZalonoTheme.textPrimary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteStylist(
      BuildContext context, SalonAppState appState, StylistItem stylist) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete ${stylist.name}?',
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: ZalonoTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to remove ${stylist.name} from your stylists? Customers will no longer be able to book with this stylist.',
          style: const TextStyle(
              fontSize: 14, color: ZalonoTheme.textSecondary, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    side: const BorderSide(color: ZalonoTheme.border),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: ZalonoTheme.textSecondary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZalonoTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                  ),
                  onPressed: () {
                    appState.removeStylist(stylist.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${stylist.name} removed from stylists'),
                        backgroundColor: ZalonoTheme.textPrimary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCustomerSummaryText(SalonAppState appState) {
    final available = appState.stylists.where((s) => s.isAvailable).toList();
    final total = appState.stylists.length;
    final rahul = appState.stylists.firstWhere(
      (s) => s.name.contains('Rahul'),
      orElse: () => StylistItem(
          id: '', name: '', role: '', services: [], isAvailable: false),
    );

    if (available.length == total) {
      return 'All $total stylists are open for booking.';
    }
    if (rahul.id.isNotEmpty && !rahul.isAvailable) {
      return "Rahul is hidden until 5:00 PM. Neha's slots reopen after 3:20 PM.";
    }
    return '${available.length} of $total stylists are open for booking.';
  }

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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(100, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () => _showAddStylistSheet(context, appState),
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
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    color: ZalonoTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Turn a stylist off when they are not in. Customers stop seeing them and their slots close automatically.',
                style:
                    TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // Dynamic list of stylists from appState
              ...appState.stylists.map((st) {
                if (st.name.contains('Rahul')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildRahulCard(st, appState),
                  );
                }
                final isCustom =
                    !['stylist_1', 'stylist_2', 'stylist_3'].contains(st.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildStylistCard(
                    initial: st.initials.isNotEmpty
                        ? st.initials.toUpperCase()
                        : 'S',
                    name: st.name,
                    status: st.statusDetail ??
                        (st.isAvailable
                            ? 'Available · ${st.role}'
                            : 'Turned off'),
                    isAvailable: st.isAvailable,
                    onToggle: (val) {
                      if (!val) {
                        _showTurnOffStylistSheet(context, appState, st);
                      } else {
                        appState.turnOnStylist(st.name);
                      }
                    },
                    onLongPressName: () =>
                        _confirmDeleteStylist(context, appState, st),
                    onDelete: isCustom
                        ? () => _confirmDeleteStylist(context, appState, st)
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 16),

              // What customers see footer
              const Text(
                'WHAT CUSTOMERS SEE',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: appState.stylists
                    .where((s) => s.isAvailable)
                    .map((s) => _buildCustomerSeeBadge(s.name.split(' ').first))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Text(
                _getCustomerSummaryText(appState),
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
    VoidCallback? onLongPressName,
    VoidCallback? onDelete,
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
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onLongPress: onLongPressName,
                        behavior: HitTestBehavior.opaque,
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    if (onDelete != null)
                      GestureDetector(
                        onTap: onDelete,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.delete_outline,
                              size: 20, color: ZalonoTheme.textMuted),
                        ),
                      ),
                  ],
                ),
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

  Widget _buildRahulCard(StylistItem rahul, SalonAppState appState) {
    final isAvailable = rahul.isAvailable;
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
                    GestureDetector(
                      onLongPress: () =>
                          _confirmDeleteStylist(context, appState, rahul),
                      behavior: HitTestBehavior.opaque,
                      child: const Text('Rahul Das',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAvailable
                          ? 'Available · 1 booking today'
                          : (rahul.statusDetail ?? 'Off until 5:00 PM'),
                      style: const TextStyle(
                          fontSize: 13, color: ZalonoTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              ZalonoSwitch(
                value: isAvailable,
                onChanged: (val) {
                  if (!val) {
                    _showTurnOffStylistSheet(context, appState, rahul);
                  } else {
                    appState.turnOnStylist(rahul.name);
                  }
                },
              ),
            ],
          ),
          if (!isAvailable) ...[
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
                Expanded(
                  child: Text(
                    'We will remind you at 5:00 PM to turn Rahul on.',
                    style:
                        TextStyle(fontSize: 11, color: ZalonoTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Add Stylist Bottom Sheet
class _AddStylistSheet extends StatefulWidget {
  final Function(String name, String role, List<String> services) onAdd;
  const _AddStylistSheet({required this.onAdd});

  @override
  State<_AddStylistSheet> createState() => _AddStylistSheetState();
}

class _AddStylistSheetState extends State<_AddStylistSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String? _nameError;

  final List<String> _popularRoles = [
    'Hair specialist',
    'Skin specialist',
    'Nail artist',
    'Senior Barber',
    'Makeup artist',
  ];

  final Set<String> _selectedServices = {
    'Haircut (Men)',
    'Haircut (Women)',
  };

  final List<String> _serviceOptions = [
    'Haircut (Men)',
    'Haircut (Women)',
    'Beard trim',
    'Hair colour',
    'Facial',
    'Head massage',
    'Clean-up',
    'Manicure',
    'Pedicure',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter stylist name';
      });
      return;
    }
    final role = _roleController.text.trim().isEmpty
        ? 'Hair specialist'
        : _roleController.text.trim();
    final services = _selectedServices.isEmpty
        ? ['Haircut (Men)', 'Haircut (Women)']
        : _selectedServices.toList();

    widget.onAdd(name, role, services);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ZalonoTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Stylist',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    color: ZalonoTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: ZalonoTheme.textSecondary, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Add a team member to manage their schedule and take bookings.',
              style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
            ),
            const SizedBox(height: 20),

            // Name
            const Text(
              'FULL NAME *',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Deepak Kumar',
                hintStyle:
                    const TextStyle(color: ZalonoTheme.textMuted, fontSize: 14),
                errorText: _nameError,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: ZalonoTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: ZalonoTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: ZalonoTheme.primary, width: 1.5),
                ),
              ),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 16),

            // Role
            const Text(
              'ROLE / SPECIALTY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _roleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'e.g. Hair specialist, Nail artist',
                hintStyle:
                    const TextStyle(color: ZalonoTheme.textMuted, fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: ZalonoTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: ZalonoTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: ZalonoTheme.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _popularRoles.map((role) {
                  final isSelected = _roleController.text == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(role,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : ZalonoTheme.textPrimary,
                          )),
                      selected: isSelected,
                      selectedColor: ZalonoTheme.primary,
                      backgroundColor: ZalonoTheme.surfaceMuted,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      side: BorderSide.none,
                      onSelected: (selected) {
                        setState(() {
                          _roleController.text = selected ? role : '';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Services
            const Text(
              'SERVICES OFFERED',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: ZalonoTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _serviceOptions.map((svc) {
                final isSelected = _selectedServices.contains(svc);
                return FilterChip(
                  label: Text(svc,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            isSelected ? Colors.white : ZalonoTheme.textPrimary,
                      )),
                  selected: isSelected,
                  selectedColor: ZalonoTheme.primary,
                  backgroundColor: ZalonoTheme.background,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color:
                          isSelected ? ZalonoTheme.primary : ZalonoTheme.border,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedServices.add(svc);
                      } else {
                        _selectedServices.remove(svc);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ZalonoTheme.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: _submit,
              child: const Text(
                'Add Stylist',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel',
                    style: TextStyle(color: ZalonoTheme.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A11: Turn a Stylist Off Bottom Sheet
class _TurnOffStylistSheet extends StatefulWidget {
  final String stylistName;
  final List<String> otherStylists;
  final Function(String duration, String target) onConfirmWithDetails;
  const _TurnOffStylistSheet({
    required this.stylistName,
    required this.otherStylists,
    required this.onConfirmWithDetails,
  });

  @override
  State<_TurnOffStylistSheet> createState() => _TurnOffStylistSheetState();
}

class _TurnOffStylistSheetState extends State<_TurnOffStylistSheet> {
  String selectedOffDuration = 'Until 5:00 PM';
  late String selectedReassignTarget;

  @override
  void initState() {
    super.initState();
    selectedReassignTarget =
        widget.otherStylists.isNotEmpty ? widget.otherStylists.first : '';
  }

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
            'Customers will not see ${widget.stylistName}, and their slots close automatically.',
            style:
                const TextStyle(fontSize: 14, color: ZalonoTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          const Text('OFF  FOR',
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
          Row(
            children: [
              const Icon(Icons.notifications_none,
                  size: 14, color: ZalonoTheme.primary),
              const SizedBox(width: 6),
              Text(
                'We will remind you at 5:00 PM to turn ${widget.stylistName} on.',
                style: const TextStyle(
                    fontSize: 12, color: ZalonoTheme.textSecondary),
              ),
            ],
          ),
          if (widget.otherStylists.isNotEmpty) ...[
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
                  
                  const SizedBox(height: 10),
                  Row(
                    children: widget.otherStylists.map((target) {
                      final active = selectedReassignTarget == target;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => selectedReassignTarget = target),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  active ? ZalonoTheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: active
                                      ? ZalonoTheme.primary
                                      : ZalonoTheme.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Move to $target',
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
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.onConfirmWithDetails(
                  selectedOffDuration, selectedReassignTarget);
            },
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
