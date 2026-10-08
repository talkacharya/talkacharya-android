import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../workspace/presentation/widgets/async_page.dart';
import '../../data/reports_api.dart';

// --- shared reading of a report -------------------------------------------

/// Where a report stands for the astrologer, as one of four things to show.
enum _Stage { replyNeeded, underReview, cleared, decidedAgainst }

_Stage _stageOf(SessionReport r) {
  final outcome = r.outcome;
  if (outcome == null) {
    return r.canRespond ? _Stage.replyNeeded : _Stage.underReview;
  }
  return outcome.kind == 'none' ? _Stage.cleared : _Stage.decidedAgainst;
}

({IconData icon, AstroHue hue}) _stageStyle(_Stage s) => switch (s) {
  _Stage.replyNeeded => (
    icon: Icons.mark_chat_unread_rounded,
    hue: AstroPalette.fire,
  ),
  _Stage.underReview => (
    icon: Icons.hourglass_top_rounded,
    hue: AstroPalette.air,
  ),
  _Stage.cleared => (icon: Icons.verified_rounded, hue: AstroPalette.health),
  _Stage.decidedAgainst => (icon: Icons.gavel_rounded, hue: AstroPalette.love),
};

String _stageLabel(AppLocalizations l, _Stage s) => switch (s) {
  _Stage.replyNeeded => l.reportsReplyNeeded,
  _Stage.underReview => l.reportsUnderReview,
  _Stage.cleared => l.reportsCleared,
  _Stage.decidedAgainst => l.reportsDecided,
};

String _typeLabel(AppLocalizations l, String type) => switch (type) {
  'billing' => l.reportsTypeBilling,
  'conduct' => l.reportsTypeConduct,
  'quality' => l.reportsTypeQuality,
  'no_show' => l.reportsTypeNoShow,
  'technical' => l.reportsTypeTechnical,
  _ => l.reportsTypeOther,
};

IconData _typeIcon(String type) => switch (type) {
  'billing' => Icons.receipt_long_rounded,
  'conduct' => Icons.record_voice_over_rounded,
  'quality' => Icons.rate_review_rounded,
  'no_show' => Icons.person_off_rounded,
  'technical' => Icons.wifi_off_rounded,
  _ => Icons.flag_rounded,
};

String _when(AppLocalizations l, DateTime at) =>
    '${TimeFormat.day(l, at)}, ${TimeFormat.clock(l, at)}';

String _money(String currency, double amount) {
  final symbol = currency == 'INR' ? '₹' : '$currency ';
  final text = amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  return '$symbol$text';
}

/// The small rounded label saying where a report stands.
class _StagePill extends StatelessWidget {
  const _StagePill({required this.stage});

  final _Stage stage;

