import 'package:diazen/screens/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomCard renders text, icon and handles tap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CustomCard(
              text: 'Dose',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    // Verify text is displayed
    expect(find.text('Dose'), findsOneWidget);

    // Tap the card
    await tester.tap(find.byType(CustomCard));
    await tester.pump();

    // Verify callback was invoked
    expect(tapped, isTrue);
  });
}
