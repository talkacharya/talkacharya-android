import 'package:bloc_test/bloc_test.dart';
import 'package:astro/src/core/config/config_repository.dart';
import 'package:astro/src/core/config/remote_config.dart';
import 'package:astro/src/core/network/api_exception.dart';
import 'package:astro/src/features/auth/data/auth_repository.dart';
import 'package:astro/src/features/auth/data/firebase_phone_auth.dart';
import 'package:astro/src/features/auth/data/models/auth_user.dart';
import 'package:astro/src/features/auth/data/models/otp_request_result.dart';
import 'package:astro/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:astro/src/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockConfig extends Mock implements ConfigRepository {}

class _MockFirebase extends Mock implements FirebasePhoneAuth {}

void main() {
  setUpAll(() => registerFallbackValue(const AuthStarted()));

  late _MockRepo repo;
  late _MockAuthBloc authBloc;

  setUp(() {
    repo = _MockRepo();
    authBloc = _MockAuthBloc();
  });

  LoginCubit build() => LoginCubit(repo: repo, authBloc: authBloc);

  test('rejects an invalid phone without hitting the API', () async {
    final cubit = build();
    await cubit.requestOtp('123');
    expect(cubit.state.error, isNotNull);
    expect(cubit.state.step, LoginStep.enterPhone);
    verifyNever(() => repo.requestOtp(any()));
  });

  blocTest<LoginCubit, LoginState>(
    'moves to enterOtp and surfaces the dev code',
    build: build,
    setUp: () {
      when(() => repo.requestOtp(any())).thenAnswer(
        (_) async => OtpRequestResult(
          challengeId: 'c1',
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          devCode: '901765',
        ),
      );
    },
    act: (c) => c.requestOtp('9565901765'),
    expect: () => [
      isA<LoginState>().having((s) => s.submitting, 'submitting', true),
      isA<LoginState>()
          .having((s) => s.step, 'step', LoginStep.enterOtp)
          .having((s) => s.devCode, 'devCode', '901765'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'verify success pushes AuthLoggedIn',
    build: build,
    seed: () =>
        const LoginState(step: LoginStep.enterOtp, phone: '+919565901765'),
    setUp: () {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const AuthUser(id: 'u1', phone: '+919565901765'),
      );
    },
    act: (c) => c.verifyOtp('901765'),
    verify: (_) {
      verify(() => authBloc.add(any(that: isA<AuthLoggedIn>()))).called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'verify failure shows the backend message',
    build: build,
    seed: () =>
        const LoginState(step: LoginStep.enterOtp, phone: '+919565901765'),
    setUp: () {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenThrow(
        ApiException(message: 'The code is incorrect or has expired.'),
      );
    },
    act: (c) => c.verifyOtp('000000'),
    expect: () => [
      isA<LoginState>().having((s) => s.submitting, 'submitting', true),
      isA<LoginState>()
          .having((s) => s.submitting, 'submitting', false)
          .having((s) => s.error, 'error', contains('incorrect')),
    ],
  );

  group('firebase mode', () {
    late _MockConfig config;
    late _MockFirebase firebase;

    setUp(() {
      config = _MockConfig();
      firebase = _MockFirebase();
      when(
        () => config.value,
      ).thenReturn(const RemoteConfig(auth: ConfigAuth(firebase: true)));
    });

    LoginCubit fbBuild() => LoginCubit(
      repo: repo,
      authBloc: authBloc,
      config: config,
      firebasePhoneAuth: firebase,
    );

    blocTest<LoginCubit, LoginState>(
      'codeSent moves to enterOtp with a verificationId',
      build: fbBuild,
      setUp: () {
        when(
          () => firebase.sendCode(
            any(),
            onCodeSent: any(named: 'onCodeSent'),
            onAutoVerified: any(named: 'onAutoVerified'),
            onError: any(named: 'onError'),
            resendToken: any(named: 'resendToken'),
          ),
        ).thenAnswer((inv) async {
          (inv.namedArguments[#onCodeSent] as void Function(String, int?))(
            'vid-123',
            7,
          );
        });
      },
      act: (c) => c.requestOtp('9565901765'),
      expect: () => [
        isA<LoginState>().having((s) => s.submitting, 'submitting', true),
        isA<LoginState>()
            .having((s) => s.step, 'step', LoginStep.enterOtp)
            .having((s) => s.verificationId, 'verificationId', 'vid-123'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'confirmCode -> loginWithFirebase -> AuthLoggedIn',
      build: fbBuild,
      seed: () => const LoginState(
        step: LoginStep.enterOtp,
        phone: '+919565901765',
        verificationId: 'vid-123',
      ),
      setUp: () {
        when(
          () => firebase.confirmCode('vid-123', '123456'),
        ).thenAnswer((_) async => 'firebase-id-token');
        when(() => repo.loginWithFirebase('firebase-id-token')).thenAnswer(
          (_) async => const AuthUser(id: 'u1', phone: '+919565901765'),
        );
      },
      act: (c) => c.verifyOtp('123456'),
      verify: (_) {
        verify(() => repo.loginWithFirebase('firebase-id-token')).called(1);
        verify(() => authBloc.add(any(that: isA<AuthLoggedIn>()))).called(1);
      },
    );
  });
}
