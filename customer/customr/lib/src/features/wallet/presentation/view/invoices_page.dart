import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/models/invoice.dart';
import '../../data/wallet_api.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  late Future<List<Invoice>> _future = getIt<WalletApi>().invoices();
  String? _busyId;

  Future<void> _open(Invoice inv) async {
    setState(() => _busyId = inv.id);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      final bytes = await getIt<WalletApi>().invoicePdf(inv.id);
      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: 'application/pdf',
          name: 'invoice-${inv.number}.pdf',
        ),
      ]);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.commonSomethingWentWrong)),
      );
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l.walletGstInvoices)),
      body: FutureBuilder<List<Invoice>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return ErrorView(
              message: l.commonSomethingWentWrong,
              onRetry: () =>
                  setState(() => _future = getIt<WalletApi>().invoices()),
            );
          }
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_rounded,
              title: l.walletGstInvoices,
              message: l.walletInvoicesSubtitle,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final inv = items[i];
              return ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(inv.number),
                subtitle: Text(
                  inv.issuedAt == null
                      ? ''
                      : DateFormat.yMMMd(locale).format(inv.issuedAt!),
                ),
                trailing: _busyId == inv.id
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Money.format(
                              inv.total,
                              inv.currency,
                              locale: locale,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.ios_share_rounded, size: 18),
                        ],
                      ),
                onTap: _busyId == null ? () => _open(inv) : null,
              );
            },
          );
        },
      ),
    );
  }
}
