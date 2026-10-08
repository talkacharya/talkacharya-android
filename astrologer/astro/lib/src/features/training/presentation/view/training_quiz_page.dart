import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../workspace/presentation/widgets/async_page.dart';
import '../../data/training_api.dart';

/// The few questions after a lesson. Every one has to be answered before it
/// can be sent; a miss can be tried again, and only the score is shown — not
/// which answers were wrong — so the retry is thought through, not copied.
///
/// Pops `true` once passed.
class TrainingQuizPage extends StatefulWidget {
  const TrainingQuizPage({required this.lesson, super.key});

  final TrainingLesson lesson;

  @override
  State<TrainingQuizPage> createState() => _TrainingQuizPageState();
}

class _TrainingQuizPageState extends State<TrainingQuizPage> {
  final _answers = <String, int>{};
  QuizResult? _result;
  bool _sending = false;

  Future<void> _submit() async {
    final l = context.l10n;
    setState(() => _sending = true);
    try {
      final result = await getIt<TrainingApi>().submitQuiz(
        widget.lesson.id,
        _answers,
      );
      if (mounted) setState(() => _result = result);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final result = _result;
    return AsyncPage<List<QuizQuestion>>(
      title: l.trainQuizTitle,
      subtitle: widget.lesson.title,
      load: () => getIt<TrainingApi>().quiz(widget.lesson.id),
      bottomBar: result != null
          ? null
          : (context, _) => StickyActionBar(
              child: BusyButton(
                label: l.trainQuizSubmit,
                icon: Icons.check_rounded,
                busy: _sending,
                // Greyed until every question has an answer.
                onPressed: _sending || !_complete ? null : _submit,
              ),
            ),
      builder: (context, questions, _, _) {
        _total = questions.length;
        if (result != null) {
          return [
            _ResultCard(
              result: result,
              onDone: () => Navigator.of(context).pop(true),
              onRetry: () => setState(() {
                _result = null;
                _answers.clear();
              }),
            ),
          ];
        }
        return [
          for (final (i, q) in questions.indexed)
            _QuestionCard(
              number: i + 1,
              question: q,
              chosen: _answers[q.id],
              onChoose: _sending
                  ? null
                  : (index) => setState(() => _answers[q.id] = index),
            ),
        ];
      },
    );
  }

  int _total = 0;
  bool get _complete => _total > 0 && _answers.length >= _total;
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.number,
    required this.question,
    required this.chosen,
    required this.onChoose,
  });

  final int number;
  final QuizQuestion question;
  final int? chosen;
  final ValueChanged<int>? onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final primary = theme.colorScheme.primary;
    return SettingsCard(
      title: question.text,
      subtitle: context.l10n.trainQuizQuestion(number),
      icon: Icons.help_rounded,
      hue: AstroPalette.air,
      child: Column(
        children: [
          for (final (i, option) in question.options.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Pressable(
                child: Material(
                  color: i == chosen
                      ? primary.withValues(alpha: 0.08)
                      : theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                    side: BorderSide(
                      color: i == chosen ? primary : brand.hairline,
                      width: i == chosen ? 1.6 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onChoose == null ? null : () => onChoose!(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            i == chosen
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: i == chosen ? primary : brand.inkMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              option,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: i == chosen
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.onDone,
    required this.onRetry,
  });

  final QuizResult result;
  final VoidCallback onDone;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final r = result;
    final hue = r.passed ? AstroPalette.health : AstroPalette.fire;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.18), hue.tint(0.05)],
        ),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Column(
        children: [
          HueIcon(
            hue: hue,
            icon: r.passed ? Icons.verified_rounded : Icons.replay_rounded,
            size: 64,
            iconSize: 32,
          ),
          const SizedBox(height: 14),
          Text(
            r.passed ? l.trainQuizPassed : l.trainQuizFailed,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            r.passed
                ? l.trainQuizPassedBody(r.score)
                : l.trainQuizFailedBody(r.score, r.passPercent),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: brand.inkMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: r.passed ? onDone : onRetry,
            child: Text(r.passed ? l.trainQuizContinue : l.trainQuizRetry),
          ),
        ],
      ),
    );
  }
}
