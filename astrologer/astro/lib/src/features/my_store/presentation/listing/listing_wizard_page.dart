import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/my_store_api.dart';
import 'listing_draft.dart';
import 'listing_steps.dart';
import 'listing_wizard_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Adding or editing a product / service, a step at a time:
/// what → photos → describe → details → price → review.
///
/// Everything typed is kept (on the phone at once, on the server every half
/// minute), photos go up the moment they are picked, and the astrologer can
/// speak instead of type. A saved listing opens on its review step, each part
/// a tap away. Built to be opened from elsewhere too (a remedy suggestion): it
/// returns the listing's id when it closes.
class ListingWizardPage extends StatefulWidget {
  const ListingWizardPage({this.listingId, super.key});

  final String? listingId;

  @override
  State<ListingWizardPage> createState() => _ListingWizardPageState();
}

class _ListingWizardPageState extends State<ListingWizardPage> {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return BlocProvider(
          create: (_) => ListingWizardCubit(
            api: getIt<MyStoreApi>(),
            store: ListingDraftStore(snap.data!),
          )..load(widget.listingId),
          child: const _WizardView(),
        );
      },
    );
  }
}

class _WizardView extends StatelessWidget {
  const _WizardView();

  String _notice(AppLocalizations l, String code) => switch (code) {
    'need_kind' => l.lwNeedKind,
    'need_category' => l.lwNeedCategory,
    'need_type' => l.lwNeedType,
    'back_to_review' => l.msBackToReview,
    'photos_uploading' => l.lwPhotosUploading,
    'fix_problems' => l.lwFixProblems,
    _ => code,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<ListingWizardCubit, ListingWizardState>(
      listenWhen: (a, b) =>
          a.noticeId != b.noticeId ||
          a.sent != b.sent ||
          (!a.restored && b.restored),
      listener: (context, s) {
        final messenger = ScaffoldMessenger.of(context);
        if (s.sent) {
          messenger.showSnackBar(SnackBar(content: Text(l.msSentForReview)));
          Navigator.of(context).pop(s.listing?.id);
          return;
        }
        final text = s.notice;
        if (text != null) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(_notice(l, text))));
        } else if (s.restored) {
          messenger.showSnackBar(SnackBar(content: Text(l.lwRestored)));
        }
      },
      builder: (context, s) {
        final cubit = context.read<ListingWizardCubit>();
        if (s.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (s.error != null) {
          return SubPageScaffold(
            title: l.msNewListing,
            children: [
              const SizedBox(height: 40),
              ErrorView(
                message: s.error!,
                onRetry: () => cubit.load(s.listing?.id),
              ),
            ],
          );
        }
        final steps = s.steps;
        final index = steps.indexOf(s.step).clamp(0, steps.length - 1);
        return PopScope(
          // back walks back through the steps before it leaves
          canPop: index == 0 || !s.isNew,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.back();
          },
          child: SubPageScaffold(
            title: s.isNew ? l.msNewListing : l.msEditListing,
            subtitle: _saveLine(context, s),
            actions: [if (s.listing != null) _Menu(state: s)],
            bottomBar: _BottomBar(state: s, index: index),
            children: [
              _Progress(steps: steps, index: index),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(a),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(s.step),
                  child: switch (s.step) {
                    WizardStep.kind => KindStep(state: s),
                    WizardStep.photos => PhotosStep(state: s),
                    WizardStep.describe => DescribeStep(state: s),
                    WizardStep.details => DetailsStep(state: s),
                    WizardStep.price => PriceStep(state: s),
                    WizardStep.preview => PreviewStep(state: s),
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// "Saved 10:42" · "Saving…" · "Offline — kept on this phone".
  String? _saveLine(BuildContext context, ListingWizardState s) {
    final l = context.l10n;
    return switch (s.save) {
      SaveState.saving => l.lwSaving,
      SaveState.saved when s.savedAt != null => l.lwSavedAt(
        TimeOfDay.fromDateTime(s.savedAt!).format(context),
      ),
      SaveState.offline => l.lwOffline,
      SaveState.failed => l.lwSaveFailed,
      _ => s.isNew && s.draft.kind.isNotEmpty ? l.lwSavedOnPhone : null,
    };
  }
}

/// A bar of segments, one per step, and "Step 2 of 6 · Photos".
class _Progress extends StatelessWidget {
  const _Progress({required this.steps, required this.index});
  final List<WizardStep> steps;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= index ? accent : brand.hairline,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              if (i < steps.length - 1) const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${l.lwStepOf(index + 1, steps.length)} · ${stepLabel(l, steps[index])}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: brand.inkMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.index});
  final ListingWizardState state;
  final int index;

  Future<void> _saveLive(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    if (state.liveContentChanged) {
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
      if (ok != true) return;
    }
    await cubit.saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<ListingWizardCubit>();
    final last = state.step == WizardStep.preview;
    final listing = state.listing;
    final canSubmit = listing == null || listing.isDraft;
    final Widget primary;
    if (!last) {
      primary = BusyButton(
        label: l.lwNext,
        icon: Icons.arrow_forward_rounded,
        onPressed: cubit.next,
      );
    } else if (canSubmit) {
      primary = BusyButton(
        label: l.msSendForReview,
        icon: Icons.send_rounded,
        busy: state.submitting,
        onPressed: cubit.submit,
      );
    } else {
      primary = BusyButton(
        label: l.msSaveChanges,
        icon: Icons.check_rounded,
        busy: state.save == SaveState.saving,
        onPressed: () => _saveLive(context),
      );
    }
    return StickyActionBar(
      child: Row(
        children: [
          if (index > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: cubit.back,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(l.lwBack),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(flex: 2, child: primary),
        ],
      ),
    );
  }
}

/// Stop selling / delete, for a saved listing.
class _Menu extends StatelessWidget {
  const _Menu({required this.state});
  final ListingWizardState state;

  Future<void> _act(BuildContext context, String action) async {
    final l = context.l10n;
    final listing = state.listing!;
    final api = getIt<MyStoreApi>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
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
    try {
      if (action == 'delete') {
        await api.remove(listing.id);
      } else {
        await api.withdraw(listing.id);
        messenger.showSnackBar(SnackBar(content: Text(l.msStoppedSelling)));
      }
      navigator.pop(listing.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final listing = state.listing!;
    return PopupMenuButton<String>(
      onSelected: (a) => _act(context, a),
      itemBuilder: (_) => [
        if (listing.isLive || listing.inReview)
          PopupMenuItem(value: 'withdraw', child: Text(l.msStopSelling)),
        PopupMenuItem(value: 'delete', child: Text(l.msDelete)),
      ],
    );
  }
}