  @override
  Widget build(BuildContext context) {
    final style = _stageStyle(stage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.hue.tint(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.hue.end),
          const SizedBox(width: 5),
          Text(
            _stageLabel(context.l10n, stage),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: style.hue.end,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// --- the list -------------------------------------------------------------

/// Reports customers have raised on this astrologer's sessions: the ones
/// waiting for their side first, then those under review, then the decided.
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<List<SessionReport>>(
      title: l.reportsTitle,
      subtitle: l.reportsSubtitle,
      load: getIt<ReportsApi>().list,
      builder: (context, reports, _, reload) {
        if (reports.isEmpty) {
          return [
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: EmptyState(
                icon: Icons.verified_user_rounded,
                hue: AstroPalette.health,
                title: l.reportsEmptyTitle,
                message: l.reportsEmptyBody,
              ),
            ),
          ];
        }
        final sorted = [...reports]
          ..sort((a, b) => _stageOf(a).index.compareTo(_stageOf(b).index));
        final waiting = sorted.where((r) => r.canRespond).length;
        return [
          if (waiting > 0) _WaitingBanner(count: waiting),
          for (final r in sorted)
            _ReportRow(
              report: r,
              onTap: () async {
                await context.push<void>(Routes.reportDetail(r.id));
                await reload();
              },
            ),
        ];
      },
    );
  }
}

/// "2 reports need your reply" — the one thing on this page with a clock.
class _WaitingBanner extends StatelessWidget {
  const _WaitingBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.fire;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [hue.tint(0.16), hue.tint(0.06)]),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: hue.tint(0.35)),
      ),
      child: Row(
        children: [
          const HueIcon(hue: hue, icon: Icons.mark_chat_unread_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.reportsWaitingTitle(count),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  l.reportsWaitingBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
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

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.report, required this.onTap});

  final SessionReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final r = report;
    final stage = _stageOf(r);
    final ch = channelStyle(context, r.channel);
    final due = r.responseDueAt;
    final name = r.customerName.isEmpty ? l.reportsACustomer : r.customerName;

    return WsCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(
                hue: _stageStyle(stage).hue,
                icon: _typeIcon(r.type),
                size: 40,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel(l, r.type),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      [
                        name,
                        ch.label,
                        if (r.sessionAt != null)
                          TimeFormat.day(l, r.sessionAt!),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StagePill(stage: stage),
              const Spacer(),
              if (stage == _Stage.replyNeeded && due != null)
                Flexible(
                  child: Text(
                    l.reportsReplyBy(_when(l, due)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AstroPalette.fire.end,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- one report -----------------------------------------------------------

/// A report in full: where it stands, what the customer said and about which
/// session, the astrologer's own side (written here, once), and the decision.
class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({required this.reportId, super.key});

  final String reportId;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send(void Function(SessionReport) set) async {
    final l = context.l10n;
    final text = _text.text.trim();
    if (text.length < 10) {
      showToast(context, l.reportsReplyTooShort);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    try {
      set(await getIt<ReportsApi>().respond(widget.reportId, text));
      if (mounted) showToast(context, l.reportsReplySent);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AsyncPage<SessionReport>(
      title: l.reportsDetailTitle,
      load: () => getIt<ReportsApi>().detail(widget.reportId),
      builder: (context, r, set, _) => [
        _StatusHero(report: r),
        _SaidCard(report: r),
        _MySideCard(
          report: r,
          controller: _text,
          sending: _sending,
          onSend: () => _send(set),
        ),
        if (r.outcome case final outcome?) _OutcomeCard(outcome: outcome),
      ],
    );
  }
}

/// The headline: what is being asked of the astrologer, or what happened.
class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.report});

  final SessionReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final r = report;
    final stage = _stageOf(r);
    final style = _stageStyle(stage);
    final due = r.responseDueAt;
    final body = switch (stage) {
      _Stage.replyNeeded =>
        due == null
            ? l.reportsHeroReplyBody
            : l.reportsHeroReplyBy(_when(l, due)),
      _Stage.underReview => l.reportsHeroReviewBody,
      _Stage.cleared => l.reportsHeroClearedBody,
      _Stage.decidedAgainst => l.reportsHeroDecidedBody,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [style.hue.tint(0.18), style.hue.tint(0.05)],
        ),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: style.hue.tint(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HueIcon(hue: style.hue, icon: style.icon, size: 46, iconSize: 23),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _stageLabel(l, stage),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: brand.inkMuted,
                    height: 1.4,
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

/// What the customer wrote, and the session it is about.
class _SaidCard extends StatelessWidget {
  const _SaidCard({required this.report});

  final SessionReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final r = report;
    final ch = channelStyle(context, r.channel);
    final name = r.customerName.isEmpty ? l.reportsACustomer : r.customerName;
    final minutes = (r.billedSeconds / 60).ceil();
    return SettingsCard(
      title: l.reportsSaidTitle(name),
      subtitle: _typeLabel(l, r.type),
      icon: _typeIcon(r.type),
      hue: AstroPalette.career,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: brand.tint,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border(
                left: BorderSide(color: AstroPalette.career.end, width: 3),
              ),
            ),
            child: Text(
              r.description,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Fact(
                  icon: ch.icon,
                  hue: ch.hue,
                  value: ch.label,
                  label: r.sessionAt == null
                      ? l.reportsFactSession
                      : TimeFormat.day(l, r.sessionAt!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Fact(
                  icon: Icons.timer_rounded,
                  hue: AstroPalette.air,
                  value: l.reportsMinutes(minutes),
                  label: l.reportsFactLength,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Fact(
                  icon: Icons.payments_rounded,
                  hue: AstroPalette.money,
                  value: _money(r.currency, r.grossAmount),
                  label: l.reportsFactBilled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.icon,
    required this.hue,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final AstroHue hue;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: hue.tint(0.10),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: hue.end),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// The astrologer's side: a box to write it in while it is wanted, their
/// words once sent, or a line saying none was given.
class _MySideCard extends StatelessWidget {
  const _MySideCard({
    required this.report,
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final SessionReport report;
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final r = report;
    final mine = r.myResponse;

    final Widget body;
    if (mine != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mine, style: theme.textTheme.bodyLarge?.copyWith(height: 1.45)),
          if (r.myResponseAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.done_all_rounded, size: 15, color: brand.online),
                const SizedBox(width: 5),
                Text(
                  l.reportsSentAt(_when(l, r.myResponseAt!)),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    } else if (r.canRespond) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            enabled: !sending,
            minLines: 4,
            maxLines: 8,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l.reportsReplyHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline_rounded, size: 15, color: brand.inkMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.reportsReplyNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BusyButton(
            label: l.reportsReplySend,
            icon: Icons.send_rounded,
            busy: sending,
            onPressed: sending ? null : onSend,
          ),
        ],
      );
    } else {
      body = Text(
        l.reportsNoReply,
        style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
      );
    }

    return SettingsCard(
      title: l.reportsMySideTitle,
      subtitle: mine == null && r.canRespond ? l.reportsMySideHint : null,
      icon: Icons.edit_note_rounded,
      hue: AstroPalette.air,
      child: body,
    );
  }
}

/// What the team decided and what it meant for the astrologer's earning.
class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.outcome});

  final ReportOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final o = outcome;
    final amount = o.deductedAmount;
    final (hue, line) = switch (o.kind) {
      'penalty' => (
        AstroPalette.love,
        l.reportsOutcomePenalty(
          amount == null ? '' : _money(o.currency, amount),
        ),
      ),
      'refund' => (AstroPalette.money, l.reportsOutcomeRefund),
      _ => (AstroPalette.health, l.reportsOutcomeNone),
    };
    return SettingsCard(
      title: l.reportsOutcomeTitle,
      subtitle: o.decidedAt == null ? null : _when(l, o.decidedAt!),
      icon: Icons.gavel_rounded,
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hue.tint(0.10),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Text(
              line,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
          if (o.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l.reportsOutcomeNote,
              style: theme.textTheme.labelMedium?.copyWith(
                color: brand.inkMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              o.note.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
