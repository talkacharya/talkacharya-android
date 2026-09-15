import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../kundali/presentation/kundali_terms.dart';
import '../../data/models/day_panchang.dart';
import '../cubit/panchang_cubit.dart';
import 'place_picker_sheet.dart';

/// Full daily panchang (`/panchang`, `?date=YYYY-MM-DD`) for a chosen city.
class PanchangPage extends StatelessWidget {
  const PanchangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.brand.canvas,
        body: BlocBuilder<PanchangCubit, PanchangState>(
          builder: (context, state) {
            final cubit = context.read<PanchangCubit>();
            final day = state.day.value;
            return RefreshIndicator(
              edgeOffset: 90,
              onRefresh: cubit.load,
              child: CustomScrollView(
                slivers: [
                  _Hero(state: state),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                    sliver: SliverList.list(
                      children: [
                        if (state.needsPlace)
                          const _ChoosePlaceCard()
                        else if (day == null && state.day.isError)
                          _LoadError(error: state.day.error)
                        else if (day == null)
                          const _BodySkeleton()
                        else
                          ..._sections(context, state, day),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _sections(
    BuildContext context,
    PanchangState state,
    DayPanchang day,
  ) {
    final isToday = state.date == context.read<PanchangCubit>().today;
    final now = isToday ? day.placeNow() : null;
    final profile = context.select(
      (BirthProfilesCubit c) => c.state.resolvedProfile,
    );
    return FadeSlideIn.list([
      if (now != null) _NowCard(day: day, now: now),
      _LimbsCard(day: day),
      _TimingsCard(day: day, now: now),
      _ChoghadiyaCard(day: day, now: now),
      if (day.notes.isNotEmpty) _NotesCard(notes: day.notes),
      if (profile != null)
        _PersonalCta(
          onTap: () => context.push('/kundali/${profile.id}/muhurta'),
        ),
      _Footer(day: day, place: state.place),
    ]);
  }
}

// --- formatting ----------------------------------------------------------------

String _time(BuildContext context, PlaceTime t) => DateFormat.jm(
  Localizations.localeOf(context).toLanguageTag(),
).format(t.local);

String _range(BuildContext context, TimeWindow w) =>
    '${_time(context, w.start)} – ${_time(context, w.end)}';

/// "till 10:42 PM", or "till 6:12 AM, 14 Sep" when it runs into another day.
String _till(BuildContext context, TimeWindow? w, DateTime pageDate) {
  if (w == null) return '';
  final l = context.l10n;
  final end = w.end;
  final sameDay =
      end.date.year == pageDate.year &&
      end.date.month == pageDate.month &&
      end.date.day == pageDate.day;
  final locale = Localizations.localeOf(context).toLanguageTag();
  final label = sameDay
      ? _time(context, end)
      : '${_time(context, end)}, ${DateFormat('d MMM', locale).format(end.date)}';
  return l.panchangTill(label);
}

// --- hero ------------------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero({required this.state});
  final PanchangState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final cubit = context.read<PanchangCubit>();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final day = state.day.value;
    final isToday = state.date == cubit.today;
    final tithi = day?.tithi;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 300,
      backgroundColor: brand.cosmicStart,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        l.panchangTitle,
        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      actions: [
        if (!isToday)
          TextButton(
            onPressed: () => cubit.setDate(cubit.today),
            style: TextButton.styleFrom(foregroundColor: brand.glowAccent),
            child: Text(l.panchangToday),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            const CosmicBackdrop(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 58, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _PlaceChip(state: state),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ArrowButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => cubit.shiftDays(-1),
                        ),
                        Expanded(
                          child: Pressable(
                            child: GestureDetector(
                              onTap: () => _pickDate(context),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat(
                                      'EEEE, d MMMM yyyy',
                                      locale,
                                    ).format(state.date),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: brand.onCosmic,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_month_rounded,
                                        size: 13,
                                        color: brand.onCosmicMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isToday
                                            ? l.panchangToday
                                            : l.panchangPickDate,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: brand.onCosmicMuted,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _ArrowButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => cubit.shiftDays(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: tithi == null
                          ? const SizedBox(height: 58)
                          : Column(
                              key: ValueKey('${state.date}-${tithi.name}'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tithi.detail.isEmpty
                                      ? KTerms.tithiName(l, tithi.name)
                                      : '${KTerms.pakshaName(l, tithi.detail)} '
                                            '${KTerms.tithiName(l, tithi.name)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: brand.onCosmic,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    KTerms.vaaraName(l, day!.vaara),
                                    if (day.moonSign.isNotEmpty)
                                      l.panchangMoonIn(
                                        KTerms.signName(l, day.moonSign),
                                      ),
                                  ].join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.onCosmicMuted,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _SunPill(
                          icon: Icons.wb_sunny_rounded,
                          label: l.birthDetailsSunrise,
                          value: day?.sunrise == null
                              ? '—'
                              : _time(context, day!.sunrise!),
                        ),
                        const SizedBox(width: 8),
                        _SunPill(
                          icon: Icons.wb_twilight_rounded,
                          label: l.birthDetailsSunset,
                          value: day?.sunset == null
                              ? '—'
                              : _time(context, day!.sunset!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<PanchangCubit>();
    final today = cubit.today;
    final picked = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: today.subtract(const Duration(days: PanchangCubit.maxDays)),
      lastDate: today.add(const Duration(days: PanchangCubit.maxDays)),
    );
    if (picked != null) await cubit.setDate(picked);
  }
}

class _PlaceChip extends StatelessWidget {
  const _PlaceChip({required this.state});
  final PanchangState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final name = state.place?.name ?? '';
    return Pressable(
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.24)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _changePlace(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.place_rounded,
                  size: 16,
                  color: AstroPalette.money.start,
                ),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Text(
                    name.isEmpty ? l.panchangChoosePlaceCta : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: brand.onCosmic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: brand.onCosmicMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _changePlace(BuildContext context) async {
  final cubit = context.read<PanchangCubit>();
  final profile = context.read<BirthProfilesCubit>().state.resolvedProfile;
  final lat = double.tryParse(profile?.latitude ?? '');
  final lon = double.tryParse(profile?.longitude ?? '');
  final birthPlace =
      profile != null &&
          lat != null &&
          lon != null &&
          (lat != 0 || lon != 0) &&
          profile.birthPlaceName.isNotEmpty
      ? PanchangPlace(
          name: profile.birthPlaceName,
          latitude: lat,
          longitude: lon,
        )
      : null;
  final picked = await showPanchangPlacePicker(
    context,
    suggestion: birthPlace != cubit.state.place ? birthPlace : null,
  );
  if (picked != null) await cubit.setPlace(picked);
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        minimumSize: const Size(40, 40),
      ),
    );
  }
}

class _SunPill extends StatelessWidget {
  const _SunPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AstroPalette.money.start),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.onCosmicMuted,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: brand.onCosmic,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- body cards ------------------------------------------------------------------

/// What's running right now at the place: the choghadiya, and a warning while
/// Rahu Kaal is on.
class _NowCard extends StatelessWidget {
  const _NowCard({required this.day, required this.now});
  final DayPanchang day;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final slot = [
      ...day.dayChoghadiya,
      ...day.nightChoghadiya,
    ].where((s) => s.window.contains(now)).firstOrNull;
    final rahu = day.rahuKaal;
    final rahuOn = rahu != null && rahu.contains(now);
    if (slot == null && !rahuOn) return const SizedBox.shrink();
    final hue = _qualityHue(slot?.quality ?? 'neutral');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: HueTile(
        hue: hue,
        radius: 18,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            HueIcon(hue: hue, icon: Icons.schedule_rounded, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.panchangRightNow.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: hue.end,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (slot != null)
                    Text(
                      l.panchangNowChoghadiya(
                        KTerms.choghadiyaName(l, slot.name),
                        _time(context, slot.window.end),
                      ),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (rahuOn)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        l.panchangRahuNow(_time(context, rahu.end)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.live,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimbsCard extends StatelessWidget {
  const _LimbsCard({required this.day});
  final DayPanchang day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = day;
    final rows = <(IconData, AstroHue, String, String, String)>[
      if (d.tithi != null)
        (
          Icons.dark_mode_rounded,
          AstroPalette.air,
          l.birthDetailsTithi,
          d.tithi!.detail.isEmpty
              ? KTerms.tithiName(l, d.tithi!.name)
              : '${KTerms.pakshaName(l, d.tithi!.detail)} ${KTerms.tithiName(l, d.tithi!.name)}',
          _till(context, d.tithi!.span, d.date),
        ),
      if (d.nakshatra != null)
        (
          Icons.auto_awesome_rounded,
          AstroPalette.career,
          l.birthDetailsNakshatra,
          int.tryParse(d.nakshatra!.detail) == null
              ? KTerms.nakshatraName(l, d.nakshatra!.name)
              : '${KTerms.nakshatraName(l, d.nakshatra!.name)} · '
                    '${l.birthDetailsPada(int.parse(d.nakshatra!.detail))}',
          _till(context, d.nakshatra!.span, d.date),
        ),
      if (d.yoga != null)
        (
          Icons.self_improvement_rounded,
          AstroPalette.health,
          l.birthDetailsYoga,
          KTerms.yogaName(l, d.yoga!.name),
          _till(context, d.yoga!.span, d.date),
        ),
      if (d.karana != null)
        (
          Icons.brightness_5_rounded,
          AstroPalette.fire,
          l.birthDetailsKarana,
          KTerms.karanaName(l, d.karana!.name),
          _till(context, d.karana!.span, d.date),
        ),
      if (d.vaara.isNotEmpty)
        (
          Icons.today_rounded,
          AstroPalette.money,
          l.birthDetailsWeekday,
          KTerms.vaaraName(l, d.vaara),
          '',
        ),
      if (d.moonSign.isNotEmpty)
        (
          Icons.nightlight_round,
          AstroPalette.water,
          l.birthDetailsMoonSign,
          KTerms.signName(l, d.moonSign),
          '',
        ),
      if (d.sunSign.isNotEmpty)
        (
          Icons.wb_sunny_outlined,
          AstroPalette.money,
          l.birthDetailsSunSign,
          KTerms.signName(l, d.sunSign),
          '',
        ),
    ];

    return _Card(
      title: l.panchangLimbs,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 18, color: context.brand.hairline),
            _LimbRow(
              icon: rows[i].$1,
              hue: rows[i].$2,
              label: rows[i].$3,
              value: rows[i].$4,
              till: rows[i].$5,
            ),
          ],
        ],
      ),
    );
  }
}

class _LimbRow extends StatelessWidget {
  const _LimbRow({
    required this.icon,
    required this.hue,
    required this.label,
    required this.value,
    required this.till,
  });

  final IconData icon;
  final AstroHue hue;
  final String label;
  final String value;
  final String till;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: hue.tint(0.13),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: hue.end),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (till.isNotEmpty)
          // Capped so a long "till 3:05 AM, 14 Sep" wraps instead of pushing
          // the limb name off-screen.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 124),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                till,
                textAlign: TextAlign.end,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TimingsCard extends StatelessWidget {
  const _TimingsCard({required this.day, required this.now});
  final DayPanchang day;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final good = <(String, TimeWindow)>[
      if (day.brahmaMuhurta != null) (l.panchangBrahma, day.brahmaMuhurta!),
      if (day.abhijit != null) (l.panchangAbhijit, day.abhijit!),
    ];
    final avoid = <(String, TimeWindow)>[
      if (day.rahuKaal != null) (l.panchangRahuKaal, day.rahuKaal!),
      if (day.yamaganda != null) (l.panchangYamaganda, day.yamaganda!),
      if (day.gulika != null) (l.panchangGulika, day.gulika!),
    ];
    if (good.isEmpty && avoid.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _Card(
          title: l.panchangAuspicious,
          accent: AstroPalette.health,
          child: Column(
            children: [
              for (final (label, w) in good)
                _WindowRow(
                  label: label,
                  window: w,
                  hue: AstroPalette.health,
                  now: now,
                ),
              if (day.abhijit == null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l.panchangNoAbhijit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        _Card(
          title: l.panchangInauspicious,
          accent: AstroPalette.fire,
          child: Column(
            children: [
              for (final (label, w) in avoid)
                _WindowRow(
                  label: label,
                  window: w,
                  hue: AstroPalette.fire,
                  now: now,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WindowRow extends StatelessWidget {
  const _WindowRow({
    required this.label,
    required this.window,
    required this.hue,
    required this.now,
  });

  final String label;
  final TimeWindow window;
  final AstroHue hue;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final running = now != null && window.contains(now!);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: running ? hue.tint(0.14) : hue.tint(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: running ? hue.end : hue.tint(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (running) ...[_NowBadge(hue: hue), const SizedBox(width: 8)],
          Text(
            _range(context, window),
            style: theme.textTheme.labelLarge?.copyWith(
              color: hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoghadiyaCard extends StatefulWidget {
  const _ChoghadiyaCard({required this.day, required this.now});
  final DayPanchang day;
  final DateTime? now;

  @override
  State<_ChoghadiyaCard> createState() => _ChoghadiyaCardState();
}

class _ChoghadiyaCardState extends State<_ChoghadiyaCard> {
  /// Opens on the night when it's already past sunset today.
  late bool _night = _startOnNight();

  bool _startOnNight() {
    final now = widget.now;
    final sunset = widget.day.sunset;
    return now != null &&
        sunset != null &&
        !now.isBefore(sunset.local) &&
        widget.day.nightChoghadiya.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final day = widget.day;
    final slots = _night ? day.nightChoghadiya : day.dayChoghadiya;
    if (day.dayChoghadiya.isEmpty) return const SizedBox.shrink();

    return _Card(
      title: l.panchangChoghadiya,
      trailing: day.nightChoghadiya.isEmpty
          ? null
          : SegmentedButton<bool>(
              showSelectedIcon: false,
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              segments: [
                ButtonSegment(
                  value: false,
                  icon: const Icon(Icons.wb_sunny_rounded, size: 16),
                  label: Text(l.panchangDay),
                ),
                ButtonSegment(
                  value: true,
                  icon: const Icon(Icons.nightlight_round, size: 16),
                  label: Text(l.panchangNight),
                ),
              ],
              selected: {_night},
              onSelectionChanged: (s) => setState(() => _night = s.first),
            ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Column(
          key: ValueKey(_night),
          children: [
            for (final s in slots) _ChoghadiyaRow(slot: s, now: widget.now),
          ],
        ),
      ),
    );
  }
}

class _ChoghadiyaRow extends StatelessWidget {
  const _ChoghadiyaRow({required this.slot, required this.now});
  final PanchangChoghadiya slot;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = _qualityHue(slot.quality);
    final running = now != null && slot.window.contains(now!);
    final label = switch (slot.quality) {
      'good' => l.muhurtaChoGood,
      'bad' => l.muhurtaChoBad,
      _ => l.muhurtaChoNeutral,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: running ? hue.tint(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: running ? hue.end : context.brand.hairline,
          width: running ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: hue.linear(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  KTerms.choghadiyaName(l, slot.name),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _range(context, slot.window),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          if (running) ...[_NowBadge(hue: hue), const SizedBox(width: 6)],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: hue.tint(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: hue.end,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});
  final List<({String title, String body})> notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Card(
      title: context.l10n.panchangNotes,
      accent: AstroPalette.money,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final n in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (n.title.isNotEmpty)
                    Text(
                      n.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (n.body.isNotEmpty)
                    Text(
                      n.body,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PersonalCta extends StatelessWidget {
  const _PersonalCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: HueTile(
        hue: AstroPalette.career,
        radius: 18,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            const HueIcon(
              hue: AstroPalette.career,
              icon: Icons.person_pin_circle_rounded,
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.panchangPersonalTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l.panchangPersonalBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.brand.inkMuted),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.day, required this.place});
  final DayPanchang day;
  final PanchangPlace? place;

  @override
  Widget build(BuildContext context) {
    final name = place?.name ?? day.place;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        context.l10n.panchangFooter(
          name.isEmpty ? '—' : name,
          day.timezone.isEmpty ? '—' : day.timezone,
        ),
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: context.brand.inkMuted),
      ),
    );
  }
}

class _ChoosePlaceCard extends StatelessWidget {
  const _ChoosePlaceCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Column(
        children: [
          const HueIcon(
            hue: AstroPalette.money,
            icon: Icons.location_city_rounded,
            size: 56,
            iconSize: 28,
          ),
          const SizedBox(height: 14),
          Text(
            l.panchangChoosePlaceTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.panchangChoosePlaceBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _changePlace(context),
            icon: const Icon(Icons.search_rounded),
            label: Text(l.panchangChoosePlaceCta),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 44,
            color: context.brand.inkMuted,
          ),
          const SizedBox(height: 12),
          Text(
            l.homeCouldntLoadPanchang,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            localizedError(context, error),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.brand.inkMuted),
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: () => context.read<PanchangCubit>().load(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l.commonRetry),
          ),
        ],
      ),
    );
  }
}

class _BodySkeleton extends StatelessWidget {
  const _BodySkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 280, radius: 20),
          SizedBox(height: 12),
          SkeletonBox(height: 150, radius: 20),
          SizedBox(height: 12),
          SkeletonBox(height: 200, radius: 20),
        ],
      ),
    );
  }
}

// --- shared -------------------------------------------------------------------

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.child,
    this.accent,
    this.trailing,
  });

  final String title;
  final Widget child;
  final AstroHue? accent;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (accent != null) ...[
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: accent!.linear(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _NowBadge extends StatelessWidget {
  const _NowBadge({required this.hue});
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        gradient: hue.linear(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.l10n.muhurtaNow,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

AstroHue _qualityHue(String quality) => switch (quality) {
  'good' => AstroPalette.health,
  'bad' => AstroPalette.fire,
  _ => AstroPalette.money,
};
