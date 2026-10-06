import 'package:flutter/material.dart';

class ChatRoomSkeleton extends StatefulWidget {
  const ChatRoomSkeleton({super.key});

  @override
  State<ChatRoomSkeleton> createState() => _ChatRoomSkeletonState();
}

class _ChatRoomSkeletonState extends State<ChatRoomSkeleton>
    with SingleTickerProviderStateMixin {
  // Swap for your theme colors.
  static const _bg = Color(0xFFFFF8F5);
  static const _recv = Color(0xFFEFDDD6);
  static const _recvBar = Color(0xFFE2C9BE);
  static const _sent = Color(0xFF8E4B2C);
  static const _sentBar = Color(0x40FFFFFF);
  static const _card = Color(0xFFFFF0EB);
  static const _cardBorder = Color(0xFFEBD3C9);
  static const _neutral = Color(0xFFEBDAD2);

  // (isMine, textWidth) top to bottom, mirroring the real chat.
  static const _items = <(bool, double)>[
    (true, 60),
    (false, 190),
    (true, 80),
    (false, 50),
    (false, 110),
    (false, 50),
    (false, 150),
    (false, 240),
    (true, 50),
    (true, 200),
  ];

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _b(double w, double h, {double? r, Color color = _neutral}) =>
      Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r ?? h / 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(-1.5 + 3 * _c.value, -0.3),
            end: Alignment(-0.5 + 3 * _c.value, 0.3),
            colors: const [
              Color(0x00FFFFFF),
              Color(0x66FFFFFF),
              Color(0x00FFFFFF),
            ],
          ).createShader(rect),
          child: child,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    children: [
                      for (final (mine, w) in _items) _bubble(mine, w),
                    ],
                  ),
                ),
              ),
              Center(child: _b(230, 36, color: _recv)), // "Chat ended" pill
              const SizedBox(height: 14),
              _ratingCard(),
              const SizedBox(height: 10),
              _composer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        _b(24, 24, r: 12),
        const SizedBox(width: 20),
        _b(46, 46, r: 23), // avatar
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _b(140, 16), // name
            const SizedBox(height: 7),
            _b(100, 11), // consultation status
          ],
        ),
        const Spacer(),
        _b(24, 24, r: 12), // search
        const SizedBox(width: 22),
        _b(6, 24, r: 3), // more
        const SizedBox(width: 8),
      ],
    ),
  );

  Widget _bubble(bool mine, double width) {
    final bar = mine ? _sentBar : _recvBar;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        decoration: BoxDecoration(
          color: mine ? _sent : _recv,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(mine ? 20 : 6),
            bottomRight: Radius.circular(mine ? 6 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _b(width, 12, color: bar),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _b(12, 12, color: bar), // speaker icon
                const SizedBox(width: 8),
                _b(44, 8, color: bar), // time
                if (mine) ...[
                  const SizedBox(width: 8),
                  _b(14, 8, color: bar), // ticks
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingCard() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: _cardBorder),
    ),
    child: Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 5; i++) ...[
              _b(22, 22, r: 5, color: _cardBorder), // stars
              const SizedBox(width: 4),
            ],
            const SizedBox(width: 12),
            _b(150, 12), // "You rated this session"
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _b(22, 22, r: 6), // lock icon
            const SizedBox(width: 12),
            _b(220, 14), // "Consultation ended..."
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _sent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(child: _b(140, 14, color: _sentBar)),
        ),
        const SizedBox(height: 12),
        _b(210, 10), // "Chat again with ..."
      ],
    ),
  );

  Widget _composer() => Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: _cardBorder)),
    ),
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
    child: Row(
      children: [
        _b(28, 28, r: 7),
        const SizedBox(width: 14),
        Expanded(child: _b(double.infinity, 52, r: 26)),
        const SizedBox(width: 10),
        _b(52, 52, r: 26),
      ],
    ),
  );
}
