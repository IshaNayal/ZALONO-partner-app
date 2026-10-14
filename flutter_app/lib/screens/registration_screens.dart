import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({super.key});

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  int _currentStep = 1; // 1 to 9 (R2 to R11), and 10 is R12 Submitted

  // Form State
  String phone = '98765 43210';
  List<String> mobileOtp = ['4', '2', '7', '9', '0', '1'];
  String onboardingCode = 'ZL-4821';
  bool codeVerified = true;

  String ownerName = 'Rohan Mehta';
  String email = 'rohan@glowstudio.in';
  bool emailVerified = true;
  String gstNumber = '22ABCDE1234F1Z5';
  bool panAdded = true;

  String salonName = 'Glow Studio';
  String salonCategory = 'Premium'; // Basic, Medium, Premium, Ultra premium
  List<String> salonServes = ['Unisex', 'Other'];
  String customCategory = 'Kids salon';

  String address = 'Plot No. 123, Saheed Nagar, Near Big Bazaar, Bhubaneswar';
  String pincode = '751007';

  // Services
  String selectedServiceCategory = 'Hair';
  final List<Map<String, dynamic>> services = [
    {'name': 'Haircut (Men)', 'time': '30 min', 'price': '₹399', 'checked': true},
    {'name': 'Haircut (Women)', 'time': '45 min', 'price': '₹699', 'checked': true},
    {'name': 'Beard trim', 'time': '15 min', 'price': '₹149', 'checked': true},
    {'name': 'Hair colour', 'time': '90 min', 'price': '₹2,499', 'checked': true},
    {'name': 'Hair spa', 'time': '60 min', 'price': '₹1,999', 'checked': false},
  ];

  // Stylists
  final List<Map<String, String>> stylists = [
    {'initial': 'P', 'name': 'Priya Sharma', 'role': 'Hair specialist', 'services': 'Haircut, Hair colour, Beard trim'},
    {'initial': 'R', 'name': 'Rahul Das', 'role': 'Skin specialist', 'services': 'Facial, Clean-up'},
    {'initial': 'N', 'name': 'Neha Patel', 'role': 'Nail artist', 'services': 'Manicure, Pedicure'},
  ];

  bool agreeTerms = false;

  void _nextStep() {
    if (_currentStep < 10) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
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
                onPressed: (_currentStep == 9 && !agreeTerms) ? null : _nextStep,
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
        return _buildR4AboutOwner();
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

  // R2
  Widget _buildR2VerifyMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your mobile\nnumber',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary, height: 1.2),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Row(
            children: const [
              Text('+91', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(width: 12),
              Text('98765 43210', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('ENTER THE 6-DIGIT CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: mobileOtp.map((digit) => Container(
            width: 46,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: ZalonoTheme.border)),
            child: Text(digit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          )).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
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
      ],
    );
  }

  // R3
  Widget _buildR3OnboardingCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your onboarding\ncode',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary, height: 1.2),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ZalonoTheme.primary, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(onboardingCode, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const CircleAvatar(
                radius: 12,
                backgroundColor: ZalonoTheme.primary,
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(Icons.check, size: 16, color: ZalonoTheme.primary),
            SizedBox(width: 6),
            Text('Code verified · registration unlocked', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'No code yet? Ask your Zalono executive or contact support.',
          style: TextStyle(fontSize: 13, color: ZalonoTheme.textSecondary),
        ),
      ],
    );
  }

  // R4
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(ownerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
              Text(email, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: ZalonoTheme.primary, borderRadius: BorderRadius.circular(20)),
                child: const Text('Verify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('DOCUMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
            Text('All optional', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ZalonoTheme.primary)),
          ],
        ),
        const SizedBox(height: 10),
        _buildDocRow('PAN card', true),
        const SizedBox(height: 8),
        _buildDocRow('Aadhaar card', false),
        const SizedBox(height: 8),
        _buildDocRow('Business proof\nShop licence or Udyam', false),
        const SizedBox(height: 20),
        const Text('GST NUMBER · optional', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(gstNumber, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildDocRow(String title, bool added) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.description_outlined, color: ZalonoTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
          added
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: ZalonoTheme.primary), borderRadius: BorderRadius.circular(20)),
                  child: const Text('✓ Added', style: TextStyle(color: ZalonoTheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: ZalonoTheme.primaryLight, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Upload', style: TextStyle(color: ZalonoTheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
        ],
      ),
    );
  }

  // R6
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
            _buildPhotoBox('Cover', true),
            const SizedBox(width: 10),
            _buildPhotoBox(null, false),
            const SizedBox(width: 10),
            _buildPhotoBox(null, false),
            const SizedBox(width: 10),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: ZalonoTheme.primary, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add, color: ZalonoTheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('SALON NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(salonName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
                      cat,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(customCategory, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 8),
        const Text(
          'Customers see this as a category in the app. Zalono reviews new categories before they go live.',
          style: TextStyle(fontSize: 12, color: ZalonoTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPhotoBox(String? label, bool isCover) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFE9B5B8),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.bottomCenter,
      child: isCover
          ? Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: const Text('Cover', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: ZalonoTheme.primary)),
            )
          : null,
    );
  }

  // R7
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
        Row(
          children: const [
            Icon(Icons.my_location, size: 18, color: ZalonoTheme.primary),
            SizedBox(width: 8),
            Text('Use my current location', style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('COMPLETE ADDRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(address, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        const Text('PINCODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: ZalonoTheme.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: ZalonoTheme.border)),
          child: Text(pincode, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // R8
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
            return Container(
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
        Container(
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
        const SizedBox(height: 16),
        Center(
          child: Text('4 services selected', style: const TextStyle(color: ZalonoTheme.textSecondary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // R9
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
        Container(
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

  // R10
  Widget _buildR10Timings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('When are you open?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Add more than one timing a day if you take a break. Use the toggle to switch a timing on or off.',
          style: TextStyle(fontSize: 15, color: ZalonoTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        // Mon
        _buildDayTimingBlock('Mon', [
          {'slot': '10:00 AM – 2:00 PM', 'on': true},
          {'slot': '4:00 PM – 10:00 PM', 'on': true},
        ]),
        // Tue - Fri
        _buildDayTimingBlock('Tue', [{'slot': '10:00 AM – 10:00 PM', 'on': true}]),
        _buildDayTimingBlock('Wed', [{'slot': '10:00 AM – 10:00 PM', 'on': true}]),
        _buildDayTimingBlock('Thu', [{'slot': '10:00 AM – 10:00 PM', 'on': true}]),
        _buildDayTimingBlock('Fri', [{'slot': '10:00 AM – 10:00 PM', 'on': true}]),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Copy Monday's timings to all days", style: TextStyle(color: ZalonoTheme.primary, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildDayTimingBlock(String day, List<Map<String, dynamic>> slots) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 40, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
              Expanded(
                child: Column(
                  children: slots.map((s) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: ZalonoTheme.border)),
                            child: Text(s['slot'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: s['on'],
                          activeColor: ZalonoTheme.primary,
                          onChanged: (v) => setState(() => s['on'] = v),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text('+ Add timing', style: TextStyle(color: ZalonoTheme.primary, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // R11
  Widget _buildR11ReviewAndAgree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review and agree', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ZalonoTheme.textPrimary)),
        const SizedBox(height: 20),
        _buildReviewRow('Owner', 'Rohan Mehta · +91 98765 43210', 3),
        _buildReviewRow('Salon', 'Glow Studio · Premium', 4),
        _buildReviewRow('Location', 'Saheed Nagar · 751007', 5),
        _buildReviewRow('Services', '4 services', 6),
        _buildReviewRow('Stylists', '3 people', 7),
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
              const Expanded(
                child: Text(
                  'I agree with all terms and policies of Zalono',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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

  // R12 Submitted
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
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
