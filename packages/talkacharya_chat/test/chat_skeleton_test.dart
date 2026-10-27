import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(320, 640),
    double textScale = 1,
    Brightness brightness = Brightness.light,
    bool home = false,
  }) async {
    tester.view
      ..physicalSize = size * 3
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        builder: (context, app) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: app!,
        ),
        home: home ? child : Scaffold(appBar: AppBar(), body: child),
      ),
    );
    // The shimmer repeats forever: pump, never settle.
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final brightness in Brightness.values) {
    for (final width in const [280.0, 360.0, 600.0]) {
      testWidgets('fits without overflow ($brightness, $width wide)', (
        tester,
      ) async {
        await pump(
          tester,
          const ChatSkeleton.page(),
          size: Size(width, 700),
          textScale: 2,
          brightness: brightness,
          home: true,
        );
        expect(tester.takeException(), isNull);

        await pump(
          tester,
          const ChatSkeleton.body(),
          size: Size(width, 500),
          brightness: brightness,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('body is only bubbles — no app bar of its own', (tester) async {
    await pump(tester, const ChatSkeleton.body());
    // The one app bar is the room's.
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('page has a back button that leaves the room', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ChatSkeleton.page(),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('takes the sent colour from the theme', (tester) async {
    await pump(tester, const ChatSkeleton.body());
    final primary = Theme.of(
      tester.element(find.byType(ChatSkeleton)),
    ).colorScheme.primary;
    final colours = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => (c.decoration as BoxDecoration?)?.color)
        .whereType<Color>()
        .toSet();
    expect(colours, contains(primary.withValues(alpha: 0.30)));
  });
}
