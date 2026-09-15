import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';

import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../data/models/horoscope.dart';
import '../../../data/models/zodiac.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';
import 'zodiac_wheel.dart';
import 'package:customr/src/core/l10n/l10n.dart';

/// Today's reading. The sign follows the active birth profile's sun sign by
/// default; the chip opens a picker to override it (persisted).
class HoroscopeCard extends StatelessWidget {
  const HoroscopeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final sign = context.select((HomeCubit c) => c.state.sign);
    final horoscope = context.select((HomeCubit c) => c.state.horoscope);
    final brand = context.brand;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeTodaysHoroscope,
          hue: AstroPalette.air,
          trailing: _SignChip(
            sign: sign,
            onTap: () => _pickSign(context, cubit, sign),
          ),
        ),
        const SizedBox(height: 12),
        const ZodiacWheel(),
        const SizedBox(height: 12),
        Padding(
          padding: HomeGaps.sidePad,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [brand.cosmicStart, brand.cosmicEnd],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              boxShadow: brand.shadowCosmic,
            ),
            child: Stack(
              children: [
                // Distant-moon glow, top-right.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.7, -0.7),
                        radius: 0.9,
                        colors: [
                          brand.cosmicAccent.withValues(alpha: 0.28),
                          brand.cosmicAccent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Decorative celestial shapes (painted behind content)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HoroscopeCardTexturePainter(
                      dustColor: brand.cosmicAccent,
                      starColor: brand.gold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionSwitcher(
                        child: horoscope.when(
                          idle: () => const _HoroskeletonBody(),
                          loading: () => const _HoroskeletonBody(),
                          error: (_) =>
                              _ErrorBody(onRetry: cubit.retryHoroscope),
                          data: (h) => _HoroscopeBody(horoscope: h),
                        ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.push(Routes.horoscopeFor(sign: sign.slug)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: brand.gold,
                          side: BorderSide(
                            color: brand.gold.withValues(alpha: 0.6),
                          ),
                          shape: const StadiumBorder(),
                          minimumSize: const Size.fromHeight(44),
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: Text(
                          context.l10n.horoReadFull,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickSign(
    BuildContext context,
    HomeCubit cubit,
    ZodiacSign current,
  ) async {
    final picked = await showAppSheet<ZodiacSign>(
      context: context,
      title: context.l10n.homeChooseSignTitle,
      builder: (context) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (final z in ZodiacSign.values)
            InkWell(
              onTap: () => Navigator.pop(context, z),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: z == current
                      ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.4)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: z == current
                        ? Theme.of(context).colorScheme.primary
                        : context.brand.hairline,
                    width: z == current ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(z.svgPath, width: 44, height: 44),
                    const SizedBox(height: 8),
                    Text(
                      z.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: z == current
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: z == current
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
    if (picked != null && picked != current) {
      await cubit.setSign(picked);
    }
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.sign, required this.onTap});
  final ZodiacSign sign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Material(
      color: theme.colorScheme.surface,
      shape: StadiumBorder(
        side: BorderSide(color: brand.glowAccent.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(sign.svgPath, width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                sign.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aspect icon colors for Love, Career, Health.
const _aspectColors = <String, Color>{
  'Love': Color(0xFFFF6B9D),
  'Career': Color(0xFFFF8A3D),
  'Health': Color(0xFF14B8A6),
};

class _HoroscopeBody extends StatefulWidget {
  const _HoroscopeBody({required this.horoscope});
  final Horoscope horoscope;

  @override
  State<_HoroscopeBody> createState() => _HoroscopeBodyState();
}

class _HoroscopeBodyState extends State<_HoroscopeBody> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final h = widget.horoscope;
    final theme = Theme.of(context);
    final brand = context.brand;
    final aspects = <(String, IconData, String?)>[
      ('Love', Icons.favorite_rounded, h.love),
      ('Career', Icons.work_rounded, h.career),
      ('Health', Icons.spa_rounded, h.health),
    ].where((a) => a.$3 != null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (h.luck != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: brand.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: brand.gold.withValues(alpha: 0.4)),
            ),
            child: Text(
              'Luck today · ${h.luck}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 280),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstCurve: Curves.easeOutCubic,
          secondCurve: Curves.easeOutCubic,
          sizeCurve: Curves.easeOutCubic,
          firstChild: Text(
            h.general,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: brand.onCosmic,
            ),
          ),
          secondChild: Text(
            h.general,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: brand.onCosmic,
            ),
          ),
        ),
        if (h.general.length > 120)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'Show less' : 'Read more',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (aspects.isNotEmpty) ...[
          const SizedBox(height: 14),
          for (final (label, icon, text) in aspects)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: _aspectColors[label] ?? brand.onCosmicMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          height: 1.45,
                          color: brand.onCosmicMuted,
                        ),
                        children: [
                          TextSpan(
                            text: '$label — ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: brand.onCosmic,
                            ),
                          ),
                          TextSpan(text: text),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _HoroskeletonBody extends StatelessWidget {
  const _HoroskeletonBody();

  @override
  Widget build(BuildContext context) {
    return const HomeShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 90, height: 18, radius: 999),
          SizedBox(height: 14),
          SkeletonBox(height: 12),
          SizedBox(height: 8),
          SkeletonBox(height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: 180, height: 12),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Row(
      children: [
        Expanded(
          child: Text(
            "Couldn't fetch today's reading.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: brand.onCosmicMuted,
            ),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(foregroundColor: brand.gold),
          child: Text(context.l10n.homeRetryBtn),
        ),
      ],
    );
  }
}

/// Paints a sparse constellation — scattered dust with a few connecting
/// lines, one 4-point sparkle picked out in gold — behind the cosmic card's
/// content. Deterministic (fixed seed) so it doesn't repaint differently
/// frame to frame.
class _HoroscopeCardTexturePainter extends CustomPainter {
  _HoroscopeCardTexturePainter({
    required this.dustColor,
    required this.starColor,
  });

  final Color dustColor;
  final Color starColor;

  static final _rng = math.Random(7);
  static final _dots = List.generate(
    14,
    (_) => Offset(_rng.nextDouble(), _rng.nextDouble()),
  );
  static const _links = [(0, 3), (3, 7), (7, 9), (2, 5), (10, 12)];

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(Offset unit) =>
        Offset(unit.dx * size.width, unit.dy * size.height);

    final linePaint = Paint()
      ..color = dustColor.withValues(alpha: 0.22)
      ..strokeWidth = 0.8;
    for (final (a, b) in _links) {
      canvas.drawLine(at(_dots[a]), at(_dots[b]), linePaint);
    }

    final dotPaint = Paint()..color = dustColor.withValues(alpha: 0.55);
    for (var i = 0; i < _dots.length; i++) {
      canvas.drawCircle(at(_dots[i]), i.isEven ? 1.6 : 1.1, dotPaint);
    }

    // One gold sparkle marking the "reading" — a small 4-point star.
    _drawSparkle(
      canvas,
      center: Offset(size.width - 30, 26),
      r: 7,
      paint: Paint()..color = starColor.withValues(alpha: 0.75),
    );
  }

  void _drawSparkle(
    Canvas canvas, {
    required Offset center,
    required double r,
    required Paint paint,
  }) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + r, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + r)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - r, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - r)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HoroscopeCardTexturePainter old) =>
      old.dustColor != dustColor || old.starColor != starColor;
}
