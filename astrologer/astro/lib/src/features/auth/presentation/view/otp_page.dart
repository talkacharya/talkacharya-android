import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/brand_colors.dart';
import '../bloc/login/login_cubit.dart';
import 'widgets/auth_shell.dart';

/// Step two: the code.
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const _length = 6;

  /// How long before the code can be asked for again. Resend was previously
  /// available the instant the screen opened, which sends a second SMS —
  /// billed, and usually arriving beside the first one that was simply slow.
  static const _resendAfter = Duration(seconds: 30);

  final _controller = TextEditingController();
  Timer? _ticker;
  DateTime _sentAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    // The Verify button reads the code's length; without this it would only
    // catch up on the resend timer's next tick.
    _controller.addListener(_onTyped);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller
      ..removeListener(_onTyped)
      ..dispose();
    super.dispose();
  }

  void _onTyped() => setState(() {});

  int get _resendIn {
    final left = _resendAfter - DateTime.now().difference(_sentAt);
    return left.isNegative ? 0 : left.inSeconds + 1;
  }

  void _submit(LoginState state) {
    if (state.submitting || _controller.text.length < _length) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().verifyOtp(_controller.text);
  }

  void _resend() {
    setState(() => _sentAt = DateTime.now());
    _controller.clear();
    context.read<LoginCubit>().resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
      },
      builder: (context, state) {
        // Dev mode: the server hands back the code, so QA doesn't wait on SMS.
        if (state.devCode != null && _controller.text.isEmpty) {
          // After the frame: writing to the controller notifies its listeners,
          // and doing that mid-build would rebuild and submit during a build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _controller.text.isEmpty) {
              _controller.text = state.devCode!;
            }
          });
        }
        final waiting = _resendIn;
        return AuthShell(
          onBack: context.read<LoginCubit>().editPhone,
          children: authStagger([
            Gap.md,
            Text(
              l.otpTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: brand.onCosmic,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap.sm,
            _SentTo(phone: state.phone),
            Gap.xl,
            AuthCard(
              child: _OtpBoxes(
                controller: _controller,
                length: _length,
                onCompleted: () => _submit(state),
              ),
            ),
            if (state.devCode != null) ...[
              Gap.md,
              _DevCodeBanner(code: state.devCode!),
            ],
            Gap.lg,
            AuthPrimaryButton(
              label: l.otpVerify,
              loading: state.submitting,
              onPressed: _controller.text.length == _length
                  ? () => _submit(state)
                  : null,
            ),
            Gap.md,
            Center(
              child: waiting > 0
                  ? Text(
                      l.otpResendIn(waiting),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.onCosmicMuted,
                      ),
                    )
                  : TextButton(
                      onPressed: state.submitting ? null : _resend,
                      style: TextButton.styleFrom(
                        foregroundColor: brand.onCosmic,
                      ),
                      child: Text(l.otpResend),
                    ),
            ),
          ]),
        );
      },
    );
  }
}

/// Which number the code went to, and a way back if it was the wrong one.
class _SentTo extends StatelessWidget {
  const _SentTo({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Row(
      children: [
        Flexible(
          child: Text(
            l.otpSentTo(prettyPhone(phone)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: brand.onCosmicMuted,
            ),
          ),
        ),
        TextButton(
          onPressed: context.read<LoginCubit>().editPhone,
          style: TextButton.styleFrom(
            foregroundColor: brand.onCosmic,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(l.otpChangeNumber),
        ),
      ],
    );
  }
}

/// Six cells over one real field.
///
/// The cells are painted from the field's value and the field itself sits on
/// top, invisible: one insertion point, so paste, backspace and the keyboard's
/// own SMS suggestion all behave the way they do in any other text field —
/// which six separate controllers famously do not.
class _OtpBoxes extends StatefulWidget {
  const _OtpBoxes({
    required this.controller,
    required this.length,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final VoidCallback onCompleted;

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    // The cell ring is drawn only while the field has focus, so losing it has
    // to repaint as much as gaining it.
    _focus.addListener(_onFocus);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  void _onFocus() => setState(() {});

  void _onChanged() {
    setState(() {});
    if (widget.controller.text.length == widget.length) {
      // Deferred for the same reason the dev prefill is: this can be reached
      // from a controller write that happens inside a build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onCompleted();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final code = widget.controller.text;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < widget.length; i++)
              _Cell(
                digit: i < code.length ? code[i] : '',
                // The cell the next digit lands in, so there is always one
                // obvious place to look while typing.
                active: i == code.length && _focus.hasFocus,
              ),
          ],
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              showCursor: false,
              cursorColor: Colors.transparent,
              // Android reads the code out of the SMS and offers it here.
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: brand.onCosmic),
              decoration: const InputDecoration(
                counterText: '',
                filled: false,
                border: InputBorder.none,
              ),
              onTap: () => setState(() {}),
              onSubmitted: (_) => widget.onCompleted(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.digit, required this.active});
  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final filled = digit.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 46,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: brand.onCosmic.withValues(alpha: filled ? .16 : .06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: brand.onCosmic.withValues(alpha: active ? .85 : .18),
          width: active ? 1.8 : 1,
        ),
      ),
      child: Text(
        digit,
        style: TextStyle(
          color: brand.onCosmic,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DevCodeBanner extends StatelessWidget {
  const _DevCodeBanner({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: brand.gold.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brand.gold.withValues(alpha: .45)),
      ),
      child: Row(
        children: [
          Icon(Icons.build_circle_outlined, size: 18, color: brand.gold),
          Gap.sm,
          Expanded(
            child: Text(
              context.l10n.otpDevMode(code),
              style: TextStyle(color: brand.onCosmic),
            ),
          ),
        ],
      ),
    );
  }
}
