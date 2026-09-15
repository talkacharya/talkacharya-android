import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/zodiac.dart';
import '../../cubit/home_cubit.dart';

const _kN = 12;
const _kStep = (2 * math.pi) / _kN; // 30° per sign

/// Sign index (0 = Aries … 11 = Pisces) currently under the top pointer for a
/// given ring [rotation]. Pure so it can be unit-tested.
int zodiacIndexForRotation(double rotation) {
  final k = (-rotation / _kStep).round() % _kN;
  return k < 0 ? k + _kN : k;
}

/// Nearest rotation that puts a sign exactly under the pointer.
double snapZodiacRotation(double rotation) =>
    (rotation / _kStep).round() * _kStep;

/// Shortest rotation delta from [rotation] that brings sign [index] to the top.
double zodiacDeltaToIndex(double rotation, int index) {
  final from = zodiacIndexForRotation(rotation);
  final diff = (((index - from) + _kN ~/ 2) % _kN) - _kN ~/ 2;
  return -diff * _kStep;
}

/// An interactive zodiac wheel.
///
/// Conceptually a full 12-segment circle whose centre sits just below the
/// widget, so only the top arc (a little more than a semicircle) is on screen.
/// The user spins it left/right — drag the ring, or flick to fling — and it
/// snaps so a sign lands under the top pointer. On release it calls
/// [HomeCubit.setSign], the exact same path the "Today's horoscope" card uses,
/// so the reading below reloads.
///
/// Only horizontal drags are claimed, so a vertical swipe still scrolls the
/// home feed.
class ZodiacWheel extends StatefulWidget {
  const ZodiacWheel({this.height = 190, super.key});

  final double height;

  @override
  State<ZodiacWheel> createState() => _ZodiacWheelState();
}

