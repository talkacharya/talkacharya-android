import 'package:bloc_test/bloc_test.dart';
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:customr/src/features/auth/presentation/view/phone_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late _MockLoginCubit cubit;

  setUp(() {
    cubit = _MockLoginCubit();
    when(() => cubit.state).thenReturn(const LoginState());
    when(
      () => cubit.requestOtp(
        any(),
        acceptedTerms: any(named: 'acceptedTerms'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFEA6A1E),
          extensions: const [BrandColors.light],
        ),
        home: BlocProvider<LoginCubit>.value(
          value: cubit,
          child: const PhonePage(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.pump();
  }

  testWidgets('no code is asked for until the terms are accepted', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Get OTP'));
    await tester.pump();

    verifyNever(
      () => cubit.requestOtp(
        any(),
        acceptedTerms: any(named: 'acceptedTerms'),
      ),
    );
    expect(
      find.text('Please accept the Terms of Use and Privacy Policy to continue.'),
      findsOneWidget,
    );
  });

  testWidgets('accepting the terms lets the code be asked for', (tester) async {
    await pump(tester);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.text('Get OTP'));
    await tester.pump();

    verify(
      () => cubit.requestOtp('9876543210', acceptedTerms: true),
    ).called(1);
  });
}
