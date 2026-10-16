import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/router/routes.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../data/my_store_api.dart';
import '../data/my_store_models.dart';
import 'my_store_widgets.dart';

/// `/my-store/listings/new` and `/my-store/listings/:id` — one product or
/// service: what it is, its photos, its price and stock, and sending it for
/// review. Price and stock change at once even when it is live; anything a
/// customer reads takes a live listing back to review, and the page says so
/// before saving.
class ListingEditorPage extends StatefulWidget {
  const ListingEditorPage({this.listingId, super.key});

  final String? listingId;

  @override
  State<ListingEditorPage> createState() => _ListingEditorPageState();
}

class _ListingEditorPageState extends State<ListingEditorPage> {
  final _api = getIt<MyStoreApi>();
  final _form = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _subtitle = TextEditingController();
  final _description = TextEditingController();
  final _benefits = TextEditingController();
  final _howTo = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  final _stock = TextEditingController();
  final _weight = TextEditingController();
  final _lead = TextEditingController();

  CatalogOptions? _options;
  MyListing? _listing;
  String? _type;
  String? _category;
  Map<String, dynamic> _attrs = {};

  /// Photos picked before the listing has been saved the first time.
  final _pending = <String>[];

  bool _loading = true;
  bool _busy = false;
  String? _error;

  /// What the content fields held when loaded, to tell a content edit apart
  /// from a price or stock one.
  String _contentKey = '';

  bool get _isNew => _listing == null;
  ListingType? get _typeInfo => _type == null ? null : _options?.typeOf(_type!);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _subtitle,
      _description,
      _benefits,
      _howTo,
      _price,
      _mrp,
      _stock,
      _weight,
      _lead,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final options = await _api.options();
      final id = widget.listingId;
      final listing = id == null ? null : await _api.listing(id);
      if (!mounted) return;
      setState(() {
        _options = options;
        _apply(listing);
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  void _apply(MyListing? listing) {
    _listing = listing;
    if (listing == null) return;
    _type = listing.typeSlug;
    _category = listing.categorySlug;
    _attrs = Map.of(listing.attributes);
    _title.text = listing.title;
    _subtitle.text = listing.subtitle;
    _description.text = listing.description;
    _benefits.text = listing.benefits;
    _howTo.text = listing.howToUse;
    _price.text = _plain(listing.price);
    _mrp.text = _plain(listing.compareAt);
    _stock.text = listing.stock?.toString() ?? '';
    _weight.text = listing.weightGrams > 0 ? '${listing.weightGrams}' : '';
    _lead.text = listing.leadTimeDays?.toString() ?? '';
    _contentKey = _currentContentKey();
  }

  static String _plain(double? v) => v == null
      ? ''
      : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2));

  String _currentContentKey() => [
    _title.text.trim(),
    _subtitle.text.trim(),
    _description.text.trim(),
    _benefits.text.trim(),
    _howTo.text.trim(),
    _category,
    _lead.text.trim(),
    _attrs.toString(),
  ].join('|');

  Map<String, dynamic> _payload() {
    final type = _typeInfo;
    return {
      if (_isNew) 'product_type': _type,
      'category': _category,
      'title': _title.text.trim(),
      'subtitle': _subtitle.text.trim(),
      'description': _description.text.trim(),
      'benefits': _benefits.text.trim(),
      'how_to_use': _howTo.text.trim(),
      'attributes': _attrs,
      'price': _price.text.trim(),
      'compare_at': _mrp.text.trim().isEmpty ? null : _mrp.text.trim(),
      'lead_time_days': _lead.text.trim().isEmpty ? null : _lead.text.trim(),
      if (type?.isPhysical ?? false)
        'stock': _stock.text.trim().isEmpty ? 0 : _stock.text.trim(),
      if (type?.isPhysical ?? false) 'weight_grams': _weight.text.trim(),
    };
  }

