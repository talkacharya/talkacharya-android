import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/home_promo.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Height of every slide, whatever its kind. Fixed so the [PageView] doesn't
/// jump as slides of different content swipe past.
const double _railHeight = 188;

/// Auto-advancing promo rail. Renders whatever [PromoSlide] kind the feed sends
/// — a styled text card, a full-bleed image, an inline video, or a custom
/// widget. Curated client-side until `/app/home` starts sending media slides.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _page = 0;
  int _count = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _armTimer(int count) {
    _count = count;
    _timer?.cancel();
    if (count < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % _count;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final promos = context.select((HomeCubit c) => c.state.promos);
    final list = promos.when(
      idle: () => const <PromoSlide>[],
      loading: () => const <PromoSlide>[],
      error: (_) => const <PromoSlide>[],
      data: (l) => l,
    );
    if (list.isEmpty) return const SizedBox.shrink();
    if (list.length != _count) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _armTimer(list.length),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: _railHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: list.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? HomeGaps.side : 6,
                right: i == list.length - 1 ? HomeGaps.side : 6,
                bottom: 14,
              ),
              child: Pressable(
                child: _PromoSlideView(slide: list[i], active: i == _page),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < list.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  gradient: i == _page
                      ? const LinearGradient(colors: AstroPalette.romance)
                      : null,
                  color: i == _page ? null : context.brand.hairline,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: i == _page
                      ? [
                          BoxShadow(
                            color: AstroPalette.romance[1].withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Normalises a promo deeplink (`talkacharya://wallet` → `/wallet`) and routes.
void _openPromo(BuildContext context, String? deeplink) {
  if (deeplink == null || deeplink.isEmpty) return;
  var loc = deeplink;
  const scheme = 'talkacharya://';
  if (loc.startsWith(scheme)) loc = '/${loc.substring(scheme.length)}';
  context.go(loc);
}

/// Dispatches one slide to the widget for its kind.
class _PromoSlideView extends StatelessWidget {
  const _PromoSlideView({required this.slide, required this.active});

  final PromoSlide slide;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final s = slide;
    switch (s) {
      case RichPromo():
        return _RichPromoCard(promo: s);
      case ImagePromo():
        return _MediaPromoCard(
          promo: s,
          deeplink: s.deeplink,
          child: CachedNetworkImage(
            imageUrl: s.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => const _PromoFill(),
            errorWidget: (_, _, _) => const _PromoFill(),
          ),
        );
      case VideoPromo():
        return _VideoPromoCard(promo: s, active: active);
      case WidgetPromo():
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: s.deeplink == null
                ? null
                : () => _openPromo(context, s.deeplink),
            child: s.builder(context),
          ),
        );
    }
  }
}

/// Neutral fill shown behind an image that's still loading or failed to load.
class _PromoFill extends StatelessWidget {
  const _PromoFill();

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [brand.tint, brand.shimmerBase],
        ),
      ),
    );
  }
}

/// Shared chrome for image / video slides — rounded clip, tap target, bottom
/// scrim and the optional headline + CTA overlay.
class _MediaPromoCard extends StatelessWidget {
  const _MediaPromoCard({
    required this.child,
    required this.deeplink,
    this.promo,
    this.overlayTitle,
    this.overlayCta,
  });

  final Widget child;
  final String? deeplink;
  final ImagePromo? promo;
  final String? overlayTitle;
  final String? overlayCta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = overlayTitle ?? promo?.title;
    final subtitle = promo?.subtitle;
    final cta = overlayCta ?? promo?.cta;
    final hasOverlay =
        (title?.isNotEmpty ?? false) ||
        (subtitle?.isNotEmpty ?? false) ||
        (cta?.isNotEmpty ?? false);

