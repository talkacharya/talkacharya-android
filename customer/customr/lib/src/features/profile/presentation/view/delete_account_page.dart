import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/constants/api_paths.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/app_snack.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

/// `GET /me/account/delete`: what deleting would mean for this account.
class _Preview {
  const _Preview({
    required this.graceDays,
    required this.inSession,
    required this.wallet,
  });

  final int graceDays;
  final bool inSession;

  /// Money still in the wallet, as (currency, amount).
  final List<(String, double)> wallet;

  factory _Preview.fromJson(Map<String, dynamic> j) => _Preview(
    graceDays: (j['grace_days'] as num?)?.toInt() ?? 30,
    inSession: j['in_session'] == true,
    wallet: [
      for (final w in j['wallet'] as List? ?? const [])
        (
          '${(w as Map)['currency'] ?? 'INR'}',
          double.tryParse('${w['amount']}') ?? 0,
        ),
    ],
  );
}

/// Deleting the account: what goes, what stays, how to change one's mind, and
/// the button. Asking signs the customer out everywhere at once; the account
/// itself is erased when the grace period ends, unless they sign in again
/// before then.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  late Future<_Preview> _future = _load();
  final _reason = TextEditingController();
  bool _understood = false;
  bool _busy = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<_Preview> _load() async {
    final res = await getIt<Dio>().get<Map<String, dynamic>>(
      ApiPaths.accountDelete,
    );
    return _Preview.fromJson(res.data ?? const {});
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final auth = context.read<AuthBloc>();
    final sure = await showAppSheet<bool>(
      context: context,
      builder: (_) => const _ConfirmSheet(),
    );
    if (sure != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await getIt<Dio>().post<Map<String, dynamic>>(
        ApiPaths.accountDelete,
        data: {'reason': _reason.text.trim()},
      );
      if (!mounted) return;
      AppSnack.showTop(context, l.delAccDone, type: SnackType.success);
      // The server has already ended this session; leave the app's too.
      auth.add(const AuthLogoutRequested());
    } catch (e) {
      if (mounted) {
        AppSnack.showTop(context, friendlyError(e), type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Scaffold(
      backgroundColor: brand.canvas,
      appBar: AppBar(title: Text(l.profileDeleteAccount)),
      body: FutureBuilder<_Preview>(
        future: _future,
        builder: (context, snap) {
          final preview = snap.data;
          if (preview == null) {
            return snap.hasError
                ? ErrorView(
                    message: l.commonSomethingWentWrong,
                    onRetry: () => setState(() => _future = _load()),
                  )
                : const Center(child: CircularProgressIndicator());
          }
          final days = preview.graceDays;
          final locale = Localizations.localeOf(context).toLanguageTag();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              FadeSlideIn(child: _Hero(days: days)),
              const SizedBox(height: 12),
              _Section(
                title: l.delAccRemovedTitle,
                icon: Icons.delete_sweep_rounded,
                hue: AstroPalette.love,
                lines: [
                  (Icons.badge_rounded, l.delAccRemoved1),
                  (Icons.auto_awesome_rounded, l.delAccRemovedCustomer),
                  (Icons.notifications_off_rounded, l.delAccRemoved3),
                ],
              ),
              const SizedBox(height: 12),
              _Section(
                title: l.delAccKeptTitle,
                icon: Icons.inventory_2_rounded,
                hue: AstroPalette.air,
                lines: [
                  (Icons.receipt_long_rounded, l.delAccKept1),
                  (Icons.forum_rounded, l.delAccKept2),
                ],
              ),
              for (final (currency, amount) in preview.wallet) ...[
                const SizedBox(height: 12),
                _Notice(
                  icon: Icons.account_balance_wallet_rounded,
                  hue: AstroPalette.money,
                  text: l.delAccWallet(
                    Money.format(amount, currency, locale: locale),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (preview.inSession)
                _Notice(
                  icon: Icons.block_rounded,
                  hue: AstroPalette.fire,
                  text: l.delAccInSession,
                )
              else ...[
                TextField(
                  controller: _reason,
                  enabled: !_busy,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l.delAccReasonTitle,
                    hintText: l.delAccReasonHint,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 8),
                Pressable(
                  child: Material(
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _understood
                            ? theme.colorScheme.error
                            : brand.hairline,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _busy
                          ? null
                          : () => setState(() => _understood = !_understood),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Icon(
                              _understood
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: _understood
                                  ? theme.colorScheme.error
                                  : brand.inkMuted,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l.delAccUnderstand(days),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: _understood && !_busy ? _delete : null,
                  icon: _busy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.delete_forever_rounded),
                  label: Text(l.delAccButton),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// What happens and when, in three steps.
class _Hero extends StatelessWidget {
  const _Hero({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    const hue = AstroPalette.love;
    final steps = [
      (Icons.logout_rounded, l.delAccStepNow),
      (Icons.hourglass_bottom_rounded, l.delAccStepWait(days)),
      (Icons.login_rounded, l.delAccStepCancel(days)),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.18), hue.tint(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HueIcon(
                hue: hue,
                icon: Icons.person_remove_rounded,
                size: 46,
                iconSize: 23,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l.delAccHeroTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final (icon, text) in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: hue.end),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.inkMuted,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A titled card of icon-and-line rows.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.hue,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final AstroHue hue;
  final List<(IconData, String)> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(hue: hue, icon: icon, size: 36, iconSize: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final (lineIcon, text) in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(lineIcon, size: 18, color: brand.inkMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.hue, required this.text});

  final IconData icon;
  final AstroHue hue;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: hue.tint(0.10),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: hue.tint(0.3)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: hue.end),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// The last question before it is done.
class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: HueIcon(
            hue: AstroPalette.love,
            icon: Icons.person_remove_rounded,
            size: 60,
            iconSize: 30,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l.delAccSheetTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.delAccSheetBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: brand.inkMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.delAccKeep),
        ),
        const SizedBox(height: 4),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delAccButton),
        ),
      ],
    );
  }
}
