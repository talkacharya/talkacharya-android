import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../cubit/predictions_cubit.dart';
import '../../../../core/l10n/api_error_l10n.dart';

Future<void> showBuyCreditsSheet(
  BuildContext context,
  PredictionCatalog catalog,
) {
  final cubit = context.read<PredictionsCubit>();
  return showAppSheet<void>(
    context: context,
    title: context.l10n.predBuyTitle,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _BuyCreditsBody(catalog: catalog),
    ),
  );
}

class _BuyCreditsBody extends StatelessWidget {
  const _BuyCreditsBody({required this.catalog});
  final PredictionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.predBuyBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          for (final pack in catalog.packs) ...[
            _PackTile(pack: pack, currency: catalog.currency),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 6),
          Text(
            l.predBuyWalletNote,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackTile extends StatefulWidget {
  const _PackTile({required this.pack, required this.currency});
  final PredictionPack pack;
  final String currency;

  @override
  State<_PackTile> createState() => _PackTileState();
}

class _PackTileState extends State<_PackTile> {
  bool _busy = false;

  Future<void> _buy() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final l = context.l10n;
    try {
      final balance = await context.read<PredictionsCubit>().buyPack(
        widget.pack.pack,
      );
      nav.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l.predBuySuccess(balance))),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(localizedErrorFor(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = widget.pack;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          l.predPackName(p.credits),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(l.predPackPer(_perCredit(p))),
        trailing: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : FilledButton(
                onPressed: _buy,
                // The app-wide FilledButton theme forces a full-width
                // (Size.fromHeight) minimum — override it here so the button
                // wraps its label and fits in ListTile.trailing.
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('${widget.currency} ${p.price}'),
              ),
      ),
    );
  }

  String _perCredit(PredictionPack p) {
    final price = double.tryParse(p.price) ?? 0;
    if (p.credits <= 1) return p.price;
    return (price / p.credits).toStringAsFixed(0);
  }
}
