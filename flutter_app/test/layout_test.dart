import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zalono_partner/main.dart';
import 'package:zalono_partner/screens/bookings_screen.dart';
import 'package:zalono_partner/screens/home_screen.dart';
import 'package:zalono_partner/screens/login_screens.dart';
import 'package:zalono_partner/screens/more_screens.dart';
import 'package:zalono_partner/screens/notifications_screen.dart';
import 'package:zalono_partner/screens/r1_welcome_screen.dart';
import 'package:zalono_partner/screens/registration_screens.dart';
import 'package:zalono_partner/screens/stylists_screen.dart';
import 'package:zalono_partner/services/app_state.dart';

void main() {
  Widget wrap(Widget child, [SalonAppState? state]) {
    return ChangeNotifierProvider<SalonAppState>.value(
      value: state ?? SalonAppState(),
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Test WelcomeScreen', (tester) async {
    await tester.pumpWidget(wrap(const WelcomeScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test RegistrationFlowScreen all steps', (tester) async {
    await tester.pumpWidget(wrap(const RegistrationFlowScreen()));
    await tester.pumpAndSettle();

    // Verify Step 1 is rendered
    expect(find.text('STEP 1 OF 9'), findsOneWidget);

    // Enter phone number and OTP 123456
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, '8527678461');
    for (int i = 0; i < 6; i++) {
      await tester.enterText(textFields.at(i + 1), '${i + 1}');
    }
    await tester.pumpAndSettle();

    // Continue to step 2
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('STEP 2 OF 9'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'ZL-BBS-4821');
    await tester.pumpAndSettle();

    // Continue to step 3
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('STEP 3 OF 9'), findsOneWidget);

    // Enter owner name
    await tester.enterText(find.byType(TextField).first, 'Rohan Mehta');
    await tester.enterText(find.byType(TextField).at(1), 'rohan.mehta@example.com');
    await tester.pumpAndSettle();

    // Tap Continue on Step 3 to go to 'Verify your email'
    final continueToEmailBtn = find.widgetWithText(ElevatedButton, 'Continue');
    expect(continueToEmailBtn, findsOneWidget);
    await tester.tap(continueToEmailBtn);
    await tester.pumpAndSettle();

    // Verify 'Verify your email' screen is displayed
    expect(find.text('Verify your email'), findsOneWidget);

    // Enter email OTP 123456
    final emailOtpFields = find.byType(TextField);
    for (int i = 0; i < 6; i++) {
      await tester.enterText(emailOtpFields.at(i), '${i + 1}');
    }
    await tester.pumpAndSettle();
    expect(find.text('Email verified'), findsOneWidget);

    // Verify Continue button on 'Verify your email' is enabled and works
    final continueEmailVerifyBtn = find.widgetWithText(ElevatedButton, 'Continue');
    expect(continueEmailVerifyBtn, findsOneWidget);
    await tester.tap(continueEmailVerifyBtn);
    await tester.pumpAndSettle();

    // Now should advance to Step 4 (Salon Details)
    expect(find.text('STEP 4 OF 9'), findsOneWidget);

    // Continue through remaining steps
    for (int s = 4; s < 9; s++) {
      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue');
      if (continueBtn.evaluate().isNotEmpty) {
        await tester.tap(continueBtn);
        await tester.pumpAndSettle();
      }
    }
  });

  testWidgets('Test LoginScreen', (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test MainNavigationShell', (tester) async {
    await tester.pumpWidget(wrap(const MainNavigationShell()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test HomeScreen', (tester) async {
    await tester.pumpWidget(wrap(HomeScreen(onNavigateToBookings: () {})));
    await tester.pumpAndSettle();
  });

  testWidgets('Test BookingsScreen', (tester) async {
    await tester.pumpWidget(wrap(const BookingsScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test MoreScreen', (tester) async {
    await tester.pumpWidget(wrap(const MoreScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test SalonProfileScreen', (tester) async {
    await tester.pumpWidget(wrap(const SalonProfileScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test OwnerProfileScreen', (tester) async {
    await tester.pumpWidget(wrap(const OwnerProfileScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test StylistsScreen', (tester) async {
    final state = SalonAppState();
    await tester.pumpWidget(wrap(const StylistsScreen(), state));
    await tester.pumpAndSettle();

    // Verify 'Stylists' title is bold (w900)
    final titleFinder = find.text('Stylists');
    expect(titleFinder, findsOneWidget);
    final Text titleWidget = tester.widget(titleFinder);
    expect(titleWidget.style?.fontWeight, FontWeight.w900);

    // Tap '+ Add stylist' button
    final addBtn = find.text('+ Add stylist');
    expect(addBtn, findsOneWidget);
    await tester.tap(addBtn);
    await tester.pumpAndSettle();

    // Modal sheet should appear
    expect(find.text('Add Stylist'), findsWidgets);

    // Enter Stylist name
    final nameField = find.byType(TextField).first;
    await tester.enterText(nameField, 'Deepak Kumar');
    await tester.pumpAndSettle();

    // Tap 'Add Stylist' submit button inside bottom sheet
    final submitBtn = find.widgetWithText(ElevatedButton, 'Add Stylist');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Verify Deepak Kumar is added to list and customer see badges
    expect(find.text('Deepak Kumar'), findsOneWidget);
    expect(find.text('Deepak'), findsOneWidget);

    // Long press on Deepak Kumar to trigger confirmation dialog
    await tester.longPress(find.text('Deepak Kumar'));
    await tester.pumpAndSettle();

    // Confirm dialog is shown
    expect(find.text('Delete Deepak Kumar?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Deepak Kumar'), findsOneWidget);

    // Long press again and confirm deletion
    await tester.longPress(find.text('Deepak Kumar'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Verify Priya Sharma has been removed
    expect(find.text('Deepak Kumar'), findsNothing);
  });

  testWidgets('Test TimingsScreen', (tester) async {
    await tester.pumpWidget(wrap(const TimingsScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test SupportScreen', (tester) async {
    await tester.pumpWidget(wrap(const SupportScreen()));
    await tester.pumpAndSettle();
  });

  testWidgets('Test NotificationsScreen', (tester) async {
    await tester.pumpWidget(wrap(const NotificationsScreen()));
    await tester.pumpAndSettle();
  });
}
