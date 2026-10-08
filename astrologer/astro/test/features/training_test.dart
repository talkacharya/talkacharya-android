import 'package:astro/src/core/astro/onboarding_store.dart';
import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/features/training/data/training_api.dart';
import 'package:astro/src/features/training/presentation/view/training_page.dart';
import 'package:astro/src/features/training/presentation/view/training_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockTraining extends Mock implements TrainingApi {}

class _MockOnboarding extends Mock implements OnboardingStore {}

Widget _app(Widget home) => MaterialApp(
  theme: ThemeData(extensions: const [BrandColors.light]),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

Map<String, dynamic> _lesson(
  String id,
  String title, {
  bool mandatory = false,
  String category = '',
  Map<String, dynamic> progress = const {},
  bool hasQuiz = false,
}) => {
  'id': id,
  'title': title,
  'duration_seconds': 185,
  'category': category,
  'is_mandatory': mandatory,
  'video_urls': {
    'en': 'https://example.com/$id.mp4',
    'hi': 'https://example.com/$id-hi.mp4',
  },
  'has_quiz': hasQuiz,
  'progress': progress,
};

void main() {
  late _MockTraining api;
  late _MockOnboarding onboarding;

  setUp(() {
    api = _MockTraining();
    onboarding = _MockOnboarding();
    when(() => onboarding.stage).thenReturn(OnboardingStage.approved);
    when(() => onboarding.refresh()).thenAnswer((_) async {});
    GetIt.I
      ..registerSingleton<TrainingApi>(api)
      ..registerSingleton<OnboardingStore>(onboarding);
    trainingLanguage.value = null;
  });

  tearDown(GetIt.I.reset);

  test('a lesson knows its versions and when only the quiz is left', () {
    final both = TrainingLesson.fromJson(
      _lesson(
        'v1',
        'First call',
        hasQuiz: true,
        progress: {'percent': 95, 'watched': true},
      ),
    );
    expect(both.hasBothLanguages, isTrue);
    expect(both.urlFor('hi'), 'https://example.com/v1-hi.mp4');
    expect(both.quizPending, isTrue);
    expect(both.completed, isFalse);

    final one = TrainingLesson.fromJson({
      'id': 'v2',
      'video_urls': {
        'en': 'https://example.com/a',
        'hi': 'https://example.com/a',
      },
    });
    expect(one.hasBothLanguages, isFalse);
  });

  testWidgets('required lessons come first, with how far each has got', (
    tester,
  ) async {
    when(() => api.load()).thenAnswer(
      (_) async => TrainingData(
        status: TrainingStatus.fromJson({
          'required': true,
          'blocked': true,
          'mandatory_done': 1,
          'mandatory_total': 2,
          'complete_percent': 90,
        }),
        lessons: [
          TrainingLesson.fromJson(
            _lesson(
              'v1',
              'Your first session',
              mandatory: true,
              progress: {'percent': 100, 'watched': true, 'completed': true},
            ),
          ),
          TrainingLesson.fromJson(
            _lesson(
              'v2',
              'What you may not share',
              mandatory: true,
              progress: {'percent': 40},
            ),
          ),
          TrainingLesson.fromJson(
            _lesson('v3', 'Setting your rates', category: 'Earning more'),
          ),
        ],
      ),
    );
    await tester.pumpWidget(_app(const TrainingPage()));
    await _settle(tester);

    expect(find.text('1 of 2 required lessons done'), findsOneWidget);
    expect(
      find.text('Finish the required lessons to start using the app.'),
      findsOneWidget,
    );
    expect(find.text('Earning more'), findsOneWidget);
    expect(find.text('40% watched'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    // Opened from inside the app: no way-in bar.
    expect(find.text('Enter the app'), findsNothing);
  });

  testWidgets('the quiz is sent only once every question is answered', (
    tester,
  ) async {
    when(() => api.quiz('v1')).thenAnswer(
      (_) async => const [
        QuizQuestion(
          id: 'q1',
          text: 'When does billing start?',
          options: ['On accept', 'After 5 minutes'],
        ),
        QuizQuestion(
          id: 'q2',
          text: 'May you share your number?',
          options: ['Yes', 'No'],
        ),
      ],
    );
    when(() => api.submitQuiz('v1', any())).thenAnswer(
      (_) async => const QuizResult(
        passed: false,
        score: 50,
        passPercent: 70,
        completed: false,
      ),
    );
    final lesson = TrainingLesson.fromJson(_lesson('v1', 'First call'));
    await tester.pumpWidget(_app(TrainingQuizPage(lesson: lesson)));
    await _settle(tester);

    await tester.tap(find.text('On accept'));
    await tester.pump();
    await tester.tap(find.text('Submit answers'));
    await tester.pump();
    verifyNever(() => api.submitQuiz(any(), any()));

    await tester.tap(find.text('Yes'));
    await tester.pump();
    await tester.tap(find.text('Submit answers'));
    await _settle(tester);

    verify(() => api.submitQuiz('v1', {'q1': 0, 'q2': 0})).called(1);
    expect(find.text('Not quite'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
