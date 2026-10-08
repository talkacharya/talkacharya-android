import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../performance/presentation/widgets/perf_format.dart';
import '../../../workspace/presentation/widgets/async_page.dart';
import '../../data/training_api.dart';
import 'training_player_page.dart';

/// The language lessons play in. Starts as the app's own language; the
/// astrologer can switch, and the choice holds for as long as the app runs.
final ValueNotifier<String?> trainingLanguage = ValueNotifier<String?>(null);

String currentTrainingLanguage(BuildContext context) =>
    trainingLanguage.value ??
    (Localizations.localeOf(context).languageCode == 'hi' ? 'hi' : 'en');

/// The lessons: what is required and how much of it is done, a switch for
/// the language they play in, and each lesson with its progress. A lesson
/// opens in the app's own player, which is what keeps count.
class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final _store = getIt<OnboardingStore>();

  /// Opened from the gate, before the app itself was open.
  late final bool _gated = _store.stage != OnboardingStage.approved;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<TrainingData>(
      title: l.wsTraining,
      subtitle: l.trainSubtitle,
      load: getIt<TrainingApi>().load,
      bottomBar: !_gated
          ? null
          : (context, _) => ListenableBuilder(
              listenable: _store,
              builder: (context, _) => _store.stage == OnboardingStage.approved
                  ? const TrainingDoneBar()
                  : const SizedBox.shrink(),
            ),
      builder: (context, data, _, reload) {
        if (data.lessons.isEmpty) {
          return [
            WsEmpty(
              icon: Icons.play_circle_rounded,
              hue: AstroPalette.fire,
              title: l.wsTrainingEmpty,
              message: l.wsTrainingEmptyBody,
            ),
          ];
        }
        Future<void> open(TrainingLesson lesson) async {
          final language = currentTrainingLanguage(context);
          await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(
              builder: (_) => TrainingPlayerPage(
                lesson: lesson,
                language: language,
                completePercent: data.status.completePercent,
              ),
            ),
          );
          await reload();
          // Finishing the last required lesson is what opens the app.
          await _store.refresh();
        }

        // Required first, then by shelf, in the order the team set.
        final required = data.lessons.where((v) => v.isMandatory).toList();
        final shelves = <String, List<TrainingLesson>>{};
        for (final v in data.lessons.where((v) => !v.isMandatory)) {
          shelves.putIfAbsent(v.category, () => []).add(v);
        }
        return [
          if (data.status.mandatoryTotal > 0)
            _ProgressHero(status: data.status),
          const _LanguageSwitch(),
          if (required.isNotEmpty) ...[
            _ShelfTitle(l.trainRequiredShelf),
            for (final v in required)
              _LessonCard(lesson: v, onTap: () => open(v)),
          ],
          for (final shelf in shelves.entries) ...[
            _ShelfTitle(shelf.key.isEmpty ? l.trainMoreShelf : shelf.key),
            for (final v in shelf.value)
              _LessonCard(lesson: v, onTap: () => open(v)),
          ],
        ];
      },
    );
  }
}

class _ShelfTitle extends StatelessWidget {
  const _ShelfTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: context.brand.inkMuted,
      ),
    ),
  );
}

/// How many of the required lessons are done, as a ring and a sentence —
/// and, while they stand between the astrologer and the app, saying so.
class _ProgressHero extends StatelessWidget {
  const _ProgressHero({required this.status});

  final TrainingStatus status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final s = status;
    final done = s.mandatoryDone >= s.mandatoryTotal;
    final hue = done ? AstroPalette.health : AstroPalette.fire;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.18), hue.tint(0.05)],
        ),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.square(
                  dimension: 62,
                  child: CircularProgressIndicator(
                    value: s.mandatoryTotal == 0
                        ? 0
                        : s.mandatoryDone / s.mandatoryTotal,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    color: hue.end,
                    backgroundColor: hue.tint(0.25),
                  ),
                ),
                done
                    ? Icon(Icons.check_rounded, color: hue.end, size: 28)
                    : Text(
                        '${s.mandatoryDone}/${s.mandatoryTotal}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done
                      ? l.trainHeroDone
                      : l.trainHeroCount(s.mandatoryDone, s.mandatoryTotal),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  done
                      ? l.trainHeroDoneBody
                      : s.blocked
                      ? l.trainHeroBlockedBody
                      : s.required
                      ? l.trainHeroRequiredBody
                      : l.trainHeroOptionalBody,
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
    );
  }
}

/// English | हिन्दी — which version of each lesson plays.
class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return ValueListenableBuilder<String?>(
      valueListenable: trainingLanguage,
      builder: (context, _, _) {
        final current = currentTrainingLanguage(context);
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(Icons.translate_rounded, size: 18, color: brand.inkMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.trainLanguage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: brand.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: brand.tint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (code, name) in const [
                      ('en', 'English'),
                      ('hi', 'हिन्दी'),
                    ])
                      Pressable(
                        child: GestureDetector(
                          onTap: () => trainingLanguage.value = code,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: code == current
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              name,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: code == current
                                    ? theme.colorScheme.onPrimary
                                    : brand.inkMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, required this.onTap});

  final TrainingLesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final v = lesson;
    final hue = v.completed ? AstroPalette.health : AstroPalette.fire;
    final thumb = v.thumbnail;
    return WsCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.sm),
            child: SizedBox(
              width: 108,
              height: 68,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumb != null && thumb.isNotEmpty)
                    Image.network(
                      thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => DecoratedBox(
                        decoration: BoxDecoration(gradient: hue.linear()),
                      ),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(gradient: hue.linear()),
                    ),
                  Center(
                    child: Icon(
                      v.completed
                          ? Icons.check_circle_rounded
                          : Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  // How far through, along the foot of the picture.
                  if (!v.completed && v.percent > 0)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        value: v.percent / 100,
                        minHeight: 4,
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (v.durationSeconds > 0)
                      Text(
                        formatDuration(l, v.durationSeconds),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    if (v.completed)
                      _Tag(label: l.trainDone, hue: AstroPalette.health)
                    else if (v.quizPending)
                      _Tag(label: l.trainQuizLeft, hue: AstroPalette.air)
                    else if (v.percent > 0)
                      _Tag(
                        label: l.trainPercent(v.percent),
                        hue: AstroPalette.career,
                      ),
                    if (v.isMandatory && !v.completed)
                      _Tag(label: l.trainRequiredTag, hue: AstroPalette.fire),
                    if (v.isNew && v.percent == 0)
                      _Tag(label: l.wsNew, hue: AstroPalette.money),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.hue});

  final String label;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: hue.tint(0.13),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: hue.end,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

/// Shown when training holds the app back and is now done: the way in.
class TrainingDoneBar extends StatelessWidget {
  const TrainingDoneBar({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: FilledButton.icon(
        onPressed: () => context.go(Routes.home),
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(context.l10n.trainEnterApp),
      ),
    ),
  );
}