    return Material(
      color: context.brand.tint,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: deeplink == null ? null : () => _openPromo(context, deeplink),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (hasOverlay)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xCC000000), Color(0x22000000)],
                  ),
                ),
              ),
            if (hasOverlay)
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title?.isNotEmpty ?? false)
                      Text(
                        title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    if (subtitle?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                    if (cta?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          cta!,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Inline video slide — muted, looping, plays only while it's the active page
/// and "reduce motion" is off. Shows the poster (or a fill) until the first
/// frame lands, and permanently if playback can't start.
class _VideoPromoCard extends StatefulWidget {
  const _VideoPromoCard({required this.promo, required this.active});

  final VideoPromo promo;
  final bool active;

  @override
  State<_VideoPromoCard> createState() => _VideoPromoCardState();
}

class _VideoPromoCardState extends State<_VideoPromoCard> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final c = VideoPlayerController.networkUrl(
      Uri.parse(widget.promo.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = c;
    try {
      await c.initialize();
      await c.setVolume(0);
      await c.setLooping(true);
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _ready = true);
      _sync();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _sync() {
    final c = _controller;
    if (c == null || !_ready) return;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.active && !reduceMotion) {
      c.play();
    } else {
      c.pause();
    }
  }

  @override
  void didUpdateWidget(covariant _VideoPromoCard old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active) _sync();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final poster = widget.promo.posterUrl;
    final Widget backdrop = (_ready && c != null)
        ? FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: c.value.size.width == 0 ? 16 : c.value.size.width,
              height: c.value.size.height == 0 ? 9 : c.value.size.height,
              child: VideoPlayer(c),
            ),
          )
        : (poster != null && poster.isNotEmpty)
        ? CachedNetworkImage(
            imageUrl: poster,
            fit: BoxFit.cover,
            placeholder: (_, _) => const _PromoFill(),
            errorWidget: (_, _, _) => const _PromoFill(),
          )
        : const _PromoFill();

    return Stack(
      fit: StackFit.expand,
      children: [
        _MediaPromoCard(
          deeplink: widget.promo.deeplink,
          overlayTitle: widget.promo.title,
          overlayCta: widget.promo.cta,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(
              key: ValueKey(_ready && !_failed),
              child: backdrop,
            ),
          ),
        ),
        if (!_ready || _failed)
          const IgnorePointer(
            child: Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 46,
                color: Colors.white70,
              ),
            ),
          ),
      ],
    );
  }
}

class _RichPromoCard extends StatelessWidget {
  const _RichPromoCard({required this.promo});

  final RichPromo promo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (colors, accent) = _palette(context, promo.tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        color: colors.first,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: InkWell(
            onTap: promo.deeplink == null
                ? null
                : () => _openPromo(context, promo.deeplink),
            child: Stack(
              children: [
                // Soft orbs + sparkles for depth.
                const Positioned(
                  right: -40,
                  top: -50,
                  child: _Orb(size: 170, alpha: 0.14),
                ),
                const Positioned(
                  right: 40,
                  bottom: -70,
                  child: _Orb(size: 130, alpha: 0.10),
                ),
                const Positioned.fill(
                  child: CustomPaint(painter: _PromoSparkles()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              promo.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              promo.subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.88),
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 7, 10, 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    promo.cta,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: accent,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: accent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          _icon(promo.tone),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData _icon(PromoTone tone) => switch (tone) {
    PromoTone.night => Icons.nightlight_round,
    PromoTone.saffron => Icons.card_giftcard_rounded,
    PromoTone.calm => Icons.self_improvement_rounded,
  };

  /// Gradient stops + the CTA text colour for each tone.
  (List<Color>, Color) _palette(BuildContext context, PromoTone tone) {
    final brand = context.brand;
    return switch (tone) {
      PromoTone.night => (
        [brand.cosmicEnd, const Color(0xFF6D28D9), AstroPalette.romance[1]],
        const Color(0xFF6D28D9),
      ),
      PromoTone.saffron => (
        [
          AstroPalette.money.start,
          AstroPalette.money.end,
          AstroPalette.fire.end,
        ],
        AstroPalette.fire.end,
      ),
      PromoTone.calm => (
        [
          AstroPalette.health.start,
          AstroPalette.health.end,
          AstroPalette.water.end,
        ],
        AstroPalette.water.end,
      ),
    };
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.alpha});
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );
}

class _PromoSparkles extends CustomPainter {
  const _PromoSparkles();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(9);
    final p = Paint();
    for (var i = 0; i < 22; i++) {
      p.color = Colors.white.withValues(alpha: 0.12 + rnd.nextDouble() * 0.35);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        rnd.nextDouble() * 1.3 + 0.3,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
