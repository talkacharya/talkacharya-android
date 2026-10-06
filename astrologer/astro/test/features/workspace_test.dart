import 'package:astro/src/core/l10n/l10n.dart';
import 'package:astro/src/features/consultations/data/consultation_api.dart';
import 'package:astro/src/features/consultations/data/models/saved_reply.dart';
import 'package:astro/src/features/livestream/data/models/host_stream.dart';
import 'package:astro/src/features/profile/data/profile_models.dart';
import 'package:astro/src/features/workspace/data/workspace_api.dart';
import 'package:astro/src/features/workspace/presentation/view/calendar_page.dart';
import 'package:astro/src/features/workspace/presentation/view/notices_pages.dart';
import 'package:astro/src/features/workspace/presentation/view/people_pages.dart';
import 'package:astro/src/features/workspace/presentation/view/studio_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockWorkspace extends Mock implements WorkspaceApi {}

class _MockConsultations extends Mock implements ConsultationApi {}

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

void main() {
  late _MockWorkspace api;

  setUp(() {
    api = _MockWorkspace();
    GetIt.I.registerSingleton<WorkspaceApi>(api);
  });

  tearDown(GetIt.I.reset);

  group('models', () {
    test('referral overview parses money and people', () {
      final r = ReferralOverview.fromJson({
        'code': 'ASTRO123',
        'invite_link': 'https://talkacharya.com/r/ASTRO123',
        'total': 3,
        'pending': 2,
        'rewarded': 1,
        'earned': '100.00',
        'currency': 'INR',
        'referee_bonus': '50',
        'referrer_bonus': '100',
        'referrals': [
          {'referee_name': 'Asha', 'status': 'rewarded'},
        ],
      });
      expect(r.earned, 100);
      expect(r.referrerBonus, 100);
      expect(r.people.single.status, 'rewarded');
    });

    test('a gallery knows when it is full', () {
      final g = Gallery.fromJson({
        'max': 2,
        'photos': [
          {'id': 'a', 'image': 'http://x/a.png'},
          {
            'id': 'b',
            'image': 'http://x/b.png',
            'status': 'rejected',
            'review_note': 'No phone numbers',
          },
        ],
      });
      expect(g.full, isTrue);
      expect(g.photos.first.status, 'approved');
      expect(g.photos.last.rejected, isTrue);
      expect(g.photos.last.reviewNote, 'No phone numbers');
    });
  });

  group('Schedule', () {
    // 2026-10-05 is a Monday: backend weekday 0.
    final monday = DateTime(2026, 10, 5);
    final schedule = Schedule(
      hours: const [
        WorkingWindow(
          weekday: 0,
          start: TimeOfDay(hour: 18, minute: 0),
          end: TimeOfDay(hour: 21, minute: 0),
        ),
        WorkingWindow(
          weekday: 0,
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        WorkingWindow(
          weekday: 2,
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
      ],
      streams: [
        HostStream(
          id: 's1',
          title: 'Navratri special',
          scheduledAt: DateTime(2026, 10, 5, 19),
        ),
        HostStream(
          id: 's2',
          status: 'ended',
          scheduledAt: DateTime(2026, 10, 5, 8),
        ),
      ],
    );

    test('a day gets its own windows, earliest first', () {
      expect(schedule.hoursOn(monday).map((w) => w.start.hour), [9, 18]);
      expect(schedule.hoursOn(monday.add(const Duration(days: 1))), isEmpty);
      expect(
        schedule.hoursOn(monday.add(const Duration(days: 2))),
        hasLength(1),
      );
    });

    test('only lives still scheduled for that day are shown', () {
      expect(schedule.streamsOn(monday).map((s) => s.id), ['s1']);
      expect(schedule.streamsOn(monday.add(const Duration(days: 1))), isEmpty);
    });
  });

  testWidgets('announcements show pinned notices and their text', (
    tester,
  ) async {
    when(() => api.announcements()).thenAnswer(
      (_) async => [
        Announcement.fromJson({
          'id': 'a1',
          'title': 'New payout cycle',
          'body': 'Payouts are weekly from November.',
          'is_pinned': true,
          'published_at': DateTime.now().toIso8601String(),
        }),
      ],
    );
    await tester.pumpWidget(_app(const AnnouncementsPage()));
    await _settle(tester);

    expect(find.text('New payout cycle'), findsOneWidget);
    expect(find.text('Payouts are weekly from November.'), findsOneWidget);
    expect(find.byIcon(Icons.push_pin_rounded), findsOneWidget);
  });

  testWidgets('training groups videos by shelf and flags new ones', (
    tester,
  ) async {
    when(() => api.trainingVideos()).thenAnswer(
      (_) async => [
        TrainingVideo.fromJson({
          'id': 'v1',
          'title': 'Your first session',
          'video_url': 'https://example.com/1',
          'duration_seconds': 185,
          'category': 'Getting started',
          'is_new': true,
        }),
        TrainingVideo.fromJson({
          'id': 'v2',
          'title': 'Setting your rates',
          'video_url': 'https://example.com/2',
          'category': 'Earning more',
        }),
      ],
    );
    await tester.pumpWidget(_app(const TrainingPage()));
    await _settle(tester);

    expect(find.text('Getting started'), findsOneWidget);
    expect(find.text('Earning more'), findsOneWidget);
    expect(find.text('3m 5s'), findsOneWidget);
    expect(find.text('NEW'), findsOneWidget);
  });

  testWidgets('favourites show the private note; removing updates the list', (
    tester,
  ) async {
    when(() => api.favourites()).thenAnswer(
      (_) async => [
        FavouriteCustomer.fromJson({
          'conversation': 'c1',
          'name': 'Asha',
          'note': 'Career question — follow up',
          'sessions': 4,
        }),
      ],
    );
    when(() => api.removeFavourite('c1')).thenAnswer((_) async => []);
    await tester.pumpWidget(_app(const FavouritesPage()));
    await _settle(tester);

    expect(find.text('Asha'), findsOneWidget);
    expect(find.text('Career question — follow up'), findsOneWidget);
    expect(find.textContaining('4 sessions with you'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from favourites'));
    await tester.pumpAndSettle();

    verify(() => api.removeFavourite('c1')).called(1);
    expect(find.text('Asha'), findsNothing);
    expect(find.text('No favourites yet'), findsOneWidget);
  });

  testWidgets('community shows the count and who joined', (tester) async {
    when(() => api.community()).thenAnswer(
      (_) async => Community.fromJson({
        'count': 128,
        'new_this_week': 6,
        'followers': [
          {'name': 'Meera', 'since': DateTime.now().toIso8601String()},
        ],
      }),
    );
    await tester.pumpWidget(_app(const CommunityPage()));
    await _settle(tester);

    expect(find.text('128'), findsOneWidget);
    expect(find.text('+6'), findsOneWidget);
    expect(find.text('Meera'), findsOneWidget);
  });

  testWidgets('referral page states the reward and shows the code', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    when(() => api.referrals()).thenAnswer(
      (_) async => ReferralOverview.fromJson({
        'code': 'ASTRO123',
        'invite_link': 'https://talkacharya.com/r/ASTRO123',
        'total': 3,
        'rewarded': 1,
        'earned': '100.00',
        'currency': 'INR',
        'referee_bonus': '50',
        'referrer_bonus': '100',
        'referrals': [
          {'referee_name': 'Asha', 'status': 'rewarded'},
          {'referee_name': 'Ravi', 'status': 'pending'},
        ],
      }),
    );
    await tester.pumpWidget(_app(const ReferralPage()));
    await _settle(tester);

    expect(find.text('ASTRO123'), findsOneWidget);
    expect(
      find.textContaining('Earn ₹100 for every new customer'),
      findsOneWidget,
    );
    expect(find.textContaining('They get ₹50'), findsOneWidget);
    expect(find.text('Rewarded'), findsOneWidget);
    expect(find.text('Joined'), findsOneWidget);
  });

  testWidgets('feedback refuses a one-word message and sends a real one', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    when(() => api.feedback()).thenAnswer((_) async => []);
    when(
      () => api.sendFeedback(
        category: any(named: 'category'),
        message: any(named: 'message'),
        appVersion: any(named: 'appVersion'),
      ),
    ).thenAnswer((_) async {});
    await tester.pumpWidget(_app(const FeedbackPage()));
    await _settle(tester);

    await tester.enterText(find.byType(TextField), 'slow');
    await tester.tap(find.text('Send feedback'));
    await tester.pump();
    verifyNever(
      () => api.sendFeedback(
        category: any(named: 'category'),
        message: any(named: 'message'),
        appVersion: any(named: 'appVersion'),
      ),
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Payments'));
    await tester.pump();
    await tester.enterText(
      find.byType(TextField),
      'My payout for last week has not arrived.',
    );
    await tester.tap(find.text('Send feedback'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    verify(
      () => api.sendFeedback(
        category: 'payments',
        message: 'My payout for last week has not arrived.',
        appVersion: any(named: 'appVersion'),
      ),
    ).called(1);
  });

  testWidgets('quick replies list what is saved, most used labelled', (
    tester,
  ) async {
    final consultations = _MockConsultations();
    when(() => consultations.savedReplies()).thenAnswer(
      (_) async => const [
        SavedReply(
          id: 'r1',
          body: 'Namaste! Share your birth details.',
          useCount: 12,
        ),
        SavedReply(id: 'r2', body: 'Give me a moment to check your chart.'),
      ],
    );
    GetIt.I.registerSingleton<ConsultationApi>(consultations);
    await tester.pumpWidget(_app(const QuickRepliesPage()));
    await _settle(tester);

    expect(find.text('Namaste! Share your birth details.'), findsOneWidget);
    expect(find.text('Used 12 times'), findsOneWidget);
    expect(find.text('New quick reply'), findsOneWidget);
  });
}
