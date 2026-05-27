import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipo/shared/enums/apply_status.dart';
import 'package:ipo/shared/widgets/status_chip.dart';

void main() {
  testWidgets('StatusChip renders the status label and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusChip(ApplyStatus.allotted)),
      ),
    );

    expect(find.text('Allotted'), findsOneWidget);
    expect(find.byIcon(ApplyStatus.allotted.icon), findsOneWidget);
  });
}
