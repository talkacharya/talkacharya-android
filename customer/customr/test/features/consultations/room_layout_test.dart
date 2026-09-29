import 'package:customr/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The room went blank on a closed thread because its "Start consultation"
/// bar put a themed `FilledButton` straight into a `Row`.
///
/// The theme gives every `FilledButton` `minimumSize: Size.fromHeight(52)`,
/// which is `Size(infinity, 52)`, and a `Row` hands its non-flex children
/// unbounded width. Together those are an infinite-width constraint — and the
/// damage is not confined to the button: the whole subtree fails to lay out,
/// so the screen paints empty with nothing on it to say why.
void main() {
  testWidgets('a bounded minimum makes it safe inside a Row', (t) async {
    // The trap this guards against. If this ever stops being true, the
    // explicit `minimumSize` on the buttons in the room can go.
    final themed = AppTheme.light.filledButtonTheme.style?.minimumSize
        ?.resolve({});
    expect(themed?.width, double.infinity, reason: 'theme no longer the trap');

    await t.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Row(
            children: [
              const Expanded(child: Text('Follow-up time is over.')),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                onPressed: () {},
                child: const Text('Start consultation'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(t.takeException(), isNull);
    expect(find.text('Start consultation'), findsOneWidget);
  });
}
