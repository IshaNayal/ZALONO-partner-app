import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zalono_partner/screens/home_screen.dart';
import 'package:zalono_partner/services/app_state.dart';

void main() {
  Widget createWidget(SalonAppState state) {
    return ChangeNotifierProvider<SalonAppState>.value(
      value: state,
      child: MaterialApp(
        home: Scaffold(
          body: HomeScreen(onNavigateToBookings: () {}),
        ),
      ),
    );
  }

  testWidgets('Walk-in modal sheet shows "No stylist selected" when no stylist is selected', (tester) async {
    final state = SalonAppState();
    state.addStylist(name: 'Rahul Das', role: 'Hair Specialist', services: ['Haircut']);
    state.addStylist(name: 'Priya Sharma', role: 'Senior Stylist', services: ['Facial']);

    await tester.pumpWidget(createWidget(state));
    await tester.pumpAndSettle();

    // Tap '+ Add walk-in' button
    final addWalkInBtn = find.text('Add walk-in');
    expect(addWalkInBtn, findsOneWidget);
    await tester.tap(addWalkInBtn);
    await tester.pumpAndSettle();

    // Verify "No stylist selected" is shown initially
    expect(find.text('No stylist selected'), findsOneWidget);
    expect(find.textContaining('null blocked'), findsNothing);

    // Scroll to and select Rahul
    final rahulFinder = find.text('Rahul');
    await tester.ensureVisible(rahulFinder);
    await tester.tap(rahulFinder);
    await tester.pumpAndSettle();

    // Now it should show 'Rahul blocked · 30 min'
    expect(find.text('Rahul blocked · 30 min'), findsOneWidget);
    expect(find.text('No stylist selected'), findsNothing);

    // Tap Rahul again to unselect
    await tester.tap(rahulFinder);
    await tester.pumpAndSettle();

    // Should return to "No stylist selected"
    expect(find.text('No stylist selected'), findsOneWidget);
    expect(find.textContaining('null blocked'), findsNothing);
  });
}
