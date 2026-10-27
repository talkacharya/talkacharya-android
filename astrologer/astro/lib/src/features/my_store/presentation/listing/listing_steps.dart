import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/money.dart';
import '../../data/my_store_models.dart';
import '../my_store_widgets.dart';
import 'listing_draft.dart';
import 'listing_fields.dart';
import 'listing_wizard_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The six steps of the listing form. Each reads the draft from the cubit and
/// writes every change straight back; nothing is held only in a widget.

String stepLabel(AppLocalizations l, WizardStep s) => switch (s) {
  WizardStep.kind => l.lwStepKind,
  WizardStep.photos => l.lwStepPhotos,
  WizardStep.describe => l.lwStepDescribe,
  WizardStep.details => l.lwStepDetails,
  WizardStep.price => l.lwStepPrice,
  WizardStep.preview => l.lwStepPreview,
};

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.title, {this.body});
  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: kFieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (body != null) ...[
            const SizedBox(height: 6),
            Text(
              body!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.brand.inkMuted,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

const _hues = [
  AstroPalette.money,
  AstroPalette.career,
  AstroPalette.love,
  AstroPalette.health,
  AstroPalette.air,
  AstroPalette.fire,
];

IconData _categoryIcon(KindCategory c, bool service) => switch (c.icon) {
  'rudraksha' || 'mala' => Icons.blur_circular_rounded,
  'gem' || 'gemstone' => Icons.diamond_rounded,
  'ring' => Icons.circle_outlined,
  'yantra' => Icons.grid_on_rounded,
  'samagri' => Icons.local_florist_rounded,
  'pooja' => Icons.temple_hindu_rounded,
  _ => service ? Icons.temple_hindu_rounded : Icons.category_rounded,
};

// --- 1. what ---------------------------------------------------------------------

class KindStep extends StatelessWidget {
  const KindStep({required this.state, super.key});
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final d = state.draft;
    final options = state.options!;
    final kind = options.kind(d.kind);
    // an existing listing keeps its kind; it may move to another category
    // that takes the same kind of listing
    final locked = !state.isNew;
    final categories = [
      for (final c in kind?.categories ?? const <KindCategory>[])
        if (!locked || c.types.contains(d.type)) c,
    ];
    final category = state.category;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(l.lwKindTitle),
        ChoiceTile(
          title: l.lwKindProduct,
          subtitle: l.lwKindProductHint,
          icon: Icons.shopping_bag_rounded,
          hue: AstroPalette.money,
          selected: d.kind == 'product',
          onTap: locked ? null : () => cubit.chooseKind('product'),
        ),
        const SizedBox(height: 12),
        ChoiceTile(
          title: l.lwKindService,
          subtitle: l.lwKindServiceHint,
          icon: Icons.temple_hindu_rounded,
          hue: AstroPalette.career,
          selected: d.kind == 'service',
          onTap: locked ? null : () => cubit.chooseKind('service'),
        ),
        if (kind != null) ...[
          const SizedBox(height: 28),
          _StepTitle(l.lwCategoryTitle),
          if (categories.isEmpty)
            Text(l.lwNoCategories)
          else
            for (final (i, c) in categories.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ChoiceTile(
                  dense: true,
                  title: c.name,
                  icon: _categoryIcon(c, kind.isService),
                  hue: _hues[i % _hues.length],
                  selected: d.category == c.slug,
                  onTap: () => cubit.chooseCategory(c.slug),
                ),
              ),
        ],
        if (category != null && category.types.length > 1) ...[
          const SizedBox(height: 18),
          _StepTitle(l.lwTypeTitle),
          for (final t in category.types)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ChoiceTile(
                dense: true,
                title: options.typeOf(t)?.name ?? t,
                selected: d.type == t,
                onTap: locked ? null : () => cubit.chooseType(t),
              ),
            ),
        ],
      ],
    );
  }
}

// --- 2. photos -------------------------------------------------------------------

class PhotosStep extends StatelessWidget {
  const PhotosStep({required this.state, super.key});
  final ListingWizardState state;

