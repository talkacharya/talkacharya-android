import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';

/// What the astrologer chose in the sheet: a time to be back at, or — with
/// [at] null — to take the channel again right now.
class NextOnlineChoice {
  const NextOnlineChoice(this.at);
  final DateTime? at;
}

/// How far ahead a next-online time can be (the backend's limit).
const kNextOnlineMaxDays = 30;

const _slotMinutes = 15;
const _slotCount = 12;
const _listedDays = 7;
const _fallbackDayStart = TimeOfDay(hour: 9, minute: 0);

/// "Today, 5:00 PM" · "Tomorrow, 9:00 AM" · "12 Oct, 9:00 AM".
String nextOnlineLabel(BuildContext context, DateTime at) {
  final l = context.l10n;
  final time = TimeOfDay.fromDateTime(at).format(context);
  return l.nextOnlineWhen(_dayLabel(l, DateUtils.dateOnly(at)), time);
}

String _dayLabel(AppLocalizations l, DateTime day) {
  final today = DateUtils.dateOnly(DateTime.now());
  final ahead = day.difference(today).inHours / 24;
  if (ahead.round() == 0) return l.nextOnlineToday;
  if (ahead.round() == 1) return l.nextOnlineTomorrow;
  return DateFormat('d MMM', l.localeName).format(day);
}

/// Asks when the astrologer will take [channel] again: a day on the left, a
/// time on the right. Only the next few quarter-hours are listed; any other
/// day or time comes from the pickers at the foot of each column.
///
/// [dayStart] says where the listed times begin on a day other than today
/// (their working hours, when they keep any).
Future<NextOnlineChoice?> showNextOnlineSheet(
  BuildContext context, {
  required String channel,
  DateTime? current,
  TimeOfDay? Function(DateTime day)? dayStart,
}) {
  final label = channelStyle(context, channel).label;
  return showAppSheet<NextOnlineChoice>(
    context: context,
    title: context.l10n.nextOnlineSheetTitle(label),
    builder: (_) => _NextOnlineSheet(
      channelLabel: label,
      current: current,
      dayStart: dayStart,
    ),
  );
}

class _NextOnlineSheet extends StatefulWidget {
  const _NextOnlineSheet({
    required this.channelLabel,
    required this.current,
    required this.dayStart,
  });

  final String channelLabel;
  final DateTime? current;
  final TimeOfDay? Function(DateTime day)? dayStart;

  @override
  State<_NextOnlineSheet> createState() => _NextOnlineSheetState();
}

class _NextOnlineSheetState extends State<_NextOnlineSheet> {
  late final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late DateTime _day;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    final current = widget.current;
    if (current != null && current.isAfter(DateTime.now())) {
      _day = DateUtils.dateOnly(current);
      _time = TimeOfDay.fromDateTime(current);
    } else {
      _day = _today;
    }
  }

  List<DateTime> get _days => [
    for (var i = 0; i < _listedDays; i++) DateUtils.addDaysToDate(_today, i),
  ];

  /// The quarter-hours offered for [_day]: from the next one after now for
  /// today, from the start of the working day otherwise.
  List<TimeOfDay> get _slots {
    final int first;
    if (DateUtils.isSameDay(_day, _today)) {
      final now = TimeOfDay.now();
      first = ((now.hour * 60 + now.minute) ~/ _slotMinutes + 1) * _slotMinutes;
    } else {
      final start = widget.dayStart?.call(_day) ?? _fallbackDayStart;
      first = start.hour * 60 + start.minute;
    }
    return [
      for (
        var m = first;
        m < 24 * 60 && m < first + _slotCount * _slotMinutes;
        m += _slotMinutes
      )
        TimeOfDay(hour: m ~/ 60, minute: m % 60),
    ];
  }

  DateTime? get _chosen {
    final t = _time;
    if (t == null) return null;
    return DateTime(_day.year, _day.month, _day.day, t.hour, t.minute);
  }

  bool get _valid => _chosen?.isAfter(DateTime.now()) ?? false;

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: _today,
      lastDate: DateUtils.addDaysToDate(_today, kNextOnlineMaxDays),
    );
    if (picked != null && mounted) {
      setState(() => _day = DateUtils.dateOnly(picked));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? _slots.firstOrNull ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  void _confirm() {
    if (!_valid) {
      showToast(context, context.l10n.nextOnlinePast);
      return;
    }
    Navigator.of(context).pop(NextOnlineChoice(_chosen));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final days = _days;
    final slots = _slots;
    final dayListed = days.any((d) => DateUtils.isSameDay(d, _day));
    final time = _time;
    final timeListed = time == null || slots.contains(time);
    final chosen = _chosen;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.nextOnlineInfo(widget.channelLabel),
          style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.42,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Column(
                  title: l.nextOnlineDay,
                  children: [
                    for (final d in days)
                      _Option(
                        label: _dayLabel(l, d),
                        // "Today" and "Tomorrow" carry their date underneath.
                        caption: d.difference(_today).inHours < 36
                            ? DateFormat('d MMM', l.localeName).format(d)
                            : DateFormat.EEEE(l.localeName).format(d),
                        selected: DateUtils.isSameDay(d, _day),
                        onTap: () => setState(() => _day = d),
                      ),
                    if (!dayListed)
                      _Option(
                        label: _dayLabel(l, _day),
                        caption: DateFormat.EEEE(l.localeName).format(_day),
                        selected: true,
                        onTap: _pickDay,
                      ),
                    _Option(
                      label: l.nextOnlinePickDate,
                      icon: Icons.calendar_month_rounded,
                      onTap: _pickDay,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Column(
                  title: l.nextOnlineTime,
                  children: [
                    if (!timeListed)
                      _Option(
                        label: time.format(context),
                        selected: true,
                        onTap: _pickTime,
                      ),
                    for (final s in slots)
                      _Option(
                        label: s.format(context),
                        selected: s == time,
                        onTap: () => setState(() => _time = s),
                      ),
                    _Option(
                      label: l.nextOnlineCustomTime,
                      icon: Icons.schedule_rounded,
                      onTap: _pickTime,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: chosen == null ? null : _confirm,
          child: Text(
            chosen == null
                ? l.nextOnlineConfirm
                : l.nextOnlineConfirmAt(nextOnlineLabel(context, chosen)),
          ),
        ),
        if (widget.current != null)
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(const NextOnlineChoice(null)),
            child: Text(l.nextOnlineTurnOn(widget.channelLabel)),
          ),
      ],
    );
  }
}

/// One scrolling column of the sheet under a small heading.
class _Column extends StatelessWidget {
  const _Column({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: context.brand.inkMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => children[i],
          ),
        ),
      ],
    );
  }
}

/// A day or a time to pick; with an [icon] it opens a picker instead.
class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.onTap,
    this.caption,
    this.icon,
    this.selected = false,
  });

  final String label;
  final String? caption;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final ink = selected || icon != null ? primary : null;
    return Material(
      color: selected ? primary.withValues(alpha: 0.10) : Colors.transparent,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(color: selected ? primary : brand.hairline),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: primary),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    if (caption != null)
                      Text(
                        caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_rounded, size: 18, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}
