import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/training_api.dart';
import 'training_page.dart';
import 'training_quiz_page.dart';

/// Plays one lesson and keeps count of how much of it has been watched.
///
/// The first time through, the astrologer cannot drag past the furthest point
/// they have watched — a lesson that can be skipped to its end has not been
/// watched. Going back is always allowed, and once it is finished it plays
/// like any video.
class TrainingPlayerPage extends StatefulWidget {
  const TrainingPlayerPage({
    required this.lesson,
    required this.language,
    required this.completePercent,
    super.key,
  });

  final TrainingLesson lesson;

  /// The version to start in: `en` or `hi`.
  final String language;
  final int completePercent;

  @override
  State<TrainingPlayerPage> createState() => _TrainingPlayerPageState();
}

class _TrainingPlayerPageState extends State<TrainingPlayerPage>
    with WidgetsBindingObserver {
  late TrainingLesson _lesson = widget.lesson;
  VideoPlayerController? _video;
  Timer? _report;
  late String _language = widget.language;
  String? _error;

  /// The furthest point watched, in seconds: what seeking is held to.
  late int _furthest = widget.lesson.positionSeconds;
  int _lastSent = -1;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open(startAt: _lesson.completed ? 0 : _lesson.positionSeconds);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _report?.cancel();
    unawaited(_send());
    _video?.removeListener(_onTick);
    _video?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A lesson does not play to an empty room.
    if (state != AppLifecycleState.resumed) {
      _video?.pause();
      unawaited(_send());
    }
  }

  Future<void> _open({required int startAt}) async {
    final url = _lesson.urlFor(_language);
    final old = _video;
    old?.removeListener(_onTick);
    setState(() {
      _video = null;
      _error = null;
      _ended = false;
    });
    await old?.dispose();
    final uri = Uri.tryParse(url);
    if (url.isEmpty || uri == null) {
      if (mounted) setState(() => _error = context.l10n.trainNoVideo);
      return;
    }
    final video = VideoPlayerController.networkUrl(uri);
    try {
      await video.initialize();
      final length = video.value.duration.inSeconds;
      // Not right at the end: a lesson reopened starts somewhere watchable.
      final from = length > 0 && startAt >= length - 3 ? 0 : startAt;
      if (from > 0) await video.seekTo(Duration(seconds: from));
      if (!mounted) {
        await video.dispose();
        return;
      }
      video.addListener(_onTick);
      setState(() => _video = video);
      await video.play();
      _report ??= Timer.periodic(
        const Duration(seconds: 10),
        (_) => unawaited(_send()),
      );
    } catch (_) {
      await video.dispose();
      if (mounted) setState(() => _error = context.l10n.trainCantPlay);
    }
  }

  void _onTick() {
    final v = _video?.value;
    if (v == null || !mounted) return;
    final now = v.position.inSeconds;
    if (now > _furthest) _furthest = now;
    final ended =
        v.duration > Duration.zero &&
        v.position >= v.duration - const Duration(milliseconds: 400);
    if (ended && !_ended) {
      _ended = true;
      unawaited(_send());
    }
    setState(() {});
  }

  /// Tells the server the furthest point reached, when it has moved on.
  Future<void> _send() async {
    final v = _video?.value;
    if (v == null || _furthest == _lastSent) return;
    _lastSent = _furthest;
    try {
      final lesson = await getIt<TrainingApi>().reportProgress(
        _lesson.id,
        positionSeconds: _furthest,
        durationSeconds: v.duration.inSeconds,
      );
      if (mounted) setState(() => _lesson = lesson);
    } catch (_) {
      _lastSent = -1; // try again at the next beat
    }
  }

  void _seek(double seconds) {
    final v = _video;
    if (v == null) return;
    // Forward only as far as has been watched, until the lesson is finished.
    final limit = _lesson.completed
        ? v.value.duration.inSeconds
        : _furthest.clamp(0, v.value.duration.inSeconds);
    v.seekTo(Duration(seconds: seconds.round().clamp(0, limit)));
  }

  Future<void> _switchLanguage(String code) async {
    if (code == _language) return;
    final at = _video?.value.position.inSeconds ?? 0;
    trainingLanguage.value = code;
    _language = code;
    await _open(startAt: at);
  }

  Future<void> _takeQuiz() async {
    await _video?.pause();
    if (!mounted) return;
    final passed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => TrainingQuizPage(lesson: _lesson)),
    );
    if (passed == true && mounted) {
      setState(() {
        _lesson = _lesson.copyAsCompleted();
      });
      showToast(context, context.l10n.trainLessonDone);
    }
  }

  static String _clock(Duration d) {
    final s = d.inSeconds;
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final video = _video;
    final value = video?.value;
    final length = value?.duration.inSeconds ?? _lesson.durationSeconds;
    final percent = length > 0
        ? (_furthest * 100 / length).round().clamp(_lesson.percent, 100)
        : _lesson.percent;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.canvas,
        body: Column(
          children: [
            // The picture, under the status bar, with its own controls.
            ColoredBox(
              color: Colors.black,
              child: SafeArea(
                bottom: false,
                child: AspectRatio(
                  aspectRatio: value != null && value.aspectRatio > 0
                      ? value.aspectRatio.clamp(1.2, 1.9)
                      : 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (video != null)
                        Center(
                          child: AspectRatio(
                            aspectRatio: value!.aspectRatio,
                            child: VideoPlayer(video),
                          ),
                        )
                      else if (_error != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.white70,
                                  size: 34,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () => _open(startAt: _furthest),
                                  child: Text(l.commonRetry),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      if (video != null)
                        _Controls(
                          playing: value!.isPlaying,
                          buffering: value.isBuffering,
                          position: value.position,
                          duration: value.duration,
                          // What may be dragged to: everything once finished.
                          reachable: _lesson.completed
                              ? value.duration.inSeconds
                              : _furthest,
                          clock: _clock,
                          onToggle: () =>
                              value.isPlaying ? video.pause() : video.play(),
                          onSeek: _seek,
                        ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Text(
                    _lesson.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StateCard(
                    lesson: _lesson,
                    percent: percent,
                    needed: widget.completePercent,
                    onQuiz: _takeQuiz,
                  ),
                  if (_lesson.hasBothLanguages)
                    SettingsCard(
                      title: l.trainLanguage,
                      icon: Icons.translate_rounded,
                      hue: AstroPalette.air,
                      child: Row(
                        children: [
                          for (final (code, name) in const [
                            ('en', 'English'),
                            ('hi', 'हिन्दी'),
                          ]) ...[
                            Expanded(
                              child: _LanguageChoice(
                                label: name,
                                selected: code == _language,
                                onTap: () => _switchLanguage(code),
                              ),
                            ),
                            if (code == 'en') const SizedBox(width: 10),
                          ],
                        ],
                      ),
                    ),
                  if (_lesson.description.trim().isNotEmpty)
                    SettingsCard(
                      title: l.trainAbout,
                      icon: Icons.notes_rounded,
                      hue: AstroPalette.career,
                      child: Text(
                        _lesson.description.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
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

extension on TrainingLesson {
  /// The lesson as it stands once its quiz has been passed.
  TrainingLesson copyAsCompleted() => TrainingLesson(
    id: id,
    title: title,
    description: description,
    thumbnail: thumbnail,
    durationSeconds: durationSeconds,
    category: category,
    isNew: isNew,
    isMandatory: isMandatory,
    urls: urls,
    hasQuiz: hasQuiz,
    positionSeconds: positionSeconds,
    percent: percent,
    watched: true,
    quizPassed: true,
    completed: true,
  );
}

/// Play / pause in the middle, time and the seek bar along the foot.
class _Controls extends StatelessWidget {
  const _Controls({
    required this.playing,
    required this.buffering,
    required this.position,
    required this.duration,
    required this.reachable,
    required this.clock,
    required this.onToggle,
    required this.onSeek,
  });

  final bool playing;
  final bool buffering;
  final Duration position;
  final Duration duration;

  /// Seconds the bar may be dragged to.
  final int reachable;
  final String Function(Duration) clock;
  final VoidCallback onToggle;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    final total = duration.inSeconds.toDouble();
    final gold = context.brand.gold;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: playing && !buffering ? 0 : 1,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: buffering
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xB3000000)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
              child: Row(
                children: [
                  Text(
                    clock(position),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        activeTrackColor: gold,
                        // The stretch watched but not yet replayed.
                        secondaryActiveTrackColor: Colors.white54,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: gold,
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Slider(
                          max: total <= 0 ? 1 : total,
                          value: position.inSeconds.toDouble().clamp(
                            0,
                            total <= 0 ? 1 : total,
                          ),
                          secondaryTrackValue: reachable.toDouble().clamp(
                            0,
                            total <= 0 ? 1 : total,
                          ),
                          onChanged: total <= 0 ? null : onSeek,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    clock(duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Where the lesson stands: how much is watched against how much is needed,
/// then the quiz if there is one, then done.
class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.lesson,
    required this.percent,
    required this.needed,
    required this.onQuiz,
  });

  final TrainingLesson lesson;
  final int percent;
  final int needed;
  final VoidCallback onQuiz;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final v = lesson;
    final hue = v.completed
        ? AstroPalette.health
        : v.quizPending
        ? AstroPalette.air
        : AstroPalette.fire;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [hue.tint(0.16), hue.tint(0.05)]),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              HueIcon(
                hue: hue,
                icon: v.completed
                    ? Icons.verified_rounded
                    : v.quizPending
                    ? Icons.quiz_rounded
                    : Icons.play_lesson_rounded,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.completed
                          ? l.trainStateDone
                          : v.quizPending
                          ? l.trainStateQuiz
                          : l.trainStateWatching(percent),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      v.completed
                          ? l.trainStateDoneBody
                          : v.quizPending
                          ? l.trainStateQuizBody
                          : l.trainStateWatchingBody(needed),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!v.completed && !v.quizPending) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 7,
                color: hue.end,
                backgroundColor: hue.tint(0.22),
              ),
            ),
          ],
          if (v.quizPending) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onQuiz,
              icon: const Icon(Icons.quiz_rounded),
              label: Text(l.trainTakeQuiz),
            ),
          ],
        ],
      ),
    );
  }
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Pressable(
      child: Material(
        color: selected ? primary.withValues(alpha: 0.08) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          side: BorderSide(
            color: selected ? primary : context.brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: selected ? primary : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
