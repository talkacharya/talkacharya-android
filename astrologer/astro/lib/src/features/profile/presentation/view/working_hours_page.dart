import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';

const _defaultStart = TimeOfDay(hour: 9, minute: 0);
const _defaultEnd = TimeOfDay(hour: 21, minute: 0);

/// Which consultation types are accepted, how many chats at once, and the
/// weekly schedule (one window per day).
class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});
  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  final _api = getIt<ProfileApi>();

  Set<String> _channels = {};
  int _maxConcurrent = 1;
  final Map<int, WorkingWindow> _week = {};

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

  String get _key => [
    (_channels.toList()..sort()).join(','),
    _maxConcurrent,
    for (var d = 0; d < 7; d++)
      _week[d] == null ? '-' : _week[d]!.toJson().values.join('/'),
  ].join('|');

  bool get _dirty => !_loading && _key != _savedKey;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final results = await Future.wait([
        _api.availability(),
        _api.workingHours(),
      ]);
      if (!mounted) return;
      final av = results[0] as AvailabilitySettings;
      final hours = results[1] as List<WorkingWindow>;
      setState(() {
        _channels = {...av.channels};
        _maxConcurrent = av.maxConcurrent;
        _week
          ..clear()
          // One window per day in this editor; keep the first if several.
          ..addAll({for (final w in hours.reversed) w.weekday: w});
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
    if (_week.values.any((w) => !w.isValid)) {
      showToast(context, l.hoursInvalid);
      return;
    }
    setState(() => _saving = true);
    try {
      await _api.setAvailability(
        channels: kChannels.where(_channels.contains).toList(),
        maxConcurrent: _maxConcurrent,
      );
      await _api.setWorkingHours([for (var d = 0; d < 7; d++) ?_week[d]]);
      _savedKey = _key;
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
    setState(
      () => _channels.contains(ch) ? _channels.remove(ch) : _channels.add(ch),
    );
  }

  Future<void> _pickTime(int day, {required bool start}) async {
    final w = _week[day]!;
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? w.start : w.end,
    );
    if (picked == null || !mounted) return;
    setState(
      () => _week[day] = start
          ? w.copyWith(start: picked)
          : w.copyWith(end: picked),
    );
  }

  void _copyToAll(int day) {
    final w = _week[day]!;
    setState(() {
      for (var d = 0; d < 7; d++) {
        _week[d] = w.copyWith(weekday: d);
      }
    });
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
        else ...[
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
                    onChanged: () => _toggleChannel(ch),
                  ),
              ],
            ),
          ),
          if (_channels.contains('chat'))
            SettingsCard(
              title: l.hoursConcurrent,
              subtitle: l.hoursConcurrentHint,
              icon: Icons.dynamic_feed_rounded,
              hue: AstroPalette.money,
              trailing: _Stepper(
                value: _maxConcurrent,
                min: 1,
                max: 10,
                onChanged: (v) => setState(() => _maxConcurrent = v),
              ),
              padding: EdgeInsets.zero,
              child: const SizedBox.shrink(),
            ),
          SettingsCard(
            title: l.hoursSchedule,
            subtitle: l.hoursScheduleHint,
            icon: Icons.calendar_month_rounded,
            hue: AstroPalette.air,
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                for (var d = 0; d < 7; d++)
                  _DayRow(
                    weekday: d,
                    window: _week[d],
                    onToggle: (on) => setState(() {
                      if (on) {
                        _week[d] = WorkingWindow(
                          weekday: d,
                          start:
                              _week.values.firstOrNull?.start ?? _defaultStart,
                          end: _week.values.firstOrNull?.end ?? _defaultEnd,
                        );
                      } else {
                        _week.remove(d);
                      }
                    }),
                    onStart: () => _pickTime(d, start: true),
                    onEnd: () => _pickTime(d, start: false),
                    onCopyToAll: () => _copyToAll(d),
                  ),
              ],
            ),
          ),
        ],
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
  });

  final String channel;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final ch = channelStyle(context, channel);
    return SwitchListTile(
      value: value,
      onChanged: (_) => onChanged(),
      secondary: HueIcon(hue: ch.hue, icon: ch.icon, size: 36, iconSize: 18),
      title: Text(
        ch.label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.brand.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.weekday,
    required this.window,
    required this.onToggle,
    required this.onStart,
    required this.onEnd,
    required this.onCopyToAll,
  });

  final int weekday;
  final WorkingWindow? window;
  final ValueChanged<bool> onToggle;
  final VoidCallback onStart;
  final VoidCallback onEnd;
  final VoidCallback onCopyToAll;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    // 2024-01-01 was a Monday, matching the backend's 0 = Monday.
    final dayName = DateFormat.EEEE(
      l.localeName,
    ).format(DateTime(2024, 1, 1 + weekday));
    final w = window;
    final invalid = w != null && !w.isValid;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              dayName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: w == null ? brand.inkMuted : null,
              ),
            ),
          ),
          Expanded(
            child: w == null
                ? Text(l.hoursOff, style: TextStyle(color: brand.inkMuted))
                : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      _TimeChip(time: w.start, error: invalid, onTap: onStart),
                      Text('–', style: TextStyle(color: brand.inkMuted)),
                      _TimeChip(time: w.end, error: invalid, onTap: onEnd),
                    ],
                  ),
          ),
          if (w != null)
            PopupMenuButton<void>(
              icon: Icon(Icons.more_vert_rounded, color: brand.inkMuted),
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: onCopyToAll,
                  child: Text(l.hoursCopyToAll),
                ),
              ],
            ),
          Switch(value: w != null, onChanged: onToggle),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.time,
    required this.onTap,
    this.error = false,
  });

  final TimeOfDay time;
  final VoidCallback onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final color = error ? brand.live : Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          time.format(context),
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
