import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/file_upload_helper.dart';
import '../widgets/action_dialogs.dart';
import '../widgets/zalono_switch.dart';

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({super.key});

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  int _currentStep = 1; // 1 to 9 (R2 to R11), and 10 is R12 Submitted
  bool _isVerifyingEmail = false; // Sub-step on Step 3 for R5 Verify email

  // Step 1: Mobile & OTP
  late TextEditingController _phoneController;
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  bool _isNumberVerified = false;

  // Step 2: Onboarding Code
  late TextEditingController _onboardingCodeController;
  bool codeVerified = true;

  // Step 3: Owner & Email
  late TextEditingController _ownerNameController;
  late TextEditingController _emailController;
  late TextEditingController _gstController;
  bool emailVerified = false;

  bool panAdded = true;
  bool aadhaarAdded = false;
  bool businessProofAdded = false;
  Uint8List? panBytes;
  String? panFileName;
  Uint8List? aadhaarBytes;
  String? aadhaarFileName;
  Uint8List? businessProofBytes;
  String? businessProofFileName;
  List<Uint8List> salonPhotoBytes = [];

  // Step 4: Salon Details
  late TextEditingController _salonNameController;
  String salonCategory = 'Premium'; // Basic, Medium, Premium, Ultra premium
  List<String> salonServes = ['Unisex', 'Other'];
  late TextEditingController _customCategoryController;

  // Step 5: Location
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;

  // Step 6: Services
  String selectedServiceCategory = 'Hair';
  final List<Map<String, dynamic>> services = [
    {'name': 'Haircut (Men)', 'time': '30 min', 'price': '₹399', 'checked': true},
    {'name': 'Haircut (Women)', 'time': '45 min', 'price': '₹699', 'checked': true},
    {'name': 'Beard trim', 'time': '15 min', 'price': '₹149', 'checked': true},
    {'name': 'Hair colour', 'time': '90 min', 'price': '₹2,499', 'checked': true},
    {'name': 'Hair spa', 'time': '60 min', 'price': '₹1,999', 'checked': false},
  ];

  // Step 7: Stylists
  final List<Map<String, String>> stylists = [
    {'initial': 'P', 'name': 'Priya Sharma', 'role': 'Hair specialist', 'services': 'Haircut, Hair colour, Beard trim'},
    {'initial': 'R', 'name': 'Rahul Das', 'role': 'Skin specialist', 'services': 'Facial, Clean-up'},
    {'initial': 'N', 'name': 'Neha Patel', 'role': 'Nail artist', 'services': 'Manicure, Pedicure'},
  ];

  // Step 8: Timings
  Map<String, List<Map<String, dynamic>>> dayTimings = {
    'Mon': [
      {'slot': '10:00 AM – 2:00 PM', 'on': true},
      {'slot': '4:00 PM – 10:00 PM', 'on': true},
    ],
    'Tue': [{'slot': '10:00 AM – 10:00 PM', 'on': true}],
    'Wed': [{'slot': '10:00 AM – 10:00 PM', 'on': true}],
    'Thu': [{'slot': '10:00 AM – 10:00 PM', 'on': true}],
    'Fri': [{'slot': '10:00 AM – 10:00 PM', 'on': true}],
  };

  // Step 9: Agreement
  bool agreeTerms = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '98765 43210');
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _otpFocusNodes = List.generate(6, (_) => FocusNode());

    _onboardingCodeController = TextEditingController(text: 'ZL-4821');

    _ownerNameController = TextEditingController(text: 'Rohan Mehta');
    _emailController = TextEditingController(text: 'rohan@glowstudio.in');
    _gstController = TextEditingController(text: '22ABCDE1234F1Z5');

    _salonNameController = TextEditingController(text: 'Glow Studio');
    _customCategoryController = TextEditingController(text: 'Kids salon');

    _addressController = TextEditingController(text: 'Plot No. 123, Saheed Nagar, Near Big Bazaar, Bhubaneswar');
    _pincodeController = TextEditingController(text: '751007');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _onboardingCodeController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _salonNameController.dispose();
    _customCategoryController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _checkOtpVerification() {
    final code = _otpControllers.map((c) => c.text).join();
    setState(() {
      _isNumberVerified = (code == '123456');
    });
  }

  void _useCurrentLocation() {
    setState(() {
      _addressController.text = 'Plot No. 45, DLF Cybercity, Patia, Bhubaneswar, Odisha';
      _pincodeController.text = '751024';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Current GPS location detected and filled.'),
        backgroundColor: ZalonoTheme.primary,
      ),
    );
  }

  void _addNewServiceDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '499');
    final timeCtrl = TextEditingController(text: '30 min');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service in Hair', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Service Name', hintText: 'e.g. Hair Wash & Blow dry')),
            const SizedBox(height: 10),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price', prefixText: '₹')),
            const SizedBox(height: 10),
            TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Duration', hintText: 'e.g. 30 min')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  services.add({
                    'name': nameCtrl.text.trim(),
                    'time': timeCtrl.text.trim().isEmpty ? '30 min' : timeCtrl.text.trim(),
                    'price': '₹${priceCtrl.text.trim()}',
                    'checked': true,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added ${nameCtrl.text.trim()} to services!'), backgroundColor: ZalonoTheme.primary),
                );
              }
            },
            child: const Text('Add Service'),
          ),
        ],
      ),
    );
  }

  void _addNewStylistDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController(text: 'Stylist');
    final svcCtrl = TextEditingController(text: 'Haircut, Hair colour');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Stylist', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', hintText: 'e.g. Deepak Kumar')),
            const SizedBox(height: 10),
            TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Role', hintText: 'e.g. Hair specialist')),
            const SizedBox(height: 10),
            TextField(controller: svcCtrl, decoration: const InputDecoration(labelText: 'Services', hintText: 'e.g. Haircut, Beard trim')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                final name = nameCtrl.text.trim();
                setState(() {
                  stylists.add({
                    'initial': name[0].toUpperCase(),
                    'name': name,
                    'role': roleCtrl.text.trim(),
                    'services': svcCtrl.text.trim(),
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name added to salon stylists!'), backgroundColor: ZalonoTheme.primary),
                );
              }
            },
            child: const Text('Add Stylist'),
          ),
        ],
      ),
    );
  }

  void _addNewTimingSlot(String day) async {
    final start = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
    if (!mounted || start == null) return;

    final end = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 18, minute: 0));
    if (!mounted || end == null) return;

    final startStr = start.format(context);
    final endStr = end.format(context);

    setState(() {
      dayTimings[day]?.add({'slot': '$startStr – $endStr', 'on': true});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added timing $startStr – $endStr to $day!'), backgroundColor: ZalonoTheme.primary),
    );
  }

  void _copyMondayTimings() {
    final monSlots = dayTimings['Mon'];
    if (monSlots != null) {
      setState(() {
        for (var day in ['Tue', 'Wed', 'Thu', 'Fri']) {
          dayTimings[day] = monSlots.map((s) => Map<String, dynamic>.from(s)).toList();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Monday's timings copied to all days!"), backgroundColor: ZalonoTheme.primary),
      );
    }
  }

  Future<void> _pickSalonPhoto({int? index}) async {
    try {
      final picked = await FileUploadHelper.pickImageFile();
      if (picked != null) {
        setState(() {
          if (index != null && index < salonPhotoBytes.length) {
            salonPhotoBytes[index] = picked.bytes;
          } else {
            salonPhotoBytes.add(picked.bytes);
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salon photo uploaded: ${picked.name}'),
              backgroundColor: ZalonoTheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickDocument(String title) async {
    try {
      final picked = await FileUploadHelper.pickDocumentFile();
      if (picked != null) {
        setState(() {
          if (title.contains('PAN')) {
            panAdded = true;
            panBytes = picked.bytes;
            panFileName = picked.name;
          } else if (title.contains('Aadhaar')) {
            aadhaarAdded = true;
            aadhaarBytes = picked.bytes;
            aadhaarFileName = picked.name;
          } else if (title.contains('Business')) {
            businessProofAdded = true;
            businessProofBytes = picked.bytes;
            businessProofFileName = picked.name;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title uploaded: ${picked.name}'),
              backgroundColor: ZalonoTheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep == 1 && !_isNumberVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code 123456 to verify.'),
          backgroundColor: ZalonoTheme.primary,
        ),
      );
      return;
    }

    if (_currentStep == 3) {
      if (!_isVerifyingEmail && !emailVerified) {
        // Go to R5 Verify email
        setState(() => _isVerifyingEmail = true);
        return;
      }
      if (_isVerifyingEmail) {
        setState(() {
          emailVerified = true;
          _isVerifyingEmail = false;
          _currentStep = 4;
        });
        return;
      }
    }

    if (_currentStep < 10) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_isVerifyingEmail) {
      setState(() => _isVerifyingEmail = false);
      return;
    }
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == 10) {
      return _buildR12Submitted();
    }

    final isContinueDisabled = (_currentStep == 1 && !_isNumberVerified) ||
        (_currentStep == 9 && !agreeTerms);

    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _prevStep,
        ),
        title: Text(
          'STEP $_currentStep OF 9',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: ZalonoTheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: List.generate(9, (index) {
                final active = index < _currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: active ? ZalonoTheme.primary : const Color(0xFFE8DFD8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: _buildStepContent(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isContinueDisabled ? null : _nextStep,
                child: Text(_currentStep == 9 ? 'Submit for review' : 'Continue'),
              ),
              if (_currentStep == 7) ...[
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: _nextStep,
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildR2VerifyMobile();
      case 2:
        return _buildR3OnboardingCode();
      case 3:
        return _isVerifyingEmail ? _buildR5VerifyEmail() : _buildR4AboutOwner();
      case 4:
        return _buildR6SalonDetails();
      case 5:
        return _buildR7Location();
      case 6:
        return _buildR8Services();
      case 7:
        return _buildR9WhoWorksHere();
      case 8:
        return _buildR10Timings();
      case 9:
        return _buildR11ReviewAndAgree();
      default:
        return const SizedBox();
    }
  }

  // R2 · Verify mobile (Step 1 of 9)
  Widget _buildR2VerifyMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your mobile number',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ZalonoTheme.textPrimary, height: 1.2),
        ),
        const SizedBox(height: 8),
        const Text(
          "We send a code to your phone. This number becomes your salon's login.",
          style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        const Text('MOBILE NUMBER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ZalonoTheme.border),
          ),
          child: Row(
            children: [
              const Text('+91', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              Container(width: 1, height: 24, color: ZalonoTheme.border),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Enter mobile number',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const Icon(Icons.edit_outlined, size: 18, color: ZalonoTheme.primary),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('ENTER THE 6-DIGIT CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final isFocused = _otpFocusNodes[index].hasFocus;
            final hasVal = _otpControllers[index].text.isNotEmpty;
            return Container(
              width: 46,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFocused
                      ? ZalonoTheme.primary
                      : (hasVal ? ZalonoTheme.textPrimary : ZalonoTheme.border),
                  width: isFocused ? 1.8 : 1,
                ),
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < 5) {
                    _otpFocusNodes[index + 1].requestFocus();
                  }
                  _checkOtpVerification();
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        if (_isNumberVerified) ...[
          const Row(
            children: [
              Icon(Icons.check, size: 16, color: ZalonoTheme.primary),
              SizedBox(width: 6),
              Text('Number verified', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'Next you will enter an onboarding code from your Zalono executive. Registration stays locked without it.',
              style: TextStyle(color: ZalonoTheme.primaryDark, fontSize: 13, height: 1.4),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enter dummy code 123456 by hand',
                  style: TextStyle(color: ZalonoTheme.textSecondary, fontSize: 13),
                ),
                GestureDetector(
                  onTap: () {
                    for (int i = 0; i < 6; i++) {
                      _otpControllers[i].text = '${i + 1}';
                    }
                    _checkOtpVerification();
                  },
                  child: const Text(
                    'Auto-fill 123456',
                    style: TextStyle(color: ZalonoTheme.primary, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // R3 · Onboarding code (Step 2 of 9)
  Widget _buildR3OnboardingCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your onboarding\ncode',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ZalonoTheme.textPrimary, height: 1.2),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your Zalono executive gives you this code. Only salons with a code can register.',
          style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        const Text('ONBOARDING CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ZalonoTheme.primary, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _onboardingCodeController,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                ),
              ),
              const CircleAvatar(
                radius: 12,
                backgroundColor: ZalonoTheme.primary,
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.check, size: 16, color: ZalonoTheme.primary),
            SizedBox(width: 6),
            Text('Code verified · registration unlocked', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => ActionDialogs.showSupportSheet(context),
          child: const Text(
            'No code yet? Ask your Zalono executive or contact support.',
            style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
          ),
        ),
      ],
    );
  }

  // R4 · About the owner (Step 3 of 9)
  Widget _buildR4AboutOwner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About the owner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 24),
        const Text('FULL NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _ownerNameController,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
        const SizedBox(height: 16),
        const Text('EMAIL ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isVerifyingEmail = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: emailVerified ? ZalonoTheme.primaryLight : ZalonoTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    emailVerified ? '✓ Verified' : 'Verify',
                    style: TextStyle(
                      color: emailVerified ? ZalonoTheme.primary : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DOCUMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
            Text('All optional', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ZalonoTheme.primary)),
          ],
        ),
        const SizedBox(height: 10),
        _buildDocCard(
          title: 'PAN card',
          added: panAdded,
          fileBytes: panBytes,
          fileName: panFileName,
          onUpload: () => _pickDocument('PAN card'),
          onPreview: () => _showDocPreviewSheet(
            'PAN card',
            panBytes,
            panFileName,
            () => _pickDocument('PAN card'),
            () => setState(() {
              panAdded = false;
              panBytes = null;
              panFileName = null;
            }),
          ),
        ),
        _buildDocCard(
          title: 'Aadhaar card',
          added: aadhaarAdded,
          fileBytes: aadhaarBytes,
          fileName: aadhaarFileName,
          onUpload: () => _pickDocument('Aadhaar card'),
          onPreview: () => _showDocPreviewSheet(
            'Aadhaar card',
            aadhaarBytes,
            aadhaarFileName,
            () => _pickDocument('Aadhaar card'),
            () => setState(() {
              aadhaarAdded = false;
              aadhaarBytes = null;
              aadhaarFileName = null;
            }),
          ),
        ),
        _buildDocCard(
          title: 'Business proof',
          subtitle: 'Shop licence or Udyam',
          added: businessProofAdded,
          fileBytes: businessProofBytes,
          fileName: businessProofFileName,
          onUpload: () => _pickDocument('Business proof'),
          onPreview: () => _showDocPreviewSheet(
            'Business proof',
            businessProofBytes,
            businessProofFileName,
            () => _pickDocument('Business proof'),
            () => setState(() {
              businessProofAdded = false;
              businessProofBytes = null;
              businessProofFileName = null;
            }),
          ),
        ),
        const SizedBox(height: 20),
        const Text('GST NUMBER · optional', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _gstController,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
      ],
    );
  }

  // R5 · Verify email (Step 3 of 9 sub-step)
  Widget _buildR5VerifyEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your email',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary, height: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a 6-digit code to ${_emailController.text}.',
          style: const TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        const Text('ENTER THE 6-DIGIT CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['5', '3', '8', '2', '0', '4'].map((digit) => Container(
            width: 46,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ZalonoTheme.border),
            ),
            child: Text(digit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          )).toList(),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.check, size: 16, color: ZalonoTheme.primary),
            SizedBox(width: 6),
            Text('Email verified', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              _isVerifyingEmail = false;
            });
          },
          child: const Text(
            'Wrong email? Change it',
            style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDocCard({
    required String title,
    String? subtitle,
    required bool added,
    Uint8List? fileBytes,
    String? fileName,
    required VoidCallback onUpload,
    required VoidCallback onPreview,
  }) {
    return GestureDetector(
      onTap: added ? onPreview : onUpload,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ZalonoTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8EC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.article_outlined,
                  color: ZalonoTheme.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B6864),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            added
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ZalonoTheme.primary, width: 1.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: ZalonoTheme.primary),
                        SizedBox(width: 4),
                        Text(
                          'Added',
                          style: TextStyle(
                            color: ZalonoTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        color: ZalonoTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showDocPreviewSheet(String title, Uint8List? bytes, String? fileName, VoidCallback onReplace, VoidCallback onRemove) {
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E1E1E)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bytes != null) ...[
              if (fileName?.toLowerCase().endsWith('.pdf') == true)
                Container(
                  height: 150,
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
                    bytes,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
            ] else ...[
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: ZalonoTheme.primary, size: 36),
                    SizedBox(height: 6),
                    Text('Document on file', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (fileName != null)
              Text(
                'File: $fileName',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6864), fontWeight: FontWeight.w500),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onReplace();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ZalonoTheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Replace Photo', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onRemove();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDE8EC),
                      foregroundColor: ZalonoTheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // R6 · Salon details (Step 4 of 9)
  Widget _buildR6SalonDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tell us about the salon', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 20),
        const Text('SALON PHOTOS · 3 TO 5', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPhotoBox(0, 'Cover', true),
            const SizedBox(width: 10),
            _buildPhotoBox(1, null, false),
            const SizedBox(width: 10),
            _buildPhotoBox(2, null, false),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _pickSalonPhoto(),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: ZalonoTheme.primary, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, color: ZalonoTheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('SALON NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _salonNameController,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
        const SizedBox(height: 20),
        const Text('SALON CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: ['Basic', 'Medium', 'Premium', 'Ultra premium'].map((cat) {
            final active = cat == salonCategory;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => salonCategory = cat),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? ZalonoTheme.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
                  ),
                  child: Center(
                    child: Text(
                      cat == 'Ultra premium' ? 'Ultra\npremium' : cat,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text('SALON SERVES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: ['Men', 'Women', 'Unisex', 'Other'].map((srv) {
            final active = salonServes.contains(srv);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (salonServes.contains(srv)) {
                      salonServes.remove(srv);
                    } else {
                      salonServes.add(srv);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? ZalonoTheme.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
                  ),
                  child: Center(
                    child: Text(
                      srv,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : ZalonoTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text('YOUR CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _customCategoryController,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Customers see this as a category in the app. Zalono reviews new categories before they go live.',
          style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPhotoBox(int index, String? label, bool isCover) {
    final hasPhoto = index < salonPhotoBytes.length;
    return GestureDetector(
      onTap: () => _pickSalonPhoto(index: hasPhoto ? index : null),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFE9B5B8),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasPhoto)
              Positioned.fill(
                child: Image.memory(
                  salonPhotoBytes[index],
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(Icons.add_photo_alternate_outlined, color: Colors.white70, size: 24),
            if (isCover)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: const Text('Cover', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // R7 · Location (Step 5 of 9)
  Widget _buildR7Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Where is the salon?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Stand at the salon so the pin is exact. Customers see walking time from this spot.',
          style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFEFE8E1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _MapRoadPainter(),
              ),
              const Icon(Icons.location_on, size: 48, color: ZalonoTheme.primary),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: _useCurrentLocation,
          child: const Row(
            children: [
              Icon(Icons.my_location, size: 18, color: ZalonoTheme.primary),
              SizedBox(width: 8),
              Text('Use my current location', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('COMPLETE ADDRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _addressController,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
        const SizedBox(height: 16),
        const Text('PINCODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: TextField(
            controller: _pincodeController,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ),
      ],
    );
  }

  // R8 · Services (Step 6 of 9)
  Widget _buildR8Services() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What do you offer?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text('Tick what you offer. Tap a time or price to change it.', style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 20),
        Row(
          children: ['Hair', 'Skin', 'Nails', 'Body', '+ Add'].map((cat) {
            final active = cat == selectedServiceCategory;
            return GestureDetector(
              onTap: () {
                if (cat == '+ Add') {
                  _addNewServiceDialog();
                } else {
                  setState(() => selectedServiceCategory = cat);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? ZalonoTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? ZalonoTheme.primary : ZalonoTheme.border),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : (cat == '+ Add' ? ZalonoTheme.primary : ZalonoTheme.textPrimary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ...services.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Row(
            children: [
              Checkbox(
                value: s['checked'],
                activeColor: ZalonoTheme.primary,
                onChanged: (val) => setState(() => s['checked'] = val ?? false),
              ),
              Expanded(child: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: ZalonoTheme.surfaceMuted, borderRadius: BorderRadius.circular(8)),
                child: Text(s['time'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: ZalonoTheme.surfaceMuted, borderRadius: BorderRadius.circular(8)),
                child: Text(s['price'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
        )),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _addNewServiceDialog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: ZalonoTheme.primary, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('+ Add service in Hair', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('${services.where((s) => s['checked'] == true).length} services selected', style: const TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // R9 · Who works here (Step 7 of 9)
  Widget _buildR9WhoWorksHere() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Who works here?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
              child: const Text('Optional', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ZalonoTheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Add each stylist and the services they do, so customers can pick one when they book.',
          style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _addNewStylistDialog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: ZalonoTheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('+ Add stylist', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...stylists.map((st) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: ZalonoTheme.primaryLight,
                radius: 20,
                child: Text(st['initial']!, style: const TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(st['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(st['role']!, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Text(st['services']!, style: const TextStyle(fontSize: 12, color: ZalonoTheme.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
          child: const Text(
            'Not ready? Skip this. Customers will book the salon without choosing a stylist.',
            style: TextStyle(color: ZalonoTheme.primaryDark, fontSize: 13, height: 1.4),
          ),
        ),
      ],
    );
  }

  // R10 · Timings (Step 8 of 9)
  Widget _buildR10Timings() {
    final days = dayTimings.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('When are you open?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.',
          style: TextStyle(fontSize: 14.5, color: ZalonoTheme.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            children: [
              for (int i = 0; i < days.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF3ECE5),
                    ),
                  ),
                _buildDayTimingBlock(days[i], dayTimings[days[i]]!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _copyMondayTimings,
            child: const Text("Copy Monday's timings to all days", style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildDayTimingBlock(String day, List<Map<String, dynamic>> slots) {
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
              for (int slotIdx = 0; slotIdx < slots.length; slotIdx++) ...[
                if (slotIdx > 0) const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEFE8E1), width: 1.2),
                        ),
                        child: Text(
                          slots[slotIdx]['slot'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: (slots[slotIdx]['on'] as bool)
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFF9E9B97),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ZalonoSwitch(
                      value: slots[slotIdx]['on'] as bool,
                      onChanged: (v) => setState(() => slots[slotIdx]['on'] = v),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _addNewTimingSlot(day),
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

  // R11 · Review and agree (Step 9 of 9)
  Widget _buildR11ReviewAndAgree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review and agree', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 20),
        _buildReviewRow('Owner', '${_ownerNameController.text} · +91 ${_phoneController.text}', 3),
        _buildReviewRow('Salon', '${_salonNameController.text} · $salonCategory', 4),
        _buildReviewRow('Location', '${_addressController.text.split(',').first} · ${_pincodeController.text}', 5),
        _buildReviewRow('Services', '${services.where((s) => s['checked'] == true).length} services', 6),
        _buildReviewRow('Stylists', '${stylists.length} people', 7),
        _buildReviewRow('Timings', 'Open 7 days · Mon break 2–4 PM', 8),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ZalonoTheme.primary, width: 1.5),
          ),
          child: Row(
            children: [
              Checkbox(
                value: agreeTerms,
                activeColor: ZalonoTheme.primary,
                onChanged: (v) => setState(() => agreeTerms = v ?? false),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => ActionDialogs.showTermsSheet(context),
                  child: const Text(
                    'I agree with all terms and policies of Zalono',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value, int stepTarget) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ZalonoTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          TextButton(
            onPressed: () => setState(() => _currentStep = stepTarget),
            child: const Text('Edit', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // R12 · Submitted
  Widget _buildR12Submitted() {
    return Scaffold(
      backgroundColor: ZalonoTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 40,
                backgroundColor: ZalonoTheme.primary,
                child: Icon(Icons.check, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Application submitted',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you. We will notify you as soon as your salon is approved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
              ),
              const SizedBox(height: 32),

              // Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: ZalonoTheme.border)),
                child: Column(
                  children: [
                    _buildTimelineRow(Icons.check, 'Application submitted', 'We have your details.', true, true),
                    _buildTimelineRow(Icons.radio_button_checked, 'Zalono verification', 'The team is checking Glow Studio.', true, true),
                    _buildTimelineRow(Icons.radio_button_off, 'Approved', 'You get a notification, then you can log in.', false, false),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'You cannot log in until Zalono approves your salon.',
                  style: TextStyle(color: ZalonoTheme.primaryDark, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),

              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow(IconData icon, String title, String subtitle, bool done, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: done ? ZalonoTheme.primary : ZalonoTheme.surfaceMuted,
              child: Icon(icon, size: 14, color: done ? Colors.white : ZalonoTheme.textMuted),
            ),
            if (showLine)
              Container(width: 2, height: 32, color: ZalonoTheme.primary),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    // Cross roads
    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.45)
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.48, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
