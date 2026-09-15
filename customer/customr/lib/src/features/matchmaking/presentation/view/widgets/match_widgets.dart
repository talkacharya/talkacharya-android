import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../shared/widgets/pressable.dart';

/// Initials in a gradient circle, optionally ringed (for overlapping stacks).
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    required this.initials,
    required this.hue,
    this.size = 48,
    this.ring,
    super.key,
  });

  final String initials;
  final AstroHue hue;
  final double size;
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hue.linear(),
        border: ring == null ? null : Border.all(color: ring!, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: hue.start.withValues(alpha: 0.35),
            blurRadius: size / 5,
            offset: Offset(0, size / 14),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
          height: 1,
        ),
      ),
    );
  }
}

/// A gently beating heart on the romance gradient.
class PulsingHeart extends StatefulWidget {
  const PulsingHeart({this.size = 40, super.key});
  final double size;

  @override
  State<PulsingHeart> createState() => _PulsingHeartState();
}

class _PulsingHeartState extends State<PulsingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        // Two quick beats then rest.
        final t = _c.value;
        final beat = t < 0.15
            ? math.sin(t / 0.15 * math.pi)
            : t < 0.3
            ? 0.6 * math.sin((t - 0.15) / 0.15 * math.pi)
            : 0.0;
        return Transform.scale(scale: 1 + 0.12 * beat, child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: AstroPalette.romance),
          boxShadow: [
            BoxShadow(
              color: AstroPalette.romance[1].withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.favorite_rounded,
          color: Colors.white,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}

/// Full-width primary action on the romance gradient, with busy + disabled states.
class GradientCta extends StatelessWidget {
  const GradientCta({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool busy;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !busy;
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      enabled: active,
      child: Pressable(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled ? 1 : 0.5,
          child: Material(
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              height: 56,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AstroPalette.romance),
              ),
              child: InkWell(
                onTap: active ? onPressed : null,
                child: Center(
                  child: busy
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Faint floating hearts for the romance hero.
class HeartsPainter extends CustomPainter {
  const HeartsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(3);
    for (var i = 0; i < 14; i++) {
      final c = Offset(
        rnd.nextDouble() * size.width,
        rnd.nextDouble() * size.height,
      );
      final s = 4 + rnd.nextDouble() * 8;
      final p = Paint()
        ..color = Colors.white.withValues(
          alpha: 0.08 + rnd.nextDouble() * 0.12,
        );
      final path = Path()
        ..moveTo(c.dx, c.dy + s * 0.9)
        ..cubicTo(
          c.dx - s * 1.4,
          c.dy,
          c.dx - s * 0.6,
          c.dy - s,
          c.dx,
          c.dy - s * 0.3,
        )
        ..cubicTo(
          c.dx + s * 0.6,
          c.dy - s,
          c.dx + s * 1.4,
          c.dy,
          c.dx,
          c.dy + s * 0.9,
        );
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- copy helpers ------------------------------------------------------------------

String relationLabel(AppLocalizations l, String relation) => switch (relation) {
  'self' => l.matchRelSelf,
  'spouse' => l.matchRelPartner,
  'child' => l.matchRelChild,
  'parent' => l.matchRelParent,
  'sibling' => l.matchRelSibling,
  'friend' => l.matchRelFriend,
  _ => '',
};

String verdictLabel(AppLocalizations l, String key) => switch (key) {
  'excellent' => l.matchVerdictExcellent,
  'good' => l.matchVerdictGood,
  'average' => l.matchVerdictAverage,
  _ => l.matchVerdictLow,
};

String verdictBody(AppLocalizations l, String key) => switch (key) {
  'excellent' => l.matchVerdictExcellentBody,
  'good' => l.matchVerdictGoodBody,
  'average' => l.matchVerdictAverageBody,
  _ => l.matchVerdictLowBody,
};

String kootaLabel(AppLocalizations l, String key) => switch (key) {
  'varna' => l.matchKootaVarna,
  'vashya' => l.matchKootaVashya,
  'tara' => l.matchKootaTara,
  'yoni' => l.matchKootaYoni,
  'graha_maitri' => l.matchKootaMaitri,
  'gana' => l.matchKootaGana,
  'bhakoot' => l.matchKootaBhakoot,
  'nadi' => l.matchKootaNadi,
  _ => key,
};

String kootaMeaning(AppLocalizations l, String key) => switch (key) {
  'varna' => l.matchKootaVarnaMeaning,
  'vashya' => l.matchKootaVashyaMeaning,
  'tara' => l.matchKootaTaraMeaning,
  'yoni' => l.matchKootaYoniMeaning,
  'graha_maitri' => l.matchKootaMaitriMeaning,
  'gana' => l.matchKootaGanaMeaning,
  'bhakoot' => l.matchKootaBhakootMeaning,
  'nadi' => l.matchKootaNadiMeaning,
  _ => '',
};

String kootaDetail(AppLocalizations l, String key) => switch (key) {
  'varna' => l.matchKootaVarnaDetail,
  'vashya' => l.matchKootaVashyaDetail,
  'tara' => l.matchKootaTaraDetail,
  'yoni' => l.matchKootaYoniDetail,
  'graha_maitri' => l.matchKootaMaitriDetail,
  'gana' => l.matchKootaGanaDetail,
  'bhakoot' => l.matchKootaBhakootDetail,
  'nadi' => l.matchKootaNadiDetail,
  _ => '',
};

IconData kootaIcon(String key) => switch (key) {
  'varna' => Icons.self_improvement_rounded,
  'vashya' => Icons.all_inclusive_rounded,
  'tara' => Icons.star_rounded,
  'yoni' => Icons.favorite_rounded,
  'graha_maitri' => Icons.handshake_rounded,
  'gana' => Icons.psychology_rounded,
  'bhakoot' => Icons.family_restroom_rounded,
  'nadi' => Icons.health_and_safety_rounded,
  _ => Icons.circle,
};

/// Eight distinct hues so the breakdown reads as a colourful, scannable list.
AstroHue kootaHue(String key) => switch (key) {
  'varna' => const AstroHue(Color(0xFFA78BFA), Color(0xFF7C3AED)),
  'vashya' => const AstroHue(Color(0xFF60A5FA), Color(0xFF2563EB)),
  'tara' => const AstroHue(Color(0xFFFCD34D), Color(0xFFF59E0B)),
  'yoni' => AstroPalette.love,
  'graha_maitri' => const AstroHue(Color(0xFF34D399), Color(0xFF059669)),
  'gana' => const AstroHue(Color(0xFFFB923C), Color(0xFFEA580C)),
  'bhakoot' => const AstroHue(Color(0xFF22D3EE), Color(0xFF0891B2)),
  'nadi' => const AstroHue(Color(0xFFF87171), Color(0xFFDC2626)),
  _ => AstroPalette.career,
};

String doshaLabel(AppLocalizations l, String key) => switch (key) {
  'nadi' => l.matchDoshaNadi,
  'bhakoot' => l.matchDoshaBhakoot,
  'gana' => l.matchDoshaGana,
  _ => key,
};

String manglikBody(AppLocalizations l, String status) => switch (status) {
  'none' => l.matchManglikNone,
  'both' => l.matchManglikBoth,
  'cancelled' => l.matchManglikCancelled,
  'mismatch' => l.matchManglikMismatch,
  _ => '',
};
