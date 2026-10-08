import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../workspace/data/workspace_api.dart';

/// Reads this phone's settings and keeps them fresh while a screen is open:
/// re-checked whenever the app comes back from the system settings.
mixin CallReadinessWatcher<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  CallReadinessReport? readiness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(refreshReadiness());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refreshReadiness());
  }

  Future<void> refreshReadiness() async {
    final report = await CallReadiness.check(
      callChannelId: LocalNotifications.callChannelId,
    );
    if (mounted) setState(() => readiness = report);
  }
}

/// "Ring on a locked phone": everything this phone needs before a consultation
/// rings it with the screen off — each with its state and a button to the
/// setting — and a test call to prove it.
class CallSetupPage extends StatefulWidget {
  const CallSetupPage({this.tested = false, super.key});

  /// Opened by answering a test call: it reached the phone.
  final bool tested;

  @override
  State<CallSetupPage> createState() => _CallSetupPageState();
}

class _CallSetupPageState extends State<CallSetupPage>
    with WidgetsBindingObserver, CallReadinessWatcher {
  bool _sending = false;

  Future<void> _open(CallReadinessItem item) => CallReadiness.open(
    item,
    callChannelId: LocalNotifications.callChannelId,
  );

  Future<void> _testRing() async {
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      final sent = await getIt<WorkspaceApi>().testRing();
      if (!mounted) return;
      showToast(
        context,
        sent.phones == 0
            ? l.callSetupTestNoPhone
            : l.callSetupTestSent(sent.ringsInSeconds),
      );
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final report = readiness;

    return SubPageScaffold(
      title: l.callSetupTitle,
      subtitle: l.callSetupSubtitle,
      onRefresh: refreshReadiness,
      children: [
        if (widget.tested) _Banner(ok: true, text: l.callSetupTestWorked),
        if (report == null)
          _Banner(ok: true, text: l.callSetupNotAndroid)
        else ...[
          _Banner(
            ok: report.ready,
            text: report.ready ? l.callSetupReady : l.callSetupNotReady,
          ),
          const SizedBox(height: 12),
          for (final MapEntry(key: item, value: on) in report.readable.entries)
            _Row(
              item: item,
              on: on,
              onFix: () => _open(item),
            ),
          if (report.hasAutostart)
            _Row(
              item: CallReadinessItem.autostart,
              on: null,
              onFix: () => _open(CallReadinessItem.autostart),
            ),
          if (report.hasLockScreenSwitch)
            _Row(
              item: CallReadinessItem.lockScreen,
              on: null,
              onFix: () => _open(CallReadinessItem.lockScreen),
            ),
        ],
        const SizedBox(height: 20),
        Text(
          l.callSetupTestTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(l.callSetupTestBody, style: theme.textTheme.bodySmall),
        const SizedBox(height: 10),
        BusyButton(
          label: l.callSetupTestButton,
          icon: Icons.ring_volume_rounded,
          busy: _sending,
          onPressed: _testRing,
        ),
      ],
    );
  }
}

String _title(AppLocalizations l, CallReadinessItem item) => switch (item) {
  CallReadinessItem.notifications => l.callSetupNotifications,
  CallReadinessItem.callChannel => l.callSetupCallChannel,
  CallReadinessItem.fullScreen => l.callSetupFullScreen,
  CallReadinessItem.battery => l.callSetupBattery,
  CallReadinessItem.autostart => l.callSetupAutostart,
  CallReadinessItem.lockScreen => l.callSetupLockScreen,
};

String _help(AppLocalizations l, CallReadinessItem item) => switch (item) {
  CallReadinessItem.notifications => l.callSetupNotificationsHelp,
  CallReadinessItem.callChannel => l.callSetupCallChannelHelp,
  CallReadinessItem.fullScreen => l.callSetupFullScreenHelp,
  CallReadinessItem.battery => l.callSetupBatteryHelp,
  CallReadinessItem.autostart => l.callSetupAutostartHelp,
  CallReadinessItem.lockScreen => l.callSetupLockScreenHelp,
};

class _Row extends StatelessWidget {
  const _Row({required this.item, required this.on, required this.onFix});

  final CallReadinessItem item;

  /// True / false when the app can read it; null for a maker's switch that
  /// can only be opened and checked by eye.
  final bool? on;
  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (icon, color) = switch (on) {
      true => (Icons.check_circle_rounded, const Color(0xFF30A46C)),
      false => (Icons.error_rounded, scheme.error),
      null => (Icons.help_rounded, const Color(0xFFB0691F)),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SettingsCard(
        icon: icon,
        hue: AstroPalette.career,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(l, item),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(_help(l, item), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (on != true) ...[
              const SizedBox(width: 8),
              FilledButton.tonal(
                // The theme's buttons are full width, which a Row cannot give.
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: onFix,
                child: Text(on == null ? l.callSetupCheck : l.callSetupFix),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = ok ? const Color(0xFF30A46C) : scheme.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.verified_rounded : Icons.notifications_off_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// On Home, only while something on this phone would stop a consultation from
/// ringing it with the screen off.
class CallSetupHomeCard extends StatefulWidget {
  const CallSetupHomeCard({required this.onOpen, super.key});

  final VoidCallback onOpen;

  @override
  State<CallSetupHomeCard> createState() => _CallSetupHomeCardState();
}

class _CallSetupHomeCardState extends State<CallSetupHomeCard>
    with WidgetsBindingObserver, CallReadinessWatcher {
  @override
  Widget build(BuildContext context) {
    final report = readiness;
    if (report == null || report.ready) return const SizedBox.shrink();
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onOpen,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.phone_locked_rounded, color: scheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.callSetupHomeTitle,
                      style: TextStyle(
                        color: scheme.onErrorContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.callSetupHomeBody,
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onErrorContainer),
            ],
          ),
        ),
      ),
    );
  }
}
