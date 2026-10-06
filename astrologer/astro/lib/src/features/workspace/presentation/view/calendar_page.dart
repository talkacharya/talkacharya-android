import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../livestream/data/live_api.dart';
import '../../../livestream/data/models/host_stream.dart';
import '../../../profile/data/profile_api.dart';
import '../../../profile/data/profile_models.dart';
import '../widgets/async_page.dart';
import 'notices_pages.dart';

/// What the calendar draws from: the weekly hours and the scheduled lives.
class Schedule {
  const Schedule({required this.hours, required this.streams});

  final List<WorkingWindow> hours;
  final List<HostStream> streams;

  /// Working windows on [day], earliest first. The backend counts weekdays
  /// from Monday = 0; Dart from Monday = 1.
  List<WorkingWindow> hoursOn(DateTime day) =>
      hours.where((w) => w.weekday == day.weekday - 1).toList()..sort(
        (a, b) => (a.start.hour * 60 + a.start.minute).compareTo(
          b.start.hour * 60 + b.start.minute,
        ),
      );

  /// Live streams still scheduled for [day].
  List<HostStream> streamsOn(DateTime day) => [
    for (final s in streams)
      if (s.status == 'scheduled' && s.scheduledAt != null)
        if (_sameDay(s.scheduledAt!.toLocal(), day)) s,
  ];

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// The next two weeks: which hours the astrologer has said they work each
/// day, and any live stream they have scheduled.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _day = _today();

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<Schedule> _load() async {
    final hours = getIt<ProfileApi>().workingHours();
    // A calendar without the lives is still a calendar.
    final streams = getIt<LiveApi>().mine().catchError((_) => <HostStream>[]);
    return Schedule(hours: await hours, streams: await streams);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<Schedule>(
      title: l.wsCalendar,
      subtitle: l.wsCalendarSubtitle,
      load: _load,
      builder: (context, schedule, _, _) {
        final theme = Theme.of(context);
        final brand = context.brand;
        final days = [
          for (var i = 0; i < 14; i++) _today().add(Duration(days: i)),
        ];
        final windows = schedule.hoursOn(_day);
        final streams = schedule.streamsOn(_day);
        final alwaysOn = schedule.hours.isEmpty;
        return [
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final d = days[i];
                final selected = d == _day;
                final marked =
                    schedule.hoursOn(d).isNotEmpty ||
                    schedule.streamsOn(d).isNotEmpty;
                return _DayChip(
                  day: d,
                  selected: selected,
                  marked: marked,
                  onTap: () => setState(() => _day = d),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat.yMMMMEEEEd(l.localeName).format(_day),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          for (final s in streams)
            WsCard(
              onTap: () => context.push(Routes.goLive),
              child: _Row(
                hue: AstroPalette.love,
                icon: Icons.videocam_rounded,
                title: s.title.isEmpty ? l.dashActionGoLive : s.title,
                subtitle: l.wsCalendarLiveAt(
                  DateFormat.jm(l.localeName).format(s.scheduledAt!.toLocal()),
                ),
              ),
            ),
          if (alwaysOn)
            WsCard(
              child: _Row(
                hue: AstroPalette.health,
                icon: Icons.all_inclusive_rounded,
                title: l.wsCalendarNoHours,
                subtitle: l.wsCalendarNoHoursBody,
              ),
            )
          else if (windows.isEmpty)
            WsCard(
              child: _Row(
                hue: AstroPalette.air,
                icon: Icons.bedtime_rounded,
                title: l.wsCalendarDayOff,
                subtitle: l.wsCalendarDayOffBody,
              ),
            )
          else
            for (final w in windows)
              WsCard(
                child: _Row(
                  hue: AstroPalette.health,
                  icon: Icons.schedule_rounded,
                  title:
                      '${w.start.format(context)} – ${w.end.format(context)}',
                  subtitle: l.wsCalendarWorking,
                ),
              ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () => context.go(Routes.profileWorkingHours),
            icon: const Icon(Icons.edit_calendar_rounded),
            label: Text(l.wsCalendarEdit),
          ),
          const SizedBox(height: 8),
          Text(
            l.wsCalendarNote,
            style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
          ),
        ];
      },
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.marked,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool marked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    final locale = context.l10n.localeName;
    final fg = selected ? scheme.onPrimary : brand.ink;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 52,
          decoration: BoxDecoration(
            color: selected ? scheme.primary : scheme.surface,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(
              color: selected ? scheme.primary : brand.hairline,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.E(locale).format(day),
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? fg : brand.inkMuted,
                ),
              ),
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !marked
                      ? Colors.transparent
                      : selected
                      ? fg
                      : brand.online,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.hue,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final AstroHue hue;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        HueIcon(hue: hue, icon: icon, size: 40, iconSize: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.brand.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Ways to reach the platform's support team, from the server's config.
Future<void> showHelplineSheet(BuildContext context) {
  final l = context.l10n;
  final support = getIt<ConfigRepository>().value.support;
  final whatsapp = support.whatsapp.replaceAll(RegExp(r'\D'), '');
  return showAppSheet<void>(
    context: context,
    title: l.wsHelpline,
    builder: (sheet) {
      Widget row(
        IconData icon,
        AstroHue hue,
        String title,
        String sub,
        String url,
      ) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: HueIcon(hue: hue, icon: icon, size: 40, iconSize: 20),
        title: Text(title),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Navigator.of(sheet).pop();
          openLink(context, url);
        },
      );
      final rows = [
        if (whatsapp.isNotEmpty)
          row(
            Icons.chat_rounded,
            AstroPalette.health,
            l.wsHelpWhatsapp,
            support.whatsapp,
            'https://wa.me/$whatsapp',
          ),
        if (support.email.isNotEmpty)
          row(
            Icons.mail_rounded,
            AstroPalette.career,
            l.wsHelpEmail,
            support.email,
            'mailto:${support.email}',
          ),
        if (support.helpUrl.isNotEmpty)
          row(
            Icons.help_rounded,
            AstroPalette.air,
            l.wsHelpCentre,
            l.wsHelpCentreSub,
            support.helpUrl,
          ),
      ];
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: rows.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(l.wsHelpNone),
                ),
              ]
            : rows,
      );
    },
  );
}
