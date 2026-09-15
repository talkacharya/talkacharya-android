import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/config/config_repository.dart';
import '../../../../core/profile/active_profile_store.dart';
import '../../data/auth_repository.dart';
import '../../data/firebase_phone_auth.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/login/login_cubit.dart';
import 'otp_page.dart';
import 'phone_page.dart';

/// Owns the [LoginCubit] lifecycle and cross-fades between the two steps
/// (phone -> OTP). The shared cosmic backdrop lives inside each step's
/// [AuthScaffold] so it stays put during the transition.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        repo: GetIt.I<AuthRepository>(),
        authBloc: context.read<AuthBloc>(),
        profileStore: GetIt.I<ActiveProfileStore>(),
        config: GetIt.I<ConfigRepository>(),
        firebasePhoneAuth: GetIt.I<FirebasePhoneAuth>(),
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (a, b) => a.step != b.step,
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 360),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: switch (state.step) {
            LoginStep.enterPhone => const PhonePage(key: ValueKey('phone')),
            LoginStep.enterOtp => const OtpPage(key: ValueKey('otp')),
          },
        ),
      ),
    );
  }
}
