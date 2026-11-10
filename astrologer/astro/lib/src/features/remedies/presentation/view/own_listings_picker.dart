import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../my_store/data/my_store_api.dart';
import '../../../my_store/data/my_store_models.dart';
import '../../../my_store/presentation/my_store_widgets.dart';
import 'remedies_page.dart' show ProductThumb;

/// The astrologer's own listings, to suggest one as a remedy: as it is, after
/// editing a copy just for this client, or a new one made now. A listing that
/// is not live yet reaches the client once the team approves it.
class OwnListingsPicker extends StatefulWidget {
  const OwnListingsPicker({
    required this.selectedId,
    required this.onSelected,
    required this.consultationId,
    required this.customerName,
    super.key,
  });

  final String? selectedId;
  final ValueChanged<MyListing?> onSelected;

  /// The session of the client it is for — needed to copy a listing for them.
  final String? consultationId;
  final String? customerName;

  @override
  State<OwnListingsPicker> createState() => _OwnListingsPickerState();
}

class _OwnListingsPickerState extends State<OwnListingsPicker> {
  StoreSetup? _store;
  List<MyListing>? _listings;
  String? _error;
  String? _copying;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? select}) async {
    final api = getIt<MyStoreApi>();
    try {
      final store = await api.setup();
      final listings = store.exists
          ? await api.listings()
          : const <MyListing>[];
      if (!mounted) return;
      setState(() {
        _store = store;
        _listings = listings;
        _error = null;
      });
      if (select != null) {
        for (final l in listings) {
          if (l.id == select) widget.onSelected(l);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  /// A copy only this client sees, opened in the editor; back from it, the
  /// copy is the one chosen.
  Future<void> _editForClient(MyListing listing) async {
    final l = context.l10n;
    final consultation = widget.consultationId;
    if (consultation == null) {
      showToast(context, l.remedyPickCustomerFirst);
      return;
    }
    setState(() => _copying = listing.id);
    try {
      final copy = await getIt<MyStoreApi>().copyForClient(
        listing.id,
        consultationId: consultation,
      );
      if (!mounted) return;
      await context.push<String>(Routes.myStoreListing(copy.id));
      if (mounted) await _load(select: copy.id);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _copying = null);
    }
  }

  Future<void> _newListing() async {
    final id = await context.push<String>(Routes.myStoreNewListing);
    if (mounted) await _load(select: id);
  }

  /// What this client may be sent: shared listings, and copies made for them.
  List<MyListing> _forThisClient(List<MyListing> all) => [
    for (final l in all)
      if (l.privateForName.isEmpty ||
          l.privateForName == (widget.customerName ?? ''))
        l,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final store = _store;
    final listings = _listings;

    if (listings == null && _error != null) {
      return ErrorView(message: _error!, onRetry: _load);
    }
    if (store == null || listings == null) {
      return const AppShimmer(
        child: Column(
          children: [
            SkeletonBox(height: 68, radius: 14),
            SizedBox(height: 8),
            SkeletonBox(height: 68, radius: 14),
          ],
        ),
      );
    }
    if (!store.exists) {
      return _Hint(
        icon: Icons.storefront_rounded,
        text: l.remedySetUpStore,
        action: l.remedyStoreSetUpAction,
        onTap: () async {
          await context.push<void>(Routes.myStoreSetup);
          if (mounted) await _load();
        },
      );
    }
    final shown = _forThisClient(listings);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NewTile(label: l.remedyNewListing, onTap: _newListing),
        const SizedBox(height: 8),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l.remedyNoListings,
              textAlign: TextAlign.center,
              style: TextStyle(color: brand.inkMuted),
            ),
          )
        else
          for (final item in shown)
            _ListingTile(
              listing: item,
              selected: item.id == widget.selectedId,
              copying: _copying == item.id,
              onTap: () => widget.onSelected(item),
              onEditForClient: item.privateForName.isEmpty
                  ? () => _editForClient(item)
                  : () async {
                      // Already this client's copy: edit it directly.
                      await context.push<String>(
                        Routes.myStoreListing(item.id),
                      );
                      if (mounted) await _load(select: item.id);
                    },
            ),
      ],
    );
  }
}

class _NewTile extends StatelessWidget {
  const _NewTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Material(
      color: primary.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: BorderSide(color: primary.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Icon(Icons.add_circle_rounded, color: primary),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListingTile extends StatelessWidget {
  const _ListingTile({
    required this.listing,
    required this.selected,
    required this.copying,
    required this.onTap,
    required this.onEditForClient,
  });

  final MyListing listing;
  final bool selected;
  final bool copying;
  final VoidCallback onTap;
  final VoidCallback onEditForClient;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final status = listingStatus(context, listing);
    final price =
        listing.price ??
        (listing.packages.isEmpty ? null : listing.packages.first.price);
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
            padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
            child: Row(
              children: [
                ProductThumb(url: listing.cover, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title.isEmpty
                            ? listing.categoryName
                            : listing.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            status.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: status.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (listing.privateForName.isNotEmpty)
                            Text(
                              '· ${l.remedyForClient(listing.privateForName)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AstroPalette.money.end,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (price != null)
                            Text(
                              '· ${Money.format(price, listing.currency)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: brand.inkMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (copying)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  IconButton(
                    tooltip: l.remedyEditForClient,
                    onPressed: onEditForClient,
                    icon: Icon(Icons.edit_note_rounded, color: brand.inkMuted),
                  ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? primary : brand.inkMuted,
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({
    required this.icon,
    required this.text,
    required this.action,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: brand.onTint),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: brand.onTint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton.tonal(onPressed: onTap, child: Text(action)),
        ],
      ),
    );
  }
}
