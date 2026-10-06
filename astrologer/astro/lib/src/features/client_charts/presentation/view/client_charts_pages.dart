import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/view/match_report_page.dart';
import '../../../workspace/presentation/widgets/async_page.dart';
import '../../data/client_charts_api.dart';

String _birthLine(AppLocalizations l, ClientChart c) => [
  if (c.birthDate != null) DateFormat.yMMMd(l.localeName).format(c.birthDate!),
  if (c.birthTime != null && c.birthTime!.length >= 5)
    c.birthTime!.substring(0, 5),
  if (c.place.isNotEmpty) c.place,
].join(' · ');

/// Charts the astrologer has cast on their own: tap one to open the full
/// kundali, add a new person, or remove one.
class ClientChartsPage extends StatelessWidget {
  const ClientChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<ClientChart>>(
      title: l.ccTitle,
      subtitle: l.ccSubtitle,
      load: getIt<ClientChartsApi>().list,
      bottomBar: (context, reload) => StickyActionBar(
        child: BusyButton(
          label: l.ccNew,
          icon: Icons.add_rounded,
          onPressed: () async {
            final added = await context.push<bool>(Routes.clientChartNew);
            if (added == true) await reload();
          },
        ),
      ),
      builder: (context, charts, _, reload) => charts.isEmpty
          ? [
              WsEmpty(
                icon: Icons.auto_awesome_rounded,
                hue: AstroPalette.career,
                title: l.ccEmpty,
                message: l.ccEmptyBody,
              ),
            ]
          : [for (final c in charts) _ChartCard(chart: c, onDeleted: reload)],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.chart, required this.onDeleted});

  final ClientChart chart;
  final Future<void> Function() onDeleted;

  Future<void> _delete(BuildContext context) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.ccDeleteTitle(chart.name)),
        content: Text(l.ccDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.wsRemove),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await getIt<ClientChartsApi>().delete(chart.id);
      await onDeleted();
    } catch (e) {
      if (context.mounted) showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final c = chart;
    return WsCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      onTap: () => context.push(Routes.clientKundali(c.id), extra: c.name),
      child: Row(
        children: [
          HueAvatar(name: c.name, hue: AstroPalette.forId(c.name), size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _birthLine(l, c),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
                if (c.moonSign.isNotEmpty)
                  Text(
                    l.ccMoonSign(c.moonSign),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AstroPalette.career.end,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.wsRemove,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _delete(context),
          ),
        ],
      ),
    );
  }
}

/// Name, gender, date, time and place of birth. Pops `true` once saved.
class NewClientChartPage extends StatefulWidget {
  const NewClientChartPage({super.key});

  @override
  State<NewClientChartPage> createState() => _NewClientChartPageState();
}

class _NewClientChartPageState extends State<NewClientChartPage> {
  final _name = TextEditingController();
  final _placeQuery = TextEditingController();
  Timer? _debounce;

  String _gender = 'male';
  DateTime? _date;
  TimeOfDay? _time;
  bool _timeUnknown = false;
  PlaceHit? _place;
  List<PlaceHit> _hits = const [];
  bool _saving = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _placeQuery.dispose();
    super.dispose();
  }

  bool get _ready =>
      _name.text.trim().isNotEmpty &&
      _date != null &&
      (_time != null || _timeUnknown) &&
      _place != null;

  void _onPlaceChanged(String text) {
    // Typing after picking means they want a different place.
    if (_place != null && text != _place!.name) setState(() => _place = null);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final hits = await getIt<ClientChartsApi>().searchPlaces(text);
        if (mounted && text == _placeQuery.text) setState(() => _hits = hits);
      } catch (_) {}
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(now.year - 30),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        _timeUnknown = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_ready || _saving) return;
    setState(() => _saving = true);
    String two(int n) => n.toString().padLeft(2, '0');
    try {
      await getIt<ClientChartsApi>().create(
        name: _name.text,
        gender: _gender,
        birthDate: _date!,
        birthTime: _timeUnknown || _time == null
            ? null
            : '${two(_time!.hour)}:${two(_time!.minute)}:00',
        place: _place!,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return SubPageScaffold(
      title: l.ccNew,
      bottomBar: StickyActionBar(
        child: BusyButton(
          label: l.ccSave,
          icon: Icons.auto_awesome_rounded,
          busy: _saving,
          onPressed: _ready ? _save : null,
        ),
      ),
      children: [
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: l.ccName),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: [
            for (final g in const ['male', 'female', 'other'])
              ChoiceChip(
                label: Text(switch (g) {
                  'male' => l.ccMale,
                  'female' => l.ccFemale,
                  _ => l.ccOther,
                }),
                selected: g == _gender,
                onSelected: (_) => setState(() => _gender = g),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(
                  _date == null
                      ? l.ccBirthDate
                      : DateFormat.yMMMd(l.localeName).format(_date!),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _timeUnknown ? null : _pickTime,
                icon: const Icon(Icons.schedule_rounded, size: 18),
                label: Text(
                  _time == null ? l.ccBirthTime : _time!.format(context),
                ),
              ),
            ),
          ],
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _timeUnknown,
          onChanged: (v) => setState(() => _timeUnknown = v ?? false),
          title: Text(l.ccTimeUnknown),
          subtitle: Text(l.ccTimeUnknownHint),
        ),
        TextField(
          controller: _placeQuery,
          onChanged: _onPlaceChanged,
          decoration: InputDecoration(
            labelText: l.ccBirthPlace,
            prefixIcon: const Icon(Icons.place_rounded),
            suffixIcon: _place == null
                ? null
                : Icon(Icons.check_circle_rounded, color: brand.online),
          ),
        ),
        if (_place == null)
          for (final h in _hits)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_city_rounded),
              title: Text(h.name),
              onTap: () => setState(() {
                _place = h;
                _placeQuery.text = h.name;
                _hits = const [];
                FocusScope.of(context).unfocus();
              }),
            ),
      ],
    );
  }
}

