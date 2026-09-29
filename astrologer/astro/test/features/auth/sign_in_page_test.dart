import 'package:astro/src/core/config/config_repository.dart';
import 'package:astro/src/core/config/remote_config.dart';
import 'package:astro/src/core/di/service_locator.dart';
import 'package:astro/src/core/l10n/gen/app_localizations.dart';
import 'package:astro/src/core/theme/brand_colors.dart';
import 'package:astro/src/features/auth/data/auth_repository.dart';
import 'package:astro/src/features/auth/data/models/otp_request_result.dart';
import 'package:astro/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:astro/src/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:astro/src/features/auth/presentation/view/phone_page.dart';
import 'package:astro/src/features/auth/presentation/view/widgets/auth_shell.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeConfig extends Fake implements ConfigRepository {
  @override
  RemoteConfig get value => RemoteConfig.fallback();
}

void main() {
  late _MockRepo repo;
  late _MockAuthBloc authBloc;
  late LoginCubit cubit;

  setUpAll(() => registerFallbackValue(const AuthStarted()));

  setUp(() {
    repo = _MockRepo();
    authBloc = _MockAuthBloc();
    cubit = LoginCubit(repo: repo, authBloc: authBloc);
    // The legal gate reads the terms and privacy URLs from the config.
    if (getIt.isRegistered<ConfigRepository>()) {
      getIt.unregister<ConfigRepository>();
    }
    getIt.registerSingleton<ConfigRepository>(_FakeConfig());
  });

  tearDown(() async {
    await cubit.close();
    await getIt.reset();
  });

  /// Settles rather than pumps once: the screen staggers itself into view, so
  /// asserting on the first frame would be asserting on an empty screen.
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [BrandColors.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(value: cubit, child: const PhonePage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  FilledButton button(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  group('signing in', () {
    testWidgets('will not send an OTP before the terms are agreed to', (
      tester,
    ) async {
      await pump(tester);
      await tester.enterText(find.byType(TextField), '9565901765');
      await tester.pumpAndSettle();

      // A full number is not enough on its own.
      expect(button(tester).onPressed, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('will not send an OTP before the number is complete', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.byType(Checkbox));
      await tester.enterText(find.byType(TextField), '95659');
      await tester.pumpAndSettle();

      expect(button(tester).onPressed, isNull);

      await tester.enterText(find.byType(TextField), '9565901765');
      await tester.pumpAndSettle();

      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('sends the number once both are satisfied', (tester) async {
      when(() => repo.requestOtp(any())).thenAnswer(
        (_) async => OtpRequestResult(
          challengeId: 'c1',
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        ),
      );

      await pump(tester);
      await tester.enterText(find.byType(TextField), '9565901765');
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Normalised to E.164 on the way out — the screen only collects the
      // ten national digits.
      verify(() => repo.requestOtp('+919565901765')).called(1);
    });

    testWidgets('the number survives going back to correct it', (tester) async {
      cubit.emit(cubit.state.copyWith(phone: '9565901765'));
      await pump(tester);

      expect(find.text('9565901765'), findsOneWidget);
    });
  });

  group('a stored number', () {
    test('goes back into the field as ten digits', () {
      // LoginState.phone is normalised the moment it is submitted.
      expect(nationalDigits('+919565901765'), '9565901765');
      expect(nationalDigits('9565901765'), '9565901765');
      expect(nationalDigits(''), '');
    });

    test('is shown back grouped, with one country code', () {
      expect(prettyPhone('+919565901765'), '+91 95659 01765');
      expect(prettyPhone('9565901765'), '+91 95659 01765');
    });

    test('is left alone when it is not a number we can group', () {
      expect(prettyPhone('12345'), '12345');
    });
  });

  group('the agreement', () {
    test('is remembered across the step change', () {
      cubit.acceptTerms(true);
      // Going to the code screen and back again is a widget swap; the
      // agreement is state, so it is still there.
      cubit.emit(cubit.state.copyWith(step: LoginStep.enterOtp));
      cubit.editPhone();

      expect(cubit.state.termsAccepted, isTrue);
      expect(cubit.state.step, LoginStep.enterPhone);
    });

    test('starts unticked — it has to be given, not assumed', () {
      expect(cubit.state.termsAccepted, isFalse);
    });

    test('can be withdrawn', () {
      cubit
        ..acceptTerms(true)
        ..acceptTerms(false);

      expect(cubit.state.termsAccepted, isFalse);
    });
  });
}
