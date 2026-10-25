import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zalono_partner/widgets/zalono_otp_input.dart';

void main() {
  Widget buildTestWidget({
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
    VoidCallback? onChanged,
    ValueChanged<String>? onCompleted,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ZalonoOtpInput(
            controllers: controllers,
            focusNodes: focusNodes,
            onChanged: onChanged,
            onCompleted: onCompleted,
          ),
        ),
      ),
    );
  }

  group('OTP Input Tests', () {
    late List<TextEditingController> controllers;
    late List<FocusNode> focusNodes;

    setUp(() {
      controllers = List.generate(6, (_) => TextEditingController());
      focusNodes = List.generate(6, (_) => FocusNode());
    });

    tearDown(() {
      for (final c in controllers) {
        c.dispose();
      }
      for (final f in focusNodes) {
        f.dispose();
      }
    });

    testWidgets('Test 1 & 2: Sequential entry moves focus forward and populates digits', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      // Enter digits 1 through 6
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byType(TextField).at(i));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      final fullOtp = controllers.map((c) => c.text).join();
      expect(fullOtp, equals('123456'));
      expect(controllers[0].text, equals('1'));
      expect(controllers[1].text, equals('2'));
      expect(controllers[2].text, equals('3'));
      expect(controllers[3].text, equals('4'));
      expect(controllers[4].text, equals('5'));
      expect(controllers[5].text, equals('6'));
    });

    testWidgets('Test 3: Backspace on a populated box deletes current digit and keeps focus', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      // Populate box 0, 1, 2, 3 with '1', '2', '3', '4'
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byType(TextField).at(i));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      // Tap on box 3 (which contains '4')
      await tester.tap(find.byType(TextField).at(3));
      await tester.pumpAndSettle();
      expect(focusNodes[3].hasFocus, isTrue);
      expect(controllers[3].text, equals('4'));

      // Press Backspace via sendKeyEvent
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      // Box 3 digit should be deleted, and focus remains on box 3
      expect(controllers[3].text, equals(''));
      expect(controllers[2].text, equals('3'));
      expect(focusNodes[3].hasFocus, isTrue);
    });

    testWidgets('Test 4: Backspace on an empty box moves focus to previous box and deletes it', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      // Populate box 0, 1, 2 with '1', '2', '3'
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(TextField).at(i));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pumpAndSettle();
      }

      // Box 3 is currently empty, focus is on box 3
      await tester.tap(find.byType(TextField).at(3));
      await tester.pumpAndSettle();
      expect(controllers[3].text, equals(''));
      expect(controllers[2].text, equals('3'));

      // Press Backspace on empty box 3
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      // Focus should move to box 2 and box 2 should be cleared
      expect(focusNodes[2].hasFocus, isTrue);
      expect(controllers[2].text, equals(''));
      expect(controllers[1].text, equals('2'));
    });

    testWidgets('Test 5: Backspace in the first empty box does not move outside or cause error', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      expect(focusNodes[0].hasFocus, isTrue);

      // Press Backspace on box 0 when empty
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(focusNodes[0].hasFocus, isTrue);
      expect(controllers[0].text, equals(''));
    });

    testWidgets('Test 6 & 7: ArrowLeft and ArrowRight navigate without modifying values', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      controllers[0].text = '1';
      controllers[1].text = '2';
      controllers[2].text = '3';
      await tester.pumpAndSettle();

      // Focus box 1
      await tester.tap(find.byType(TextField).at(1));
      await tester.pumpAndSettle();
      expect(focusNodes[1].hasFocus, isTrue);

      // Press ArrowRight
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(focusNodes[2].hasFocus, isTrue);

      // Press ArrowLeft
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(focusNodes[1].hasFocus, isTrue);

      // Values must not be modified
      expect(controllers[0].text, equals('1'));
      expect(controllers[1].text, equals('2'));
      expect(controllers[2].text, equals('3'));
    });

    testWidgets('Test 8: Digit replacement replaces existing digit and moves forward', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      // Enter '4' in box 0
      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), '4');
      await tester.pumpAndSettle();
      expect(controllers[0].text, equals('4'));

      // Tap box 0 again and enter '9' (which arrives as '49' or replacement)
      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), '49');
      await tester.pumpAndSettle();

      // Old digit '4' replaced by '9', and focus moved to box 1
      expect(controllers[0].text, equals('9'));
      expect(focusNodes[1].hasFocus, isTrue);
    });

    testWidgets('Test 9 & 10: Paste complete OTP with separators distributes correctly', (tester) async {
      String completedCode = '';
      await tester.pumpWidget(buildTestWidget(
        controllers: controllers,
        focusNodes: focusNodes,
        onCompleted: (code) => completedCode = code,
      ));

      // Paste formatted OTP "427-901" into first box
      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), '427-901');
      await tester.pumpAndSettle();

      expect(controllers.map((c) => c.text).join(), equals('427901'));
      expect(completedCode, equals('427901'));
    });

    testWidgets('Test 11: Non-digits are rejected', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'abc');
      await tester.pumpAndSettle();

      expect(controllers[0].text, equals(''));
      expect(focusNodes[0].hasFocus, isTrue);
    });

    testWidgets('Test 18: Clear entire OTP resets all boxes cleanly', (tester) async {
      await tester.pumpWidget(buildTestWidget(controllers: controllers, focusNodes: focusNodes));

      for (int i = 0; i < 6; i++) {
        controllers[i].text = '$i';
      }
      await tester.pumpAndSettle();
      expect(controllers.map((c) => c.text).join(), equals('012345'));

      for (final c in controllers) {
        c.clear();
      }
      await tester.pumpAndSettle();

      expect(controllers.map((c) => c.text).join(), equals(''));
      expect(controllers.every((c) => c.text.isEmpty), isTrue);
    });
  });
}
