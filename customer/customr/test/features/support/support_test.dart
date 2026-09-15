// Help & disputes: model parsing, cubits, and the three screens at a small phone
// size in English and Hindi (any overflow or build exception fails).
import 'package:customr/src/core/config/config_repository.dart';
import 'package:customr/src/core/config/remote_config.dart';
import 'package:customr/src/core/di/service_locator.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/core/theme/brand_colors.dart';
import 'package:customr/src/core/util/async_value.dart';
import 'package:customr/src/features/consultations/data/models/consultation.dart';
import 'package:customr/src/features/support/data/models/dispute.dart';
import 'package:customr/src/features/support/data/support_api.dart';
import 'package:customr/src/features/support/data/support_repository.dart';
import 'package:customr/src/features/support/presentation/cubit/dispute_detail_cubit.dart';
import 'package:customr/src/features/support/presentation/cubit/help_cubit.dart';
import 'package:customr/src/features/support/presentation/cubit/report_issue_cubit.dart';
import 'package:customr/src/features/support/presentation/view/dispute_detail_page.dart';
import 'package:customr/src/features/support/presentation/view/help_page.dart';
import 'package:customr/src/features/support/presentation/view/report_issue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements SupportRepository {}

class _MockConfig extends Mock implements ConfigRepository {}

final _session = Consultation(
  id: 'c-1',
  channel: 'voice',
  status: ConsultationStatus.ended,
  astrologerId: 'a-1',
  astrologerName: 'Acharya Vishwanath Shastri',
  currency: 'INR',
  billedSeconds: 600,
  grossAmount: '240.00',
  endedAt: DateTime(2026, 9, 12, 16, 30),
);

final _json = <String, dynamic>{
  'id': 'd-1',
  'consultation': {
    'id': 'c-1',
    'channel': 'voice',
    'astrologer_id': 'a-1',
    'astrologer_name': 'Acharya Vishwanath Shastri',
    'ended_at': '2026-09-12T11:00:00Z',
    'billed_seconds': 600,
    'gross_amount': '240.00',
    'currency': 'INR',
  },
  'type': 'billing',
  'description': 'I was charged for 10 minutes but we spoke for 4.',
  'status': 'resolved',
  'resolution': 'refund_partial',
  'resolution_note': 'We refunded the extra minutes after checking the logs.',
  'refund_amount': '144.00',
  'resolved_at': '2026-09-13T09:00:00Z',
  'created_at': '2026-09-12T12:00:00Z',
  'timeline': [
    {'type': 'raised', 'created_at': '2026-09-12T12:00:00Z'},
    {'type': 'reviewing', 'created_at': '2026-09-12T15:00:00Z'},
    {'type': 'resolved', 'created_at': '2026-09-13T09:00:00Z'},
  ],
};

