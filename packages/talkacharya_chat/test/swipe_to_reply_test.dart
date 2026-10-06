import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

void main() {
  Future<void> pump(WidgetTester t, {required VoidCallback onReply, bool enabled = true, bool reverse = false}) {
    return t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SwipeToReply(
              enabled: enabled,
              reverse: reverse,
              onReply: onReply,
              child: const SizedBox(width: 200, height: 60, child: Text('hi')),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('a long enough pull replies', (t) async {
    var replies = 0;
    await pump(t, onReply: () => replies++);

    await t.drag(find.text('hi'), const Offset(80, 0));
    await t.pumpAndSettle();

    expect(replies, 1);
  });

  testWidgets('a short pull does not', (t) async {
    // A scroll that wanders sideways must never fire a reply.
    var replies = 0;
    await pump(t, onReply: () => replies++);

    await t.drag(find.text('hi'), const Offset(20, 0));
    await t.pumpAndSettle();

    expect(replies, 0);
  });

  testWidgets('pulling the wrong way does nothing', (t) async {
    var replies = 0;
    await pump(t, onReply: () => replies++);

    await t.drag(find.text('hi'), const Offset(-120, 0));
    await t.pumpAndSettle();

    expect(replies, 0);
  });

  testWidgets('reverse pull replies when reverse is true', (t) async {
    var replies = 0;
    await pump(t, onReply: () => replies++, reverse: true);

    await t.drag(find.text('hi'), const Offset(-80, 0));
    await t.pumpAndSettle();

    expect(replies, 1);
  });

  testWidgets('disabled means the child is handed through untouched', (t) async {
    // System lines and cards have nothing to quote; the gesture must not
    // swallow their taps either.
    var replies = 0;
    await pump(t, onReply: () => replies++, enabled: false);

    await t.drag(find.text('hi'), const Offset(120, 0));
    await t.pumpAndSettle();

    expect(replies, 0);
    expect(find.byType(GestureDetector), findsNothing);
  });
}
