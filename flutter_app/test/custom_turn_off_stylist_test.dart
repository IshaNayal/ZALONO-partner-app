import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zalono_partner/screens/stylists_screen.dart';
import 'package:zalono_partner/services/app_state.dart';
import 'package:zalono_partner/widgets/zalono_switch.dart';

void main() {
  Widget createWidget(SalonAppState state) {
    return ChangeNotifierProvider<SalonAppState>.value(
      value: state,
      child: const MaterialApp(
        home: Scaffold(
          body: StylistsScreen(),
        ),
      ),
    );
  }

  testWidgets('Turning off a stylist allows selecting Custom date and time', (tester) async {
    final state = SalonAppState();
    state.addStylist(name: 'Rahul Das', role: 'Hair Specialist', services: ['Haircut']);
    state.addStylist(name: 'Priya Sharma', role: 'Senior Stylist', services: ['Facial']);
    await tester.pumpWidget(createWidget(state));
    await tester.pumpAndSettle();

    // Verify Rahul Das is displayed
    expect(find.text('Rahul Das'), findsOneWidget);

    // Find switch for Rahul
    final switches = find.byType(ZalonoSwitch);
    expect(switches, findsWidgets);

    // Toggle off Rahul
    await tester.tap(switches.first);
    await tester.pumpAndSettle();

    // Verify turn off bottom sheet appears
    expect(find.text('Turn off Rahul?'), findsOneWidget);
    expect(find.text('OFF  FOR'), findsOneWidget);
    expect(find.text('Until 5:00 PM'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);

    // Verify initial reminder text for Until 5:00 PM
    expect(find.text('We will remind you at 5:00 PM to turn Rahul on.'), findsOneWidget);

    // Tap 'Custom' pill
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    // Date picker dialog should now be displayed
    // Tap 'NEXT' to confirm date
    final nextBtn = find.text('NEXT');
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();

      // Time picker should now be displayed
      final okBtn = find.text('OK');
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await tester.pumpAndSettle();
      }
    }

    // Verify Custom date and time container is now visible
    expect(find.text('CUSTOM DATE & TIME'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    // Verify reminder text dynamically contains 'to turn Rahul on.'
    expect(find.textContaining('to turn Rahul on.'), findsOneWidget);

    // Confirm turn off
    final confirmBtn = find.widgetWithText(ElevatedButton, 'Turn off Rahul');
    expect(confirmBtn, findsOneWidget);
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // Rahul should now be marked off with custom duration
    final rahul = state.stylists.firstWhere((s) => s.name.contains('Rahul'));
    expect(rahul.isAvailable, isFalse);
    expect(rahul.statusDetail, contains('Off Until'));
  });

  testWidgets('Custom date and time works for other stylists as well', (tester) async {
    final state = SalonAppState();
    state.addStylist(name: 'Rahul Das', role: 'Hair Specialist', services: ['Haircut']);
    state.addStylist(name: 'Priya Sharma', role: 'Senior Stylist', services: ['Facial']);
    await tester.pumpWidget(createWidget(state));
    await tester.pumpAndSettle();

    // Verify Priya Sharma is in list
    expect(find.text('Priya Sharma'), findsOneWidget);

    // Switches
    final switches = find.byType(ZalonoSwitch);
    expect(switches, findsWidgets);

    // Toggle off Priya (second switch)
    await tester.tap(switches.at(1));
    await tester.pumpAndSettle();

    // Verify bottom sheet for Priya appears
    expect(find.text('Turn off Priya?'), findsOneWidget);

    // Tap 'Custom' pill
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    // Tap 'NEXT' on DatePicker
    final nextBtn = find.text('NEXT');
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();

      // Tap 'OK' on TimePicker
      final okBtn = find.text('OK');
      if (okBtn.evaluate().isNotEmpty) {
        await tester.tap(okBtn);
        await tester.pumpAndSettle();
      }
    }

    // Verify Custom date and time card is displayed
    expect(find.text('CUSTOM DATE & TIME'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    // Verify reminder text references Priya
    expect(find.textContaining('to turn Priya on.'), findsOneWidget);

    // Confirm turn off
    final confirmBtn = find.widgetWithText(ElevatedButton, 'Turn off Priya');
    expect(confirmBtn, findsOneWidget);
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // Verify Priya is off with custom duration
    final priya = state.stylists.firstWhere((s) => s.name.contains('Priya'));
    expect(priya.isAvailable, isFalse);
    expect(priya.statusDetail, contains('Off Until'));
  });
}
