import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/constants/api_paths.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../workspace/presentation/widgets/async_page.dart';

/// `GET /me/account/delete`: what deleting would mean for this account.
class _Preview {
  const _Preview({required this.graceDays, required this.inSession});

  final int graceDays;
  final bool inSession;

  factory _Preview.fromJson(Map<String, dynamic> j) => _Preview(
    graceDays: (j['grace_days'] as num?)?.toInt() ?? 30,
    inSession: j['in_session'] == true,
  );
}

/// Deleting the account: what goes, what stays, how to change one's mind, and
/// the button. Asking signs the astrologer out everywhere and hides them from
/// customers at once; the account itself is erased when the grace period ends,
/// unless they sign in again before then.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _reason = TextEditingController();
  bool _understood = false;
  bool _busy = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<_Preview> _load() async {
    try {
      final res = (await getIt<Dio>().get<Map<String, dynamic>>(
        ApiPaths.accountDelete,
      )).ensureOk();
      return _Preview.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
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
      (await getIt<Dio>().post<Map<String, dynamic>>(
        ApiPaths.accountDelete,
        data: {'reason': _reason.text.trim()},
      )).ensureOk();
      if (!mounted) return;
      showToast(context, l.delAccDone);
      // The server has already ended this session; leave the app's too.
      auth.add(const AuthLogoutRequested());
    } on DioException catch (e) {
      if (mounted) showToast(context, ApiException.fromDio(e).message);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<_Preview>(
      title: l.delAccTitle,
      load: _load,
      builder: (context, preview, _, _) {
        final days = preview.graceDays;
        final theme = Theme.of(context);
        final brand = context.brand;
        return [
          _Hero(days: days),
          SettingsCard(
            title: l.delAccRemovedTitle,
            icon: Icons.delete_sweep_rounded,
            hue: AstroPalette.love,
            child: Column(
              children: [
                _Line(icon: Icons.badge_rounded, text: l.delAccRemoved1),
                _Line(
                  icon: Icons.folder_shared_rounded,
                  text: l.delAccRemovedAstro,
                ),
                _Line(
                  icon: Icons.notifications_off_rounded,
                  text: l.delAccRemoved3,
                ),
              ],
            ),
          ),
          SettingsCard(
            title: l.delAccKeptTitle,
            icon: Icons.inventory_2_rounded,
            hue: AstroPalette.air,
            child: Column(
              children: [
                _Line(icon: Icons.receipt_long_rounded, text: l.delAccKept1),
                _Line(icon: Icons.forum_rounded, text: l.delAccKept2),
              ],
            ),
          ),
          _Notice(
            icon: Icons.account_balance_rounded,
            hue: AstroPalette.money,
            text: l.delAccPayoutNote,
          ),
          if (preview.inSession)
            _Notice(
              icon: Icons.block_rounded,
              hue: AstroPalette.fire,
              text: l.delAccInSession,
            )
          else ...[
            SettingsCard(
              title: l.delAccReasonTitle,
              icon: Icons.edit_note_rounded,
              hue: AstroPalette.career,
              child: TextField(
                controller: _reason,
                enabled: !_busy,
                minLines: 2,
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: l.delAccReasonHint),
              ),
            ),
            Pressable(
              child: Material(
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.md),
                  side: BorderSide(
                    color: _understood ? brand.live : brand.hairline,
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
                          color: _understood ? brand.live : brand.inkMuted,
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
                backgroundColor: brand.live,
                disabledBackgroundColor: brand.live.withValues(alpha: 0.3),
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
        ];
      },
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.18), hue.tint(0.05)],
        ),
        borderRadius: BorderRadius.circular(Radii.lg),
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

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: context.brand.inkMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
        ),
      ],
    ),
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.hue, required this.text});

  final IconData icon;
  final AstroHue hue;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: hue.tint(0.10),
      borderRadius: BorderRadius.circular(Radii.md),
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
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.delAccKeep),
        ),
        const SizedBox(height: 4),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: brand.live),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delAccButton),
        ),
      ],
    );
  }
}
