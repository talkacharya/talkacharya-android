import 'package:flutter/material.dart';

class AstrologerProfileSkeleton extends StatefulWidget {
  const AstrologerProfileSkeleton({super.key});

  @override
  State<AstrologerProfileSkeleton> createState() =>
      _AstrologerProfileSkeletonState();
}

class _AstrologerProfileSkeletonState extends State<AstrologerProfileSkeleton>
    with SingleTickerProviderStateMixin {
  static const _base = Color(0xFFEFE4E1);
  static const _highlight = Color(0xFFFAF3F1);

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: AnimatedBuilder(
        animation: _c,
        child: _content(context),
        builder: (_, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(-2 + 3 * _c.value, -0.4),
            end: Alignment(-1 + 3 * _c.value, 0.4),
            colors: const [_base, _highlight, _base],
            stops: const [0.35, 0.5, 0.65],
          ).createShader(rect),
          child: child,
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            children: [
              // Hero + avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const _Bone(h: 346, r: 0),
                  Positioned(
                    top: mq.padding.top + 16,
                    left: 20,
                    child: const _Bone(w: 40, h: 40, r: 20),
                  ),
                  Positioned(
                    top: mq.padding.top + 16,
                    right: 16,
                    child: const _Bone(w: 128, h: 42, r: 21),
                  ),
                  const Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        _Bone(w: 190, h: 26, r: 8),
                        SizedBox(height: 10),
                        _Bone(w: 240, h: 14, r: 7),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: 16,
                    left: 150,
                    child: Row(
                      children: [
                        _Bone(w: 130, h: 34, r: 17),
                        SizedBox(width: 12),
                        _Bone(w: 160, h: 34, r: 17),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: -55,
                    left: 20,
                    child: _Bone(w: 116, h: 116, r: 58),
                  ),
                ],
              ),
              const SizedBox(height: 80),

              // Stats
              _Card(
                child: Row(
                  children: List.generate(
                    4,
                    (_) => const Expanded(
                      child: Column(
                        children: [
                          _Bone(w: 42, h: 42, r: 12),
                          SizedBox(height: 10),
                          _Bone(w: 32, h: 14, r: 6),
                          SizedBox(height: 6),
                          _Bone(w: 56, h: 10, r: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Expertise
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bone(w: 90, h: 18, r: 6),
                    SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _Bone(w: 120, h: 38, r: 12),
                        _Bone(w: 94, h: 38, r: 12),
                        _Bone(w: 86, h: 38, r: 12),
                      ],
                    ),
                  ],
                ),
              ),

              // About
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bone(w: 70, h: 18, r: 6),
                    SizedBox(height: 16),
                    _Bone(h: 14, r: 6),
                    SizedBox(height: 10),
                    _Bone(h: 14, r: 6),
                    SizedBox(height: 10),
                    _Bone(h: 14, r: 6),
                    SizedBox(height: 10),
                    _Bone(w: 170, h: 14, r: 6),
                    SizedBox(height: 18),
                    _Bone(w: 80, h: 14, r: 6),
                    SizedBox(height: 18),
                    _Bone(h: 1, r: 0),
                    SizedBox(height: 16),
                    _Bone(w: 200, h: 14, r: 6),
                  ],
                ),
              ),

              // Consultation rates
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bone(w: 140, h: 18, r: 6),
                    SizedBox(height: 16),
                    _Bone(h: 52, r: 14),
                    SizedBox(height: 10),
                    _Bone(h: 52, r: 14),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bottom action bar
        Positioned(
          left: 16,
          right: 16,
          bottom: mq.padding.bottom + 12,
          child: const Row(
            children: [
              Expanded(flex: 5, child: _Bone(h: 58, r: 20)),
              SizedBox(width: 10),
              Expanded(child: _Bone(h: 58, r: 18)),
              SizedBox(width: 10),
              Expanded(child: _Bone(h: 58, r: 18)),
              SizedBox(width: 10),
              Expanded(child: _Bone(h: 58, r: 18)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.w, required this.h, this.r = 8});

  final double? w;
  final double h;
  final double r;

  @override
  Widget build(BuildContext context) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white, width: 1.5),
    ),
    child: child,
  );
}
