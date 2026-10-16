import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zalono_partner/main.dart';
import 'package:zalono_partner/screens/more_screens.dart';
import 'package:zalono_partner/services/app_state.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ZalonoPartnerApp());
    expect(find.text('Zalono'), findsWidgets);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('SalonProfileScreen displays uploaded photos in placeholders', (WidgetTester tester) async {
    final state = SalonAppState();
    // 1x1 transparent PNG in bytes
    final dummyPhoto = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
    ]);

    state.setSalonPhotos([dummyPhoto, dummyPhoto]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: SalonProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title and View only badge
    expect(find.text('Salon profile'), findsOneWidget);
    expect(find.text('View only'), findsOneWidget);

    // Verify 2 images are rendered from state.salonPhotos
    expect(find.byType(Image), findsNWidgets(2));

    // Verify 1 placeholder icon is rendered for the 3rd unfilled box
    expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
  });
}