class _ZodiacWheelState extends State<ZodiacWheel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  /// Ring rotation, radians. 0 → Aries under the pointer; each `-_kStep` brings
  /// the next sign (clockwise) to the pointer.
  double _rotation = 0;
  double _driveFrom = 0;
  double _driveTo = 0;

  bool _dragging = false;
  bool _seeded = false;
  double? _lastPointerAngle; // unwraps the atan2 seam across ±π
  Offset _lastLocal = Offset.zero;
  int? _lastReported;

  // --- selection maths ------------------------------------------------

  int get _topIndex => zodiacIndexForRotation(_rotation);

  ZodiacSign get _topSign => ZodiacSign.values[_topIndex];

  double _snap(double rotation) => snapZodiacRotation(rotation);

  double _deltaToIndex(int index) => zodiacDeltaToIndex(_rotation, index);

  /// Angle of a screen point about [centre], clockwise from straight up.
  double _pointerAngle(Offset p, Offset centre) =>
      math.atan2(p.dx - centre.dx, centre.dy - p.dy);

  // --- lifecycle ----------------------------------------------------

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this)
      ..addListener(_onTick)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _reportSelection();
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final k = ZodiacSign.values.indexOf(context.read<HomeCubit>().state.sign);
    _rotation = -k * _kStep;
    _lastReported = k;
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onTick() {
    final t = Curves.easeOutCubic.transform(_anim.value);
    setState(() => _rotation = _driveFrom + (_driveTo - _driveFrom) * t);
  }

  void _animateTo(double target) {
    if ((target - _rotation).abs() < 1e-4) {
      _rotation = _snap(_rotation);
      _reportSelection();
      return;
    }
    _driveFrom = _rotation;
    _driveTo = target;
    final turns = (target - _rotation).abs() / _kStep;
    _anim
      ..duration = Duration(
        milliseconds: (240 + turns * 85).clamp(260, 1150).round(),
      )
      ..forward(from: 0);
  }

  void _reportSelection() {
    _rotation = _snap(_rotation);
    final k = _topIndex;
    if (k != _lastReported) {
      _lastReported = k;
      context.read<HomeCubit>().setSign(ZodiacSign.values[k]);
    }
  }

  // --- gestures ----------------------------------------------------

  void _onDragStart(DragStartDetails d, Offset centre) {
    _anim.stop();
    _dragging = true;
    _lastLocal = d.localPosition;
    _lastPointerAngle = _pointerAngle(d.localPosition, centre);
  }

  void _onDragUpdate(DragUpdateDetails d, Offset centre) {
    _lastLocal = d.localPosition;
    final a = _pointerAngle(d.localPosition, centre);
    var delta = a - (_lastPointerAngle ?? a);
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;
    _lastPointerAngle = a;
    setState(() => _rotation += delta);
  }

  void _onDragEnd(DragEndDetails d, Offset centre) {
    _dragging = false;
    // Turn the flick's linear velocity into an angular one via its tangential
    // component where the finger left the wheel.
    final radial = _lastLocal - centre;
    final r = math.max(radial.distance, 24.0);
    final tangent = Offset(-radial.dy, radial.dx) / r; // unit, clockwise
    final v = d.velocity.pixelsPerSecond;
    final vTangential = v.dx * tangent.dx + v.dy * tangent.dy;
    final omega = (vTangential / r).clamp(-16.0, 16.0); // rad/s
    _animateTo(_snap(_rotation + omega * 0.18));
  }

  void _tapIndex(int index) {
    if (_dragging) return;
    _anim.stop();
    _animateTo(_snap(_rotation) + _deltaToIndex(index));
  }

  // --- build ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (a, b) => a.sign != b.sign,
      listener: (_, state) {
        if (_dragging || _anim.isAnimating || state.sign == _topSign) return;
        final k = ZodiacSign.values.indexOf(state.sign);
        _lastReported = k;
        _animateTo(_snap(_rotation) + _deltaToIndex(k));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              // Hub peeks in at the bottom; the ring is sized so its top slot
              // clears the label + pointer (~72px) and ~7 signs stay on screen.
              final centre = Offset(w / 2, widget.height - 10);
              final ringR = widget.height - 82;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (d) => _onDragStart(d, centre),
                onHorizontalDragUpdate: (d) => _onDragUpdate(d, centre),
                onHorizontalDragEnd: (d) => _onDragEnd(d, centre),
                onHorizontalDragCancel: () {
                  _dragging = false;
                  _animateTo(_snap(_rotation));
                },
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WheelPainter(
                          centre: centre,
                          ringR: ringR,
                          scheme: Theme.of(context).colorScheme,
                        ),
                      ),
                    ),
                    for (var i = 0; i < _kN; i++)
                      _positionedIcon(i, centre, ringR),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _TopIndicator(sign: _topSign),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _positionedIcon(int i, Offset centre, double ringR) {
    final a = i * _kStep + _rotation;
    final pos = Offset(
      centre.dx + ringR * math.sin(a),
      centre.dy - ringR * math.cos(a),
    );
    if (pos.dy > widget.height + 44 || pos.dy < -64) {
      return const SizedBox.shrink();
    }
    final active = i == _topIndex;
    const box = 66.0; // fixed hit box; the badge grows inside it

    return Positioned(
      left: pos.dx - box / 2,
      top: pos.dy - box / 2,
      width: box,
      height: box,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _tapIndex(i),
          child: _SignBadge(sign: ZodiacSign.values[i], active: active),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------

class _SignBadge extends StatelessWidget {
  const _SignBadge({required this.sign, required this.active});

  final ZodiacSign sign;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final size = active ? 58.0 : 44.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      child: SvgPicture.asset(sign.svgPath),
    );
  }
}

class _TopIndicator extends StatelessWidget {
  const _TopIndicator({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const glowAccent = Color(0xFFFFB347);
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(
              axisAlignment: -1,
              sizeFactor: anim,
              child: child,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              sign.label.toUpperCase(),
              key: ValueKey(sign),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: glowAccent.withValues(alpha: 0.6),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Icon(Icons.arrow_drop_down_rounded, size: 30, color: glowAccent),
      ],
    );
  }
}

// --------------------------------------------------------------------------