  Future<bool> _confirmLive(BuildContext context) async {
    if (!state.isLive) return true;
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

  Future<void> _add(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
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
    if (source == null || !context.mounted) return;
    if (!await _confirmLive(context)) return;
    // Shrunk on the phone: a slow line carries a 1600px photo, not a 12 MP one.
    final picker = ImagePicker();
    final paths = source == ImageSource.camera
        ? [
            ?(await picker.pickImage(
              source: source,
              maxWidth: 1600,
              imageQuality: 82,
            ))?.path,
          ]
        : [
            for (final x in await picker.pickMultiImage(
              maxWidth: 1600,
              imageQuality: 82,
            ))
              x.path,
          ];
    if (paths.isNotEmpty) cubit.addPhotos(paths);
  }

  Future<void> _photoMenu(BuildContext context, ListingPhoto p, int i) async {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final photos = state.listing?.photos ?? const <ListingPhoto>[];
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i > 0)
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
    if (action == null || !context.mounted) return;
    if (action == 'cover') {
      await cubit.reorderPhotos([
        p,
        for (final x in photos)
          if (x.id != p.id) x,
      ]);
    } else if (await _confirmLive(context)) {
      await cubit.removePhoto(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final brand = context.brand;
    final photos = state.listing?.photos ?? const <ListingPhoto>[];
    final max = state.options?.maxImages ?? 8;
    final total = state.photoCount;

    Widget frame({required Widget child, String? badge, VoidCallback? onTap}) =>
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 112,
            height: 112,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: brand.tint,
              borderRadius: BorderRadius.circular(16),
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
                      padding: const EdgeInsets.symmetric(vertical: 3),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(l.lwPhotosTitle, body: l.lwPhotosBody),
        ProblemBox(messages: state.problems[WizardStep.photos] ?? const []),
        SizedBox(
          height: 116,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            proxyDecorator: (child, _, _) =>
                Material(color: Colors.transparent, child: child),
            onReorder: (from, to) {
              if (from >= photos.length) return;
              final list = [...photos];
              final moved = list.removeAt(from);
              list.insert(to > from ? to - 1 : to, moved);
              cubit.reorderPhotos(list);
            },
            footer: Row(
              children: [
                for (final u in state.uploads)
                  frame(
                    onTap: u.status == UploadStatus.failed
                        ? () => cubit.retryUpload(u.key)
                        : null,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(u.path), fit: BoxFit.cover),
                        Container(color: Colors.black38),
                        Center(
                          child: u.status == UploadStatus.failed
                              ? Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                    l.lwUploadFailed,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    value:
                                        u.status == UploadStatus.uploading &&
                                            u.progress > 0
                                        ? u.progress
                                        : null,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => cubit.cancelUpload(u.key),
                            child: const CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (total < max)
                  frame(
                    onTap: () => _add(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          color: brand.gold,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${l.msAddPhoto}  $total/$max',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            children: [
              for (final (i, p) in photos.indexed)
                ReorderableDelayedDragStartListener(
                  key: ValueKey(p.id),
                  index: i,
                  child: frame(
                    badge: i == 0 ? l.msCover : null,
                    onTap: () => _photoMenu(context, p, i),
                    child: Image.network(
                      p.thumb,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- 3. describe -----------------------------------------------------------------

class DescribeStep extends StatelessWidget {
  const DescribeStep({required this.state, super.key});
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final d = state.draft;
    final service = d.isService;
    final claims = state.options!.claimsIn(
      [d.title, d.subtitle, d.description, d.benefits, d.howTo].join(' '),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(l.lwDescribeTitle, body: l.lwVoiceHint),
        ProblemBox(messages: state.problems[WizardStep.describe] ?? const []),
        DraftTextField(
          label: l.msTitleField,
          value: d.title,
          maxLength: 200,
          hint: service ? l.msTitleHintService : l.msTitleHintProduct,
          onChanged: (v) => cubit.edit((x) => x.copyWith(title: v)),
        ),
        DraftTextField(
          label: l.msSubtitleField,
          value: d.subtitle,
          maxLength: 240,
          optional: true,
          onChanged: (v) => cubit.edit((x) => x.copyWith(subtitle: v)),
        ),
        DraftTextField(
          label: l.msDescription,
          value: d.description,
          maxLength: 6000,
          minLines: 5,
          maxLines: 12,
          hint: service ? l.msDescHintService : l.msDescHintProduct,
          onChanged: (v) => cubit.edit((x) => x.copyWith(description: v)),
        ),
        DraftTextField(
          label: l.msSignificance,
          value: d.benefits,
          optional: true,
          minLines: 3,
          maxLines: 8,
          maxLength: 3000,
          onChanged: (v) => cubit.edit((x) => x.copyWith(benefits: v)),
        ),
        DraftTextField(
          label: service ? l.msHowPerformed : l.msHowToUse,
          value: d.howTo,
          optional: true,
          minLines: 3,
          maxLines: 8,
          maxLength: 3000,
          onChanged: (v) => cubit.edit((x) => x.copyWith(howTo: v)),
        ),
        if (claims.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NoteBox(
              text: l.lwClaimsFound(claims.join(', ')),
              color: AstroPalette.fire.end,
              icon: Icons.report_rounded,
            ),
          ),
        NoteBox(
          text: l.msClaimsRule,
          color: AstroPalette.fire.end,
          icon: Icons.gavel_rounded,
        ),
      ],
    );
  }
}

// --- 4. details ------------------------------------------------------------------

class DetailsStep extends StatelessWidget {
  const DetailsStep({required this.state, super.key});
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final attrs = state.type?.attributes ?? const <ListingAttribute>[];
    final values = state.draft.attributes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(l.lwDetailsTitle),
        ProblemBox(messages: state.problems[WizardStep.details] ?? const []),
        for (final a in attrs) _attribute(context, cubit, a, values[a.key]),
      ],
    );
  }

  Widget _attribute(
    BuildContext context,
    ListingWizardCubit cubit,
    ListingAttribute a,
    Object? value,
  ) {
    final label = [a.name, if (a.unit.isNotEmpty) '(${a.unit})'].join(' ');
    final help = a.helpText.isEmpty ? null : a.helpText;
    switch (a.inputType) {
      case 'boolean':
        return FieldBlock(
          label: label,
          optional: !a.required,
          hint: help,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Switch(
              value: value == true,
              onChanged: (v) => cubit.setAttribute(a.key, v),
            ),
          ),
        );
      case 'choice':
        return FieldBlock(
          label: label,
          optional: !a.required,
          hint: help,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in a.options)
                ChoiceChip(
                  label: Text(o.label),
                  selected: '$value' == o.key,
                  onSelected: (on) =>
                      cubit.setAttribute(a.key, on ? o.key : null),
                ),
            ],
          ),
        );
      case 'multi_choice':
        final picked = {for (final v in (value as List? ?? const [])) '$v'};
        final all = picked.length == a.options.length && a.options.isNotEmpty;
        return FieldBlock(
          label: label,
          optional: !a.required,
          hint: help,
          trailing: TextButton(
            onPressed: () => cubit.setAttribute(a.key, [
              if (!all)
                for (final o in a.options) o.key,
            ]),
            child: Text(all ? '✕' : 'All'),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in a.options)
                FilterChip(
                  label: Text(o.label),
                  selected: picked.contains(o.key),
                  onSelected: (on) {
                    final next = {...picked};
                    on ? next.add(o.key) : next.remove(o.key);
                    cubit.setAttribute(a.key, next.toList());
                  },
                ),
            ],
          ),
        );
      default:
        final number = a.inputType == 'number';
        return DraftTextField(
          key: ValueKey('attr-${a.key}'),
          label: label,
          optional: !a.required,
          help: help,
          value: value == null ? '' : '$value',
          number: number,
          decimal: number,
          onChanged: (v) => cubit.setAttribute(
            a.key,
            number ? (num.tryParse(v.trim()) ?? v.trim()) : v.trim(),
          ),
        );
    }
  }
}

// --- 5. price --------------------------------------------------------------------

/// "You get ≈ ₹6,700": the price less the platform's commission and GST on it.
class EarningLine extends StatelessWidget {
  const EarningLine({required this.state, required this.price, super.key});
  final ListingWizardState state;
  final double? price;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fee = state.category?.commissionPercent;
    final p = price;
    if (fee == null || p == null || p <= 0) return const SizedBox.shrink();
    final gst = state.options?.commissionGstPercent ?? 18;
    final get = p - p * fee / 100 * (1 + gst / 100);
    final feeText = fee == fee.roundToDouble()
        ? fee.toStringAsFixed(0)
        : fee.toStringAsFixed(1);
    final brand = context.brand;
    return Container(
      margin: const EdgeInsets.only(bottom: kFieldGap),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: brand.online.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_rounded, color: brand.online),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.lwYouGet(Money.format(get, 'INR')),
                  style: TextStyle(
                    color: brand.online,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  l.lwYouGetHint(feeText),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: brand.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int? _discount(String price, String mrp) {
  final p = double.tryParse(price.trim());
  final m = double.tryParse(mrp.trim());
  if (p == null || m == null || m <= p || m <= 0) return null;
  return ((m - p) / m * 100).round();
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge(this.percent);
  final int? percent;

  @override
  Widget build(BuildContext context) {
    final pct = percent;
    if (pct == null || pct <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.brand.online.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.l10n.lwDiscount(pct),
        style: TextStyle(
          color: context.brand.online,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

String? _mrpError(AppLocalizations l, String price, String mrp) {
  final p = double.tryParse(price.trim());
  final m = double.tryParse(mrp.trim());
  return p != null && m != null && m < p ? l.msMrpBelowPrice : null;
}

class PriceStep extends StatelessWidget {
  const PriceStep({required this.state, super.key});
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final d = state.draft;
    final service = d.isService;
    final physical = state.type?.isPhysical ?? !service;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(
          service ? l.lwPriceTitleService : l.lwPriceTitleProduct,
          body: l.msPriceHint,
        ),
        ProblemBox(messages: state.problems[WizardStep.price] ?? const []),
        if (service) ...[
          for (final (i, p) in d.packages.indexed)
            _PackageCard(
              key: ValueKey(p.key),
              index: i,
              package: p,
              canRemove: d.packages.length > 1,
              state: state,
            ),
          if (d.packages.length < 6)
            Padding(
              padding: const EdgeInsets.only(bottom: kFieldGap),
              child: OutlinedButton.icon(
                onPressed: () => cubit.addPackage(),
                icon: const Icon(Icons.add_rounded),
                label: Text(l.lwPackageAdd),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DraftTextField(
                  label: l.msPrice,
                  value: d.price,
                  number: true,
                  decimal: true,
                  prefix: '₹ ',
                  onChanged: (v) => cubit.edit((x) => x.copyWith(price: v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DraftTextField(
                  label: l.msMrp,
                  value: d.mrp,
                  optional: true,
                  number: true,
                  decimal: true,
                  prefix: '₹ ',
                  error: _mrpError(l, d.price, d.mrp),
                  onChanged: (v) => cubit.edit((x) => x.copyWith(mrp: v)),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DiscountBadge(_discount(d.price, d.mrp)),
            ),
          ),
          EarningLine(state: state, price: double.tryParse(d.price)),
          if (physical)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DraftTextField(
                    label: l.msStock,
                    value: d.stock,
                    number: true,
                    help: l.msStockHint,
                    onChanged: (v) => cubit.edit((x) => x.copyWith(stock: v)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DraftTextField(
                    label: l.msWeight,
                    value: d.weight,
                    number: true,
                    suffix: 'g',
                    help: l.msWeightHint,
                    onChanged: (v) => cubit.edit((x) => x.copyWith(weight: v)),
                  ),
                ),
              ],
            ),
        ],
        DraftTextField(
          label: service ? l.msLeadService : l.msLeadProduct,
          value: d.lead,
          number: true,
          optional: true,
          suffix: l.msDays,
          onChanged: (v) => cubit.edit((x) => x.copyWith(lead: v)),
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.index,
    required this.package,
    required this.canRemove,
    required this.state,
    super.key,
  });

  final int index;
  final PackageDraft package;
  final bool canRemove;
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final brand = context.brand;
    final p = package;
    void set(PackageDraft Function(PackageDraft x) f) =>
        cubit.updatePackage(p.key, f);
    final presets = [
      (l.lwPresetSingle, 1),
      (l.lwPresetFamily, 4),
      (l.lwPresetGrand, 11),
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.lwPackage(index + 1),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              _DiscountBadge(_discount(p.price, p.mrp)),
              if (canRemove)
                IconButton(
                  tooltip: l.lwPackageRemove,
                  onPressed: () => cubit.removePackage(p.key),
                  icon: Icon(Icons.delete_outline_rounded, color: brand.live),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (p.name.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final (name, count) in presets)
                    ActionChip(
                      label: Text(name),
                      onPressed: () => set(
                        (x) => x.copyWith(name: name, participants: count),
                      ),
                    ),
                ],
              ),
            ),
          DraftTextField(
            label: l.lwPackageName,
            value: p.name,
            maxLength: 120,
            onChanged: (v) => set((x) => x.copyWith(name: v)),
          ),
          FieldBlock(
            label: l.lwPackageNames,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: CountStepper(
                value: p.participants,
                onChanged: (v) => set((x) => x.copyWith(participants: v)),
              ),
            ),
          ),
          DraftTextField(
            label: l.lwPackageIncludes,
            value: p.includes,
            hint: l.lwPackageIncludesHint,
            maxLength: 300,
            optional: true,
            onChanged: (v) => set((x) => x.copyWith(includes: v)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DraftTextField(
                  label: l.msPrice,
                  value: p.price,
                  number: true,
                  decimal: true,
                  prefix: '₹ ',
                  onChanged: (v) => set((x) => x.copyWith(price: v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DraftTextField(
                  label: l.msMrp,
                  value: p.mrp,
                  number: true,
                  decimal: true,
                  optional: true,
                  prefix: '₹ ',
                  error: _mrpError(l, p.price, p.mrp),
                  onChanged: (v) => set((x) => x.copyWith(mrp: v)),
                ),
              ),
            ],
          ),
          EarningLine(state: state, price: double.tryParse(p.price)),
        ],
      ),
    );
  }
}

// --- 6. review -------------------------------------------------------------------

class PreviewStep extends StatelessWidget {
  const PreviewStep({required this.state, super.key});
  final ListingWizardState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final theme = Theme.of(context);
    final brand = context.brand;
    final d = state.draft;
    final listing = state.listing;
    final photos = listing?.photos ?? const <ListingPhoto>[];
    final prices = d.isService
        ? [
            for (final p in d.packages)
              if (double.tryParse(p.price) != null) double.parse(p.price),
          ]
        : [if (double.tryParse(d.price) != null) double.parse(d.price)];
    prices.sort();
    final priceText = prices.isEmpty
        ? '—'
        : (d.isService && prices.length > 1
              ? l.lwFrom(Money.format(prices.first, 'INR'))
              : Money.format(prices.first, 'INR'));
    final problems = {for (final e in state.problems.entries) e.key: e.value};

    Widget section(WizardStep step, String summary) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        problems.containsKey(step)
            ? Icons.error_outline_rounded
            : Icons.check_circle_outline_rounded,
        color: problems.containsKey(step)
            ? AstroPalette.fire.end
            : brand.online,
      ),
      title: Text(
        stepLabel(l, step),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(summary, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: TextButton(
        onPressed: () => cubit.goTo(step),
        child: Text(l.lwEdit),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (listing != null) ...[
          ListingStatusCard(listing: listing),
          const SizedBox(height: 16),
        ],
        _StepTitle(l.lwPreviewTitle),
        // the listing as a customer will meet it
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: brand.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: photos.isNotEmpty
                    ? Image.network(photos.first.url, fit: BoxFit.cover)
                    : (state.uploads.isNotEmpty
                          ? Image.file(
                              File(state.uploads.first.path),
                              fit: BoxFit.cover,
                            )
                          : ColoredBox(
                              color: brand.tint,
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: brand.inkMuted,
                              ),
                            )),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title.isEmpty ? '—' : d.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (d.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(d.subtitle, style: TextStyle(color: brand.inkMuted)),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      priceText,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (d.isService && d.packages.length > 1) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final p in d.packages)
                            if (p.name.isNotEmpty)
                              Chip(
                                label: Text(
                                  '${p.name} · ${p.price.isEmpty ? '—' : Money.format(double.tryParse(p.price) ?? 0, 'INR')}',
                                ),
                              ),
                        ],
                      ),
                    ],
                    if (d.description.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        d.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(height: 1.4),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        section(WizardStep.kind, state.category?.name ?? '—'),
        section(WizardStep.photos, '${state.photoCount}'),
        section(WizardStep.describe, d.title.isEmpty ? '—' : d.title),
        if (state.steps.contains(WizardStep.details))
          section(WizardStep.details, '${d.attributes.length}'),
        section(WizardStep.price, priceText),
      ],
    );
  }
}

/// Where a saved listing stands: its state, what the team said.
class ListingStatusCard extends StatelessWidget {
  const ListingStatusCard({required this.listing, super.key});
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: s.color.withValues(alpha: 0.3)),
      ),
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
        ],
      ),
    );
  }
}
