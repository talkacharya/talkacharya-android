import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/models/dispute.dart';
import '../cubit/report_issue_cubit.dart';
import '../widgets/dispute_ui.dart';
import '../../../../core/utils/haptic_service.dart';

/// "Report a problem" for one session (`/consultations/:id/report`).
class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _details = TextEditingController();

  @override
  void initState() {
    super.initState();
    _details.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<ReportIssueCubit, ReportIssueState>(
      listenWhen: (a, b) => a.status != b.status || a.error != b.error,
      listener: (context, state) {
        if (state.status == ReportIssueStatus.submitted) {
          HapticService.medium();
        } else if (state.error != null &&
            state.status == ReportIssueStatus.ready) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(localizedError(context, state.error)),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      builder: (context, state) {
        final Widget body;
        Widget? bottom;
        if (state.status == ReportIssueStatus.loading) {
          body = const Center(child: CircularProgressIndicator());
        } else if (state.status == ReportIssueStatus.failed) {
          body = ErrorView(
            message: localizedError(context, state.error),
            onRetry: () => context.read<ReportIssueCubit>().load(),
          );
        } else if (state.submitted != null) {
          body = _Outcome(
            key: const ValueKey('submitted'),
            icon: Icons.check_rounded,
            hue: AstroPalette.health,
            title: l.reportSubmittedTitle,
            body: l.reportSubmittedBody,
            dispute: state.submitted!,
          );
        } else if (state.existing != null) {
          body = _Outcome(
            key: const ValueKey('existing'),
            icon: Icons.manage_search_rounded,
            hue: AstroPalette.career,
            title: l.reportAlreadyTitle,
            body: l.reportAlreadyBody,
            dispute: state.existing!,
          );
        } else {
          body = _form(context, state);
          bottom = _submitBar(context, state);
        }
        return Scaffold(
          backgroundColor: context.brand.canvas,
          appBar: AppBar(title: Text(l.reportTitle)),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: body,
          ),
          bottomNavigationBar: bottom,
        );
      },
    );
  }

  Widget _form(BuildContext context, ReportIssueState state) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cubit = context.read<ReportIssueCubit>();
    final remaining =
        ReportIssueCubit.minDescription - _details.text.trim().length;

    return ListView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: FadeSlideIn.list([
        if (state.consultation != null)
          _SessionCard(consultation: state.consultation!),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          child: Text(
            l.reportWhatHappened,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final type in DisputeType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TypeTile(
              type: type,
              selected: state.type == type,
              onTap: () => cubit.selectType(type),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 10),
          child: Text(
            l.reportDescribe,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextField(
          controller: _details,
          minLines: 4,
          maxLines: 8,
          maxLength: ReportIssueCubit.maxDescription,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: l.reportDescribeHint,
            helperText: remaining > 0
                ? l.reportMinChars('${ReportIssueCubit.minDescription}')
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 14,
              color: context.brand.inkMuted,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                l.reportPrivacyNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.brand.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _submitBar(BuildContext context, ReportIssueState state) {
    final l = context.l10n;
    final busy = state.status == ReportIssueStatus.submitting;
    final ready =
        state.type != null &&
        _details.text.trim().length >= ReportIssueCubit.minDescription;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          10,
          16,
          10 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: context.brand.hairline)),
        ),
        child: FilledButton(
          onPressed: ready && !busy
              ? () {
                  FocusScope.of(context).unfocus();
                  context.read<ReportIssueCubit>().submit(_details.text);
                }
              : null,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          child: busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(l.reportSubmit),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.consultation});
  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = consultation;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final channel = switch (c.channel) {
      'voice' => l.channelVoice,
      'video' => l.channelVideo,
      _ => l.channelChat,
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Row(
        children: [
          HueAvatar(
            name: c.astrologerName,
            url: c.astrologerAvatar,
            hue: AstroPalette.forId(c.astrologerId),
            size: 46,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.reportSessionWith(c.astrologerName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    channel,
                    disputeDate(context, c.endedAt, time: true),
                    l.roomMinutes(c.billedMinutes),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  maxLines: 2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Money.format(c.gross, c.currency, locale: locale),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final DisputeType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = type.hue;
    return Pressable(
      child: Material(
        color: selected ? hue.tint(0.08) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? hue.end : context.brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: hue.tint(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(type.icon, size: 20, color: hue.end),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.label(l),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        type.hint(l),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    key: ValueKey(selected),
                    color: selected ? hue.end : context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Submitted / already-reported face.
class _Outcome extends StatelessWidget {
  const _Outcome({
    required this.icon,
    required this.hue,
    required this.title,
    required this.body,
    required this.dispute,
    super.key,
  });

  final IconData icon;
  final AstroHue hue;
  final String title;
  final String body;
  final Dispute dispute;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 480),
              curve: Curves.elasticOut,
              builder: (context, t, child) =>
                  Transform.scale(scale: t.clamp(0.0, 1.2), child: child),
              child: HueIcon(hue: hue, icon: icon, size: 76, iconSize: 38),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.brand.inkMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              // Pop, then push: go_router's pushReplacement drops the future of
              // the replaced route, so the Help hub would never hear to reload.
              onPressed: () {
                final router = GoRouter.of(context);
                context.pop();
                router.push(Routes.dispute(dispute.id), extra: dispute);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(l.reportViewStatus),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(l.commonDone),
            ),
          ],
        ),
      ),
    );
  }
}
