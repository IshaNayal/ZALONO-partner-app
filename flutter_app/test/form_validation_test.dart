import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zalono_partner/screens/registration_screens.dart';
import 'package:zalono_partner/screens/login_screens.dart';
import 'package:zalono_partner/services/app_state.dart';
import 'package:zalono_partner/theme/app_theme.dart';
import 'package:zalono_partner/widgets/zalono_otp_input.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return ChangeNotifierProvider(
      create: (_) => SalonAppState(),
      child: MaterialApp(
        theme: ZalonoTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('Registration Screen - Empty Fields & Continue Button Validation', () {
    testWidgets('Initial input fields in registration screen start completely empty', (tester) async {
      await tester.pumpWidget(buildTestApp(const RegistrationFlowScreen()));
      await tester.pumpAndSettle();

      // On Step 1 (Verify Mobile), mobile TextField should be empty
      final mobileFinder = find.byType(TextField);
      expect(mobileFinder, findsWidgets);

      // The phone field is the first TextField
      final phoneField = tester.widget<TextField>(mobileFinder.first);
      expect(phoneField.controller?.text, isEmpty);

      // OTP fields must also all be empty
      final otpFields = find.descendant(
        of: find.byType(ZalonoOtpInput),
        matching: find.byType(TextField),
      );
      expect(otpFields, findsNWidgets(6));
      for (int i = 0; i < 6; i++) {
        final tf = tester.widget<TextField>(otpFields.at(i));
        expect(tf.controller?.text, isEmpty);
      }
    });

    testWidgets('Continue button requires BOTH 10-digit mobile AND 6-digit OTP to show red', (tester) async {
      await tester.pumpWidget(buildTestApp(const RegistrationFlowScreen()));
      await tester.pumpAndSettle();

      final continueButtonFinder = find.widgetWithText(ElevatedButton, 'Continue');
      expect(continueButtonFinder, findsOneWidget);

      ElevatedButton getButton() => tester.widget<ElevatedButton>(continueButtonFinder);

      // 1. Initially both empty: button disabled and grey (Color(0xFFD0CBC6))
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      // 2. Enter 10-digit phone only (no OTP)
      final phoneFieldFinder = find.byType(TextField).first;
      await tester.enterText(phoneFieldFinder, '9876543210');
      await tester.pumpAndSettle();

      // Still disabled and grey
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      // 3. Clear phone and enter 6-digit OTP only
      await tester.enterText(phoneFieldFinder, '');
      await tester.pumpAndSettle();

      final otpFields = find.descendant(
        of: find.byType(ZalonoOtpInput),
        matching: find.byType(TextField),
      );
      for (int i = 0; i < 6; i++) {
        await tester.enterText(otpFields.at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      // Still disabled and grey because phone is empty!
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      // 4. Enter only 9 digits of phone (incomplete phone)
      await tester.enterText(phoneFieldFinder, '987654321');
      await tester.pumpAndSettle();

      // Still disabled and grey
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      // 5. Enter 10th digit of phone (now BOTH phone and OTP are complete!)
      await tester.enterText(phoneFieldFinder, '9876543210');
      await tester.pumpAndSettle();

      // Button is now active and RED (ZalonoTheme.primary)!
      expect(getButton().onPressed, isNotNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(ZalonoTheme.primary));

      // 6. Delete one digit of OTP
      await tester.enterText(otpFields.at(5), '');
      await tester.pumpAndSettle();

      // Immediately turns disabled and grey again!
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));
    });

    testWidgets('Verify your email requires OTP 123456 before showing Email verified and enabling Continue', (tester) async {
      await tester.pumpWidget(buildTestApp(const RegistrationFlowScreen()));
      await tester.pumpAndSettle();

      // Complete Step 1
      final phoneFieldFinder = find.byType(TextField).first;
      await tester.enterText(phoneFieldFinder, '9876543210');
      await tester.pumpAndSettle();

      final step1OtpFields = find.descendant(
        of: find.byType(ZalonoOtpInput),
        matching: find.byType(TextField),
      );
      for (int i = 0; i < 6; i++) {
        await tester.enterText(step1OtpFields.at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      // Tap Continue to Step 2
      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Complete Step 2 (Onboarding Code)
      final codeField = find.byType(TextField).first;
      await tester.enterText(codeField, 'ZL-BBS-4821');
      await tester.pumpAndSettle();
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // On Step 3 (About owner)
      expect(find.text('About the owner'), findsOneWidget);
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Test Owner');
      await tester.enterText(textFields.at(1), 'owner@test.com');
      await tester.pumpAndSettle();

      // Tap "Verify" button next to email
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      // Now on "Verify your email" sub-screen
      expect(find.text('Verify your email'), findsOneWidget);

      // "Email verified" should NOT be shown initially
      expect(find.text('Email verified'), findsNothing);

      ElevatedButton getContinueButton() => tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(getContinueButton().onPressed, isNull);
      expect(getContinueButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      final emailOtpFields = find.descendant(
        of: find.byType(ZalonoOtpInput),
        matching: find.byType(TextField),
      );
      expect(emailOtpFields, findsNWidgets(6));

      // Enter incorrect OTP "111111"
      for (int i = 0; i < 6; i++) {
        await tester.enterText(emailOtpFields.at(i), '1');
        await tester.pumpAndSettle();
      }

      // "Email verified" should still NOT be shown, button still disabled
      expect(find.text('Email verified'), findsNothing);
      expect(getContinueButton().onPressed, isNull);

      // Enter correct OTP "123456"
      const correctDigits = ['1', '2', '3', '4', '5', '6'];
      for (int i = 0; i < 6; i++) {
        await tester.enterText(emailOtpFields.at(i), correctDigits[i]);
        await tester.pumpAndSettle();
      }

      // "Email verified" MUST now be shown!
      expect(find.text('Email verified'), findsOneWidget);

      // Continue button must now be active and RED!
      expect(getContinueButton().onPressed, isNotNull);
      expect(getContinueButton().style?.backgroundColor?.resolve({}), equals(ZalonoTheme.primary));

      // If user clears one digit, "Email verified" disappears and button becomes grey
      await tester.enterText(emailOtpFields.at(5), '');
      await tester.pumpAndSettle();
      expect(find.text('Email verified'), findsNothing);
      expect(getContinueButton().onPressed, isNull);

      // Re-enter 6th digit "6"
      await tester.enterText(emailOtpFields.at(5), '6');
      await tester.pumpAndSettle();
      expect(find.text('Email verified'), findsOneWidget);
      expect(getContinueButton().onPressed, isNotNull);

      // Tap Continue to finish email verification (since owner name was filled, it advances to Step 4 Salon details)
      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Tell us about the salon'), findsOneWidget);

      // Tap back button to return to Step 3 and verify email badge shows "✓ Verified"
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('About the owner'), findsOneWidget);
      expect(find.text('✓ Verified'), findsOneWidget);
    });
  });

  group('Login Screen - Empty Fields & Log in Button Validation', () {
    testWidgets('Login screen fields start empty and button requires both mobile and OTP', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await tester.pumpAndSettle();

      final loginButtonFinder = find.byType(ElevatedButton);
      expect(loginButtonFinder, findsOneWidget);

      ElevatedButton getButton() => tester.widget<ElevatedButton>(loginButtonFinder);

      // Initially empty & disabled
      expect(getButton().onPressed, isNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(const Color(0xFFD0CBC6)));

      // Enter phone only
      final phoneFieldFinder = find.byType(TextField).first;
      await tester.enterText(phoneFieldFinder, '9876543210');
      await tester.pumpAndSettle();
      expect(getButton().onPressed, isNull);

      // Enter OTP
      final otpFields = find.descendant(
        of: find.byType(ZalonoOtpInput),
        matching: find.byType(TextField),
      );
      for (int i = 0; i < 6; i++) {
        await tester.enterText(otpFields.at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      // Both entered: button is RED and active!
      expect(getButton().onPressed, isNotNull);
      expect(getButton().style?.backgroundColor?.resolve({}), equals(ZalonoTheme.primary));
    });
  });
}
