import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

class _Backend extends Fake implements CallBackend {}

class _Signaling extends Fake implements CallSignaling {}

class _Engine extends Fake implements RtcEngine {}

class _Perms extends Fake implements CallPermissions {}

void main() {
  testWidgets('minimizing the way both apps do it does not loop', (t) async {
    final call = CallController(
      backend: _Backend(),
      signaling: _Signaling(),
      engine: _Engine(),
      permissions: _Perms(),
    );
    final nav = GlobalKey<NavigatorState>();
    var minimized = 0;

    await t.pumpWidget(
      MaterialApp(navigatorKey: nav, home: const Scaffold(body: Text('home'))),
    );
    unawaited(nav.currentState!.push(
      MaterialPageRoute<void>(
        builder: (room) => BlocProvider.value(
          value: call,
          child: CallScreen(
            peerName: 'Ravi',
            // exactly what both apps' rooms pass today
            onMinimize: () {
              minimized++;
              if (minimized > 50) throw StateError('minimize loops forever');
              Navigator.of(room).maybePop();
            },
          ),
        ),
      ),
    ));
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));
    expect(find.byType(CallScreen), findsOneWidget);

    await t.tap(find.byTooltip(const CallStrings().minimize));
    await t.pump();

    expect(minimized, 1, reason: 'minimize re-entered itself');
  });
}
