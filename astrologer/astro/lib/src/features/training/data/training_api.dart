import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Whether training is asked of this astrologer, and how far they have got
/// with the lessons marked required.
class TrainingStatus {
  const TrainingStatus({
    required this.required,
    required this.blocked,
    required this.mandatoryDone,
    required this.mandatoryTotal,
    required this.completePercent,
    required this.quizEnabled,
  });

  /// Required lessons must be finished to use the app.
  final bool required;

  /// Required, and not finished: the app is held back.
  final bool blocked;
  final int mandatoryDone;
  final int mandatoryTotal;

  /// How much of a lesson has to be watched for it to count.
  final int completePercent;
  final bool quizEnabled;

  factory TrainingStatus.fromJson(Map<String, dynamic> j) => TrainingStatus(
    required: j['required'] == true,
    blocked: j['blocked'] == true,
    mandatoryDone: (j['mandatory_done'] as num?)?.toInt() ?? 0,
    mandatoryTotal: (j['mandatory_total'] as num?)?.toInt() ?? 0,
    completePercent: (j['complete_percent'] as num?)?.toInt() ?? 90,
    quizEnabled: j['quiz_enabled'] == true,
  );
}

/// One lesson, in both languages, with this astrologer's progress through it.
class TrainingLesson {
  const TrainingLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.durationSeconds,
    required this.category,
    required this.isNew,
    required this.isMandatory,
    required this.urls,
    required this.hasQuiz,
    required this.positionSeconds,
    required this.percent,
    required this.watched,
    required this.quizPassed,
    required this.completed,
  });

  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final int durationSeconds;
  final String category;
  final bool isNew;
  final bool isMandatory;

  /// Language code → where that version plays from.
  final Map<String, String> urls;

  /// A quiz stands between watching and finishing.
  final bool hasQuiz;

  /// The furthest point watched so far.
  final int positionSeconds;
  final int percent;

  /// Watched far enough to count.
  final bool watched;
  final bool quizPassed;
  final bool completed;

  /// Watched, with only the quiz left.
  bool get quizPending => watched && hasQuiz && !quizPassed;

  /// The version to play for [language], falling back to whichever exists.
  String urlFor(String language) =>
      urls[language] ?? urls['en'] ?? (urls.values.firstOrNull ?? '');

  /// Whether a separate version exists for each of the two languages.
  bool get hasBothLanguages =>
      (urls['en'] ?? '').isNotEmpty &&
      (urls['hi'] ?? '').isNotEmpty &&
      urls['en'] != urls['hi'];

  factory TrainingLesson.fromJson(Map<String, dynamic> j) {
    final p = (j['progress'] as Map?)?.cast<String, dynamic>() ?? const {};
    return TrainingLesson(
      id: '${j['id']}',
      title: j['title'] as String? ?? '',
      description: j['description'] as String? ?? '',
      thumbnail: j['thumbnail'] as String?,
      durationSeconds: (j['duration_seconds'] as num?)?.toInt() ?? 0,
      category: j['category'] as String? ?? '',
      isNew: j['is_new'] == true,
      isMandatory: j['is_mandatory'] == true,
      urls: {
        for (final e in (j['video_urls'] as Map? ?? const {}).entries)
          '${e.key}': '${e.value}',
      },
      hasQuiz: j['has_quiz'] == true,
      positionSeconds: (p['position_seconds'] as num?)?.toInt() ?? 0,
      percent: (p['percent'] as num?)?.toInt() ?? 0,
      watched: p['watched'] == true,
      quizPassed: p['quiz_passed'] == true,
      completed: p['completed'] == true,
    );
  }
}

class TrainingData {
  const TrainingData({required this.status, required this.lessons});

  final TrainingStatus status;
  final List<TrainingLesson> lessons;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
  });

  final String id;
  final String text;
  final List<String> options;

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
    id: '${j['id']}',
    text: j['text'] as String? ?? '',
    options: [for (final o in j['options'] as List? ?? const []) '$o'],
  );
}

class QuizResult {
  const QuizResult({
    required this.passed,
    required this.score,
    required this.passPercent,
    required this.completed,
  });

  final bool passed;
  final int score;
  final int passPercent;

  /// The lesson is now finished.
  final bool completed;

  factory QuizResult.fromJson(Map<String, dynamic> j) => QuizResult(
    passed: j['passed'] == true,
    score: (j['score'] as num?)?.toInt() ?? 0,
    passPercent: (j['pass_percent'] as num?)?.toInt() ?? 70,
    completed: j['completed'] == true,
  );
}

/// Lessons, progress and quizzes (`/astro/training…`).
class TrainingApi {
  TrainingApi(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<TrainingData> load() => _guard(() async {
    final res = (await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroTraining,
    )).ensureOk();
    final j = res.data ?? const {};
    return TrainingData(
      status: TrainingStatus.fromJson(
        (j['status'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      lessons: [
        for (final row in j['lessons'] as List? ?? const [])
          TrainingLesson.fromJson((row as Map).cast<String, dynamic>()),
      ],
    );
  });

  /// Tells the server how far playback has got; returns the lesson as it now
  /// stands. [durationSeconds] is the player's own measure of the length.
  Future<TrainingLesson> reportProgress(
    String id, {
    required int positionSeconds,
    required int durationSeconds,
  }) => _guard(() async {
    final res = (await _dio.post<Map<String, dynamic>>(
      ApiPaths.astroTrainingProgress(id),
      data: {
        'position_seconds': positionSeconds,
        'duration_seconds': durationSeconds,
      },
    )).ensureOk();
    return TrainingLesson.fromJson(
      ((res.data ?? const {})['lesson'] as Map).cast<String, dynamic>(),
    );
  });

  Future<List<QuizQuestion>> quiz(String id) => _guard(() async {
    final res = (await _dio.get<Map<String, dynamic>>(
      ApiPaths.astroTrainingQuiz(id),
    )).ensureOk();
    return [
      for (final q in (res.data ?? const {})['questions'] as List? ?? const [])
        QuizQuestion.fromJson((q as Map).cast<String, dynamic>()),
    ];
  });

  /// [answers] maps a question's id to the index of the chosen option.
  Future<QuizResult> submitQuiz(String id, Map<String, int> answers) =>
      _guard(() async {
        final res = (await _dio.post<Map<String, dynamic>>(
          ApiPaths.astroTrainingQuiz(id),
          data: {'answers': answers},
        )).ensureOk();
        return QuizResult.fromJson(res.data ?? const {});
      });
}
