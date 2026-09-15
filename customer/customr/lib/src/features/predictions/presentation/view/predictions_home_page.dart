import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/error_view.dart';
import '../cubit/predictions_cubit.dart';
import 'buy_credits_sheet.dart';
import 'prediction_routes.dart';

class PredictionsHomePage extends StatefulWidget {
  const PredictionsHomePage({super.key});

  @override
  State<PredictionsHomePage> createState() => _PredictionsHomePageState();
}

class _PredictionsHomePageState extends State<PredictionsHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PredictionsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.predTitle)),
      body: RefreshIndicator(
        onRefresh: () => context.read<PredictionsCubit>().load(force: true),
        child: BlocBuilder<PredictionsCubit, PredictionsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                _Hero(l: l),
                const SizedBox(height: 16),
                state.catalog.when(
                  idle: _loading,
                  loading: _loading,
                  error: (m) => ErrorView(
                    message: m,
                    onRetry: () => context.read<PredictionsCubit>().loadCatalog(
                      force: true,
                    ),
                  ),
                  data: (cat) => _CreditRow(catalog: cat),
                ),
                const SizedBox(height: 20),
                Text(
                  l.predChooseArea,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _AreaGrid(),
                const SizedBox(height: 22),
                Text(
                  l.predMyReadings,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                state.list.when(
                  idle: _loading,
                  loading: _loading,
                  error: (m) => ErrorView(
                    message: m,
                    onRetry: () =>
                        context.read<PredictionsCubit>().loadList(force: true),
                  ),
                  data: (items) => items.isEmpty
                      ? _EmptyList(l: l)
                      : Column(
                          children: [
                            for (final p in items) ...[
                              PredictionCard(
                                prediction: p,
                                areaTitle: predAreaTitle(l, p.area),
                                periodTitle: predPeriodTitle(l, p.period),
                                statusLabel: predStatusLabel(l, p.status),
                                trailingDate: _dateHint(l, p),
                                onTap: () =>
                                    context.push(PredictionRoutes.detail(p.id)),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 36),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _loading() => const Padding(
    padding: EdgeInsets.all(28),
    child: Center(child: CircularProgressIndicator()),
  );

  static String _dateHint(AppLocalizations l, Prediction p) {
    if (p.status.isDelivered && p.deliveredAt != null) {
      return l.predDeliveredOn(_d(p.deliveredAt!));
    }
    if (p.status.isOpen && p.dueAt != null) {
      return l.predEta(_d(p.dueAt!));
    }
    return '';
  }

  static String _d(DateTime d) => '${d.day}/${d.month}';
}

class _Hero extends StatelessWidget {
  const _Hero({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.predHeroTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 6),
          Text(
            l.predHeroBody,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  const _CreditRow({required this.catalog});

  final PredictionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        CreditBalancePill(
          balance: catalog.creditBalance,
          label: l.predCredits(catalog.creditBalance),
          onBuy: () => showBuyCreditsSheet(context, catalog),
        ),
        const Spacer(),
        if (catalog.subscribed)
          Chip(label: Text(l.predSubscribed))
        else
          TextButton(
            onPressed: () => showBuyCreditsSheet(context, catalog),
            child: Text(l.predSeePacks),
          ),
      ],
    );
  }
}

class _AreaGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        for (final area in PredictionLabels.areaOrder)
          _AreaTile(area: area, l: l),
      ],
    );
  }
}

class _AreaTile extends StatelessWidget {
  const _AreaTile({required this.area, required this.l});

  final PredictionArea area;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(PredictionRoutes.request, extra: area),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                PredictionLabels.areaIcon(area),
                color: scheme.primary,
                size: 20,
              ),
              Text(
                predAreaTitle(l, area),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        l.predNoReadings,
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
    ),
  );
}

// --- label helpers (engine enum -> localised) --------------------------

String predAreaTitle(AppLocalizations l, PredictionArea a) => switch (a) {
  PredictionArea.career => l.predAreaCareer,
  PredictionArea.marriageLove => l.predAreaMarriage,
  PredictionArea.finance => l.predAreaFinance,
  PredictionArea.health => l.predAreaHealth,
  PredictionArea.education => l.predAreaEducation,
  PredictionArea.general => l.predAreaGeneral,
};

String predPeriodTitle(AppLocalizations l, PredictionPeriod p) => switch (p) {
  PredictionPeriod.month => l.predPeriodMonth,
  PredictionPeriod.quarter => l.predPeriodQuarter,
  PredictionPeriod.year => l.predPeriodYear,
};

String predStatusLabel(AppLocalizations l, PredictionStatus s) => switch (s) {
  PredictionStatus.requested ||
  PredictionStatus.drafting => l.predStatusWriting,
  PredictionStatus.inReview => l.predStatusReview,
  PredictionStatus.delivered => l.predStatusReady,
  PredictionStatus.rejected => l.predStatusUnavailable,
  PredictionStatus.refunded => l.predStatusRefunded,
};