  Future<bool> _confirmLiveEdit() async {
    final l = context.l10n;
    final listing = _listing;
    if (listing == null || !listing.isLive) return true;
    if (_currentContentKey() == _contentKey) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.msLiveEditTitle),
        content: Text(l.msLiveEditBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.msLiveEditGo),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<MyListing?> _save({bool quiet = false}) async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return null;
    if (!await _confirmLiveEdit()) return null;
    setState(() => _busy = true);
    try {
      var listing = _isNew
          ? await _api.create(_payload())
          : await _api.update(_listing!.id, _payload());
      // Photos chosen before the first save go up now that it exists.
      for (final path in List.of(_pending)) {
        listing = await _api.addPhoto(listing.id, path);
        _pending.remove(path);
      }
      if (!mounted) return listing;
      final wasNew = _isNew;
      setState(() => _apply(listing));
      if (!quiet) {
        showToast(
          context,
          listing.sentBackToReview ? l.msBackToReview : l.commonSaved,
        );
      }
      if (wasNew) {
        // Keep the page, now on the saved listing's own address.
        context.replace(Routes.myStoreListing(listing.id));
      }
      return listing;
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final saved = await _save(quiet: true);
    if (saved == null || !mounted) return;
    if (saved.checklist.isNotEmpty) {
      showToast(context, l.msFixChecklist);
      return;
    }
    setState(() => _busy = true);
    try {
      final listing = await _api.submit(saved.id);
      if (!mounted) return;
      setState(() => _apply(listing));
      showToast(context, l.msSentForReview);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _pickPhoto() async {
    final l = context.l10n;
    final max = _options?.maxImages ?? 8;
    final count = (_listing?.photos.length ?? 0) + _pending.length;
    if (count >= max) {
      showToast(context, l.msPhotoLimit(max));
      return;
    }
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l.msPhotoCamera),
              onTap: () => Navigator.pop(sheet, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l.msPhotoGallery),
              onTap: () => Navigator.pop(sheet, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    // Sent large on purpose: the server cuts every size the store needs.
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2400,
      imageQuality: 88,
    );
    if (picked == null || !mounted) return;
    final listing = _listing;
    if (listing == null) {
      setState(() => _pending.add(picked.path));
      return;
    }
    if (listing.isLive && !await _confirmPhotoEdit()) return;
    setState(() => _busy = true);
    try {
      final updated = await _api.addPhoto(listing.id, picked.path);
      if (!mounted) return;
      setState(() => _apply(updated));
      if (updated.sentBackToReview) showToast(context, l.msBackToReview);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<bool> _confirmPhotoEdit() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.msLiveEditTitle),
        content: Text(l.msLiveEditBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.msLiveEditGo),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _photoActions(ListingPhoto photo, int index) async {
    final l = context.l10n;
    final listing = _listing!;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0)
              ListTile(
                leading: const Icon(Icons.star_rounded),
                title: Text(l.msMakeCover),
                onTap: () => Navigator.pop(sheet, 'cover'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(l.msRemovePhoto),
              onTap: () => Navigator.pop(sheet, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'remove' && listing.isLive && !await _confirmPhotoEdit()) {
      return;
    }
    setState(() => _busy = true);
    try {
      final updated = action == 'cover'
          ? await _api.reorderPhotos(listing.id, [
              photo.id,
              for (final p in listing.photos)
                if (p.id != photo.id) p.id,
            ])
          : await _api.removePhoto(listing.id, photo.id);
      if (mounted) setState(() => _apply(updated));
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _menu(String action) async {
    final l = context.l10n;
    final listing = _listing;
    if (listing == null) return;
    if (action == 'delete') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (d) => AlertDialog(
          title: Text(l.msDeleteTitle),
          content: Text(l.msDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(d, true),
              child: Text(l.msDelete),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _busy = true);
    try {
      if (action == 'delete') {
        await _api.remove(listing.id);
        if (mounted) Navigator.of(context).pop();
        return;
      }
      final updated = await _api.withdraw(listing.id);
      if (mounted) {
        setState(() => _apply(updated));
        showToast(context, l.msStoppedSelling);
      }
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  String? _required(String? v) =>
      (v ?? '').trim().isEmpty ? context.l10n.msRequired : null;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final listing = _listing;
    return SubPageScaffold(
      title: _isNew ? l.msNewListing : l.msEditListing,
      actions: [
        if (listing != null)
          PopupMenuButton<String>(
            onSelected: _menu,
            itemBuilder: (_) => [
              if (listing.isLive || listing.inReview)
                PopupMenuItem(value: 'withdraw', child: Text(l.msStopSelling)),
              PopupMenuItem(value: 'delete', child: Text(l.msDelete)),
            ],
          ),
      ],
      bottomBar: _loading || _error != null ? null : _bottomBar(context),
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          ErrorView(message: _error!, onRetry: _load)
        else
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (listing != null) _StatusCard(listing: listing),
                _photosCard(context),
                _aboutCard(context),
                if ((_typeInfo?.attributes ?? const []).isNotEmpty)
                  _attributesCard(context),
                _priceCard(context),
              ],
            ),
          ),
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    final l = context.l10n;
    final listing = _listing;
    final canSubmit = listing == null || listing.isDraft;
    return StickyActionBar(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _busy ? null : () => _save(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                listing == null
                    ? l.msSaveDraft
                    : (listing.isLive ? l.msSaveChanges : l.commonSave),
              ),
            ),
          ),
          if (canSubmit) ...[
            const SizedBox(width: 10),
            Expanded(
              child: BusyButton(
                label: l.msSendForReview,
                busy: _busy,
                onPressed: _submit,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _photosCard(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final photos = _listing?.photos ?? const <ListingPhoto>[];
    final max = _options?.maxImages ?? 8;
    final total = photos.length + _pending.length;
    Widget tile({required Widget child, VoidCallback? onTap, String? badge}) =>
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 92,
            height: 92,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: brand.tint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: brand.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                child,
                if (badge != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        badge,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
    return SettingsCard(
      title: l.msPhotos,
      subtitle: l.msPhotosHint(max),
      icon: Icons.photo_library_rounded,
      hue: AstroPalette.career,
      child: SizedBox(
        height: 96,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < photos.length; i++)
              tile(
                onTap: _busy ? null : () => _photoActions(photos[i], i),
                badge: i == 0 ? l.msCover : null,
                child: Image.network(
                  photos[i].thumb,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            for (var i = 0; i < _pending.length; i++)
              tile(
                onTap: () => setState(() => _pending.removeAt(i)),
                badge: photos.isEmpty && i == 0 ? l.msCover : null,
                child: Image.file(File(_pending[i]), fit: BoxFit.cover),
              ),
            if (total < max)
              tile(
                onTap: _busy ? null : _pickPhoto,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_rounded, color: brand.gold),
                    const SizedBox(height: 4),
                    Text(
                      l.msAddPhoto,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _aboutCard(BuildContext context) {
    final l = context.l10n;
    final options = _options!;
    final service = _typeInfo?.isService ?? false;
    final categories = [...options.categories]
      ..sort(
        (a, b) => options
            .categoryLabel(a.slug)
            .compareTo(options.categoryLabel(b.slug)),
      );
    return SettingsCard(
      title: l.msWhatSection,
      icon: Icons.inventory_2_rounded,
      hue: AstroPalette.money,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _type,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.msType),
            items: [
              for (final t in options.types)
                DropdownMenuItem(
                  value: t.slug,
                  child: Text(
                    '${t.name} · ${t.isService ? l.msKindService : l.msKindProduct}',
                  ),
                ),
            ],
            onChanged: _isNew
                ? (v) => setState(() {
                    _type = v;
                    _attrs = {};
                  })
                : null,
            validator: (v) => v == null ? l.msRequired : null,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.msCategory),
            items: [
              for (final c in categories)
                DropdownMenuItem(
                  value: c.slug,
                  child: Text(options.categoryLabel(c.slug)),
                ),
            ],
            onChanged: (v) => setState(() => _category = v),
            validator: (v) => v == null ? l.msRequired : null,
          ),
          TextFormField(
            controller: _title,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.msTitleField,
              hintText: service ? l.msTitleHintService : l.msTitleHintProduct,
            ),
            validator: _required,
          ),
          TextFormField(
            controller: _subtitle,
            maxLength: 240,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.msSubtitleField),
          ),
          TextFormField(
            controller: _description,
            minLines: 4,
            maxLines: 10,
            maxLength: 6000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.msDescription,
              hintText: service ? l.msDescHintService : l.msDescHintProduct,
              alignLabelWithHint: true,
            ),
          ),
          TextFormField(
            controller: _benefits,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.msSignificance,
              alignLabelWithHint: true,
            ),
          ),
          TextFormField(
            controller: _howTo,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: service ? l.msHowPerformed : l.msHowToUse,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 4),
          NoteBox(
            text: l.msClaimsRule,
            color: AstroPalette.fire.end,
            icon: Icons.gavel_rounded,
          ),
        ],
      ),
    );
  }

  Widget _attributesCard(BuildContext context) {
    final l = context.l10n;
    final attrs = _typeInfo!.attributes;
    return SettingsCard(
      title: l.msDetailsSection,
      icon: Icons.tune_rounded,
      hue: AstroPalette.air,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (final a in attrs) _attributeField(context, a)],
      ),
    );
  }

  Widget _attributeField(BuildContext context, ListingAttribute a) {
    final l = context.l10n;
    final label = [
      a.name,
      if (a.unit.isNotEmpty) '(${a.unit})',
      if (a.required) '*',
    ].join(' ');
    final value = _attrs[a.key];
    String? need(Object? v) =>
        a.required && (v == null || '$v'.trim().isEmpty) ? l.msRequired : null;
    switch (a.inputType) {
      case 'boolean':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(child: Text(label)),
              Switch(
                value: value == true,
                onChanged: (v) => setState(() => _attrs[a.key] = v),
              ),
            ],
          ),
        );
      case 'choice':
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DropdownButtonFormField<String>(
            initialValue: a.options.any((o) => o.key == value)
                ? '$value'
                : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: label,
              helperText: a.helpText.isEmpty ? null : a.helpText,
            ),
            items: [
              for (final o in a.options)
                DropdownMenuItem(value: o.key, child: Text(o.label)),
            ],
            onChanged: (v) => setState(() => _attrs[a.key] = v),
            validator: need,
          ),
        );
      case 'multi_choice':
        final picked = {for (final v in (value as List? ?? const [])) '$v'};
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final o in a.options)
                    FilterChip(
                      label: Text(o.label),
                      selected: picked.contains(o.key),
                      onSelected: (on) => setState(() {
                        final next = {...picked};
                        on ? next.add(o.key) : next.remove(o.key);
                        _attrs[a.key] = next.toList();
                      }),
                    ),
                ],
              ),
            ],
          ),
        );
      default:
        final number = a.inputType == 'number';
        return TextFormField(
          initialValue: value == null ? '' : '$value',
          keyboardType: number
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            helperText: a.helpText.isEmpty ? null : a.helpText,
          ),
          onChanged: (v) => _attrs[a.key] = number
              ? (num.tryParse(v.trim()) ?? v.trim())
              : v.trim(),
          validator: need,
        );
    }
  }

  Widget _priceCard(BuildContext context) {
    final l = context.l10n;
    final type = _typeInfo;
    final physical = type?.isPhysical ?? false;
    final service = type?.isService ?? false;
    final money = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
    final whole = [FilteringTextInputFormatter.digitsOnly];
    return SettingsCard(
      title: l.msPriceSection,
      subtitle: l.msPriceHint,
      icon: Icons.currency_rupee_rounded,
      hue: AstroPalette.health,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: money,
                  decoration: InputDecoration(
                    labelText: l.msPrice,
                    prefixText: '₹ ',
                  ),
                  validator: (v) => (double.tryParse((v ?? '').trim()) ?? 0) > 0
                      ? null
                      : l.msPriceInvalid,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _mrp,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: money,
                  decoration: InputDecoration(
                    labelText: l.msMrp,
                    prefixText: '₹ ',
                    helperText: l.msMrpHint,
                  ),
                  validator: (v) {
                    final mrp = double.tryParse((v ?? '').trim());
                    final price = double.tryParse(_price.text.trim());
                    if (mrp == null || price == null) return null;
                    return mrp < price ? l.msMrpBelowPrice : null;
                  },
                ),
              ),
            ],
          ),
          if (physical)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stock,
                    keyboardType: TextInputType.number,
                    inputFormatters: whole,
                    decoration: InputDecoration(
                      labelText: l.msStock,
                      helperText: l.msStockHint,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _weight,
                    keyboardType: TextInputType.number,
                    inputFormatters: whole,
                    decoration: InputDecoration(
                      labelText: l.msWeight,
                      suffixText: 'g',
                      helperText: l.msWeightHint,
                    ),
                  ),
                ),
              ],
            ),
          TextFormField(
            controller: _lead,
            keyboardType: TextInputType.number,
            inputFormatters: whole,
            decoration: InputDecoration(
              labelText: service ? l.msLeadService : l.msLeadProduct,
              suffixText: l.msDays,
            ),
          ),
        ],
      ),
    );
  }
}

