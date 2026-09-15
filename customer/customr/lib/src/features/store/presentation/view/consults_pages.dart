import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/consult.dart';
import '../../data/store_repository.dart';
import '../cubit/consult_cubits.dart';
import '../widgets/consult_widgets.dart';
import '../widgets/store_ui.dart';

/// `/store/consults` — every product an astrologer has advised the customer on.
class ConsultsPage extends StatelessWidget {
  const ConsultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.storeAdviceTitle)),
      body: BlocBuilder<ConsultsCubit, AsyncValue<List<StoreConsult>>>(
        builder: (context, state) {
          final cubit = context.read<ConsultsCubit>();
          if (state.isError && !state.hasValue) {
            return ErrorView(message: state.error ?? '', onRetry: cubit.load);
          }
          final list = state.value;
          if (list == null) {
            return AppShimmer(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (var i = 0; i < 4; i++)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: SkeletonBox(height: 84, radius: 18),
                    ),
                ],
              ),
            );
          }
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.forum_outlined,
              title: l.storeAdviceEmptyTitle,
              message: l.storeAdviceEmptyBody,
              action: FilledButton.tonal(
                onPressed: () => context.push(Routes.store),
                child: Text(l.storeExplore),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: FadeSlideIn.list([
                for (final c in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ConsultSummaryCard(consult: c),
                  ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

/// `/store/consults/:id` — one product consult: the question, the call, the verdict.
class ConsultDetailPage extends StatelessWidget {
  const ConsultDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.storeAdviceTitle)),
      body: BlocBuilder<ConsultDetailCubit, AsyncValue<StoreConsult>>(
        builder: (context, state) {
          final cubit = context.read<ConsultDetailCubit>();
          if (state.isError && !state.hasValue) {
            return ErrorView(message: state.error ?? '', onRetry: cubit.load);
          }
          final c = state.value;
          if (c == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = c.product;
          final v = c.verdict;
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: FadeSlideIn.list([
                if (product != null)
                  StoreCard(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () =>
                          context.push(Routes.storeProduct(product.slug)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: StoreImage(
                              url: product.image,
                              slug: product.type,
                              radius: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                PriceTag(
                                  price: product.priceFrom,
                                  compareAt: product.compareAt,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                StoreCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          HueAvatar(
                            name: c.astrologerName,
                            url: c.astrologerAvatar,
                            hue: AstroPalette.forId(c.astrologerId),
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.astrologerName,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  [
                                    l.storeVideoCall,
                                    storeDate(context, c.createdAt),
                                  ].where((s) => s.isNotEmpty).join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: context.brand.inkMuted),
                                ),
                              ],
                            ),
                          ),
                          if (c.callLive)
                            FilledButton.tonal(
                              onPressed: () => context.push(
                                Routes.consultation(c.consultationId),
                              ),
                              child: Text(l.storeOpenCall),
                            ),
                        ],
                      ),
                      if (c.question.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          l.storeYourQuestion,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: context.brand.inkMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.question,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (v != null)
                  VerdictCard(
                    consult: c,
                    onBuyRecommended:
                        product == null || v.kind != VerdictKind.suitable
                        ? null
                        : () => context.push(
                            Routes.storeProduct(
                              product.slug,
                              recommendationId: v.recommendationId,
                            ),
                          ),
                    onOpenAlternative: (alt) => context.push(
                      Routes.storeProduct(
                        alt.slug,
                        recommendationId: v.recommendationId,
                      ),
                    ),
                  )
                else
                  StoreCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          color: context.brand.inkMuted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            consultStatusLine(context, c),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

/// Shown on a consultation's summary screen when the call was about a product.
/// Renders nothing for ordinary consultations.
class StoreConsultSummaryCard extends StatefulWidget {
  const StoreConsultSummaryCard({required this.consultationId, super.key});
  final String consultationId;

  @override
  State<StoreConsultSummaryCard> createState() =>
      _StoreConsultSummaryCardState();
}

class _StoreConsultSummaryCardState extends State<StoreConsultSummaryCard> {
  StoreConsult? _consult;

  @override
  void initState() {
    super.initState();
    getIt<StoreRepository>()
        .consultForConsultation(widget.consultationId)
        .then((c) {
          if (mounted) setState(() => _consult = c);
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final c = _consult;
    if (c == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ConsultSummaryCard(consult: c),
    );
  }
}
