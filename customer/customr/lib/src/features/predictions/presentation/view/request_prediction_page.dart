import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../cubit/predictions_cubit.dart';
import 'buy_credits_sheet.dart';
import 'prediction_routes.dart';
import 'predictions_home_page.dart' show predAreaTitle, predPeriodTitle;
import '../../../../core/l10n/api_error_l10n.dart';

class RequestPredictionPage extends StatefulWidget {
  const RequestPredictionPage({this.initialArea, super.key});
  final PredictionArea? initialArea;

  @override
  State<RequestPredictionPage> createState() => _RequestPredictionPageState();
}

class _RequestPredictionPageState extends State<RequestPredictionPage> {
  late PredictionArea _area = widget.initialArea ?? PredictionArea.general;
  PredictionPeriod _period = PredictionPeriod.year;
  String? _profileId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final bp = context.read<BirthProfilesCubit>();
    bp.load();
    _profileId = bp.state.activeProfileId;
    context.read<PredictionsCubit>().loadCatalog();
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final cubit = context.read<PredictionsCubit>();
    final catalog = cubit.state.catalog.value;

    if (_profileId == null) {
      messenger.showSnackBar(SnackBar(content: Text(l.predPickProfile)));
      return;
    }
    if (catalog != null && !catalog.hasCredits) {
      await showBuyCreditsSheet(context, catalog);
      if (!mounted) return;
      final refreshed = cubit.state.catalog.value;
      if (refreshed == null || !refreshed.hasCredits) return;
    }

    setState(() => _busy = true);
    try {
      final p = await cubit.request(
        birthProfileId: _profileId!,
        area: _area,
        period: _period,
      );
      unawaited(router.pushReplacement(PredictionRoutes.detail(p.id)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(localizedErrorFor(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.predRequestTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          _Label(l.predForProfile),
          BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
            builder: (context, state) {
              final profiles = state.profiles;
              if (profiles.isEmpty) {
                return OutlinedButton.icon(
                  onPressed: () => context.push(Routes.birthProfileNew),
                  icon: const Icon(Icons.add),
                  label: Text(l.predAddProfile),
                );
              }
              return Wrap(
                spacing: 8,
                children: [
                  for (final p in profiles)
                    ChoiceChip(
                      label: Text(p.displayName),
                      selected: _profileId == p.id,
                      onSelected: (_) => setState(() => _profileId = p.id),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _Label(l.predArea),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in PredictionLabels.areaOrder)
                ChoiceChip(
                  label: Text(predAreaTitle(l, a)),
                  selected: _area == a,
                  onSelected: (_) => setState(() => _area = a),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _Label(l.predPeriod),
          Wrap(
            spacing: 8,
            children: [
              for (final p in PredictionPeriod.values)
                ChoiceChip(
                  label: Text(predPeriodTitle(l, p)),
                  selected: _period == p,
                  onSelected: (_) => setState(() => _period = p),
                ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<PredictionsCubit, PredictionsState>(
            buildWhen: (a, b) => a.catalog != b.catalog,
            builder: (context, state) {
              final cat = state.catalog.value;
              return Text(
                cat == null
                    ? ''
                    : cat.hasCredits
                    ? l.predCostsOne(cat.creditBalance)
                    : l.predNoCreditYet,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _busy ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.predRequestCta),
          ),
          const SizedBox(height: 12),
          Text(
            l.predRequestDisclaimer,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