/// Where the listing stands: its state, what the team said, what is missing.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.listing});
  final MyListing listing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = listingStatus(context, listing);
    final explain = listing.hasChangesRequested
        ? null
        : switch (listing.status) {
            'published' => l.msLiveExplain,
            'in_review' => l.msReviewExplain,
            _ => l.msDraftExplain,
          };
    return SettingsCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MsPill(label: s.label, color: s.color, icon: s.icon),
              const Spacer(),
              if (listing.isLive)
                Text(
                  l.msSoldCount(listing.soldCount),
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),
          if (explain != null) ...[
            const SizedBox(height: 8),
            Text(
              explain,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.brand.inkMuted,
                height: 1.35,
              ),
            ),
          ],
          if (listing.hasChangesRequested) ...[
            const SizedBox(height: 10),
            NoteBox(
              title: l.msTeamSaid,
              text: listing.reviewNote,
              color: s.color,
            ),
          ],
          if (listing.isDraft && listing.checklist.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              l.msChecklistTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            for (final c in listing.checklist)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: context.brand.inkMuted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        checklistLabel(l, c),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// The server's checklist item in the app's language when it is a known one;
/// attribute problems come worded by the server.
String checklistLabel(AppLocalizations l, ChecklistItem c) => switch (c.code) {
  'no_image' => l.msCheckPhoto,
  'no_description' => l.msCheckDescription,
  'no_price' => l.msCheckPrice,
  'no_weight' => l.msCheckWeight,
  _ => c.message,
};