class _WheelPainter extends CustomPainter {
  _WheelPainter({
    required this.centre,
    required this.ringR,
    required this.scheme,
  });

  final Offset centre;
  final double ringR;
  final ColorScheme scheme;

  static const _arc = 2.0; // ± radians of rim drawn (~115°)

  static const _bgTop = Color(0xFF241F45);
  static const _bgBottom = Color(0xFF120F27);

  @override
  void paint(Canvas canvas, Size size) {
    final primary = scheme.primary;
    final pointer = Offset(centre.dx, centre.dy - ringR);

    // The dark "cosmic" panel the wheel sits on.
    final panel = RRect.fromRectAndRadius(
      Rect.fromLTWH(6, 0, size.width - 12, size.height),
      const Radius.circular(24),
    );
    canvas.drawRRect(
      panel,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgTop, _bgBottom],
        ).createShader(Offset.zero & size),
    );
    canvas.save();
    canvas.clipRRect(panel); // keep the glow / beam inside the panel

    // Starfield — tiny dots scattered on the dark background.
    final starDotPaint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    final rng = _PseudoRandom(42);
    for (var i = 0; i < 60; i++) {
      final sx = rng.next() * size.width;
      final sy = rng.next() * size.height;
      final sr = 0.4 + rng.next() * 1.1;
      canvas.drawCircle(
        Offset(sx, sy),
        sr,
        starDotPaint
          ..color = Colors.white.withValues(alpha: 0.08 + rng.next() * 0.22),
      );
    }

    // Glow where the selected sign lands — tight around the active icon.
    canvas.drawCircle(
      pointer,
      45,
      Paint()
        ..shader = RadialGradient(
          colors: [
            primary.withValues(alpha: 0.55),
            const Color(0xFFFFB347).withValues(alpha: 0.15),
            primary.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: pointer, radius: 45)),
    );

    // Light beam, hub → pointer (narrow — only covers the active slot).
    final beam = Path()
      ..moveTo(centre.dx - 18, centre.dy)
      ..lineTo(centre.dx - 36, centre.dy - ringR + 6)
      ..lineTo(centre.dx + 36, centre.dy - ringR + 6)
      ..lineTo(centre.dx + 18, centre.dy)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                primary.withValues(alpha: 0.15),
                primary.withValues(alpha: 0.02),
              ],
            ).createShader(
              Rect.fromLTRB(
                centre.dx - 36,
                centre.dy - ringR,
                centre.dx + 36,
                centre.dy,
              ),
            ),
    );

    // Rim arc + tick marks on the ring the icons ride.
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: ringR),
      -math.pi / 2 - _arc,
      _arc * 2,
      false,
      rim,
    );
    for (var i = -3; i <= 3; i++) {
      final dir = Offset(math.sin(i * _kStep), -math.cos(i * _kStep));
      canvas.drawLine(
        centre + dir * (ringR - 6),
        centre + dir * (ringR + 6),
        rim,
      );
    }

    // The hub — a dark disc with a small radiating star, echoing the artwork.
    const hubR = 34.0;
    canvas.drawCircle(
      centre,
      hubR,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF3A2A6B), Color(0xFF161235)],
        ).createShader(Rect.fromCircle(center: centre, radius: hubR)),
    );
    canvas.drawCircle(
      centre,
      hubR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = primary.withValues(alpha: 0.6),
    );
    final star = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.30);
    for (var i = 0; i < 8; i++) {
      final a = i * (math.pi / 4);
      canvas.drawLine(
        centre,
        centre + Offset(math.sin(a), -math.cos(a)) * (hubR - 8),
        star,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_WheelPainter old) =>
      old.centre != centre ||
      old.ringR != ringR ||
      old.scheme.primary != scheme.primary;
}

/// Simple deterministic pseudo-random for starfield (no dart:math Random in
/// paint — we want identical stars each frame to avoid shimmer).
class _PseudoRandom {
  _PseudoRandom(this._seed);
  int _seed;
  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
