import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('the error view says what happened and retries', (t) async {
    var retried = 0;
    await t.pumpWidget(
      _app(
        ErrorView(
          title: 'No connection',
          message: 'Check the internet and try again.',
          onRetry: () => retried++,
        ),
      ),
    );
    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Check the internet and try again.'), findsOneWidget);

    await t.tap(find.text('Try again'));
    expect(retried, 1);
  });

  testWidgets('without a retry there is no button to press', (t) async {
    await t.pumpWidget(_app(const ErrorView(message: 'Not available.')));
    expect(find.text('Not available.'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });
}
