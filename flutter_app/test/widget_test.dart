import 'package:flutter_test/flutter_test.dart';
import 'package:zalono_partner/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ZalonoPartnerApp());
    expect(find.text('Zalono'), findsWidgets);
    expect(find.text('Log in'), findsOneWidget);
  });
}