void main() {
  late _MockRepo repo;

  setUpAll(() {
    final config = _MockConfig();
    when(() => config.hapticEnabled).thenReturn(false);
    when(() => config.value).thenReturn(
      const RemoteConfig(
        support: ConfigSupport(
          email: 'support@talkacharya.com',
          whatsapp: '+91 98765 43210',
          helpUrl: 'https://talkacharya.com/help',
        ),
      ),
    );
    getIt.registerSingleton<ConfigRepository>(config);
    registerFallbackValue(DisputeType.billing);
  });

  setUp(() => repo = _MockRepo());

  group('Dispute.fromJson', () {
    test('parses the customer-safe shape', () {
      final d = Dispute.fromJson(_json);
      expect(d.type, DisputeType.billing);
      expect(d.status, DisputeStatus.resolved);
      expect(d.refunded, isTrue);
      expect(d.refundAmount, 144);
      expect(d.consultation.billedMinutes, 10);
      expect(d.timeline.map((s) => s.type), [
        'raised',
        'reviewing',
        'resolved',
      ]);
    });

    test('unknown values fall back safely', () {
      final d = Dispute.fromJson({'id': 'x', 'type': 'weird', 'status': '?'});
      expect(d.type, DisputeType.quality);
      expect(d.status, DisputeStatus.open);
      expect(d.refunded, isFalse);
      expect(DisputeType.parse('no_show'), DisputeType.noShow);
    });
  });

  group('ReportIssueCubit', () {
    ReportIssueCubit build() =>
        ReportIssueCubit(repo: repo, consultationId: 'c-1');

    test(
      'load → ready; existing open report short-circuits the form',
      () async {
        when(() => repo.consultation('c-1')).thenAnswer((_) async => _session);
        when(() => repo.disputeFor('c-1')).thenAnswer(
          (_) async => Dispute.fromJson({..._json, 'status': 'investigating'}),
        );
        final cubit = build();
        await cubit.load();
        expect(cubit.state.status, ReportIssueStatus.ready);
        expect(cubit.state.existing?.id, 'd-1');
      },
    );

    test('a closed earlier report does not block a new one', () async {
      when(() => repo.consultation('c-1')).thenAnswer((_) async => _session);
      when(
        () => repo.disputeFor('c-1'),
      ).thenAnswer((_) async => Dispute.fromJson(_json));
      final cubit = build();
      await cubit.load();
      expect(cubit.state.existing, isNull);
    });

    test('submit needs a type and 10+ characters', () async {
      when(() => repo.consultation('c-1')).thenAnswer((_) async => _session);
      when(() => repo.disputeFor('c-1')).thenAnswer((_) async => null);
      when(
        () => repo.raise(
          consultationId: 'c-1',
          type: any(named: 'type'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) async => Dispute.fromJson({..._json, 'status': 'open'}));

      final cubit = build();
      await cubit.load();
      await cubit.submit('charged wrongly'); // no type yet
      expect(cubit.state.submitted, isNull);

      cubit.selectType(DisputeType.billing);
      await cubit.submit('too short');
      expect(cubit.state.submitted, isNull);

      await cubit.submit('  I was charged for extra minutes  ');
      expect(cubit.state.status, ReportIssueStatus.submitted);
      verify(
        () => repo.raise(
          consultationId: 'c-1',
          type: DisputeType.billing,
          description: 'I was charged for extra minutes',
        ),
      ).called(1);
    });

    test('already_open from the server shows the existing report', () async {
      when(() => repo.consultation('c-1')).thenAnswer((_) async => _session);
      var calls = 0;
      when(() => repo.disputeFor('c-1')).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? null
            : Dispute.fromJson({..._json, 'status': 'open'});
      });
      when(
        () => repo.raise(
          consultationId: any(named: 'consultationId'),
          type: any(named: 'type'),
          description: any(named: 'description'),
        ),
      ).thenThrow(const DisputeAlreadyOpen());

      final cubit = build();
      await cubit.load();
      cubit.selectType(DisputeType.technical);
      await cubit.submit('the call kept dropping every minute');
      expect(cubit.state.status, ReportIssueStatus.ready);
      expect(cubit.state.existing?.id, 'd-1');
    });
  });

  test('HelpCubit maps sessions to their reports', () async {
    when(
      () => repo.disputes(),
    ).thenAnswer((_) async => [Dispute.fromJson(_json)]);
    when(() => repo.reportableSessions()).thenAnswer((_) async => [_session]);
    final cubit = HelpCubit(repo);
    await cubit.load();
    expect(cubit.state.sessions.value, hasLength(1));
    expect(cubit.state.disputeBySession['c-1']?.id, 'd-1');
  });

  // --- screens ---------------------------------------------------------------

  Widget app(Widget child, Locale locale) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFFEA6A1E),
      extensions: const [BrandColors.light],
    ),
    home: child,
  );

  for (final locale in const [Locale('en'), Locale('hi')]) {
    group('small phone · ${locale.languageCode}', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized()
            .platformDispatcher
            .views
            .first
          ..physicalSize = const Size(360, 740) * 3
          ..devicePixelRatio = 3;
      });
      tearDown(() {
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
          ..resetPhysicalSize()
          ..resetDevicePixelRatio();
      });

      testWidgets('help hub lays out (sessions, reports, contact, FAQ)', (
        tester,
      ) async {
        when(
          () => repo.disputes(),
        ).thenAnswer((_) async => [Dispute.fromJson(_json)]);
        when(() => repo.reportableSessions()).thenAnswer(
          (_) async => [
            _session,
            _session.copyWith(id: 'c-2', channel: 'chat'),
          ],
        );
        await tester.pumpWidget(
          app(
            BlocProvider(
              create: (_) => HelpCubit(repo)..load(),
              child: const HelpPage(),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
        // Fling to the bottom so the lazily-built FAQ exists, then open one.
        await tester.drag(find.byType(ListView), const Offset(0, -3000));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ExpansionTile).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('report form lays out and enables submit', (tester) async {
        when(() => repo.consultation('c-1')).thenAnswer((_) async => _session);
        when(() => repo.disputeFor('c-1')).thenAnswer((_) async => null);
        await tester.pumpWidget(
          app(
            BlocProvider(
              create: (_) =>
                  ReportIssueCubit(repo: repo, consultationId: 'c-1')..load(),
              child: const ReportIssuePage(),
            ),
            locale,
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);

        final submit = find.byType(FilledButton);
        expect(tester.widget<FilledButton>(submit).onPressed, isNull);
        await tester.tap(find.byIcon(Icons.receipt_long_rounded));
        await tester.scrollUntilVisible(
          find.byType(TextField),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.byType(TextField),
          'I was charged for extra minutes',
        );
        await tester.pumpAndSettle();
        expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      });

      for (final status in ['open', 'investigating', 'resolved', 'rejected']) {
        testWidgets('report detail lays out ($status)', (tester) async {
          final d = Dispute.fromJson({
            ..._json,
            'status': status,
            if (status != 'resolved') 'refund_amount': null,
            if (status == 'open') 'timeline': [_json['timeline'][0]],
          });
          when(() => repo.dispute('d-1')).thenAnswer((_) async => d);
          await tester.pumpWidget(
            app(
              BlocProvider(
                create: (_) =>
                    DisputeDetailCubit(repo: repo, id: 'd-1', seed: d)..load(),
                child: const DisputeDetailPage(),
              ),
              locale,
            ),
          );
          await tester.pumpAndSettle(const Duration(seconds: 1));
          expect(tester.takeException(), isNull);
          expect(find.byType(DisputeDetailPage), findsOneWidget);
        });
      }
    });
  }

  test('DisputeDetailCubit keeps the seed while refreshing', () async {
    final seed = Dispute.fromJson({..._json, 'status': 'open'});
    when(() => repo.dispute('d-1')).thenThrow(Exception('offline'));
    final cubit = DisputeDetailCubit(repo: repo, id: 'd-1', seed: seed);
    expect(cubit.state.value, seed);
    await cubit.load();
    expect(cubit.state.status, AsyncStatus.error);
    expect(cubit.state.value, seed);
  });
}
