import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/availability/availability_coordinator.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';
import 'next_online_sheet.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Which consultation types are accepted, and when a type switched off is
/// back. Online itself is the Home toggle; there is no weekly schedule — with
/// every type waiting for its next-online time the astrologer is offline.
class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});
  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  final _api = getIt<ProfileApi>();

  Set<String> _channels = {};
  // Types switched off until a time the astrologer gave; saved at once
  // from the sheet, not with the rest of the page.
  Map<String, DateTime> _nextOnline = {};

  // Snapshot of the saved state, for dirty-checking.
  String _savedKey = '';

  bool _loading = true;
  bool _failed = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String get _key => (_channels.toList()..sort()).join(',');

  bool get _dirty => !_loading && _key != _savedKey;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final av = await _api.availability();
      if (!mounted) return;
      setState(() {
        _channels = {...av.channels};
        _nextOnline = {...av.nextOnline};
        _loading = false;
        _savedKey = _key;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _save() async {
    final l = context.l10n;
    setState(() => _saving = true);
    try {
      await _api.setAvailability(
        channels: kChannels.where(_channels.contains).toList(),
      );
      _savedKey = _key;
      // Every type off is offline: the Home panel says so now.
      unawaited(getIt<AvailabilityCoordinator>().refresh());
      if (mounted) showToast(context, l.commonSaved);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toggleChannel(String ch) {
    if (_channels.contains(ch) && _channels.length == 1) {
      showToast(context, context.l10n.hoursNeedChannel);
      return;
    }
    setState(() {
      if (!_channels.remove(ch)) {
        _channels.add(ch);
        // On by hand means on now; saving drops the time on the server too.
        _nextOnline.remove(ch);
      }
    });
  }

  Future<void> _askNextOnline(String ch) async {
    final choice = await showNextOnlineSheet(
      context,
      channel: ch,
      current: _nextOnline[ch],
    );
    if (choice == null || !mounted) return;
    final l = context.l10n;
    final label = channelStyle(context, ch).label;
    final at = choice.at;
    final wasDirty = _dirty;
    try {
      final av = at == null
          ? await _api.clearNextOnline(ch)
          : await _api.setNextOnline(ch, at);
      unawaited(getIt<AvailabilityCoordinator>().refresh());
      if (!mounted) return;
      setState(() {
        _nextOnline = {...av.nextOnline};
        av.channels.contains(ch) ? _channels.add(ch) : _channels.remove(ch);
        // This went to the server already: it is not an unsaved edit.
        if (!wasDirty) _savedKey = _key;
      });
      showToast(
        context,
        at == null
            ? l.nextOnlineCleared(label)
            : l.nextOnlineDone(label, nextOnlineLabel(context, at)),
      );
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dirty = _dirty;
    return SubPageScaffold(
      title: l.profileHours,
      canPop: !dirty || _saving,
      onPopBlocked: () => _confirmDiscard(context),
      bottomBar: dirty
          ? StickyActionBar(
              child: BusyButton(
                label: l.commonSave,
                busy: _saving,
                onPressed: _save,
              ),
            )
          : null,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_failed)
          ErrorView(message: l.commonLoadFailed, onRetry: _load)
        else
          SettingsCard(
            title: l.hoursChannels,
            subtitle: l.hoursChannelsHint,
            icon: Icons.forum_rounded,
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                for (final ch in kChannels)
                  _ChannelSwitch(
                    channel: ch,
                    value: _channels.contains(ch),
                    nextOnline: _nextOnline[ch],
                    onChanged: () => _toggleChannel(ch),
                    onNextOnline: () => _askNextOnline(ch),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final l = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.editDiscardTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.editKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.editDiscard),
          ),
        ],
      ),
    );
    if ((discard ?? false) && context.mounted) Navigator.of(context).pop();
  }
}

class _ChannelSwitch extends StatelessWidget {
  const _ChannelSwitch({
    required this.channel,
    required this.value,
    required this.onChanged,
    required this.onNextOnline,
    this.nextOnline,
  });

  final String channel;
  final bool value;
  final VoidCallback onChanged;

  /// When this type comes back by itself, while it is off until a set time.
  final DateTime? nextOnline;
  final VoidCallback onNextOnline;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ch = channelStyle(context, channel);
    final back = nextOnline;
    final waiting = !value && back != null && back.isAfter(DateTime.now());
    return SwitchListTile(
      value: value,
      onChanged: (_) => onChanged(),
      secondary: HueIcon(hue: ch.hue, icon: ch.icon, size: 36, iconSize: 18),
      title: Text(
        ch.label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Align(
        alignment: AlignmentDirectional.centerStart,
        child: InkWell(
          onTap: onNextOnline,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    waiting
                        ? l.nextOnlineBack(nextOnlineLabel(context, back))
                        : l.nextOnlineSet,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
