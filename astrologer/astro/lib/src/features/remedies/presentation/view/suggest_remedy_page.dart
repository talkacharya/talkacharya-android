import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/remedies_api.dart';
import 'remedies_page.dart';

/// The latest session with each customer, newest first — who a remedy can be
/// suggested to. Customers are told apart by name: that is all a session row
/// carries about them.
List<Consultation> latestPerCustomer(List<Consultation> sessions) {
  final seen = <String>{};
  return [
    for (final c in sessions)
      if (seen.add(c.customerName.trim().toLowerCase())) c,
  ];
}

/// Pick a customer (unless the page was opened from their session), pick a
/// product, add a line on how to use it, send. Pops `true` once sent.
class SuggestRemedyPage extends StatefulWidget {
  const SuggestRemedyPage({this.consultationId, this.customerName, super.key});

  /// Set when opened from a session: the customer is already decided.
  final String? consultationId;
  final String? customerName;

  @override
  State<SuggestRemedyPage> createState() => _SuggestRemedyPageState();
}

class _SuggestRemedyPageState extends State<SuggestRemedyPage> {
  final _note = TextEditingController();
  final _search = TextEditingController();
  Timer? _debounce;

  List<Consultation>? _customers;
  List<RemedyProduct>? _products;
  String? _productsError;

  late String? _consultationId = widget.consultationId;
  RemedyProduct? _product;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    if (_consultationId == null) _loadCustomers();
    _loadProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _note.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final sessions = await getIt<ConsultationApi>().list(
        status: 'ended,active,accepted',
      );
      if (mounted) setState(() => _customers = latestPerCustomer(sessions));
    } catch (_) {
      if (mounted) setState(() => _customers = const []);
    }
  }

  Future<void> _loadProducts() async {
    final query = _search.text;
    try {
      final products = await getIt<RemediesApi>().products(query: query);
      // A slower response for an earlier query must not replace a newer one.
      if (!mounted || query != _search.text) return;
      setState(() {
        _products = products;
        _productsError = null;
      });
    } catch (e) {
      if (mounted) setState(() => _productsError = friendlyError(e));
    }
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadProducts);
  }

  Future<void> _send() async {
    final consultation = _consultationId;
    final product = _product;
    if (consultation == null || product == null || _sending) return;
    setState(() => _sending = true);
    final l = context.l10n;
    try {
      await getIt<RemediesApi>().suggest(
        consultationId: consultation,
        productId: product.id,
        note: _note.text,
      );
      if (!mounted) return;
      showToast(context, l.remedySent);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final preset = widget.consultationId != null;
    final products = _products;

    return SubPageScaffold(
      title: l.remedySuggestTitle,
      subtitle: preset && (widget.customerName ?? '').isNotEmpty
          ? l.remedySuggestFor(widget.customerName!)
          : null,
      bottomBar: StickyActionBar(
        child: BusyButton(
          label: l.remedySend,
          icon: Icons.send_rounded,
          busy: _sending,
          onPressed: _consultationId == null || _product == null ? null : _send,
        ),
      ),
      children: [
        if (!preset) ...[
          _StepTitle(number: 1, text: l.remedyStepCustomer),
          _CustomerPicker(
            customers: _customers,
            selected: _consultationId,
            onSelected: (id) => setState(() => _consultationId = id),
          ),
          const SizedBox(height: 18),
        ],
        _StepTitle(number: preset ? 1 : 2, text: l.remedyStepProduct),
        TextField(
          controller: _search,
          onChanged: _onSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l.remedySearchHint,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 10),
        if (products == null && _productsError != null)
          ErrorView(message: _productsError!, onRetry: _loadProducts)
        else if (products == null)
          const AppShimmer(
            child: Column(
              children: [
                SkeletonBox(height: 68, radius: 14),
                SizedBox(height: 8),
                SkeletonBox(height: 68, radius: 14),
              ],
            ),
          )
        else if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              l.remedyNoProducts,
              textAlign: TextAlign.center,
              style: TextStyle(color: brand.inkMuted),
            ),
          )
        else
          for (final p in products)
            _ProductTile(
              product: p,
              selected: p.id == _product?.id,
              onTap: () => setState(() => _product = p),
            ),
        const SizedBox(height: 18),
        _StepTitle(number: preset ? 2 : 3, text: l.remedyStepNote),
        TextField(
          controller: _note,
          minLines: 2,
          maxLines: 4,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l.remedyNoteHint),
        ),
        Text(
          l.remedyDisclosure,
          style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
        ),
      ],
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
            child: Text(
              '$number',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerPicker extends StatelessWidget {
  const _CustomerPicker({
    required this.customers,
    required this.selected,
    required this.onSelected,
  });

  final List<Consultation>? customers;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = customers;
    if (list == null) {
      return const AppShimmer(child: SkeletonBox(height: 44, radius: 22));
    }
    if (list.isEmpty) {
      return Text(
        l.remedyNoCustomers,
        style: TextStyle(color: context.brand.inkMuted),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final c in list.take(20))
          ChoiceChip(
            avatar: HueAvatar(
              name: c.customerName,
              hue: AstroPalette.forId(c.customerName),
              size: 24,
            ),
            label: Text(
              [
                c.customerName,
                if ((c.endedAt ?? c.requestedAt) != null)
                  TimeFormat.relative(l, c.endedAt ?? c.requestedAt),
              ].join(' · '),
            ),
            selected: c.id == selected,
            onSelected: (_) => onSelected(c.id),
          ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final RemedyProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final p = product;
    final primary = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? primary.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(
            color: selected ? primary : brand.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ProductThumb(url: p.image, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (p.subtitle.isNotEmpty)
                        Text(
                          p.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      if (p.priceFrom != null)
                        Text(
                          Money.format(p.priceFrom!, 'INR'),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? primary : brand.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
