import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/earnings_api.dart';
import '../../data/earnings_models.dart';

/// Icon, label and hue for an [EarningKinds] value.
({IconData icon, String label, AstroHue hue}) earningKindStyle(
  BuildContext context,
  String kind,
) {
  final l = context.l10n;
  return switch (kind) {
    EarningKinds.gift => (
      icon: Icons.card_giftcard_rounded,
      label: l.earnKindGift,
      hue: AstroPalette.love,
    ),
    EarningKinds.prediction => (
      icon: Icons.insights_rounded,
      label: l.earnKindPrediction,
      hue: AstroPalette.air,
    ),
    EarningKinds.storeSale => (
      icon: Icons.storefront_rounded,
      label: l.earnKindStore,
      hue: AstroPalette.money,
    ),
    EarningKinds.affiliate => (
      icon: Icons.handshake_rounded,
      label: l.earnKindAffiliate,
      hue: AstroPalette.fire,
    ),
    EarningKinds.bonus => (
      icon: Icons.celebration_rounded,
      label: l.earnKindBonus,
      hue: AstroPalette.health,
    ),
    EarningKinds.adjustment => (
      icon: Icons.tune_rounded,
      label: l.earnKindAdjustment,
      hue: AstroPalette.water,
    ),
    _ => (
      icon: Icons.forum_rounded,
      label: l.earnKindConsultation,
      hue: AstroPalette.career,
    ),
  };
}

/// Label, colour and icon for a [PayoutStatuses] value.
({String label, Color color, IconData icon}) payoutStatusStyle(
  BuildContext context,
  String status,
) {
  final l = context.l10n;
  final brand = context.brand;
  return switch (status) {
    PayoutStatuses.paid => (
      label: l.payoutStatusPaid,
      color: brand.online,
      icon: Icons.check_circle_rounded,
    ),
    PayoutStatuses.processing => (
      label: l.payoutStatusProcessing,
      color: AstroPalette.career.end,
      icon: Icons.sync_rounded,
    ),
    PayoutStatuses.failed => (
      label: l.payoutStatusFailed,
      color: brand.live,
      icon: Icons.error_rounded,
    ),
    PayoutStatuses.onHold => (
      label: l.payoutStatusOnHold,
      color: AstroPalette.money.end,
      icon: Icons.pause_circle_rounded,
    ),
    PayoutStatuses.cancelled => (
      label: l.payoutStatusCancelled,
      color: brand.inkMuted,
      icon: Icons.cancel_rounded,
    ),
    _ => (
      label: l.payoutStatusPending,
      color: AstroPalette.money.end,
      icon: Icons.schedule_rounded,
    ),
  };
}

String taxDocKindLabel(BuildContext context, String kind) {
  final l = context.l10n;
  return switch (kind) {
    'customer_invoice' => l.docKindCustomerInvoice,
    'astrologer_invoice' => l.docKindAstrologerInvoice,
    'tds_certificate' => l.docKindTds,
    'gst_invoice' => l.docKindGst,
    'credit_note' => l.docKindCreditNote,
    'store_invoice' => l.docKindStore,
    _ => kind.replaceAll('_', ' '),
  };
}

/// "12 Sep" in the app locale.
String shortDate(BuildContext context, DateTime d) =>
    DateFormat.MMMd(context.l10n.localeName).format(d.toLocal());

/// A percentage without needless decimals: 20.0 → "20", 12.5 → "12.5".
String _pct(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

/// Coloured status pill.
class PayoutStatusChip extends StatelessWidget {
  const PayoutStatusChip({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final s = payoutStatusStyle(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 13, color: s.color),
          const SizedBox(width: 4),
          Text(
            s.label,
            style: TextStyle(
              color: s.color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// One ledger line: kind icon, fee note, clearing state and the net amount.
class EarningEntryTile extends StatelessWidget {
  const EarningEntryTile({required this.entry, this.onTap, super.key});

  final EarningEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final k = earningKindStyle(context, e.kind);
    final today = DateUtils.dateOnly(DateTime.now());
    final clearing = e.isClearing(today);

    final (stateLabel, stateColor) = e.isPaidOut
        ? (l.earnEntryPaid, brand.inkMuted)
        : clearing
        ? (
            l.earnEntryClears(shortDate(context, e.availableOn!)),
            AstroPalette.money.end,
          )
        : (l.earnEntryReady, brand.online);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            HueIcon(hue: k.hue, icon: k.icon, size: 40, iconSize: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    k.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (e.commission > 0)
                    Text(
                      l.earnEntryFee(
                        _pct(e.commissionPercent),
                        Money.format(e.gross, e.currency),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Money.signed(e.net, e.currency),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: e.net < 0 ? brand.live : brand.online,
                  ),
                ),
                Text(
                  stateLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: stateColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A payout in the list: amount, status, period and entry count.
class PayoutCard extends StatelessWidget {
  const PayoutCard({required this.payout, required this.onTap, super.key});

  final Payout payout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = payout;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = payoutStatusStyle(context, p.status);
    final period = (p.periodStart != null && p.periodEnd != null)
        ? '${shortDate(context, p.periodStart!)} – ${shortDate(context, p.periodEnd!)}'
        : '';
    final meta = [
      if (period.isNotEmpty) period,
      l.payoutEntries(p.entryCount),
      if (p.paidAt != null) l.payoutPaidOn(shortDate(context, p.paidAt!)),
    ].join(' · ');

    return Pressable(
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(color: brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: s.color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Money.format(p.net, p.currency),
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            PayoutStatusChip(status: p.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meta,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: brand.inkMuted,
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

/// A tax document; tapping downloads the PDF and opens the share sheet.
class TaxDocumentTile extends StatefulWidget {
  const TaxDocumentTile({required this.document, super.key});

  final TaxDocument document;

  @override
  State<TaxDocumentTile> createState() => _TaxDocumentTileState();
}

class _TaxDocumentTileState extends State<TaxDocumentTile> {
  bool _busy = false;

  Future<void> _open() async {
    final d = widget.document;
    final failed = context.l10n.docDownloadFailed;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final bytes = await getIt<EarningsApi>().taxDocumentPdf(d.id);
      if (bytes.isEmpty) throw StateError('empty pdf');
      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: 'application/pdf',
          name: '${d.number.replaceAll('/', '_')}.pdf',
        ),
      ]);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.document;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final meta = [
      d.number,
      if (d.issuedAt != null) shortDate(context, d.issuedAt!),
      if (d.tax > 0) l.docTax(Money.format(d.tax, d.currency)),
    ].join(' · ');
    return InkWell(
      onTap: _busy ? null : _open,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const HueIcon(
              hue: AstroPalette.fire,
              icon: Icons.picture_as_pdf_rounded,
              size: 40,
              iconSize: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taxDocKindLabel(context, d.kind),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Money.format(d.total, d.currency),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox.square(
              dimension: 24,
              child: _busy
                  ? const Padding(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.ios_share_rounded, color: brand.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}
