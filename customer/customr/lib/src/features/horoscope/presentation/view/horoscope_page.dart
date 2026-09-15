import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../home/data/models/zodiac.dart';
import '../../../kundali/presentation/kundali_terms.dart';
import '../../data/models/sign_horoscope.dart';
import '../cubit/horoscope_cubit.dart';
import 'widgets/horoscope_sections.dart';

/// Full horoscope: pick a sign, pick a span, read the day / week / month.
class HoroscopePage extends StatefulWidget {
  const HoroscopePage({super.key});

  @override
  State<HoroscopePage> createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  @override
  void initState() {
    super.initState();
    context.read<HoroscopeCubit>().load();
  }

  void _share(BuildContext context, SignHoroscope h) {
    final l = context.l10n;
    final signName = KTerms.signName(l, h.sign.label);
    final text = h.shareText(
      signName,
      spanDateLabel(context, h.span, h.start, h.end),
    );
    Share.share('$text\n\n— TalkAcharya');
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return BlocBuilder<HoroscopeCubit, HoroscopeState>(
      builder: (context, state) {
        final cubit = context.read<HoroscopeCubit>();
        final reading = state.reading;
        return Scaffold(
          backgroundColor: brand.canvas,
          body: RefreshIndicator(
            color: AstroPalette.element(state.sign.index).end,
            edgeOffset: 120,
            onRefresh: () => cubit.load(force: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _HeroAppBar(
                  sign: state.sign,
                  span: state.span,
                  reading: reading.value,
                  onPickSign: () => _pickSign(context, cubit, state.sign),
                  onShare: reading.value == null
                      ? null
                      : () => _share(context, reading.value!),
                ),
                SliverToBoxAdapter(
                  child: _SignStrip(
                    selected: state.sign,
                    onSelect: (s) {
                      HapticService.light();
                      cubit.selectSign(s);
                    },
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SpanHeader(
                    span: state.span,
                    hue: AstroPalette.element(state.sign.index),
                    canvas: brand.canvas,
                    onSelect: (s) {
                      HapticService.light();
                      cubit.selectSpan(s);
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  sliver: SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      child: reading.when(
                        idle: () =>
                            const _ReadingSkeleton(key: ValueKey('idle')),
                        loading: () =>
                            const _ReadingSkeleton(key: ValueKey('loading')),
                        error: (m) => Padding(
                          key: const ValueKey('error'),
                          padding: const EdgeInsets.only(top: 24),
                          child: ErrorView(
                            title: context.l10n.horoError,
                            message: m,
                            onRetry: () => cubit.load(force: true),
                          ),
                        ),
                        data: (h) => HoroscopeReading(
                          key: ValueKey('${h.sign.slug}-${h.span.name}'),
                          horoscope: h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickSign(
    BuildContext context,
    HoroscopeCubit cubit,
    ZodiacSign current,
  ) async {
    final l = context.l10n;
    final picked = await showAppSheet<ZodiacSign>(
      context: context,
      title: l.horoChooseSign,
      builder: (sheet) => SignGrid(
        selected: current,
        onSelect: (s) => Navigator.pop(sheet, s),
        footer: TextButton.icon(
          onPressed: () {
            Navigator.pop(sheet);
            showWhichSignSheet(context);
          },
          icon: const Icon(Icons.help_outline_rounded, size: 18),
          label: Text(l.horoWhichSignTitle),
        ),
      ),
    );
    if (picked != null) await cubit.selectSign(picked);
  }
}

// --- hero ----------------------------------------------------------------------

class _HeroAppBar extends StatelessWidget {
  const _HeroAppBar({
    required this.sign,
    required this.span,
    required this.reading,
    required this.onPickSign,
    required this.onShare,
  });

  final ZodiacSign sign;
  final HoroscopeSpan span;
  final SignHoroscope? reading;
  final VoidCallback onPickSign;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final hue = AstroPalette.element(sign.index);
    final signName = KTerms.signName(l, sign.label);
    final dateLabel = reading == null
        ? spanDateLabel(context, span, DateTime.now(), DateTime.now())
        : spanDateLabel(context, span, reading!.start, reading!.end);

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 292,
      backgroundColor: brand.cosmicStart,
      foregroundColor: brand.onCosmic,
      surfaceTintColor: Colors.transparent,
      title: Text(l.horoTitle),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: brand.onCosmic,
      ),
      actions: [
        IconButton(
          tooltip: l.horoWhichSignTitle,
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => showWhichSignSheet(context),
        ),
        IconButton(
          tooltip: l.horoShare,
          icon: const Icon(Icons.ios_share_rounded),
          onPressed: onShare,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [brand.cosmicStart, brand.cosmicEnd],
                ),
              ),
            ),
            // Element-coloured nebula glow.
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.75, -0.35),
                  radius: 0.95,
                  colors: [
                    hue.start.withValues(alpha: 0.42),
                    hue.start.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.9, 0.9),
                  radius: 0.8,
                  colors: [
                    hue.end.withValues(alpha: 0.30),
                    hue.end.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            const CustomPaint(painter: StarfieldPainter()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            dateLabel.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: brand.onCosmicMuted,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              signName,
                              key: ValueKey(sign),
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: brand.onCosmic,
                                fontSize: 38,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _HeroChip(
                                icon: signElementIcon(sign.index),
                                label: signElementLabel(l, sign.index),
                                color: hue.start,
                              ),
                              _HeroChip(
                                icon: Icons.brightness_7_rounded,
                                label: KTerms.planetName(
                                  l,
                                  signRuler(sign.index),
                                ),
                                color: brand.gold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Pressable(
                            child: Material(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.22),
                                ),
                              ),
                              child: InkWell(
                                customBorder: const StadiumBorder(),
                                onTap: onPickSign,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.swap_horiz_rounded,
                                        size: 18,
                                        color: brand.onCosmic,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l.horoChangeSign,
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: brand.onCosmic,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _GlowingSign(sign: sign, hue: hue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowingSign extends StatelessWidget {
  const _GlowingSign({required this.sign, required this.hue});
  final ZodiacSign sign;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      width: 132,
      height: 132,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(colors: [hue.start, hue.end, hue.start]),
        boxShadow: [
          BoxShadow(color: hue.start.withValues(alpha: 0.55), blurRadius: 36),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.brand.cosmicStart,
        ),
        padding: const EdgeInsets.all(14),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, a) => ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(a),
            child: FadeTransition(opacity: a, child: child),
          ),
          child: SvgPicture.asset(sign.svgPath, key: ValueKey(sign)),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.brand.onCosmic,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// --- sign strip ------------------------------------------------------------------

class _SignStrip extends StatefulWidget {
  const _SignStrip({required this.selected, required this.onSelect});
  final ZodiacSign selected;
  final ValueChanged<ZodiacSign> onSelect;

  @override
  State<_SignStrip> createState() => _SignStripState();
}

class _SignStripState extends State<_SignStrip> {
  static const _itemWidth = 72.0;
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: _offsetFor(widget.selected),
  );

  static double _offsetFor(ZodiacSign s) =>
      math.max(0, (s.index - 2) * _itemWidth);

  @override
  void didUpdateWidget(covariant _SignStrip old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected && _scroll.hasClients) {
      _scroll.animateTo(
        _offsetFor(widget.selected).clamp(0, _scroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return SizedBox(
      height: 104,
      child: ListView.builder(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 4),
        itemCount: ZodiacSign.values.length,
        itemBuilder: (context, i) {
          final s = ZodiacSign.values[i];
          final selected = s == widget.selected;
          final hue = AstroPalette.element(i);
          return SizedBox(
            width: _itemWidth,
            child: Semantics(
              button: true,
              selected: selected,
              label: KTerms.signName(l, s.label),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => widget.onSelect(s),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      width: 56,
                      height: 56,
                      padding: EdgeInsets.all(selected ? 2.5 : 1.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: selected
                            ? SweepGradient(
                                colors: [hue.start, hue.end, hue.start],
                              )
                            : null,
                        color: selected ? null : brand.hairline,
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: hue.start.withValues(alpha: 0.45),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [brand.cosmicStart, brand.cosmicEnd],
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(s.svgPath),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      KTerms.signName(l, s.label),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: selected ? hue.end : brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- span selector (pinned) ------------------------------------------------------

class _SpanHeader extends SliverPersistentHeaderDelegate {
  _SpanHeader({
    required this.span,
    required this.hue,
    required this.canvas,
    required this.onSelect,
  });

  final HoroscopeSpan span;
  final AstroHue hue;
  final Color canvas;
  final ValueChanged<HoroscopeSpan> onSelect;

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final labels = {
      HoroscopeSpan.yesterday: l.horoSpanYesterday,
      HoroscopeSpan.today: l.horoSpanToday,
      HoroscopeSpan.tomorrow: l.horoSpanTomorrow,
      HoroscopeSpan.week: l.horoSpanWeek,
      HoroscopeSpan.month: l.horoSpanMonth,
    };
    return Container(
      color: canvas,
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: [
          for (final s in HoroscopeSpan.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Semantics(
                button: true,
                selected: s == span,
                child: GestureDetector(
                  onTap: () => onSelect(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: s == span ? hue.linear() : null,
                      color: s == span ? null : theme.colorScheme.surface,
                      border: Border.all(
                        color: s == span ? Colors.transparent : brand.hairline,
                      ),
                      boxShadow: s == span
                          ? [
                              BoxShadow(
                                color: hue.start.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      labels[s]!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: s == span ? Colors.white : brand.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SpanHeader old) =>
      old.span != span || old.hue != hue || old.canvas != canvas;
}

// --- reading -----------------------------------------------------------------------

/// The body for one loaded reading. Public so the matchmaking / home screens can
/// reuse pieces later; kept free of cubit access.
class HoroscopeReading extends StatelessWidget {
  const HoroscopeReading({required this.horoscope, super.key});
  final SignHoroscope horoscope;

  @override
  Widget build(BuildContext context) {
    final h = horoscope;
    final sections = <Widget>[
      OverviewCard(horoscope: h),
      for (final a in h.areas) AreaCard(area: a),
      if (h.lucky != null) LuckyRow(lucky: h.lucky!),
      if (h.favourableDays.isNotEmpty) FavourableDaysCard(horoscope: h),
      if (h.tip != null) TipCard(horoscope: h),
      if (h.transits.isNotEmpty) WhyCard(horoscope: h),
      AboutSignCard(sign: h.sign),
      AstrologerCta(sign: h.sign),
      SourceNote(horoscope: h),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: FadeSlideIn.list([
        for (final s in sections)
          Padding(padding: const EdgeInsets.only(bottom: 14), child: s),
      ], step: const Duration(milliseconds: 45)),
    );
  }
}

class _ReadingSkeleton extends StatelessWidget {
  const _ReadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    Widget block(double h) => Container(
      height: h,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return AppShimmer(
      child: Column(
        children: [
          Container(
            height: 210,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  SkeletonBox(width: 110, height: 110, radius: 55),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 80, height: 14),
                        SizedBox(height: 10),
                        SkeletonBox(height: 18),
                        SizedBox(height: 8),
                        SkeletonBox(width: 140, height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final h in const [120.0, 120.0, 120.0]) block(h),
        ],
      ),
    );
  }
}

// --- helpers shared by the page + sections ----------------------------------------

String spanDateLabel(
  BuildContext context,
  HoroscopeSpan span,
  DateTime start,
  DateTime end,
) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  if (span == HoroscopeSpan.month)
    return DateFormat.yMMMM(locale).format(start);
  if (span == HoroscopeSpan.week) {
    final d = DateFormat.MMMd(locale);
    return '${d.format(start)} – ${d.format(end)}';
  }
  return DateFormat.MMMEd(locale).format(start);
}

/// Sign index → ruling graha (English key, localise with [KTerms.planetName]).
String signRuler(int i) => const [
  'Mars',
  'Venus',
  'Mercury',
  'Moon',
  'Sun',
  'Mercury',
  'Venus',
  'Mars',
  'Jupiter',
  'Saturn',
  'Saturn',
  'Jupiter',
][i % 12];

String signElementLabel(AppLocalizations l, int i) => [
  l.horoElementFire,
  l.horoElementEarth,
  l.horoElementAir,
  l.horoElementWater,
][i % 4];

IconData signElementIcon(int i) => const [
  Icons.local_fire_department_rounded,
  Icons.terrain_rounded,
  Icons.air_rounded,
  Icons.water_drop_rounded,
][i % 4];

String signQualityLabel(AppLocalizations l, int i) =>
    [l.horoQualityMovable, l.horoQualityFixed, l.horoQualityDual][i % 3];

/// "Which sign should I pick?" — explains Moon sign vs sun sign, links to Kundali.
Future<void> showWhichSignSheet(BuildContext context) {
  final l = context.l10n;
  return showAppSheet<void>(
    context: context,
    title: l.horoWhichSignTitle,
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.horoWhichSignBody,
          style: Theme.of(sheet).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(sheet);
            context.push(Routes.birthProfiles);
          },
          icon: const Icon(Icons.auto_graph_rounded),
          label: Text(l.horoOpenKundali),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

/// 3-column grid of all signs (used by the "change sign" sheet).
class SignGrid extends StatelessWidget {
  const SignGrid({
    required this.selected,
    required this.onSelect,
    this.footer,
    super.key,
  });

  final ZodiacSign selected;
  final ValueChanged<ZodiacSign> onSelect;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
            children: [
              for (final s in ZodiacSign.values)
                Builder(
                  builder: (context) {
                    final hue = AstroPalette.element(s.index);
                    final isSel = s == selected;
                    return Pressable(
                      child: Material(
                        color: isSel
                            ? hue.tint(0.14)
                            : theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isSel ? hue.end : brand.hairline,
                            width: isSel ? 1.6 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => onSelect(s),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      brand.cosmicStart,
                                      brand.cosmicEnd,
                                    ],
                                  ),
                                ),
                                child: SvgPicture.asset(s.svgPath),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                KTerms.signName(l, s.label),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                signElementLabel(l, s.index),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: hue.end,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          ?footer,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