/// What the matchmaking page needs: the saved charts and the matches so far.
class _MatchData {
  const _MatchData(this.charts, this.matches);

  final List<ClientChart> charts;
  final List<MatchRow> matches;
}

/// Guna Milan between two saved charts.
class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  String? _boy;
  String? _girl;
  bool _running = false;

  Future<_MatchData> _load() async {
    final api = getIt<ClientChartsApi>();
    final charts = api.list();
    final matches = api.matches().catchError((_) => <MatchRow>[]);
    return _MatchData(await charts, await matches);
  }

  Future<void> _run(Future<void> Function() reload) async {
    final boy = _boy;
    final girl = _girl;
    if (boy == null || girl == null || _running) return;
    setState(() => _running = true);
    try {
      final report = await getIt<ClientChartsApi>().match(
        boyId: boy,
        girlId: girl,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MatchReportPage.standalone(report: report),
        ),
      );
      await reload();
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _running = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<_MatchData>(
      title: l.mmTitle,
      subtitle: l.mmSubtitle,
      load: _load,
      builder: (context, data, _, reload) {
        final theme = Theme.of(context);
        final brand = context.brand;
        if (data.charts.length < 2) {
          return [
            WsEmpty(
              icon: Icons.favorite_rounded,
              hue: AstroPalette.love,
              title: l.mmNeedTwo,
              message: l.mmNeedTwoBody,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final added = await context.push<bool>(Routes.clientChartNew);
                if (added == true) await reload();
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l.ccNew),
            ),
          ];
        }
        Widget picker(String label, String? value, ValueChanged<String?> set) =>
            DropdownButtonFormField<String>(
              initialValue: value,
              isExpanded: true,
              decoration: InputDecoration(labelText: label),
              items: [
                for (final c in data.charts)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: set,
            );
        return [
          picker(l.mmBoy, _boy, (v) => setState(() => _boy = v)),
          const SizedBox(height: 12),
          picker(l.mmGirl, _girl, (v) => setState(() => _girl = v)),
          const SizedBox(height: 16),
          BusyButton(
            label: l.mmRun,
            icon: Icons.favorite_rounded,
            busy: _running,
            onPressed: _boy != null && _girl != null && _boy != _girl
                ? () => _run(reload)
                : null,
          ),
          if (data.matches.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l.mmRecent,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: brand.inkMuted,
              ),
            ),
            const SizedBox(height: 10),
            for (final m in data.matches)
              WsCard(
                onTap: () {
                  setState(() {
                    _boy = m.summary.boy?.id;
                    _girl = m.summary.girl?.id;
                  });
                  _run(reload);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${m.summary.boy?.name ?? ''} · '
                            '${m.summary.girl?.name ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            TimeFormat.relative(l, m.createdAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${m.summary.totalPoints.toStringAsFixed(m.summary.totalPoints % 1 == 0 ? 0 : 1)}'
                      ' / ${m.summary.maxPoints.round()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AstroPalette.love.end,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ];
      },
    );
  }
}
